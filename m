Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D86AC4361B
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 08:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6476F23A5B
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 08:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgLHIIM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 03:08:12 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53980 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725927AbgLHIIM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Dec 2020 03:08:12 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7F53D3C372D;
        Tue,  8 Dec 2020 19:07:29 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kmY1w-001jId-FJ; Tue, 08 Dec 2020 19:07:28 +1100
Date:   Tue, 8 Dec 2020 19:07:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Alex Lyakas <alex@zadara.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: RCU stall in xfs_reclaim_inodes_ag
Message-ID: <20201208080728.GX3913616@dread.disaster.area>
References: <5582F682900B483C89460123ABE79292@alyakaslap>
 <20201116213005.GM7391@dread.disaster.area>
 <6117EC6AA8F04ECA90EAACF20C4A2A7C@alyakaslap>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6117EC6AA8F04ECA90EAACF20C4A2A7C@alyakaslap>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=IkcTkHD0fZMA:10 a=zTNgK-yGK50A:10 a=7-415B0cAAAA:8
        a=yMHkVSOadiKfsFwOT30A:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 12:18:13PM +0200, Alex Lyakas wrote:
> Hi Dave,
> 
> Thank you for your response.
> 
> We did some more investigations on the issue, and we have the following
> findings:
> 
> 1) We tracked the max amount of inodes per AG radix tree. We found in our
> tests, that the max amount of inodes per AG radix tree was about 1.5M:
> [xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1368]: count=1384662
> reclaimable=58
> [xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1368]: count=1384630
> reclaimable=46
> [xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1368]: count=1384600
> reclaimable=16
> [xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1370]: count=1594500
> reclaimable=75
> [xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1370]: count=1594468
> reclaimable=55
> [xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1370]: count=1594436
> reclaimable=46
> [xfs_reclaim_inodes_ag:1285] XFS(dm-79): AG[1370]: count=1594421
> reclaimable=42
> (but the amount of reclaimable inodes is very small, as you can see).
> 
> Do you think this number is reasonable per radix tree?

That's fine. I regularly run tests that push 10M+ inodes into a
single radix tree, and that generally doesn't even show up on the
profiles....

> 2) This particular XFS instance is total of 500TB. However, the AG size in
> this case is 100GB.

Ok. I run scalability tests on 500TB filesystems with 500AGs that
hammer inode reclaim, but it should be trivial to run them with
5000AGs. Hell, let's just run 50,000AGs to see if there's actually
an iteration problem in the shrinker...

(we really need async IO in mkfs for doing things like this!)

Yup, that hurts a bit on 5.10-rc7, but not significantly. Profile
with 16 CPUs turning over 250,000 inodes/s through the cache:

       - 3.17% xfs_fs_free_cached_objects                                                                                                         ▒
	  - xfs_reclaim_inodes_nr                                                                                                                 ▒
	     - 3.09% xfs_reclaim_inodes_ag                                                                                                        ▒
		- 0.91% _raw_spin_lock                                                                                                            ▒
		     0.87% do_raw_spin_lock                                                                                                       ▒
		- 0.71% _raw_spin_unlock                                                                                                          ▒
		   - 0.67% do_raw_spin_unlock                                                                                                     ▒
			__raw_callee_save___pv_queued_spin_unlock

Which indicate spinlocks are the largest CPU user in that path.
That's likley the radix tree spin locks when removing inodes from
the AG because the upstream code now allows multiple reclaimers to
operate on the same AG.

But even with that, there isn't any sign of holdoff latencies,
scanning delays, etc occurring inside the RCU critical section.
IOWs, bumping up the number of AGs massively shouldn't impact the
RCU code here as the RCU crictical region is inside the loop over
the AGs, not spanning the loop.

I don't know how old your kernel is, but maybe something is getting
stuck on a spinlock (per-inode or per-ag) inside the RCU section?
i.e. maybe you see a RCU stall because the code has livelocked or
has severe contention on a per-ag or inode spinlock inside the RCU
section?

I suspect you are going to need to profile the code when it is
running to some idea of what it is actually doing when the stalls
occur...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
