Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1C7877F50
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 17:55:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 11B4B8F8070
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 15:55:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9BcnfHjT71SCOf4Q for
	<xfs@oss.sgi.com>; Mon, 24 Feb 2014 15:55:16 -0800 (PST)
Date: Mon, 24 Feb 2014 18:55:12 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] xfs: be honest about used inodes in statfs
Message-ID: <20140224235511.GA9001@bfoster.bfoster>
References: <53067DC0.9040800@redhat.com>
 <530BD167.2020600@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <530BD167.2020600@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Feb 24, 2014 at 05:10:31PM -0600, Eric Sandeen wrote:
> Because we have lazy counters, it's possible that we over-allocate
> inodes past the maxicount (imaxpct) limit.  
> 
> A previous commit,
> 
>  2fe3366 xfs: ensure f_ffree returned by statfs() is non-negative
> 
> stopped statfs from underflowing f_ffree in this case, but that
> only happened when we mis-reported f_files, capped at maxicount.
> 
> Change statfs to report the actual number of inodes allocated,
> even if it is greater than maxicount.  It's reality.
> Deal with it.  
> 
> (New clearer code flow thanks to Brian!)
> 
> Logic-made-readable-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 

Heh, looks good to me. I don't know if the LMRB tag disqualifies me as a
reviewer now ;), but feel free to replace it with:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> V2: Use Brian's suggested logic for working out the numbers
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f317488..0dbcc17 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1083,7 +1083,6 @@ xfs_fs_statfs(
>  	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
>  	__uint64_t		fakeinos, id;
>  	xfs_extlen_t		lsize;
> -	__int64_t		ffree;
>  
>  	statp->f_type = XFS_SB_MAGIC;
>  	statp->f_namelen = MAXNAMELEN - 1;
> @@ -1100,17 +1099,19 @@ xfs_fs_statfs(
>  	statp->f_blocks = sbp->sb_dblocks - lsize;
>  	statp->f_bfree = statp->f_bavail =
>  				sbp->sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
> +	/*
> +	 * Potential number of new inodes in free blocks, limited by maxicount.
> +	 */
>  	fakeinos = statp->f_bfree << sbp->sb_inopblog;
> -	statp->f_files =
> -	    MIN(sbp->sb_icount + fakeinos, (__uint64_t)XFS_MAXINUMBER);
>  	if (mp->m_maxicount)
> -		statp->f_files = min_t(typeof(statp->f_files),
> -					statp->f_files,
> -					mp->m_maxicount);
> +		fakeinos = mp->m_maxicount > sbp->sb_icount ?
> +			   MIN(mp->m_maxicount - sbp->sb_icount, fakeinos) : 0;
> +
> +	/* Total possible files is current inodes + potential new inodes */
> +	statp->f_files = MIN(sbp->sb_icount + fakeinos,
> +			     (__uint64_t) XFS_MAXINUMBER);
>  
> -	/* make sure statp->f_ffree does not underflow */
> -	ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
> -	statp->f_ffree = max_t(__int64_t, ffree, 0);
> +	statp->f_ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
>  
>  	spin_unlock(&mp->m_sb_lock);
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
