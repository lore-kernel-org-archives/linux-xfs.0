Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 23:00:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2P5xmks005528
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 22:59:53 -0700
Date: Tue, 25 Mar 2008 17:00:17 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: REVIEW: Write primary superblock info to ALL secondaries during mkfs
Message-ID: <20080325060017.GK103491721@sgi.com>
References: <op.t8j4nch93jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t8j4nch93jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Mar 25, 2008 at 04:39:02PM +1100, Barry Naujok wrote:
> Secondaries should contain redundant information from the primary
> superblock. It does this for the filesystem geometry information,
> but not inode values (rootino, rt inos, quota inos).
> 
> This patch updates all the secondaries from the primary just before
> it marks the filesystem as good to go.

So it's got all the inodes, geometry, etc correct in them?

So what about the fact that the kernel code doesn't keep all
copies up to date? e.g. growfs will only write new values into
a handful of superblocks, changing sunit/swidth via mount options
only change the primary, etc....

If you are going to change mkfs to keep them all up to date, the
kernel code really needs to do the same thing....

> Unfortunately, this also affects the output of xfs_repair during
> QA 030 and 178 which restores the primary superblock from the
> secondaries.

So do a version check and have a different golden output for the
new version....

> Index: ci/xfsprogs/mkfs/xfs_mkfs.c
> ===================================================================
> --- ci.orig/xfsprogs/mkfs/xfs_mkfs.c	2008-03-25 13:30:53.000000000 +1100
> +++ ci/xfsprogs/mkfs/xfs_mkfs.c	2008-03-25 16:29:44.811095380 +1100
> @@ -2397,48 +2397,32 @@
>  	}
> 
>  	/*
> -	 * Write out multiple secondary superblocks with rootinode field set
> +	 * Write out secondary superblocks with inode fields set
>  	 */
> -	if (mp->m_sb.sb_agcount > 1) {
> -		/*
> -		 * the last superblock
> -		 */
> -		buf = libxfs_readbuf(mp->m_dev,
> -				XFS_AGB_TO_DADDR(mp, mp->m_sb.sb_agcount-1,
> -					XFS_SB_DADDR),
> -				XFS_FSS_TO_BB(mp, 1),
> -				LIBXFS_EXIT_ON_FAILURE);
> -		INT_SET((XFS_BUF_TO_SBP(buf))->sb_rootino,
> -				ARCH_CONVERT, mp->m_sb.sb_rootino);
> -		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
> -		/*
> -		 * and one in the middle for luck
> -		 */
> -		if (mp->m_sb.sb_agcount > 2) {
> -			buf = libxfs_readbuf(mp->m_dev,
> -				XFS_AGB_TO_DADDR(mp, 
> (mp->m_sb.sb_agcount-1)/2,
> -					XFS_SB_DADDR),
> -				XFS_FSS_TO_BB(mp, 1),
> -				LIBXFS_EXIT_ON_FAILURE);
> -			INT_SET((XFS_BUF_TO_SBP(buf))->sb_rootino,
> -				ARCH_CONVERT, mp->m_sb.sb_rootino);
> -			libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
> -		}
> +	buf = libxfs_getsb(mp, LIBXFS_EXIT_ON_FAILURE);
> +	XFS_BUF_TO_SBP(buf)->sb_inprogress = 0;
> +
> +	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
> +		xfs_buf_t	*sbuf;

sbuf is a bad name. I immediately think "source buffer", when in fact
it's the destination buffer.

> +
> +		sbuf = libxfs_getbuf(mp->m_dev,
> +				XFS_AGB_TO_DADDR(mp, agno, XFS_SB_DADDR),
> +				XFS_FSS_TO_BB(mp, 1));
> +		memcpy(XFS_BUF_PTR(sbuf), XFS_BUF_PTR(buf),
> +				XFS_BUF_SIZE(sbuf));
> +		libxfs_writebuf(sbuf, LIBXFS_EXIT_ON_FAILURE);
>  	}
> 
>  	/*
> -	 * Dump all inodes and buffers before marking us all done.
> -	 * Need to drop references to inodes we still hold, first.
> +	 * Flush out all inodes and buffers before marking us all done.
>  	 */
>  	libxfs_rtmount_destroy(mp);
>  	libxfs_icache_purge();
> -	libxfs_bcache_purge();
> +	libxfs_bcache_flush();

Don't you still need a purge there to free all the objects in the
cache?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
