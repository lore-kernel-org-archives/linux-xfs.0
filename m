Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB73C11F65
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 10:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 142A961D0C
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 10:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbhF3KNG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Jun 2021 06:13:06 -0400
Received: from outbound-smtp15.blacknight.com ([46.22.139.232]:57145 "EHLO
        outbound-smtp15.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233959AbhF3KNG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jun 2021 06:13:06 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jun 2021 06:13:06 EDT
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp15.blacknight.com (Postfix) with ESMTPS id 0BA9F1C4450
        for <linux-xfs@vger.kernel.org>; Wed, 30 Jun 2021 11:04:57 +0100 (IST)
Received: (qmail 14405 invoked from network); 30 Jun 2021 10:04:56 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.17.255])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 30 Jun 2021 10:04:56 -0000
Date:   Wed, 30 Jun 2021 11:04:55 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 1/3] mm: Add kvrealloc()
Message-ID: <20210630100455.GI3840@techsingularity.net>
References: <20210630061431.1750745-1-david@fromorbit.com>
 <20210630061431.1750745-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210630061431.1750745-2-david@fromorbit.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 30, 2021 at 04:14:29PM +1000, Dave Chinner wrote:
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
> ---
>  fs/xfs/xfs_log_recover.c |  2 +-
>  include/linux/mm.h       |  2 ++
>  mm/util.c                | 15 +++++++++++++++
>  3 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 1721fce2ec94..fee4fbadea0a 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2062,7 +2062,7 @@ xlog_recover_add_to_cont_trans(
>  	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
>  	old_len = item->ri_buf[item->ri_cnt-1].i_len;
>  
> -	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
> +	ptr = kvrealloc(old_ptr, old_len, len + old_len, GFP_KERNEL);
>  	memcpy(&ptr[old_len], dp, len);
>  	item->ri_buf[item->ri_cnt-1].i_len += len;
>  	item->ri_buf[item->ri_cnt-1].i_addr = ptr;

While this is an improvement, note that this still potentially fail if,
for example, a vm_struct cannot be allocated for the vmalloc area,
a virtual range is not available, or the pages cannot be allocated
to back the vmalloc range. The last one is potentially problematic if
you look at __vmalloc_node_range and __vmalloc_area_node. vmalloc has
changed a lot since I last familiar with the code but I think it should
not attempt a high-order allocation for 64K but __vmalloc_area_node will
call alloc_pages_node with a GFP mask without __GFP_NOFAIL. In most cases,
it may still succeed but it could fail if the system is OOM. Did I miss
something?

I didn't do a full audit to determine what fallout, if any, there is
to ultimately passing __GFP_NOFAIL to kvmalloc although kvmalloc_node
explicitly notes that __GFP_NOFAIL is not supported. Adding Michal Hocko
to the cc to see if he remembers why __GFP_NOFAIL was problematic.

Absent being able to pass in __GFP_NOFAIL to kvmalloc_node, the new
helper kvrealloc may need to understand __GFP_NOFAIL, avoid passing it
to kvmalloc and indefintiely retry instead to avoid an XFS log recovery
hitting a NULL pointer exception when the memcpy is tried :(

-- 
Mel Gorman
SUSE Labs
