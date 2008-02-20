Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Feb 2008 16:42:39 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1K0gU4Z028557
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 16:42:35 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A057EE6AACD
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 16:42:55 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id qt3QULx6OdC4QA8D for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 16:42:55 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id E76FD18005C1F
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 18:42:54 -0600 (CST)
Message-ID: <47BB778E.40900@sandeen.net>
Date: Tue, 19 Feb 2008 18:42:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] swap E2BIG for EFBIG in mount size checks
References: <47925F5C.7010701@sandeen.net>
In-Reply-To: <47925F5C.7010701@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Mounting a too-big filesystem results in a very strange 
> "mount: Argument list too long" error message thanks to the use
> of E2BIG vs. EFBIG.
> 
> Changing this should make the error message a little more helpful.

Good idea?  bad idea?  crickets? :)

-Eric

> (Incidentally: why do we check for ENOSPC after a read, and convert
> it to E[2F]BIG?  It seems to be ancient code...  And what would you 
> think of making "size check 1 failed" etc something more descriptive, 
> like "Sector count overflows" perhaps?)
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> ---
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c
> +++ linux-2.6-xfs/fs/xfs/xfs_mount.c
> @@ -196,10 +196,10 @@ xfs_sb_validate_fsb_count(
>  
>  #if XFS_BIG_BLKNOS     /* Limited by ULONG_MAX of page cache index */
>  	if (nblocks >> (PAGE_CACHE_SHIFT - sbp->sb_blocklog) > ULONG_MAX)
> -		return E2BIG;
> +		return EFBIG;
>  #else                  /* Limited by UINT_MAX of sectors */
>  	if (nblocks << (sbp->sb_blocklog - BBSHIFT) > UINT_MAX)
> -		return E2BIG;
> +		return EFBIG;
>  #endif
>  	return 0;
>  }
> @@ -289,7 +289,7 @@ xfs_mount_validate_sb(
>  	    xfs_sb_validate_fsb_count(sbp, sbp->sb_rblocks)) {
>  		xfs_fs_mount_cmn_err(flags,
>  			"file system too large to be mounted on this system.");
> -		return XFS_ERROR(E2BIG);
> +		return XFS_ERROR(EFBIG);
>  	}
>  
>  	if (unlikely(sbp->sb_inprogress)) {
> @@ -899,7 +899,7 @@ xfs_check_sizes(xfs_mount_t *mp, int mfs
>  	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
>  	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_dblocks) {
>  		cmn_err(CE_WARN, "XFS: size check 1 failed");
> -		return XFS_ERROR(E2BIG);
> +		return XFS_ERROR(EFBIG);
>  	}
>  	error = xfs_read_buf(mp, mp->m_ddev_targp,
>  			     d - XFS_FSS_TO_BB(mp, 1),
> @@ -909,7 +909,7 @@ xfs_check_sizes(xfs_mount_t *mp, int mfs
>  	} else {
>  		cmn_err(CE_WARN, "XFS: size check 2 failed");
>  		if (error == ENOSPC)
> -			error = XFS_ERROR(E2BIG);
> +			error = XFS_ERROR(EFBIG);
>  		return error;
>  	}
>  
> @@ -918,7 +918,7 @@ xfs_check_sizes(xfs_mount_t *mp, int mfs
>  		d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
>  		if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks) {
>  			cmn_err(CE_WARN, "XFS: size check 3 failed");
> -			return XFS_ERROR(E2BIG);
> +			return XFS_ERROR(EFBIG);
>  		}
>  		error = xfs_read_buf(mp, mp->m_logdev_targp,
>  				     d - XFS_FSB_TO_BB(mp, 1),
> @@ -928,7 +928,7 @@ xfs_check_sizes(xfs_mount_t *mp, int mfs
>  		} else {
>  			cmn_err(CE_WARN, "XFS: size check 3 failed");
>  			if (error == ENOSPC)
> -				error = XFS_ERROR(E2BIG);
> +				error = XFS_ERROR(EFBIG);
>  			return error;
>  		}
>  	}
> Index: linux-2.6-xfs/fs/xfs/xfs_rtalloc.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_rtalloc.c
> +++ linux-2.6-xfs/fs/xfs/xfs_rtalloc.c
> @@ -2236,7 +2236,7 @@ xfs_rtmount_init(
>  		cmn_err(CE_WARN, "XFS: realtime mount -- %llu != %llu",
>  			(unsigned long long) XFS_BB_TO_FSB(mp, d),
>  			(unsigned long long) mp->m_sb.sb_rblocks);
> -		return XFS_ERROR(E2BIG);
> +		return XFS_ERROR(EFBIG);
>  	}
>  	error = xfs_read_buf(mp, mp->m_rtdev_targp,
>  				d - XFS_FSB_TO_BB(mp, 1),
> @@ -2245,7 +2245,7 @@ xfs_rtmount_init(
>  		cmn_err(CE_WARN,
>  	"XFS: realtime mount -- xfs_read_buf failed, returned %d", error);
>  		if (error == ENOSPC)
> -			return XFS_ERROR(E2BIG);
> +			return XFS_ERROR(EFBIG);
>  		return error;
>  	}
>  	xfs_buf_relse(bp);
> 
> 
> 
