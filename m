Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 17A517F3F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 17:13:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 033B9304048
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 15:13:45 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	dDQYgXxXhCU83n89 for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 15:13:43 -0700 (PDT)
Date: Fri, 25 Jul 2014 08:13:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/18] xfs: create macros/helpers for dealing with sparse
	inode chunks
Message-ID: <20140724221341.GO20518@dastard>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-6-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406211788-63206-6-git-send-email-bfoster@redhat.com>
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

On Thu, Jul 24, 2014 at 10:22:55AM -0400, Brian Foster wrote:
> Sparse inode chunks allow the traditional inode btree record format to
> describe an inode chunk that is not fully allocated and/or contiguous.
> Define a couple constants that set requirements for allocation and
> management of such chunks. Also define a helper to easily detect sparse
> inode chunks.
> 
> The granularity of a sparse chunk is defined by the the 16-bit holemask
> field in the inode record. Assuming 64 inodes per full chunk, a single
> holemask bit accounts for 4 inodes. The minimum allocation requirement
> for a sparse inode chunk is defined as the minimum number of blocks
> required to meet the 4 inode granularity.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_format.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 39022d9..0baad50 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -211,6 +211,11 @@ typedef	__uint64_t	xfs_inofree_t;
>  #define	XFS_INOBT_ALL_FREE		((xfs_inofree_t)-1)
>  #define	XFS_INOBT_MASK(i)		((xfs_inofree_t)1 << (i))
>  
> +#define XFS_INODES_PER_SPCHUNK		\
> +	(XFS_INODES_PER_CHUNK / (NBBY * sizeof(__uint16_t)))
> +#define XFS_INOBT_MIN_SPCHUNKLEN(sb)	\
> +	(roundup(XFS_INODES_PER_SPCHUNK, sb.sb_inopblock) / sb.sb_inopblock)

static inline.

-Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
