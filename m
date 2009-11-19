Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAJ4oxC8235322 for <xfs@oss.sgi.com>; Wed, 18 Nov 2009 22:51:00 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 65442D64CB3
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2009 20:51:21 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id qADvS0kQ7peC3YIr for
	<xfs@oss.sgi.com>; Wed, 18 Nov 2009 20:51:21 -0800 (PST)
Message-ID: <4B04CEC8.1040603@sandeen.net>
Date: Wed, 18 Nov 2009 22:51:20 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 4/7] xfs: uninline xfs_get_extsz_hint
References: <20091114161717.233372584@bombadil.infradead.org>
	<20091114161801.818601601@bombadil.infradead.org>
In-Reply-To: <20091114161801.818601601@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:

> This function is too large to efficiently be inlined.

Just out of curiosity; too how do you define too large?

-Eric

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_rw.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_rw.c	2009-11-12 17:14:15.278004428 +0100
> +++ xfs/fs/xfs/xfs_rw.c	2009-11-12 17:18:33.311004263 +0100
> @@ -336,3 +336,25 @@ xfs_bwrite(
>  	}
>  	return (error);
>  }
> +
> +/*
> + * helper function to extract extent size hint from inode
> + */
> +xfs_extlen_t
> +xfs_get_extsz_hint(
> +	struct xfs_inode	*ip)
> +{
> +	xfs_extlen_t		extsz;
> +
> +	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
> +		extsz = (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)
> +				? ip->i_d.di_extsize
> +				: ip->i_mount->m_sb.sb_rextsize;
> +		ASSERT(extsz);
> +	} else {
> +		extsz = (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)
> +				? ip->i_d.di_extsize : 0;
> +	}
> +
> +	return extsz;
> +}
> Index: xfs/fs/xfs/xfs_rw.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_rw.h	2009-11-09 17:06:46.116004228 +0100
> +++ xfs/fs/xfs/xfs_rw.h	2009-11-12 17:18:33.311004263 +0100
> @@ -37,27 +37,6 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_
>  }
>  
>  /*
> - * helper function to extract extent size hint from inode
> - */
> -STATIC_INLINE xfs_extlen_t
> -xfs_get_extsz_hint(
> -	xfs_inode_t	*ip)
> -{
> -	xfs_extlen_t	extsz;
> -
> -	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
> -		extsz = (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)
> -				? ip->i_d.di_extsize
> -				: ip->i_mount->m_sb.sb_rextsize;
> -		ASSERT(extsz);
> -	} else {
> -		extsz = (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)
> -				? ip->i_d.di_extsize : 0;
> -	}
> -	return extsz;
> -}
> -
> -/*
>   * Prototypes for functions in xfs_rw.c.
>   */
>  extern int xfs_write_clear_setuid(struct xfs_inode *ip);
> @@ -69,5 +48,6 @@ extern int xfs_read_buf(struct xfs_mount
>  			struct xfs_buf **bpp);
>  extern void xfs_ioerror_alert(char *func, struct xfs_mount *mp,
>  				xfs_buf_t *bp, xfs_daddr_t blkno);
> +extern xfs_extlen_t xfs_get_extsz_hint(struct xfs_inode *ip);
>  
>  #endif /* __XFS_RW_H__ */
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
