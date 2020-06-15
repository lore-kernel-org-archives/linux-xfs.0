Return-Path: <SRS0=I2eC=74=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDACC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Jun 2020 01:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF8A820714
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Jun 2020 01:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgFOBuH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 14 Jun 2020 21:50:07 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41817 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727946AbgFOBuG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Jun 2020 21:50:06 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A56363A4DAD;
        Mon, 15 Jun 2020 11:50:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jkeG5-0001od-O2; Mon, 15 Jun 2020 11:49:57 +1000
Date:   Mon, 15 Jun 2020 11:49:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/30] xfs: factor xfs_iflush_done
Message-ID: <20200615014957.GU2040@dread.disaster.area>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-30-david@fromorbit.com>
 <20200609131249.GC40899@bfoster>
 <20200609221431.GK2040@dread.disaster.area>
 <20200610130833.GB50747@bfoster>
 <20200611001622.GN2040@dread.disaster.area>
 <20200611140709.GB56572@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611140709.GB56572@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=7-415B0cAAAA:8
        a=Bs-5f6dHGa3q-bvnwekA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 11, 2020 at 10:07:09AM -0400, Brian Foster wrote:
> 
> TBH, I think this patch should probably be broken down into two or three
> independent patches anyways.

To what end? The patch is already small, it's simple to understand
and it's been tested. What does breaking it up into a bunch more
smaller patches actually gain us?

It means hours more work on my side without any change in the end
result. It's -completely wasted effort- if all I'm doing this for is
to get you to issue a RVB on it. Fine grained patches do not come
for free, and in a patch series that is already 30 patches long
making it even longer just increases the time and resources it costs
*me* to maintian it until it is merged.

> What's the issue with something like the
> appended diff (on top of this patch) in the meantime? If the multiple
> list logic is truly necessary, reintroduce it when it's used so it's
> actually reviewable..

Nothing. Except it causes conflicts further through my patch set
which do the work of removing this AIL specific code. IOWs, it just
*increases the amount of work I have to do* without actually
providing any benefit to anyone...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
