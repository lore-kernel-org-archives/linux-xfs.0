Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jun 2008 03:13:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5GADOEZ012030
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 03:13:25 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 46702CC1E1E
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 03:14:21 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id gJsPylyidb6Y5vx5 for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 03:14:21 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m5GAECNW017988
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 12:14:12 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m5GAECGt017986
	for xfs@oss.sgi.com; Mon, 16 Jun 2008 12:14:12 +0200
Date: Mon, 16 Jun 2008 12:14:12 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] kill INDUCE_IO_ERROR
Message-ID: <20080616101412.GA17939@lst.de>
References: <20080523062323.GA32637@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080523062323.GA32637@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Fri, May 23, 2008 at 08:23:23AM +0200, Christoph Hellwig wrote:
> All the error injection is already enabled through ifdef DEBUG, so kill
> the never set second cpp symbol to activate it without the rest of the
> debugging infrastructure.

Can I get a review on this absolutely trivial patch?

> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_error.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_error.c	2008-05-22 18:55:04.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_error.c	2008-05-22 18:55:16.000000000 +0200
> @@ -58,9 +58,6 @@ xfs_error_trap(int e)
>  	}
>  	return e;
>  }
> -#endif
> -
> -#if (defined(DEBUG) || defined(INDUCE_IO_ERROR))
>  
>  int	xfs_etest[XFS_NUM_INJECT_ERROR];
>  int64_t	xfs_etest_fsid[XFS_NUM_INJECT_ERROR];
> @@ -154,7 +151,7 @@ xfs_errortag_clearall(xfs_mount_t *mp, i
>  
>  	return 0;
>  }
> -#endif /* DEBUG || INDUCE_IO_ERROR */
> +#endif /* DEBUG */
>  
>  static void
>  xfs_fs_vcmn_err(int level, xfs_mount_t *mp, char *fmt, va_list ap)
> Index: linux-2.6-xfs/fs/xfs/xfs_error.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_error.h	2008-05-22 18:55:04.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_error.h	2008-05-22 18:55:16.000000000 +0200
> @@ -125,22 +125,14 @@ extern void xfs_corruption_error(char *t
>  #define XFS_RANDOM_DIOWRITE_IOERR			(XFS_RANDOM_DEFAULT/10)
>  #define	XFS_RANDOM_BMAPIFORMAT				XFS_RANDOM_DEFAULT
>  
> -#if (defined(DEBUG) || defined(INDUCE_IO_ERROR))
> +#ifdef DEBUG
>  extern int xfs_error_test(int, int *, char *, int, char *, unsigned long);
>  
>  #define	XFS_NUM_INJECT_ERROR				10
> -
> -#ifdef __ANSI_CPP__
> -#define XFS_TEST_ERROR(expr, mp, tag, rf)		\
> -	((expr) || \
> -	 xfs_error_test((tag), (mp)->m_fixedfsid, #expr, __LINE__, __FILE__, \
> -			 (rf)))
> -#else
>  #define XFS_TEST_ERROR(expr, mp, tag, rf)		\
>  	((expr) || \
>  	 xfs_error_test((tag), (mp)->m_fixedfsid, "expr", __LINE__, __FILE__, \
>  			(rf)))
> -#endif /* __ANSI_CPP__ */
>  
>  extern int xfs_errortag_add(int error_tag, xfs_mount_t *mp);
>  extern int xfs_errortag_clearall(xfs_mount_t *mp, int loud);
> @@ -148,7 +140,7 @@ extern int xfs_errortag_clearall(xfs_mou
>  #define XFS_TEST_ERROR(expr, mp, tag, rf)	(expr)
>  #define xfs_errortag_add(tag, mp)		(ENOSYS)
>  #define xfs_errortag_clearall(mp, loud)		(ENOSYS)
> -#endif /* (DEBUG || INDUCE_IO_ERROR) */
> +#endif /* DEBUG */
>  
>  /*
>   * XFS panic tags -- allow a call to xfs_cmn_err() be turned into
> Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-05-22 18:55:05.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-05-23 08:11:46.000000000 +0200
> @@ -1322,7 +1322,7 @@ xfs_unmountfs(xfs_mount_t *mp)
>  	if ((mp->m_flags & XFS_MOUNT_NOUUID) == 0)
>  		uuid_table_remove(&mp->m_sb.sb_uuid);
>  
> -#if defined(DEBUG) || defined(INDUCE_IO_ERROR)
> +#if defined(DEBUG)
>  	xfs_errortag_clearall(mp, 0);
>  #endif
>  	xfs_mount_free(mp);
---end quoted text---
