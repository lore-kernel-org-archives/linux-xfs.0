Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C16817F4E
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 21:31:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 53EDAAC001
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 19:31:45 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	XFEG6cFpDdKmRybA for <xfs@oss.sgi.com>;
	Sun, 09 Feb 2014 19:31:43 -0800 (PST)
Date: Mon, 10 Feb 2014 14:31:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfs: add helper for verifying checksums on xfs_bufs
Message-ID: <20140210033140.GP13647@dastard>
References: <52F83630.4020008@redhat.com>
 <52F83907.9070004@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52F83907.9070004@sandeen.net>
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

On Sun, Feb 09, 2014 at 08:27:19PM -0600, Eric Sandeen wrote:
> Many/most callers of xfs_verify_cksum() pass bp->b_addr and
> BBTOB(bp->b_length) as the first 2 args.  Add a helper
> which can just accept the bp and the crc offset, and work
> it out on its own, for brevity.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> I'm not wedded to this; seems helpful and cleaner, but
> if there's a reason not to, *shrug*
> 
>  fs/xfs/xfs_alloc.c          |    7 +++----
>  fs/xfs/xfs_attr_leaf.c      |    3 +--
>  fs/xfs/xfs_btree.c          |    8 ++++----
>  fs/xfs/xfs_cksum.h          |    7 +++++++
>  fs/xfs/xfs_da_btree.c       |    3 +--
>  fs/xfs/xfs_dir2_block.c     |    3 +--
>  fs/xfs/xfs_dir2_data.c      |    3 +--
>  fs/xfs/xfs_dir2_leaf.c      |    3 +--
>  fs/xfs/xfs_dir2_node.c      |    3 +--
>  fs/xfs/xfs_ialloc.c         |    4 ++--
>  fs/xfs/xfs_symlink_remote.c |    2 +-
>  11 files changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
> index 9eab2df..ab33714 100644
> --- a/fs/xfs/xfs_alloc.c
> +++ b/fs/xfs/xfs_alloc.c
> @@ -485,8 +485,7 @@ xfs_agfl_read_verify(
>  	if (!xfs_sb_version_hascrc(&mp->m_sb))
>  		return;
>  
> -	agfl_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
> -				   offsetof(struct xfs_agfl, agfl_crc));
> +	agfl_ok = xfs_buf_verify_cksum(bp, offsetof(struct xfs_agfl, agfl_crc));
					   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
vs

> +          !xfs_buf_verify_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF)) ||
> 				       ^^^^^^^^^^^^^^^^^^^^^^

I think that we also be consistent with the way we specify
the offset of the CRC field. Some of the code uses a #define, and
some doesn't. My preference would be to use the #define format
everywhere as it makes the code briefer and easier to read and it
gets rid of the long lines and wrapping that is done in places.

> diff --git a/fs/xfs/xfs_cksum.h b/fs/xfs/xfs_cksum.h
> index fad1676..f605d64 100644
> --- a/fs/xfs/xfs_cksum.h
> +++ b/fs/xfs/xfs_cksum.h
> @@ -60,4 +60,11 @@ xfs_verify_cksum(char *buffer, size_t length, unsigned long cksum_offset)
>  	return *(__le32 *)(buffer + cksum_offset) == xfs_end_cksum(crc);
>  }
>  
> +static inline int
> +xfs_buf_verify_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
> +{
> +	return xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
> +				cksum_offset);
> +}
> +

This introduces a dependency between xfs_buf.h and xfs_cksum.h.
i.e. if we include xfs_cksum.h we now have to include xfs_buf.h
before it.

Even though it means we'll have to juggle header files in quite a
few files, I'd prefer that we swap the dependency order as
xfs_cksum.h is shared with userspace and used in places that don't
necessarily know (or should know) what an xfs_buf is....

Otherwise it's a good cleanup.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
