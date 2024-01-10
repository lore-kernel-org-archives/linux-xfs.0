Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7404D111
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2024 17:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lsbzqhi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBA2C43394;
	Wed, 10 Jan 2024 17:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704908702;
	bh=XNcpeoQR+0c6BNF+8MCASkSPJpRw42sHwLgcAa6YCs4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lsbzqhi2fDRKAkZD39/VBP+yDv6f1nZe00DGkUIpfYAHAPalBxr3L37Gkbp3xHoM8
	 FNSamPFS6W8Aabw0EOpK4bLiiwQITf7a76tcUtHoi+712CitxmsC74LZULgCP6ojHk
	 Or2t5zPOWsHUIOLA7J+beQOurMNMEY9sbajbbZ+gyzvu00WmNZqgYfnR/ikm5zpFEn
	 D5ez/elZznacYxZ+F2afhZa1tx6y0gl5SVmERlri+uK7F8LmPgCLycBDl5oDOb32B9
	 cMHeg9N9iO5u6gxIKYbsIoDWcmJlIJu4Za68j3FxFw5FyJPnwHrrFq3JKhCo75EpI/
	 ziwxS5Rm6DkTg==
Date: Wed, 10 Jan 2024 09:45:01 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jian Wen <wenjianhn@gmail.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
	Jian Wen <wenjian1@xiaomi.com>
Subject: Re: [PATCH] xfs: explicitly call cond_resched in
 xfs_itruncate_extents_flags
Message-ID: <20240110174501.GH722975@frogsfrogsfrogs>
References: <20240110071347.3711925-1-wenjian1@xiaomi.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240110071347.3711925-1-wenjian1@xiaomi.com>

On Wed, Jan 10, 2024 at 03:13:47PM +0800, Jian Wen wrote:
> From: Jian Wen <wenjianhn@gmail.com>
> 
> Deleting a file with lots of extents may cause a soft lockup if the
> preemption model is none(CONFIG_PREEMPT_NONE=y or preempt=none is set
> in the kernel cmdline). Alibaba cloud kernel and Oracle UEK container
> kernel are affected by the issue, since they select CONFIG_PREEMPT_NONE=y.
> 
> Explicitly call cond_resched in xfs_itruncate_extents_flags avoid
> the below softlockup warning.
> watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [kworker/0:13:139]

Wowwee, how many extents does this file have, anyway?

> CPU: 0 PID: 139 Comm: kworker/0:13 Not tainted 6.7.0-rc8-g610a9b8f49fb #23
>  Workqueue: xfs-inodegc/vda1 xfs_inodegc_worker
>  Call Trace:
>   _raw_spin_lock+0x30/0x80
>   ? xfs_extent_busy_trim+0x38/0x200
>   xfs_extent_busy_trim+0x38/0x200
>   xfs_alloc_compute_aligned+0x38/0xd0
>   xfs_alloc_ag_vextent_size+0x1f1/0x870
>   xfs_alloc_fix_freelist+0x58a/0x770
>   xfs_free_extent_fix_freelist+0x60/0xa0
>   __xfs_free_extent+0x66/0x1d0
>   xfs_trans_free_extent+0xac/0x290
>   xfs_extent_free_finish_item+0xf/0x40
>   xfs_defer_finish_noroll+0x1db/0x7f0
>   xfs_defer_finish+0x10/0xa0
>   xfs_itruncate_extents_flags+0x169/0x4c0
>   xfs_inactive_truncate+0xba/0x140
>   xfs_inactive+0x239/0x2a0
>   xfs_inodegc_worker+0xa3/0x210
>   ? process_scheduled_works+0x273/0x550
>   process_scheduled_works+0x2da/0x550
>   worker_thread+0x180/0x350
> 
> Most of the Linux distributions default to voluntary preemption,
> might_sleep() would yield CPU if needed. Thus they are not affected.
> kworker/0:24+xf     298 [000]  7294.810021: probe:__cond_resched:
>   __cond_resched+0x5 ([kernel.kallsyms])
>   __kmem_cache_alloc_node+0x17c ([kernel.kallsyms])
>   __kmalloc+0x4d ([kernel.kallsyms])
>   kmem_alloc+0x7a ([kernel.kallsyms])
>   xfs_extent_busy_insert_list+0x2e ([kernel.kallsyms])
>   __xfs_free_extent+0xd3 ([kernel.kallsyms])
>   xfs_trans_free_extent+0x93 ([kernel.kallsyms])
>   xfs_extent_free_finish_item+0xf ([kernel.kallsyms])
> 
> kworker/0:24+xf     298 [000]  7294.810045: probe:__cond_resched:
>   __cond_resched+0x5 ([kernel.kallsyms])
>   down+0x11 ([kernel.kallsyms])
>   xfs_buf_lock+0x2c ([kernel.kallsyms])
>   xfs_buf_find_lock+0x62 ([kernel.kallsyms])
>   xfs_buf_get_map+0x1fd ([kernel.kallsyms])
>   xfs_buf_read_map+0x51 ([kernel.kallsyms])
>   xfs_trans_read_buf_map+0x1c5 ([kernel.kallsyms])
>   xfs_btree_read_buf_block.constprop.0+0xa1 ([kernel.kallsyms])
>   xfs_btree_lookup_get_block+0x97 ([kernel.kallsyms])
>   xfs_btree_lookup+0xc5 ([kernel.kallsyms])
>   xfs_alloc_lookup_eq+0x18 ([kernel.kallsyms])
>   xfs_free_ag_extent+0x63f ([kernel.kallsyms])
>   __xfs_free_extent+0xa7 ([kernel.kallsyms])
>   xfs_trans_free_extent+0x93 ([kernel.kallsyms])
>   xfs_extent_free_finish_item+0xf ([kernel.kallsyms])
> 
> Signed-off-by: Jian Wen <wenjian1@xiaomi.com>
> ---
>  fs/xfs/xfs_inode.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c0f1c89786c2..194381e10472 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -4,6 +4,7 @@
>   * All Rights Reserved.
>   */
>  #include <linux/iversion.h>
> +#include <linux/sched.h>
>  
>  #include "xfs.h"
>  #include "xfs_fs.h"
> @@ -1383,6 +1384,8 @@ xfs_itruncate_extents_flags(
>  		error = xfs_defer_finish(&tp);
>  		if (error)
>  			goto out;
> +
> +		cond_resched();

Is there a particular reason why truncation uses a giant chained
transaction for all extents (with xfs_defer_finish) instead of, say, one
chain per extent?

(If you've actually studied this and know why then I guess cond_resched
is a reasonable bandaid, but I don't want to play cond_resched
whackamole here.)

--D

>  	}
>  
>  	if (whichfork == XFS_DATA_FORK) {
> -- 
> 2.25.1
> 
> 
