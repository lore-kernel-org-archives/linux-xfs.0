Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f43.google.com ([209.85.128.43]:39382 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbeI0Qaj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Sep 2018 12:30:39 -0400
Received: by mail-wm1-f43.google.com with SMTP id q8-v6so5394201wmq.4
        for <linux-xfs@vger.kernel.org>; Thu, 27 Sep 2018 03:13:06 -0700 (PDT)
Date: Thu, 27 Sep 2018 12:13:01 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [ANNOUNCE] xfsprogs libxfs-4.19-sync branch rebased
Message-ID: <20180927101301.we7iviepwxb6lqnq@odin.usersys.redhat.com>
References: <193ea177-7759-f501-2c24-d03be6904a8f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <193ea177-7759-f501-2c24-d03be6904a8f@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Sep 26, 2018 at 02:12:46PM -0500, Eric Sandeen wrote:
> Hi all -
> 
> I've rebased the libxfs-4.19-sync branch with some minor fixes (below).
> 
> The head of the libxfs-4.19-sync branch is commit:
> 
> a891cd6 xfs: fix a null pointer dereference in xfs_bmap_extents_to_btree
> 
> This is still just a backport of the kernel libxfs.  I'll get to Darrick's
> transaction cleanups on top of this soon, but I was trying to stick with
> the standard "update libxfs, then get to everything else" approach.
> 
> I'll push this to for-next and tag it with an -rc0 in the next day or so,
> barring any disasters.
> 
> Thanks,
> -Eric
> 

\o/  better late than never

Whole series looks ok, you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> changes since the last push:
> 
> diff -Nurp xfsprogs-maint-clean/libxfs/libxfs_priv.h xfsprogs-maint/libxfs/libxfs_priv.h
> --- xfsprogs-maint-clean/libxfs/libxfs_priv.h	2018-09-02 23:09:54.825409402 -0500
> +++ xfsprogs-maint/libxfs/libxfs_priv.h	2018-09-26 14:11:08.805788185 -0500
> @@ -563,7 +563,7 @@ int libxfs_zero_extent(struct xfs_inode 
>  
>  
>  bool xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
> -#define xfs_log_in_recovery(mp)	false
> +#define xfs_log_in_recovery(mp)	(false)
>  
>  /* xfs_icache.c */
>  #define xfs_inode_set_cowblocks_tag(ip)	do { } while (0)
> Binary files xfsprogs-maint-clean/libxfs/list_sort.o and xfsprogs-maint/libxfs/list_sort.o differ
> Binary files xfsprogs-maint-clean/libxfs/radix-tree.o and xfsprogs-maint/libxfs/radix-tree.o differ
> diff -Nurp xfsprogs-maint-clean/libxfs/trans.c xfsprogs-maint/libxfs/trans.c
> --- xfsprogs-maint-clean/libxfs/trans.c	2018-09-02 23:09:54.826409407 -0500
> +++ xfsprogs-maint/libxfs/trans.c	2018-09-26 14:10:37.664613207 -0500
> @@ -80,6 +80,8 @@ libxfs_trans_roll(
>  	struct xfs_trans	*trans = *tpp;
>  	struct xfs_trans_res	tres;
>  	unsigned int		old_blk_res;
> +	xfs_fsblock_t		old_firstblock;
> +	struct list_head	old_dfops;
>  	int			error;
>  
>  	/*
> @@ -89,6 +91,9 @@ libxfs_trans_roll(
>  	tres.tr_logres = trans->t_log_res;
>  	tres.tr_logcount = trans->t_log_count;
>  	old_blk_res = trans->t_blk_res;
> +	old_firstblock = trans->t_firstblock;
> +	/* structure copy */
> +	old_dfops = trans->t_dfops;
>  
>  	/*
>  	 * Commit the current transaction.
> @@ -113,6 +118,9 @@ libxfs_trans_roll(
>  	error = libxfs_trans_alloc(mp, &tres, 0, 0, 0, tpp);
>  	trans = *tpp;
>  	trans->t_blk_res = old_blk_res;
> +	trans->t_firstblock = old_firstblock;
> +	/* structure copy */
> +	trans->t_dfops = old_dfops;
>  
>  	return 0;
>  }
> @@ -156,6 +164,8 @@ libxfs_trans_alloc(
>  	ptr->t_mountp = mp;
>  	ptr->t_blk_res = blocks;
>  	INIT_LIST_HEAD(&ptr->t_items);
> +	INIT_LIST_HEAD(&ptr->t_dfops);
> +	ptr->t_firstblock = NULLFSBLOCK;
>  #ifdef XACT_DEBUG
>  	fprintf(stderr, "allocated new transaction %p\n", ptr);
>  #endif
> 

-- 
Carlos
