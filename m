Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Oct 2008 03:47:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9FAl1Ke011611
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 03:47:01 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A99A64FE4CB
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 03:48:43 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id wnoHjJuHnkOhMGvD for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 03:48:43 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m9FAmfIF008905
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 12:48:41 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m9FAmfwj008903
	for xfs@oss.sgi.com; Wed, 15 Oct 2008 12:48:41 +0200
Date: Wed, 15 Oct 2008 12:48:40 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] remove exports of inline functions
Message-ID: <20081015104840.GA8853@lst.de>
References: <20081006181626.GA15388@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006181626.GA15388@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Mon, Oct 06, 2008 at 08:16:26PM +0200, Christoph Hellwig wrote:
> Recent gcc starts to complain about exports of functions marked static
> inline, so let's get rid of those.

note that the complain is in the form of a kernel doesn't link, so any
chance we could get this patch in?

> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-10-07 01:08:33.000000000 +0000
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2008-10-07 01:09:58.000000000 +0000
> @@ -153,8 +153,6 @@
>  EXPORT_SYMBOL(kmem_zalloc);
>  EXPORT_SYMBOL(kmem_zone_alloc);
>  EXPORT_SYMBOL(kmem_zalloc_greedy);
> -EXPORT_SYMBOL(kmem_zone_free);
> -EXPORT_SYMBOL(kmem_zone_init);
>  EXPORT_SYMBOL(kmem_zone_zalloc);
>  EXPORT_SYMBOL(xfs_address_space_operations);
>  EXPORT_SYMBOL(xfs_dir_file_operations);
> @@ -217,8 +215,6 @@
>  EXPORT_SYMBOL(xfs_finish_reclaim_all);
>  EXPORT_SYMBOL(xfs_freesb);
>  EXPORT_SYMBOL(xfs_fs_cmn_err);
> -EXPORT_SYMBOL(xfs_highbit32);
> -EXPORT_SYMBOL(xfs_highbit64);
>  EXPORT_SYMBOL(xfs_idestroy);
>  EXPORT_SYMBOL(xfs_iextract);
>  EXPORT_SYMBOL(xfs_iext_add);
> @@ -227,10 +223,7 @@
>  EXPORT_SYMBOL(xfs_iext_idx_to_irec);
>  EXPORT_SYMBOL(xfs_iext_insert);
>  EXPORT_SYMBOL(xfs_iext_remove);
> -EXPORT_SYMBOL(xfs_iflock);
> -EXPORT_SYMBOL(xfs_iflock_nowait);
>  EXPORT_SYMBOL(xfs_iflush);
> -EXPORT_SYMBOL(xfs_ifunlock);
>  EXPORT_SYMBOL(xfs_iget);
>  EXPORT_SYMBOL(xfs_ilock);
>  EXPORT_SYMBOL(xfs_ilock_map_shared);
---end quoted text---
