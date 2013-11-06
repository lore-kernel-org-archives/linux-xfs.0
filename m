Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E7B4C7F93
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 20:20:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5F6B6AC002
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 18:20:20 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	z09B3dSiGecFWUby for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 18:20:15 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1Vdsj4-0003bZ-6T
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 13:20:10 +1100
Date: Wed, 6 Nov 2013 13:20:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 28/37] xfs_db: avoid libxfs buffer lookup warnings
Message-ID: <20131106022010.GB6188@dastard>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
	<1383700043-32305-29-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383700043-32305-29-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com


Looks like I messed up the patch subject. It should be:

"xfs_db: use inode cluster buffers for inode IO"

On Wed, Nov 06, 2013 at 12:07:14PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we mount the filesystem inside xfs_db, libxfs is tasked with
> reading some information from disk, such as root inodes. Because
> libxfs does this inode reading, it uses inode cluster buffers to
> read the inodes. xfs_db, OTOH, just uses FSB sized buffers to read
> inodes, and hence xfs_db throws a warning when reading the root
> inode block like so:
> 
> $ sudo xfs_db -c "sb 0" -c "p rootino" -c "inode 32" /dev/vda
> Version 5 superblock detected. xfsprogs has EXPERIMENTAL support enabled!
> Use of these features is at your own risk!
> rootino = 32
> 7f59f20e6740: Badness in key lookup (length)
> bp=(bno 0x20, len 8192 bytes) key=(bno 0x20, len 1024 bytes)
> $
> 
> There is another way this can happen, and that is dumping raw data
> from disk using either the "fsb NNN" or "daddr MMM" commands to dump
> untyped information. This is always read in sector or filesystem
> block units, and so will cause similar badness warnings.
> 
> To avoid this problem when reading inodes, teach xfs_db to read
> inode clusters rather individual filesystem blocks when asked to
> read an inode.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  db/inode.c | 33 +++++++++++++++++++++++++++++++--
>  1 file changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/db/inode.c b/db/inode.c
> index 4090855..24170ba 100644
> --- a/db/inode.c
> +++ b/db/inode.c
> @@ -623,6 +623,14 @@ inode_u_symlink_count(
>  		(int)be64_to_cpu(dip->di_size) : 0;
>  }
>  
> +/*
> + * We are now using libxfs for our IO backend, so we should always try to use
> + * inode cluster buffers rather than filesystem block sized buffers for reading
> + * inodes. This means that we always use the same buffers as libxfs operations
> + * does, and that avoids buffer cache issues caused by overlapping buffers. This
> + * can be seen clearly when trying to read the root inode. Much of this logic is
> + * similar to libxfs_imap().
> + */
>  void
>  set_cur_inode(
>  	xfs_ino_t	ino)
> @@ -632,6 +640,9 @@ set_cur_inode(
>  	xfs_agnumber_t	agno;
>  	xfs_dinode_t	*dip;
>  	int		offset;
> +	int		numblks = blkbb;
> +	xfs_agblock_t	cluster_agbno;
> +
>  
>  	agno = XFS_INO_TO_AGNO(mp, ino);
>  	agino = XFS_INO_TO_AGINO(mp, ino);
> @@ -644,6 +655,24 @@ set_cur_inode(
>  		return;
>  	}
>  	cur_agno = agno;
> +
> +	if (mp->m_inode_cluster_size > mp->m_sb.sb_blocksize &&
> +	    mp->m_inoalign_mask) {
> +		xfs_agblock_t	chunk_agbno;
> +		xfs_agblock_t	offset_agbno;
> +		int		blks_per_cluster;
> +
> +		blks_per_cluster = mp->m_inode_cluster_size >>
> +							mp->m_sb.sb_blocklog;
> +		offset_agbno = agbno & mp->m_inoalign_mask;
> +		chunk_agbno = agbno - offset_agbno;
> +		cluster_agbno = chunk_agbno +
> +			((offset_agbno / blks_per_cluster) * blks_per_cluster);
> +		offset += ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock);
> +		numblks = XFS_FSB_TO_BB(mp, blks_per_cluster);
> +	} else
> +		cluster_agbno = agbno;
> +
>  	/*
>  	 * First set_cur to the block with the inode
>  	 * then use off_cur to get the right part of the buffer.
> @@ -651,8 +680,8 @@ set_cur_inode(
>  	ASSERT(typtab[TYP_INODE].typnm == TYP_INODE);
>  
>  	/* ingore ring update here, do it explicitly below */
> -	set_cur(&typtab[TYP_INODE], XFS_AGB_TO_DADDR(mp, agno, agbno),
> -		blkbb, DB_RING_IGN, NULL);
> +	set_cur(&typtab[TYP_INODE], XFS_AGB_TO_DADDR(mp, agno, cluster_agbno),
> +		numblks, DB_RING_IGN, NULL);
>  	off_cur(offset << mp->m_sb.sb_inodelog, mp->m_sb.sb_inodesize);
>  	dip = iocur_top->data;
>  	iocur_top->ino_crc_ok = libxfs_dinode_verify(mp, ino, dip);
> -- 
> 1.8.4.rc3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
