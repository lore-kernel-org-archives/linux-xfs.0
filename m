Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A409B7CF1
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 01:48:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 74237304048
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:48:23 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id GeJhXfplBRPQmCDe (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:48:21 -0700 (PDT)
Date: Sun, 31 Jul 2016 23:48:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/47] xfs: support btrees with overlapping intervals for
	keys
Message-ID: <20160801064818.GJ15590@infradead.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907701258.25461.18255100969448497359.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146907701258.25461.18255100969448497359.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

> v2: When we're deleting a record in a btree that supports overlapped
> interval records and the deletion results in two btree blocks being
> joined, we defer updating the high/low keys until after all possible
> joining (at higher levels in the tree) have finished.  At this point,
> the btree pointers at all levels have been updated to remove the empty
> blocks and we can update the low and high keys.
> 
> When we're doing this, we must be careful to update the keys of all
> node pointers up to the root instead of stopping at the first set of
> keys that don't need updating.  This is because it's possible for a
> single deletion to cause joining of multiple levels of tree, and so
> we need to update everything going back to the root.
> 
> v3: Make diff_two_keys return < 0, 0, or > 0 if key1 is less than,
> equal to, or greater than key2, respectively.  This is consistent
> with the rest of the kernel and the C library.  Clarify some comments
> and refactor the sibling_update function out of existence.  Check the
> return value of btree_updkeys().

The changelogs go below the "-- " marker so that they don't appear
in the git log.  That is unless they actually are useful like this
one and should be merged into the actual patch description instead
of being worded incrementally.

> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -51,7 +51,6 @@ static const __uint32_t xfs_magics[2][XFS_BTNUM_MAX] = {
>  #define xfs_btree_magic(cur) \
>  	xfs_magics[!!((cur)->bc_flags & XFS_BTREE_CRC_BLOCKS)][cur->bc_btnum]
>  
> -
>  STATIC int				/* error (0 or EFSCORRUPTED) */
>  xfs_btree_check_lblock(
>  	struct xfs_btree_cur	*cur,	/* btree cursor */

Random whitespace change that probably shouldn't be in the patch.

> @@ -428,6 +427,50 @@ xfs_btree_dup_cursor(
>   * into a btree block (xfs_btree_*_offset) or return a pointer to the given
>   * record, key or pointer (xfs_btree_*_addr).  Note that all addressing
>   * inside the btree block is done using indices starting at one, not zero!
> + *
> + * If XFS_BTREE_OVERLAPPING is set, then this btree supports keys containing

And here we already have the flag I asked for in the last patch.  I
think that should be enough to drop the new methods.

> +/*
> + * In-core key that holds both low and high keys for overlapped btrees.
> + * The two keys are packed next to each other on disk, so do the same
> + * in memory.  Preserve the existing xfs_btree_key as a single key to
> + * avoid the mental model breakage that would happen if we passed a
> + * bigkey into a function that operates on a single key.
> + */
> +union xfs_btree_bigkey {
> +	struct xfs_bmbt_key		bmbt;
> +	xfs_bmdr_key_t			bmbr;	/* bmbt root block */
> +	xfs_alloc_key_t			alloc;
> +	struct xfs_inobt_key		inobt;
> +};

I don't understand the purpose of this union at all, and the comment
seems misleading.  Compared to union xfs_btree_key the only difference
seems to be that xfs_btree_bigkey is missing the
'struct xfs_rmap_key rmap' member.  How does that enable us to holds
low and high keys?  Also every single user seems to cast it to
xfs_btree_key which is a little odd and smells unsafe.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
