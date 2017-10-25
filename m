Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:48745 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751682AbdJYA7q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Oct 2017 20:59:46 -0400
Date: Wed, 25 Oct 2017 11:59:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/42] mkfs: factor the crap out of the code
Message-ID: <20171025005932.GY3666@dastard>
References: <20170829235052.21050-1-david@fromorbit.com>
 <6cb1a1fa-15b2-6280-ba58-af39f496eb56@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cb1a1fa-15b2-6280-ba58-af39f496eb56@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 23, 2017 at 10:00:26PM -0500, Eric Sandeen wrote:
> Ok more review, sorry this is so dispersed.
> 
> [PATCH 14/42] mkfs: factor printing of mkfs config
> 
> Oh good.  :)
> 
> [PATCH 15/42] mkfs: factor in memory superblock setup
> 
> Heh, I read that as factor in vs factor out ;)
> 
> This seems to change logic slightly, is it intentional?
> 
> from:
> 
> -	if (sb_feat.inode_align) {
> -		int	cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
> -		if (sb_feat.crcs_enabled)
> -			cluster_size *= isize / XFS_DINODE_MIN_SIZE;
> -		sbp->sb_inoalignmt = cluster_size >> blocklog;
> -		sb_feat.inode_align = sbp->sb_inoalignmt != 0;
> -	}
> 
> to
> 
> +	if (cfg->sb_feat.inode_align) {
> +		int	cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
> +		if (cfg->sb_feat.crcs_enabled)
> +			cluster_size *= cfg->inodesize / XFS_DINODE_MIN_SIZE;
> +		sbp->sb_inoalignmt = cluster_size >> cfg->blocklog;
> +	}
> 
> it loses the test for inalignmt being 0 and turning off inode_align...

Ok, so there's a few things here. When you look at the kernel and
it decides on inode alignment, it does:

int
xfs_ialloc_cluster_alignment(
        struct xfs_mount        *mp)
{
        if (xfs_sb_version_hasalign(&mp->m_sb) &&
            mp->m_sb.sb_inoalignmt >= xfs_icluster_size_fsb(mp))
                return mp->m_sb.sb_inoalignmt;
        return 1;
}

xfs_set_inoalignment() has a similar check before using
sb_inoalignmt to create the alignment mask, so the kernel doesn't
actually care that the alignment is 0 because it doesn't align
inodes if it's less than the cluster buffer size....

The tricky one is sparse inodes, because it requires sb_inoalignmt
to be equal to the size of the chunk. The kernel does this at mount
time:

        /*
         * Full inode chunks must be aligned to inode chunk size when
         * sparse inodes are enabled to support the sparse chunk
         * allocation algorithm and prevent overlapping inode records.
         */
        if (xfs_sb_version_hassparseinodes(sbp)) {
                uint32_t        align;

                align = XFS_INODES_PER_CHUNK * sbp->sb_inodesize
                                >> sbp->sb_blocklog;
                if (sbp->sb_inoalignmt != align) {
                        xfs_warn(mp,
"Inode block alignment (%u) must match chunk size (%u) for sparse inodes.",
                                 sbp->sb_inoalignmt, align);
                        return -EINVAL;
                }
        }


If we take the case of 64k block size, we have blocklog = 16, and so:

	align	= (64 * 512) >> 16
		= 2^15 >> 16
		= 0

So sparse inodes requires sbp->sb_inoalignmt == 0 when a 64k block
size is in use. It doesn't care about the align feature bit, though.

What I just noticed is this in xfs_align_sparse_ino():

        agbno = XFS_AGINO_TO_AGBNO(mp, *startino);
        mod = agbno % mp->m_sb.sb_inoalignmt;
        if (!mod)
                return;

if sb_inoalignmt is zero - and it will be for 64k block sizes and
inode sizes <= 512 bytes - then the result here should be a divide
by zero error. The only reason we haven't seen this is that we
can't allocate a sparse inode cluster on 64k block size filesystems
when the inode size <= 1k.....

So AFAICT, the inode alignment feature bit just doesn't matter when
the alignment is set to zero because the block size is larger than
the inode cluster size.

> if you deemed that impossible, a commit log comment would be helpful.
> If not, maybe it's a bug.  :)  The test & set goes back to the mists
> of time, so I'm not sure of its purpose.

Oh, and of course, I forgot the simple reason: we always use aligned
inodes on v5 filesystems, and we've defaulted to setting it on v4 fs
for donkey's years, so AFAIC there's no reason it should ever not be
set because the kernel has to handle alignment < cluster size sanely
anyway....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
