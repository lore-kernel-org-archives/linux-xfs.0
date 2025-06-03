Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB2842A87;
	Thu,  5 Jun 2025 08:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749112361; cv=none; b=L55Omv1aaifuOzLO1NmcGXJE2qsLiq07M4c048MlcRWGfE0XVNORpKCgwP+SndA+XRBUsAnib2qWjPmcdjtbA/nZa8PiHZgTEyFK8ahzj1HNLUI0qz7pGxUaovJQPbcSX5rHgh35vFesMPOdXG3p9rr0YJ2QBDR4oT78t+4byPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749112361; c=relaxed/simple;
	bh=Q23qwzl5YFISjyMbslK4Dd0m7IvouEeCMqpBRBUae+g=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=kvip6Gnf+UwDQq7v4RB7xFL7U+ilk/WP/lzlb1LHZPDBqEV0rWAW6T2XLgztEpgA2Fxp3gIY7Z0p9dxTIzEvALYZ44TnTXZpZBRF8SBHzmEM9NvNp+21n/qu/0oru6Ac4dboTNZyzjj8LzGTPPLKROS9P9X9ZIbD/7ybc0QAGw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DtgONLlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DtgONLlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E7DC4CEE7;
	Thu,  5 Jun 2025 08:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749112360;
	bh=Q23qwzl5YFISjyMbslK4Dd0m7IvouEeCMqpBRBUae+g=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=DtgONLlQ5B/nkwOY3t4WTVF260riJq1kKNVaKOBY/T711Td4e3i7oRn+kHHKLpM/R
	 sEXNZv3sRP5kIbvYsFq0pvnTWuhQXzH9hap8gDLhJz0F7AD0IQcXM+Z7lcDPQcGBJ9
	 jyVgp60SB/UamKKCWIogFsNY5INN5wm52CKgeDoMgssH6kkv835AkP5TpkwDBmXuxr
	 DzSOVyvjPXlNkH8euw7fNGjNekbDHgtJ5+m1dhNOdUzMVa0qDhQ91szrNftojSOTA4
	 QrxzEDfU+fwgHV95xxOw6n6y16m2tczn2PVSIgIsNaDvQ36NOoU2mmC/yXJ4gbZO2v
	 +AZWmYtLqLlow==
References: <20250603085056.191073-1-txpeng@tencent.com>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: luminosity1999@gmail.com
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Tianxiang Peng
 <txpeng@tencent.com>, Qing Zhang <diasyzhang@tencent.com>, Hao Peng
 <flyingpeng@tencent.com>, Jinliang Zheng <alexjlzheng@tencent.com>, Hui Li
 <caelli@tencent.com>
Subject: Re: [PATCH 5.4] xfs: Reset cnt_cur to NULL after deletion to
 prevent UAF
Date: Tue, 03 Jun 2025 18:58:52 +0530
In-reply-to: <20250603085056.191073-1-txpeng@tencent.com>
Message-ID: <87plfi37xc.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Jun 03, 2025 at 04:50:56 PM +0800, luminosity1999@gmail.com wrote:
> From: Tianxiang Peng <txpeng@tencent.com>
>
> Our test environment detected a use-after-free bug in XFS:
>
> [ 1396.210852] Allocated by task 26155:
> [ 1396.212769]  save_stack+0x21/0x90
> [ 1396.214670]  __kasan_kmalloc.constprop.8+0xc1/0xd0
> [ 1396.216738]  kasan_slab_alloc+0x11/0x20
> [ 1396.218694]  kmem_cache_alloc+0xfb/0x280
> [ 1396.220750]  kmem_zone_alloc+0xb9/0x240 [xfs]
> [ 1396.222859]  xfs_allocbt_init_cursor+0x60/0x270 [xfs]
> [ 1396.225058]  xfs_alloc_ag_vextent_near+0x2bc/0x1aa0 [xfs]
> [ 1396.227312]  xfs_alloc_ag_vextent+0x3a0/0x5a0 [xfs]
> [ 1396.229503]  xfs_alloc_vextent+0xc11/0xd80 [xfs]
> [ 1396.231665]  xfs_bmap_btalloc+0x632/0xf20 [xfs]
> [ 1396.233804]  xfs_bmap_alloc+0x78/0x90 [xfs]
> [ 1396.235883]  xfs_bmapi_allocate+0x243/0x760 [xfs]
> [ 1396.238032]  xfs_bmapi_convert_delalloc+0x3cf/0x850 [xfs]
> [ 1396.240267]  xfs_map_blocks+0x352/0x820 [xfs]
> [ 1396.242379]  xfs_do_writepage+0x2c2/0x8d0 [xfs]
> [ 1396.244417]  write_cache_pages+0x341/0x760
> [ 1396.246490]  xfs_vm_writepages+0xc8/0x120 [xfs]
> [ 1396.248755]  do_writepages+0x8f/0x160
> [ 1396.250710]  __filemap_fdatawrite_range+0x1a4/0x200
> [ 1396.252823]  filemap_flush+0x1c/0x20
> [ 1396.254847]  xfs_release+0x1b3/0x1f0 [xfs]
> [ 1396.256920]  xfs_file_release+0x15/0x20 [xfs]
> [ 1396.258936]  __fput+0x155/0x390
> [ 1396.260781]  ____fput+0xe/0x10
> [ 1396.262620]  task_work_run+0xbf/0xe0
> [ 1396.264492]  exit_to_usermode_loop+0x11d/0x120
> [ 1396.266496]  do_syscall_64+0x1c3/0x1f0
> [ 1396.268391]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> [ 1396.272067] Freed by task 26155:
> [ 1396.273909]  save_stack+0x21/0x90
> [ 1396.275758]  __kasan_slab_free+0x131/0x180
> [ 1396.277722]  kasan_slab_free+0xe/0x10
> [ 1396.279627]  kmem_cache_free+0x8c/0x2c0
> [ 1396.281625]  xfs_btree_del_cursor+0xb2/0x100 [xfs]
> [ 1396.283739]  xfs_alloc_ag_vextent_near+0x90b/0x1aa0 [xfs]
> [ 1396.285932]  xfs_alloc_ag_vextent+0x3a0/0x5a0 [xfs]
> [ 1396.288049]  xfs_alloc_vextent+0xc11/0xd80 [xfs]
> [ 1396.290065]  xfs_bmap_btalloc+0x632/0xf20 [xfs]
> [ 1396.292008]  xfs_bmap_alloc+0x78/0x90 [xfs]
> [ 1396.293871]  xfs_bmapi_allocate+0x243/0x760 [xfs]
> [ 1396.295801]  xfs_bmapi_convert_delalloc+0x3cf/0x850 [xfs]
> [ 1396.297811]  xfs_map_blocks+0x352/0x820 [xfs]
> [ 1396.299706]  xfs_do_writepage+0x2c2/0x8d0 [xfs]
> [ 1396.301522]  write_cache_pages+0x341/0x760
> [ 1396.303379]  xfs_vm_writepages+0xc8/0x120 [xfs]
> [ 1396.305204]  do_writepages+0x8f/0x160
> [ 1396.306902]  __filemap_fdatawrite_range+0x1a4/0x200
> [ 1396.308756]  filemap_flush+0x1c/0x20
> [ 1396.310545]  xfs_release+0x1b3/0x1f0 [xfs]
> [ 1396.312386]  xfs_file_release+0x15/0x20 [xfs]
> [ 1396.314180]  __fput+0x155/0x390
> [ 1396.315825]  ____fput+0xe/0x10
> [ 1396.317442]  task_work_run+0xbf/0xe0
> [ 1396.319126]  exit_to_usermode_loop+0x11d/0x120
> [ 1396.320928]  do_syscall_64+0x1c3/0x1f0
> [ 1396.322648]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> [ 1396.325958] The buggy address belongs to the object at ffff8898039945a0
>                 which belongs to the cache xfs_btree_cur of size 224
> [ 1396.330097] The buggy address is located 181 bytes inside of
>                 224-byte region [ffff8898039945a0, ffff889803994680)
>
> This issue stems from an incomplete backport of upstream commit
> 8ebbf262d468 ("xfs: don't block in busy flushing when freeing
> extents") to the 5.4 LTS kernel. The backport introduced error
> handling that may goto error0 when xfs_extent_busy_flush() fails:

Hi,

I don't see the commit "xfs: don't block in busy flushing when freeing
extents" on v5.4.294 tag. Can you please provide me the ID of commit which
backports that patch?

Also, Please post backported XFS patches for stable kernels to the mailing
list at xfs-stable@lists.linux.dev

>
> -		xfs_extent_busy_flush(args->mp, args->pag, busy_gen,
> -				alloc_flags);
> +		error = xfs_extent_busy_flush(args->tp, args->pag,
> +				busy_gen, alloc_flags);
> +		if (error)
> +			goto error0;
>
> However, in the 5.4 codebase, the existing cursor deletion logic
> failed to reset cnt_cur to NULL after deletion. While the original
> code's goto restart path reinitialized the cursor, the new goto
> error0 path attempts to delete an already-freed cursor (now
> dangling pointer), causing a use-after-free. Reset cnt_cur to NULL
> after deletion to prevent double-free. This aligns with the cursor
> management pattern used at other deletion sites in the same
> function.
>
> This pitfall was eliminated in 5.15+ LTS kernels via XFS code
> refactoring, making the fix unnecessary for newer versions.
>
> Signed-off-by: Tianxiang Peng <txpeng@tencent.com>
> Reviewed-by: Qing Zhang <diasyzhang@tencent.com>
> Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> Reviewed-by: Jinliang Zheng <alexjlzheng@tencent.com>
> Reviewed-by: Hui Li <caelli@tencent.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 1193fd6e4..ff0c05901 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1417,6 +1417,7 @@ xfs_alloc_ag_vextent_near(
>  	 */
>  	if (bno_cur_lt == NULL && bno_cur_gt == NULL) {
>  		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> +		cnt_cur = NULL;
>  
>  		if (busy) {
>  			trace_xfs_alloc_near_busy(args);

-- 
Chandan
