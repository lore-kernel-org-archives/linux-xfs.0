Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 517D6C07E9A
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 11:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EFA7613A9
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 11:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239206AbhGNLOu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 07:14:50 -0400
Received: from outbound-smtp25.blacknight.com ([81.17.249.193]:42596 "EHLO
        outbound-smtp25.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229899AbhGNLOu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 07:14:50 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jul 2021 07:14:50 EDT
Received: from mail.blacknight.com (pemlinmail02.blacknight.ie [81.17.254.11])
        by outbound-smtp25.blacknight.com (Postfix) with ESMTPS id 8C8B642052
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 12:05:58 +0100 (IST)
Received: (qmail 5147 invoked from network); 14 Jul 2021 11:05:58 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.17.255])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 14 Jul 2021 11:05:58 -0000
Date:   Wed, 14 Jul 2021 12:05:56 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: Add kvrealloc()
Message-ID: <20210714110556.GK3809@techsingularity.net>
References: <20210714023440.2608690-1-david@fromorbit.com>
 <20210714023440.2608690-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210714023440.2608690-2-david@fromorbit.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 12:34:38PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> During log recovery of an XFS filesystem with 64kB directory
> buffers, rebuilding a buffer split across two log records results
> in a memory allocation warning from krealloc like this:
> 
> xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
> XFS (dm-0): Unmounting Filesystem
> XFS (dm-0): Mounting V5 Filesystem
> XFS (dm-0): Starting recovery (logdev: internal)
> ------------[ cut here ]------------
> WARNING: CPU: 5 PID: 3435170 at mm/page_alloc.c:3539 get_page_from_freelist+0xdee/0xe40
> .....
> RIP: 0010:get_page_from_freelist+0xdee/0xe40
> Call Trace:
>  ? complete+0x3f/0x50
>  __alloc_pages+0x16f/0x300
>  alloc_pages+0x87/0x110
>  kmalloc_order+0x2c/0x90
>  kmalloc_order_trace+0x1d/0x90
>  __kmalloc_track_caller+0x215/0x270
>  ? xlog_recover_add_to_cont_trans+0x63/0x1f0
>  krealloc+0x54/0xb0
>  xlog_recover_add_to_cont_trans+0x63/0x1f0
>  xlog_recovery_process_trans+0xc1/0xd0
>  xlog_recover_process_ophdr+0x86/0x130
>  xlog_recover_process_data+0x9f/0x160
>  xlog_recover_process+0xa2/0x120
>  xlog_do_recovery_pass+0x40b/0x7d0
>  ? __irq_work_queue_local+0x4f/0x60
>  ? irq_work_queue+0x3a/0x50
>  xlog_do_log_recovery+0x70/0x150
>  xlog_do_recover+0x38/0x1d0
>  xlog_recover+0xd8/0x170
>  xfs_log_mount+0x181/0x300
>  xfs_mountfs+0x4a1/0x9b0
>  xfs_fs_fill_super+0x3c0/0x7b0
>  get_tree_bdev+0x171/0x270
>  ? suffix_kstrtoint.constprop.0+0xf0/0xf0
>  xfs_fs_get_tree+0x15/0x20
>  vfs_get_tree+0x24/0xc0
>  path_mount+0x2f5/0xaf0
>  __x64_sys_mount+0x108/0x140
>  do_syscall_64+0x3a/0x70
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Essentially, we are taking a multi-order allocation from kmem_alloc()
> (which has an open coded no fail, no warn loop) and then
> reallocating it out to 64kB using krealloc(__GFP_NOFAIL) and that is
> then triggering the above warning.
> 
> This is a regression caused by converting this code from an open
> coded no fail/no warn reallocation loop to using __GFP_NOFAIL.
> 
> What we actually need here is kvrealloc(), so that if contiguous
> page allocation fails we fall back to vmalloc() and we don't
> get nasty warnings happening in XFS.
> 
> Fixes: 771915c4f688 ("xfs: remove kmem_realloc()")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Acked-by: Mel Gorman <mgorman@techsingularity.net>

-- 
Mel Gorman
SUSE Labs
