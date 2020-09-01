Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE14C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 00:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0353E2100A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 00:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgIAAMO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 20:12:14 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42390 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725929AbgIAAMM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 20:12:12 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 501763A6D4F;
        Tue,  1 Sep 2020 10:12:08 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kCtuB-00042e-0y; Tue, 01 Sep 2020 10:12:07 +1000
Date:   Tue, 1 Sep 2020 10:12:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Mikulas Patocka <mpatocka@redhat.com>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: RCU stall when using XFS
Message-ID: <20200901001207.GC12131@dread.disaster.area>
References: <alpine.LRH.2.02.2008311513150.7870@file01.intranet.prod.int.rdu2.redhat.com>
 <20200831211915.GB6096@magnolia>
 <20200831213612.GB12131@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831213612.GB12131@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=KcmsTjQD c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=peWNdL_QVAvMZTiMro0A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 01, 2020 at 07:36:12AM +1000, Dave Chinner wrote:
> On Mon, Aug 31, 2020 at 02:19:15PM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 31, 2020 at 03:22:15PM -0400, Mikulas Patocka wrote:
> > > Hi
> > > 
> > > I report this RCU stall when working with one 512GiB file the XFS 
> > > filesystem on persistent memory. Except for the warning, there was no 
> > > observed misbehavior.
> > > 
> > > Perhaps, it is missing cond_resched() somewhere.
> > 
> > Yikes, you can send a 2T request to a pmem device??
> > 
> > /sys/block/pmem0/queue/max_hw_sectors_kb : 2147483647
> > 
> > My puny laptop can only push 29GB/s, which I guess means we could stall
> > on an IO request for 70 seconds...
> 
> This looks like another symptom of the same "bio sizes in writeback
> are now unbound if contiguous physical pages are added to them"
> problem I raised here when considering a similar hard lockup report
> with a 2GB bio:
> 
> https://lore.kernel.org/linux-xfs/20200821215358.GG7941@dread.disaster.area/
> 
> Quote:
> 
> | .e. I'm not looking at this as a "bio overflow bug" - I'm
> | commenting on what this overflow implies from an architectural point
> | of view. i.e. that uncapped bio sizes and bio chain lengths in
> | writeback are actually a bad thing and something we've always
> | tried to avoid doing....
> 
> This looks like another instance of the same problem...
> 
> It really does look like iomap needs to cap the length of ioend and
> bio chains...

And Brian pointed out he'd alredy written such a patch:

https://lore.kernel.org/linux-xfs/20200825144917.GA321765@bfoster/#t

I missed it because I had some hardware issues with the
machine that stores my mail around then. This does what I was
suggesting, so it would be worth testing to see if it fixes this
problem as well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
