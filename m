Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25113 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935113AbdIYWzp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2017 18:55:45 -0400
Date: Mon, 25 Sep 2017 15:55:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v5 1/3] xfs: Show realtime device stats on statfs calls
 if inherit flag set
Message-ID: <20170925225517.GF5020@magnolia>
References: <20170925194418.720146-1-rwareing@fb.com>
 <20170925194418.720146-2-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170925194418.720146-2-rwareing@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org

On Mon, Sep 25, 2017 at 12:44:16PM -0700, Richard Wareing wrote:
> - Reports realtime device free blocks in statfs calls if inheritance
>   bit is set on the inode of directory.  This is a bit more intuitive,
>   especially for use-cases which are using a much larger device for
>   the realtime device.
> - Add XFS_IS_REALTIME_MOUNT option to gate based on the existence of a
>   realtime device on the mount, similar to the XFS_IS_REALTIME_INODE
>   option.
> 
> Signed-off-by: Richard Wareing <rwareing@fb.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> ---
> Changes since v4:
> * None
> 
> Changes since v3:
> * Fixed accounting bug, we are not required to substract m_alloc_set_aside
>   as this is a data device only requirement.
> * Added XFS_IS_REALTIME_MOUNT macro based on learnings from CVE-2017-14340,
>   now provides similar gating on the mount as XFS_IS_REALTIME_INODE does
>   for the inode.
> 
> Changes since v2:
> * Style updated per Christoph Hellwig's comment
> * Fixed bug: statp->f_bavail = statp->f_bfree
> 
>  fs/xfs/xfs_linux.h | 2 ++
>  fs/xfs/xfs_super.c | 8 ++++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 044fb0e..fe46e71 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -280,8 +280,10 @@ static inline __uint64_t howmany_64(__uint64_t x, __uint32_t y)
>  
>  #ifdef CONFIG_XFS_RT
>  #define XFS_IS_REALTIME_INODE(ip) ((ip)->i_d.di_flags & XFS_DIFLAG_REALTIME)
> +#define XFS_IS_REALTIME_MOUNT(mp) ((mp)->m_rtdev_targp ? 1 : 0)

(I kind of dislike these macros but I tried turning them into static inline
functions once and it turned into a nightmare.)

>  #else
>  #define XFS_IS_REALTIME_INODE(ip) (0)
> +#define XFS_IS_REALTIME_MOUNT(mp) (0)
>  #endif
>  
>  #endif /* __XFS_LINUX__ */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 455a575..6d33a5e 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1136,6 +1136,14 @@ xfs_fs_statfs(
>  	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
>  			      (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))
>  		xfs_qm_statvfs(ip, statp);
> +
> +	if (XFS_IS_REALTIME_MOUNT(mp) &&
> +	    (ip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)) {

Why don't we do this for any inode with REALTIME or RTINHERIT set?

--D

> +		statp->f_blocks = sbp->sb_rblocks;
> +		statp->f_bavail = statp->f_bfree =
> +			sbp->sb_frextents * sbp->sb_rextsize;
> +	}
> +
>  	return 0;
>  }
>  
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
