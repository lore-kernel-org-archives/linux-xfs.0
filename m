Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 61F077F6D
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 16:39:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 337808F8033
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 14:39:39 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	xUvteGLmM5xWHLfR for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2015 14:39:37 -0800 (PST)
Date: Mon, 9 Feb 2015 09:29:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 16/18] xfs: use actual inode count for sparse records
	in bulkstat/inumbers
Message-ID: <20150208222919.GD4251@dastard>
References: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
	<1423252385-3063-17-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423252385-3063-17-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 06, 2015 at 02:53:03PM -0500, Brian Foster wrote:
> The bulkstat and inumbers mechanisms make the assumption that inode
> records consist of a full 64 inode chunk in several places. For example,
> this is used to track how many inodes have been processed overall as
> well as to determine whether a record has allocated inodes that must be
> handled.
> 
> This assumption is invalid for sparse inode records. While sparse inodes
> will be marked as free in the ir_free mask, they are not accounted as
> free in ir_freecount because they cannot be allocated. Therefore,
> ir_freecount may be less than 64 inodes in an inode record for which all
> physically allocated inodes are free (and in turn ir_freecount < 64 does
> not signify that the record has allocated inodes).
> 
> Create the xfs_inobt_count() helper to calculate the total number of
> physically allocated inodes based on the holemask. Use the helper in
> xfs_bulkstat() and xfs_inumbers() instead of the fixed
> XFS_INODE_PER_CHUNK value to ensure correct accounting in the event of
> sparse inode records.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

This should be moved to early in the patchset as a preparation
patch. i.e. xfs_inobt_issparse() can be introduced without any other
dependencies on the sparse inode changes, and then this factoring
can be added before any of the actual sparse inode changes.

That way anywhere that uses the number of allocated inodes in a
chunk will be correct for sparse inodes even before sparse inode
support is added...

> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 16 ++++++++++++++++
>  fs/xfs/libxfs/xfs_ialloc.h |  5 +++++
>  fs/xfs/xfs_itable.c        | 14 ++++++++++----
>  3 files changed, 31 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index c104ee5..4d151ed 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1207,6 +1207,22 @@ xfs_inobt_first_free_inode(
>  }
>  
>  /*
> + * Calculate the real count of inodes in a chunk.
> + */
> +int
> +xfs_inobt_count(
> +	struct xfs_mount		*mp,
> +	struct xfs_inobt_rec_incore	*rec)
> +{
> +	ASSERT(!xfs_inobt_rec_check_count(mp, rec));
> +
> +	if (!xfs_inobt_issparse(rec->ir_holemask))
> +		return XFS_INODES_PER_CHUNK;
> +
> +	return rec->ir_count;
> +}

This btree record state check should probably be added to
xfs_ialloc_btree.c.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
