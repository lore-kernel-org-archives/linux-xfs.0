Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A559C49EA5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 02:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69E93613C0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 02:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbhFYCmb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Jun 2021 22:42:31 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:8303 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbhFYCmb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Jun 2021 22:42:31 -0400
Received: from dggeme703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GB1LS1KQ3z1BRYp;
        Fri, 25 Jun 2021 10:34:56 +0800 (CST)
Received: from [10.174.177.120] (10.174.177.120) by
 dggeme703-chm.china.huawei.com (10.1.199.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 25 Jun 2021 10:40:08 +0800
Subject: Re: [PATCH 1/3] mm: Add kvrealloc()
To:     Dave Chinner <david@fromorbit.com>, <linux-xfs@vger.kernel.org>,
        <linux-mm@kvack.org>
References: <20210625023029.1472466-1-david@fromorbit.com>
 <20210625023029.1472466-2-david@fromorbit.com>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <867caabb-bac5-8b34-9a68-53e8953f2fad@huawei.com>
Date:   Fri, 25 Jun 2021 10:40:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210625023029.1472466-2-david@fromorbit.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.120]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme703-chm.china.huawei.com (10.1.199.99)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2021/6/25 10:30, Dave Chinner wrote:
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

Thank you for your patch.

> ---
>  fs/xfs/xfs_log_recover.c |  2 +-
>  include/linux/mm.h       | 14 ++++++++++++++
>  2 files changed, 15 insertions(+), 1 deletion(-)
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
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 8ae31622deef..34d88ff00f31 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -830,6 +830,20 @@ static inline void *kvcalloc(size_t n, size_t size, gfp_t flags)
>  extern void kvfree(const void *addr);
>  extern void kvfree_sensitive(const void *addr, size_t len);
>  
> +static inline void *kvrealloc(void *p, size_t oldsize, size_t newsize,
> +		gfp_t flags)
> +{
> +	void *newp;
> +
> +	if (oldsize >= newsize)
> +		return p;
> +	newp = kvmalloc(newsize, flags);

Shouldn't we check newp against NULL before memcpy?
Thanks.

> +	memcpy(newp, p, oldsize);
> +	kvfree(p);
> +	return newp;
> +}
> +
> +
>  static inline int head_compound_mapcount(struct page *head)
>  {
>  	return atomic_read(compound_mapcount_ptr(head)) + 1;
> 
