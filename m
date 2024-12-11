Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471111F0E59
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 22:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733956409; cv=none; b=BZxQX1HYiwHbGuHGTxMysyUuuRVx6pFKmKdfAJ0OulzEbEC+LhCaf26bQZanG5JQSVwsGK4fWCLSFSTY5VILh7KwVBGFkAzjkISJl9b8fA0oFEqGR67dmxcBwr0eAjGNOnYU3uCIGK+1urSt+l96Yh9IZJ/x873snlKwYkWIato=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733956409; c=relaxed/simple;
	bh=ttcXYicbtNuPPSZUNhuBr9GMVgU95Mq002ir1t+DK0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V8tBSyjYHo/HsMLJiRZ08hIWrGA9dibL8coXDttJqi3qFIfHG9XWXdYPtx2KNl5G+efKg//ZqmOaIYntGp5+Q6z9Ld4pRhrBu9RcS2PUbcj7zoTrjXuWw3ZrkebrJGeps+yeGeoUNOPVKktZSSVgEOIlcvwecQyjNN1LoR64wLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ayXc4R5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ayXc4R5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036AFC4CED3;
	Wed, 11 Dec 2024 22:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733956409;
	bh=ttcXYicbtNuPPSZUNhuBr9GMVgU95Mq002ir1t+DK0I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ayXc4R5cXOms7Ojph7bKdesPAVm6Pehgj2qhJ64aQuTWS21/lYzu8ZDLpu+hGd6C/
	 dA7GPyl/ecX+AQm9OWL08C/a1JZ4wxyxciuEx6nrlqbtHxgzUxj86XORCkhEl3orMA
	 ms8raPSP0SK+YiUr/zCBursetrm4A+4BuqQFbwhHd4VttdM81fFUFns7uHo91XkyKK
	 YRmy/P7cWQ5+6Zr0VGGCg0ekywa8x6QdIG2ISBeWfjzLUKFxtCBo90eo0uOlHsqfbB
	 T6mnPTuzjjtnsT0ehZgIAhi1/KNBScr9v4xHFwX1mGocaiLq9PbE305sy3rfRZEjTr
	 lyb6KgTNOsQ1Q==
Date: Wed, 11 Dec 2024 23:33:24 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de, djwong@kernel.org, dchinner@fromorbit.com
Subject: Re: [PATCH] xfs: fix integer overflow in xlog_grant_head_check
Message-ID: <hgionwz2jw7bbupp2pdkpxy5kluv7vqjawd47loo5sfequo4rs@cag5beugnkrg>
References: <20241210124628.578843-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241210124628.578843-1-cem@kernel.org>

On Tue, Dec 10, 2024 at 12:54:39PM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cmaiolino@redhat.com>
> 
> I tripped over an integer overflow when using a big journal size.
> 
> Essentially I can reliably reproduce it using:
> 
> mkfs.xfs -f -lsize=393216b -f -b size=4096 -m crc=1,reflink=1,rmapbt=1, \
> -i sparse=1 /dev/vdb2 > /dev/null
> mount -o usrquota,grpquota,prjquota /dev/vdb2 /mnt
> xfs_io -x -c 'shutdown -f' /mnt
> umount /mnt
> mount -o usrquota,grpquota,prjquota /dev/vdb2 /mnt
> 

My apologies, I realized just now I posted the wrong reproducer here, the
correct one is:

mkfs.xfs -f -lsize=393216b -f -b size=4096 -m crc=1,reflink=1,rmapbt=1, -i sparse=1 /dev/vdb2 > /dev/null
mount -o usrquota,grpquota,prjquota /dev/vdb2 /mnt
xfs_io -x -c 'shutdown -f' /mnt
umount /mnt
mount -o ro,norecovery,usrquota,grpquota,prjquota  /dev/vdb2 /mnt

The lockup I mentioned happens on the norecovery mount. not on the regular
mount as first I stated on the patch description.

Sorry for the confusion

> The last mount command get stuck on the following path:
> 
> [<0>] xlog_grant_head_wait+0x5d/0x2a0 [xfs]
> [<0>] xlog_grant_head_check+0x112/0x180 [xfs]
> [<0>] xfs_log_reserve+0xe3/0x260 [xfs]
> [<0>] xfs_trans_reserve+0x179/0x250 [xfs]
> [<0>] xfs_trans_alloc+0x101/0x260 [xfs]
> [<0>] xfs_sync_sb+0x3f/0x80 [xfs]
> [<0>] xfs_qm_mount_quotas+0xe3/0x2f0 [xfs]
> [<0>] xfs_mountfs+0x7ad/0xc20 [xfs]
> [<0>] xfs_fs_fill_super+0x762/0xa50 [xfs]
> [<0>] get_tree_bdev_flags+0x131/0x1d0
> [<0>] vfs_get_tree+0x26/0xd0
> [<0>] vfs_cmd_create+0x59/0xe0
> [<0>] __do_sys_fsconfig+0x4e3/0x6b0
> [<0>] do_syscall_64+0x82/0x160
> [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> By investigating it a bit, I noticed that xlog_grant_head_check (called
> from xfs_log_reserve), defines free_bytes as an integer, which in turn
> is used to store the value from xlog_grant_space_left().
> xlog_grant_space_left() however, does return a uint64_t, and, giving a
> big enough journal size, it can overflow the free_bytes in
> xlog_grant_head_check(), resulting int the conditional:
> 
> else if (free_bytes < *need_bytes) {
> 
> in xlog_grant_head_check() to evaluate to true and cause xfsaild to try
> to flush the log indefinitely, which seems to be causing xfs to get
> stuck in xlog_grant_head_wait() indefinitely.
> 
> I'm adding a fixes tag as a suggestion from hch, giving that after the
> aforementioned patch, all xlog_grant_space_left() callers should store
> the return value on a 64bit type.
> 
> Fixes: c1220522ef40 ("xfs: grant heads track byte counts, not LSNs")
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> I'd like to add a caveat here, because I don't properly understand the
> journal code/mechanism yet. It does seem to me that it is feasible to
> have the reserve grant head to go to a big number and indeed cause the
> overflow, but I'm not completely sure that what I'm fixing is a real bug
> or if just the symptom of something else (or maybe a bug that triggeded
> another overflow bug :)
> 
> 
>  fs/xfs/xfs_log.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 05daad8a8d34..a799821393b5 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -222,7 +222,7 @@ STATIC bool
>  xlog_grant_head_wake(
>  	struct xlog		*log,
>  	struct xlog_grant_head	*head,
> -	int			*free_bytes)
> +	uint64_t		*free_bytes)
>  {
>  	struct xlog_ticket	*tic;
>  	int			need_bytes;
> @@ -302,7 +302,7 @@ xlog_grant_head_check(
>  	struct xlog_ticket	*tic,
>  	int			*need_bytes)
>  {
> -	int			free_bytes;
> +	uint64_t		free_bytes;
>  	int			error = 0;
>  
>  	ASSERT(!xlog_in_recovery(log));
> @@ -1088,7 +1088,7 @@ xfs_log_space_wake(
>  	struct xfs_mount	*mp)
>  {
>  	struct xlog		*log = mp->m_log;
> -	int			free_bytes;
> +	uint64_t		free_bytes;
>  
>  	if (xlog_is_shutdown(log))
>  		return;
> -- 
> 2.47.1
> 
> 
