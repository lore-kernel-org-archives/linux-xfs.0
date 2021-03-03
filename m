Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75189C4332B
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A7FE601FF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351106AbhCCDQZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:16:25 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:46078 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231631AbhCCANS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Mar 2021 19:13:18 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 54110E69F5E;
        Wed,  3 Mar 2021 11:11:58 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lHF7N-00CBri-Hg; Wed, 03 Mar 2021 11:11:57 +1100
Date:   Wed, 3 Mar 2021 11:11:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: separate CIL commit record IO
Message-ID: <20210303001157.GK4662@dread.disaster.area>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-3-david@fromorbit.com>
 <20210224203429.GR7272@magnolia>
 <20210224214417.GB4662@dread.disaster.area>
 <YDdhJ0Oe6R+UXqDU@infradead.org>
 <20210225204755.GK4662@dread.disaster.area>
 <20210301090901.GA3698088@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301090901.GA3698088@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=PQXLQY_tdtPucPiFC38A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 01, 2021 at 09:09:01AM +0000, Christoph Hellwig wrote:
> On Fri, Feb 26, 2021 at 07:47:55AM +1100, Dave Chinner wrote:
> > Sorry, I/O wait might matter for what?
> 
> Think you have a SAS hard drive, WCE=0, typical queue depth of a few
> dozend commands.

Yup, so typical IO latency of 2-3ms, assuming 10krpm, assuming we
aren't doing metadata writeback which will blow this out.

I've tested on slower iSCSI devices than this (7-8ms typical av.
seek time), and it didn't show up any performance anomalies.

> Before that we'd submit a bunch of iclogs, which are generally
> sequential except of course for the log wrap around case.  The drive
> can now easily take all the iclogs and write them in one rotation.

Even if we take the best case for your example, this still means we
block on every 8 iclogs waiting 2-3ms for the spindle to rotate and
complete the IOs. Hence for a checkpoint of 32MB with 256kB iclogs,
we're blocking for 2-3ms at least 16 times before we get to the
commit iclog. With default iclog size of 32kB, we'll block a couple
of hundred times waiting on iclog IO...

IOWs, we're already talking about a best case checkpoint commit
latency of 30-50ms here.

[ And this isn't even considering media bandwidth there - 32MB on a
drive that can do maybe 200MB/s in the middle of the spindle where
the log is. That's another 150ms of data transfer time to physical
media. So if the drive is actually writing to physical media because
WCE=0, then we're taking *at least* 200ms per 32MB checkpoint. ]

> Now if we wait for the previous iclogs before submitting the
> commit_iclog we need at least one more additional full roundtrip.

So we add an average of 2-3ms to what is already taking, in the best
case, 30-50ms.

And these are mostly async commits this overhead is added to, so
there's rarely anything waiting on it and hence the extra small
latency is almost always lost in the noise. Even if the extra delay
is larger, there is rarely anything waiting on it so it's still
noise...

I just don't see anything relevant that stands out from the noise on
my systems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
