Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 715837F3F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 18:30:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5EA7130407A
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 16:30:11 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	rP2Pz6xLgC1brBFl for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 16:30:06 -0700 (PDT)
Date: Fri, 25 Jul 2014 09:29:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/18] xfs: use actual inode count for sparse records in
	bulkstat/inumbers
Message-ID: <20140724232934.GW20518@dastard>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-18-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406211788-63206-18-git-send-email-bfoster@redhat.com>
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

On Thu, Jul 24, 2014 at 10:23:07AM -0400, Brian Foster wrote:
> The bulkstat and inumbers mechanisms make the assumption that inode
> records consist of a full 64 inode chunk in several places. E.g., this
> is used to track how many inodes have been processed overall as well as
> to determine when all in-use inodes of a record have been processed. The
> record processing, in particular, increments the record freecount for
> each in-use inode until it hits the expected max of 64.
> 
> This is invalid for sparse inode records. While all inodes might be
> marked free in the free mask regardless of whether they are allocated on
> disk, ir_freecount is based on the total number of physically allocated
> inodes and thus may be less than 64 inodes on a completely free inode
> chunk.
> 
> Create the xfs_inobt_count() helper to calculate the total number of
> physically allocated inodes based on the holemask. Use the helper in
> xfs_bulkstat() and xfs_inumbers() instead of the fixed
> XFS_INODE_PER_CHUNK value to ensure correct accounting in the event of
> sparse inode records.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 27 +++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ialloc.h |  5 +++++
>  fs/xfs/xfs_itable.c        | 12 +++++++-----
>  3 files changed, 39 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 86c6ccd..daf317f 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -951,6 +951,33 @@ xfs_inobt_first_free_inode(
>  }
>  
>  /*
> + * Calculate the real count of inodes in a chunk.
> + */
> +int
> +xfs_inobt_count(
> +	struct xfs_inobt_rec_incore	*rec)
> +{
> +	__uint16_t	allocmask;
> +	uint		allocbitmap;
> +	int		nextbit;
> +	int		count = 0;
> +
> +	if (!xfs_inobt_issparse(rec))
> +		return XFS_INODES_PER_CHUNK;
> +
> +	allocmask = ~rec->ir_holemask;
> +	allocbitmap = allocmask;
> +
> +	nextbit = xfs_next_bit(&allocbitmap, 1, 0);
> +	while (nextbit != -1) {
> +		count += XFS_INODES_PER_SPCHUNK;
> +		nextbit = xfs_next_bit(&allocbitmap, 1, nextbit + 1);
> +	}

	bitmap_weight() * XFS_INODES_PER_SPCHUNK?

-Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
