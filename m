Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E92DC433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 22:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61BE264FE9
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 22:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhCDW5z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 17:57:55 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:33745 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229505AbhCDW5z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Mar 2021 17:57:55 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 906874ECB81;
        Fri,  5 Mar 2021 09:57:52 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lHwul-00FCyK-Vm; Fri, 05 Mar 2021 09:57:51 +1100
Date:   Fri, 5 Mar 2021 09:57:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: separate CIL commit record IO
Message-ID: <20210304225751.GS4662@dread.disaster.area>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-3-david@fromorbit.com>
 <YD0GCCPmCkoYBVK0@bfoster>
 <20210303004119.GL4662@dread.disaster.area>
 <YD+pnbuyyup8tBRN@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YD+pnbuyyup8tBRN@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=-v29r9ohzD8sY56-O9AA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22 a=BPzZvq435JnGatEyYwdK:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 03, 2021 at 10:22:05AM -0500, Brian Foster wrote:
> On Wed, Mar 03, 2021 at 11:41:19AM +1100, Dave Chinner wrote:
> > On Mon, Mar 01, 2021 at 10:19:36AM -0500, Brian Foster wrote:
> > > On Tue, Feb 23, 2021 at 02:34:36PM +1100, Dave Chinner wrote:
> > > You haven't addressed my feedback from the previous version. In
> > > particular the bit about whether it is safe to block on ->ic_force_wait
> > > from here considering some of our more quirky buffer locking behavior.
> > 
> > Sorry, first I've heard about this. I don't have any such email in
> > my inbox.
> > 
> 
> For reference, the last bit of this mail:
> 
> https://lore.kernel.org/linux-xfs/20210201160737.GA3252048@bfoster/
> 
> > I don't know what waiting on an iclog in the middle of a checkpoint
> > has to do with buffer locking behaviour, because iclogs don't use
> > buffers and we block waiting on iclog IO completion all the time in
> > xlog_state_get_iclog_space(). If it's not safe to block on iclog IO
> > completion here, then it's not safe to block on an iclog in
> > xlog_state_get_iclog_space(). That's obviously not true, so I'm
> > really not sure what the concern here is...
> > 
> 
> I think the broader question is not so much whether it's safe to block
> here or not, but whether our current use of async log forces might have
> a deadlock vector (which may or may not also include the
> _get_iclog_space() scenario, I'd need to stare at that one a bit). I
> referred to buffer locking because the buffer ->iop_unpin() handler can
> attempt to acquire a buffer lock.

There are none that I know of, and I'm not changing any of the log
write blocking rules. Hence if there is a problem, it's a zero-day
that we have never triggered nor have any awareness about at all.
Hence for the purposes of development and review, we can assume such
unknown design problems don't actually exist because there's
absolutely zero evidence to indicate there is problem here...

> Looking again, that is the only place I see that blocks in iclog
> completion callbacks and it's actually an abort scenario, which means
> shutdown.

Yup. The AIL simply needs to abort writeback of such locked, pinned
buffers and then everything works just fine.

> I am slightly concerned that introducing more regular blocking in
> the CIL push might lead to more frequent async log forces that
> block on callback iclogs and thus exacerbate that issue (i.e.
> somebody might be able to now reproduce yet another shutdown
> deadlock scenario to track down that might not have been
> reproducible before, for whatever reason), but that's probably not
> a serious enough problem to block this patch and the advantages of
> the series overall.

And that's why I updated the log force stats accounting to capture
the async log forces and how we account log forces that block. That
gives me direct visibility into the blocking behaviour while I'm
running tests. And even with this new visibility, I can't see any
change in the metrics that are above the noise floor...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
