Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DEFBF7CBB
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 23:06:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56E0FAC003
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 21:06:01 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	BgTmyvFpzZXPmIxK for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2016 21:05:57 -0700 (PDT)
Date: Wed, 6 Jul 2016 14:05:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 028/119] xfs: define the on-disk rmap btree format
Message-ID: <20160706040555.GB12670@dastard>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612645206.12839.17008642336898856662.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612645206.12839.17008642336898856662.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Thu, Jun 16, 2016 at 06:20:52PM -0700, Darrick J. Wong wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now we have all the surrounding call infrastructure in place, we can
> start filling out the rmap btree implementation. Start with the
> on-disk btree format; add everything needed to read, write and
> manipulate rmap btree blocks. This prepares the way for adding the
> btree operations implementation.
> 
> [darrick: record owner and offset info in rmap btree]
> [darrick: fork, bmbt and unwritten state in rmap btree]
> [darrick: flags are a separate field in xfs_rmap_irec]
> [darrick: calculate maxlevels separately]
> [darrick: move the 'unwritten' bit into unused parts of rm_offset]
.....
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 97f354f..6efc7a3 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1383,11 +1383,151 @@ xfs_rmap_ino_owner(
>  #define XFS_RMAP_OWN_INODES	(-7ULL)	/* Inode chunk */
>  #define XFS_RMAP_OWN_MIN	(-8ULL) /* guard */
>  
> +#define XFS_RMAP_NON_INODE_OWNER(owner)	(!!((owner) & (1ULL << 63)))
> +
> +/*
> + * Data record structure
> + */
> +struct xfs_rmap_rec {
> +	__be32		rm_startblock;	/* extent start block */
> +	__be32		rm_blockcount;	/* extent length */
> +	__be64		rm_owner;	/* extent owner */
> +	__be64		rm_offset;	/* offset within the owner */
> +};
> +
> +/*
> + * rmap btree record
> + *  rm_offset:63 is the attribute fork flag
> + *  rm_offset:62 is the bmbt block flag
> + *  rm_offset:61 is the unwritten extent flag (same as l0:63 in bmbt)
> + *  rm_offset:54-60 aren't used and should be zero
> + *  rm_offset:0-53 is the block offset within the inode
> + */
> +#define XFS_RMAP_OFF_ATTR_FORK	((__uint64_t)1ULL << 63)
> +#define XFS_RMAP_OFF_BMBT_BLOCK	((__uint64_t)1ULL << 62)
> +#define XFS_RMAP_OFF_UNWRITTEN	((__uint64_t)1ULL << 61)
> +
> +#define XFS_RMAP_LEN_MAX	((__uint32_t)~0U)
> +#define XFS_RMAP_OFF_FLAGS	(XFS_RMAP_OFF_ATTR_FORK | \
> +				 XFS_RMAP_OFF_BMBT_BLOCK | \
> +				 XFS_RMAP_OFF_UNWRITTEN)
> +#define XFS_RMAP_OFF_MASK	((__uint64_t)0x3FFFFFFFFFFFFFULL)
> +
> +#define XFS_RMAP_OFF(off)		((off) & XFS_RMAP_OFF_MASK)
> +
> +#define XFS_RMAP_IS_BMBT_BLOCK(off)	(!!((off) & XFS_RMAP_OFF_BMBT_BLOCK))
> +#define XFS_RMAP_IS_ATTR_FORK(off)	(!!((off) & XFS_RMAP_OFF_ATTR_FORK))
> +#define XFS_RMAP_IS_UNWRITTEN(len)	(!!((off) & XFS_RMAP_OFF_UNWRITTEN))
> +
> +#define RMAPBT_STARTBLOCK_BITLEN	32
> +#define RMAPBT_BLOCKCOUNT_BITLEN	32
> +#define RMAPBT_OWNER_BITLEN		64
> +#define RMAPBT_ATTRFLAG_BITLEN		1
> +#define RMAPBT_BMBTFLAG_BITLEN		1
> +#define RMAPBT_EXNTFLAG_BITLEN		1
> +#define RMAPBT_UNUSED_OFFSET_BITLEN	7
> +#define RMAPBT_OFFSET_BITLEN		54
> +
> +#define XFS_RMAP_ATTR_FORK		(1 << 0)
> +#define XFS_RMAP_BMBT_BLOCK		(1 << 1)
> +#define XFS_RMAP_UNWRITTEN		(1 << 2)
> +#define XFS_RMAP_KEY_FLAGS		(XFS_RMAP_ATTR_FORK | \
> +					 XFS_RMAP_BMBT_BLOCK)
> +#define XFS_RMAP_REC_FLAGS		(XFS_RMAP_UNWRITTEN)
> +struct xfs_rmap_irec {
> +	xfs_agblock_t	rm_startblock;	/* extent start block */
> +	xfs_extlen_t	rm_blockcount;	/* extent length */
> +	__uint64_t	rm_owner;	/* extent owner */
> +	__uint64_t	rm_offset;	/* offset within the owner */
> +	unsigned int	rm_flags;	/* state flags */
> +};

Same as my last comment about xfs_format.h. Up to here is all good -
they are format definitions. But these:

> +
> +static inline __u64
> +xfs_rmap_irec_offset_pack(
> +	const struct xfs_rmap_irec	*irec)
> +{
> +	__u64			x;
> +
> +	x = XFS_RMAP_OFF(irec->rm_offset);
> +	if (irec->rm_flags & XFS_RMAP_ATTR_FORK)
> +		x |= XFS_RMAP_OFF_ATTR_FORK;
> +	if (irec->rm_flags & XFS_RMAP_BMBT_BLOCK)
> +		x |= XFS_RMAP_OFF_BMBT_BLOCK;
> +	if (irec->rm_flags & XFS_RMAP_UNWRITTEN)
> +		x |= XFS_RMAP_OFF_UNWRITTEN;
> +	return x;
> +}
> +
> +static inline int
> +xfs_rmap_irec_offset_unpack(
> +	__u64			offset,
> +	struct xfs_rmap_irec	*irec)
> +{
> +	if (offset & ~(XFS_RMAP_OFF_MASK | XFS_RMAP_OFF_FLAGS))
> +		return -EFSCORRUPTED;
> +	irec->rm_offset = XFS_RMAP_OFF(offset);
> +	if (offset & XFS_RMAP_OFF_ATTR_FORK)
> +		irec->rm_flags |= XFS_RMAP_ATTR_FORK;
> +	if (offset & XFS_RMAP_OFF_BMBT_BLOCK)
> +		irec->rm_flags |= XFS_RMAP_BMBT_BLOCK;
> +	if (offset & XFS_RMAP_OFF_UNWRITTEN)
> +		irec->rm_flags |= XFS_RMAP_UNWRITTEN;
> +	return 0;
> +}

And these:

> +static inline void
> +xfs_owner_info_unpack(
> +	struct xfs_owner_info	*oinfo,
> +	uint64_t		*owner,
> +	uint64_t		*offset,
> +	unsigned int		*flags)
> +{
> +	unsigned int		r = 0;
> +
> +	*owner = oinfo->oi_owner;
> +	*offset = oinfo->oi_offset;
> +	if (oinfo->oi_flags & XFS_OWNER_INFO_ATTR_FORK)
> +		r |= XFS_RMAP_ATTR_FORK;
> +	if (oinfo->oi_flags & XFS_OWNER_INFO_BMBT_BLOCK)
> +		r |= XFS_RMAP_BMBT_BLOCK;
> +	*flags = r;
> +}
> +
> +static inline void
> +xfs_owner_info_pack(
> +	struct xfs_owner_info	*oinfo,
> +	uint64_t		owner,
> +	uint64_t		offset,
> +	unsigned int		flags)
> +{
> +	oinfo->oi_owner = owner;
> +	oinfo->oi_offset = XFS_RMAP_OFF(offset);
> +	oinfo->oi_flags = 0;
> +	if (flags & XFS_RMAP_ATTR_FORK)
> +		oinfo->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
> +	if (flags & XFS_RMAP_BMBT_BLOCK)
> +		oinfo->oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
> +}
> +

really belong in xfs_rmap.h or xfs_rmap_btree.h.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
