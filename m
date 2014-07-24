Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8A0997F54
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 17:15:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5844C8F8040
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 15:15:32 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	tu8HtEacvsgUNp8P for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 15:15:30 -0700 (PDT)
Date: Fri, 25 Jul 2014 08:14:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/18] xfs: introduce inode record hole mask for sparse
	inode chunks
Message-ID: <20140724221453.GP20518@dastard>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-5-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406211788-63206-5-git-send-email-bfoster@redhat.com>
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

On Thu, Jul 24, 2014 at 10:22:54AM -0400, Brian Foster wrote:
> The inode btrees track 64 inodes per record, regardless of inode size.
> Thus, inode chunks on disk vary in size depending on the size of the
> inodes. This creates a contiguous allocation requirement for new inode
> chunks that can be difficult to satisfy on an aged and fragmented (free
> space) filesystem.
> 
> The inode record freecount currently uses 4 bytes on disk to track the
> free inode count. With a maximum freecount value of 64, only one byte is
> required. Convert the freecount field to a single byte and reserve two
> of the remaining 3 higher order bytes left to the hole mask field.
> 
> The hole mask field tracks potential holes in the chunks of physical
> space that the inode record refers to. This facilitates the sparse
> allocation of inode chunks when contiguous chunks are not available and
> allows the inode btrees to identify what portions of the chunk contain
> valid inodes.
> 
> Tracking holes means the field is initialized to zero and thus maintains
> backwards compatibility with existing filesystems. E.g., the higher
> order bytes of a counter with a max value of 64 are already initialized
> to 0. Update the inode record management functions to handle the new
> field and initialize it to zero for now.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_format.h       | 7 +++++--
>  fs/xfs/libxfs/xfs_ialloc.c       | 9 +++++++--
>  fs/xfs/libxfs/xfs_ialloc_btree.c | 4 +++-
>  3 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 34d85ac..39022d9 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -221,13 +221,16 @@ static inline xfs_inofree_t xfs_inobt_maskn(int i, int n)
>   */
>  typedef struct xfs_inobt_rec {
>  	__be32		ir_startino;	/* starting inode number */
> -	__be32		ir_freecount;	/* count of free inodes (set bits) */
> +	__be16		ir_holemask;	/* hole mask for sparse chunks */
> +	__u8		ir_pad;
> +	__u8		ir_freecount;	/* count of free inodes (set bits) */
>  	__be64		ir_free;	/* free inode mask */
>  } xfs_inobt_rec_t;

might we want the number of inodes allocated in the chunk there as
well (i.e. in the pad field) so we can validate the holemask against
the number of inodes allocated in the chunk?

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
