Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73EABC433E6
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 00:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CA7564F59
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 00:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhCEApB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 19:45:01 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:50414 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231415AbhCEApB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Mar 2021 19:45:01 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id C44FA63557;
        Fri,  5 Mar 2021 11:44:59 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lHyaQ-00FK1A-Pn; Fri, 05 Mar 2021 11:44:58 +1100
Date:   Fri, 5 Mar 2021 11:44:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: separate CIL commit record IO
Message-ID: <20210305004458.GU4662@dread.disaster.area>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-3-david@fromorbit.com>
 <YD0GCCPmCkoYBVK0@bfoster>
 <20210303004119.GL4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303004119.GL4662@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=gmbQYZ-Ph2ZNpx5okLcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 03, 2021 at 11:41:19AM +1100, Dave Chinner wrote:
> On Mon, Mar 01, 2021 at 10:19:36AM -0500, Brian Foster wrote:
> > On Tue, Feb 23, 2021 at 02:34:36PM +1100, Dave Chinner wrote:
> > That aside, this iteration logic all seems a bit overengineered to me.
> > We have the commit record iclog of the current checkpoint and thus the
> > immediately previous iclog in the ring. We know that previous record
> > isn't earlier than start_lsn because the caller confirmed that start_lsn
> > != commit_lsn. We also know that iclog can't become dirty -> active
> > until it and all previous iclog writes have completed because the
> > callback ordering implemented by xlog_state_do_callback() won't clean
> > the iclog until that point. Given that, can't this whole thing be
> > replaced with a check of iclog->prev to either see if it's been cleaned
> > or to otherwise xlog_wait() for that condition and return?
> 
> Maybe. I was more concerned about ensuring that it did the right
> thing so I checked all the things that came to mind. There was more
> than enough compexity in other parts of this patchset to fill my
> brain that minimal implementation were not a concern. I'll go take
> another look at it.

Ok, so we can just use xlog_wait_on_iclog() here. I didn't look too
closely at the implementation of that function, just took the
comment above it at face value that it only waited for an iclog to
hit the disk.

We actually have two different iclog IO completion wait points - one
to wait for an iclog to hit the disk, and one to wait for hit the
disk and run completion callbacks. i.e. one is not ordered against
other iclogs and the other is strictly ordered.

The ordered version runs completion callbacks before waking waiters
thereby guaranteeing all previous iclog have been completed before
completing the current iclog and waking waiters.

The CIL code needs the latter, so yes, this can be simplified down
to a single xlog_wait_on_iclog(commit_iclog->ic_prev); call from the
CIL.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
