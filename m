Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3098C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 22:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F19D20734
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 22:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgFCW1q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 18:27:46 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:49843 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727872AbgFCW1q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 18:27:46 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id E75A7108C95;
        Thu,  4 Jun 2020 08:27:41 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jgbrJ-0000wS-2Y; Thu, 04 Jun 2020 08:27:41 +1000
Date:   Thu, 4 Jun 2020 08:27:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Yafang Shao <laoar.shao@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: avoid deadlock when tigger memory reclam in
 xfs_map_blocks()
Message-ID: <20200603222741.GQ2040@dread.disaster.area>
References: <1591179035-9270-1-git-send-email-laoar.shao@gmail.com>
 <20200603172355.GP2162697@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603172355.GP2162697@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=7-415B0cAAAA:8
        a=wBMB_3lc1ql3Zin1_Q8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 03, 2020 at 10:23:55AM -0700, Darrick J. Wong wrote:
> On Wed, Jun 03, 2020 at 06:10:35AM -0400, Yafang Shao wrote:
> > Recently there is an XFS deadlock on our server with an old kernel.
> > The deadlock is caused by allocating memory xfs_map_blocks() while doing
> > writeback on behalf of memroy reclaim. Although this deadlock happens on an
> > old kernel, I think it could happen on the newest kernel as well. This
> > issue only happence once and can't be reproduced, so I haven't tried to
> > produce it on the newesr kernel.
> > 
> > Bellow is the call trace of this deadlock. Note that
> > xfs_iomap_write_allocate() is replaced by xfs_convert_blocks() in
> > commit 4ad765edb02a ("xfs: move xfs_iomap_write_allocate to xfs_aops.c").
> > 
> > [480594.790087] INFO: task redis-server:16212 blocked for more than 120 seconds.
> > [480594.790087] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [480594.790088] redis-server    D ffffffff8168bd60     0 16212  14347 0x00000004
> > [480594.790090]  ffff880da128f070 0000000000000082 ffff880f94a2eeb0 ffff880da128ffd8
> > [480594.790092]  ffff880da128ffd8 ffff880da128ffd8 ffff880f94a2eeb0 ffff88103f9d6c40
> > [480594.790094]  0000000000000000 7fffffffffffffff ffff88207ffc0ee8 ffffffff8168bd60
> > [480594.790096] Call Trace:
> > [480594.790101]  [<ffffffff8168dce9>] schedule+0x29/0x70
> > [480594.790103]  [<ffffffff8168b749>] schedule_timeout+0x239/0x2c0
> > [480594.790111]  [<ffffffff8168d28e>] io_schedule_timeout+0xae/0x130
> > [480594.790114]  [<ffffffff8168d328>] io_schedule+0x18/0x20
> > [480594.790116]  [<ffffffff8168bd71>] bit_wait_io+0x11/0x50
> > [480594.790118]  [<ffffffff8168b895>] __wait_on_bit+0x65/0x90
> > [480594.790121]  [<ffffffff811814e1>] wait_on_page_bit+0x81/0xa0
> > [480594.790125]  [<ffffffff81196ad2>] shrink_page_list+0x6d2/0xaf0
> > [480594.790130]  [<ffffffff811975a3>] shrink_inactive_list+0x223/0x710
> > [480594.790135]  [<ffffffff81198225>] shrink_lruvec+0x3b5/0x810
> > [480594.790139]  [<ffffffff8119873a>] shrink_zone+0xba/0x1e0
> > [480594.790141]  [<ffffffff81198c20>] do_try_to_free_pages+0x100/0x510
> > [480594.790143]  [<ffffffff8119928d>] try_to_free_mem_cgroup_pages+0xdd/0x170
> > [480594.790145]  [<ffffffff811f32de>] mem_cgroup_reclaim+0x4e/0x120
> > [480594.790147]  [<ffffffff811f37cc>] __mem_cgroup_try_charge+0x41c/0x670
> > [480594.790153]  [<ffffffff811f5cb6>] __memcg_kmem_newpage_charge+0xf6/0x180
> > [480594.790157]  [<ffffffff8118c72d>] __alloc_pages_nodemask+0x22d/0x420
> > [480594.790162]  [<ffffffff811d0c7a>] alloc_pages_current+0xaa/0x170
> > [480594.790165]  [<ffffffff811db8fc>] new_slab+0x30c/0x320
> > [480594.790168]  [<ffffffff811dd17c>] ___slab_alloc+0x3ac/0x4f0
> > [480594.790204]  [<ffffffff81685656>] __slab_alloc+0x40/0x5c
> > [480594.790206]  [<ffffffff811dfc43>] kmem_cache_alloc+0x193/0x1e0
> > [480594.790233]  [<ffffffffa04fab67>] kmem_zone_alloc+0x97/0x130 [xfs]
> > [480594.790247]  [<ffffffffa04f90ba>] _xfs_trans_alloc+0x3a/0xa0 [xfs]
> > [480594.790261]  [<ffffffffa04f915c>] xfs_trans_alloc+0x3c/0x50 [xfs]
> > [480594.790276]  [<ffffffffa04e958b>] xfs_iomap_write_allocate+0x1cb/0x390 [xfs]
> > [480594.790299]  [<ffffffffa04d3616>] xfs_map_blocks+0x1a6/0x210 [xfs]
> > [480594.790312]  [<ffffffffa04d416b>] xfs_do_writepage+0x17b/0x550 [xfs]
> 
> xfs_do_writepages doesn't exist anymore.  Does upstream have this
> problem?  What kernel is this patch targeting?

It does via xfs_bmapi_convert_delalloc() -> xfs_trans_alloc().

I suspect the entire iomap_do_writepage() path should be run under
GFP_NOFS context given that it is called with a locked page
cache page and calls ->map_blocks from that context...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
