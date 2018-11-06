Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:10078 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726138AbeKGHxc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 02:53:32 -0500
Date: Wed, 7 Nov 2018 09:26:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/8] xfs: scrub big block inode btrees correctly
Message-ID: <20181106222603.GV19305@dastard>
References: <154147728649.32496.4515247239602322709.stgit@magnolia>
 <154147733964.32496.6293258964746388898.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154147733964.32496.6293258964746388898.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 05, 2018 at 08:08:59PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach scrub how to handle the case that there are one or more inobt
> records covering a given inode cluster.  This fixes the operation on big
> block filesystems (e.g. 64k blocks, 512 byte inodes).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/ialloc.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 10c3aaefc2a3..5a5f8ae31803 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -169,6 +169,7 @@ xchk_iallocbt_check_cluster_ifree(
>  	xfs_ino_t			fsino;
>  	xfs_agino_t			agino;
>  	unsigned int			offset;
> +	unsigned int			cluster_ioff;
>  	bool				irec_free;
>  	bool				ino_inuse;
>  	bool				freemask_ok;
> @@ -181,11 +182,13 @@ xchk_iallocbt_check_cluster_ifree(
>  	 * Given an inobt record, an offset of a cluster within the record,
>  	 * and an offset of an inode within a cluster, compute which fs inode
>  	 * we're talking about and the offset of the inode record within the
> -	 * inode buffer.
> +	 * inode buffer, being careful about inobt records that don't align
> +	 * with the start of the inode buffer when block sizes are large.
>  	 */
>  	agino = irec->ir_startino + chunk_ioff + loop_ioff;
>  	fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
> -	offset = loop_ioff * mp->m_sb.sb_inodesize;
> +	cluster_ioff = XFS_INO_TO_OFFSET(mp, irec->ir_startino + chunk_ioff);
> +	offset = (cluster_ioff + loop_ioff) * mp->m_sb.sb_inodesize;

urk.

That's even more confusing because now we have a cluster offset into
the chunk, a chunk offset into the cluster, and an inode offset
into the cluster.

And the cluster inode offset into the chunk is call "chunk offset", the
chunk offset into the cluster is called "cluster offset" and the
inode offset is called "loop offset". And none of them are offsets -
we then calculate and "offset" from all these other "not quite
offsets"....

I'm definitely not going to remember this when I look at the code
again in a week. More help needed, I think.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
