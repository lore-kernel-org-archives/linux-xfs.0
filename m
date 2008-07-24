Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 00:51:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6O7p463028482
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 00:51:06 -0700
Message-ID: <488835F7.3040007@sgi.com>
Date: Thu, 24 Jul 2008 17:57:43 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 1/5] kill vn_from_inode
References: <20080723194934.GB6188@lst.de>
In-Reply-To: <20080723194934.GB6188@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Yep, good stuff.

Christoph Hellwig wrote:
> bhv_vnode_t is just a typedef for struct inode, so there's no need for
> a helper to convert between the two.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-07-23 19:29:16.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-07-23 19:29:22.000000000 +0200
> @@ -994,7 +994,7 @@ STATIC void
>  xfs_fs_destroy_inode(
>  	struct inode		*inode)
>  {
> -	kmem_zone_free(xfs_vnode_zone, vn_from_inode(inode));
> +	kmem_zone_free(xfs_vnode_zone, inode);
>  }
>  
>  STATIC void
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-07-23 19:29:26.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2008-07-23 19:29:52.000000000 +0200
> @@ -27,10 +27,6 @@ typedef struct inode	bhv_vnode_t;
>  /*
>   * Vnode to Linux inode mapping.
>   */
> -static inline bhv_vnode_t *vn_from_inode(struct inode *inode)
> -{
> -	return inode;
> -}
>  static inline struct inode *vn_to_inode(bhv_vnode_t *vnode)
>  {
>  	return vnode;
> @@ -100,8 +96,7 @@ extern bhv_vnode_t	*vn_hold(bhv_vnode_t 
>  
>  static inline bhv_vnode_t *vn_grab(bhv_vnode_t *vp)
>  {
> -	struct inode *inode = igrab(vn_to_inode(vp));
> -	return inode ? vn_from_inode(inode) : NULL;
> +	return igrab(vn_to_inode(vp));
>  }
>  
>  /*
> 
> 
> 
