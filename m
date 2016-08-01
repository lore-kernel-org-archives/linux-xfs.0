Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 819BA7D2D
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 14:12:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 01219AC002
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 12:12:00 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Z1IIk1r5BDrs7f8F (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 01 Aug 2016 12:11:58 -0700 (PDT)
Date: Mon, 1 Aug 2016 12:11:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/47] xfs: support btrees with overlapping intervals for
	keys
Message-ID: <20160801191126.GE8590@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907701258.25461.18255100969448497359.stgit@birch.djwong.org>
	<20160801064818.GJ15590@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160801064818.GJ15590@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

On Sun, Jul 31, 2016 at 11:48:18PM -0700, Christoph Hellwig wrote:
> > v2: When we're deleting a record in a btree that supports overlapped
> > interval records and the deletion results in two btree blocks being
> > joined, we defer updating the high/low keys until after all possible
> > joining (at higher levels in the tree) have finished.  At this point,
> > the btree pointers at all levels have been updated to remove the empty
> > blocks and we can update the low and high keys.
> > 
> > When we're doing this, we must be careful to update the keys of all
> > node pointers up to the root instead of stopping at the first set of
> > keys that don't need updating.  This is because it's possible for a
> > single deletion to cause joining of multiple levels of tree, and so
> > we need to update everything going back to the root.
> > 
> > v3: Make diff_two_keys return < 0, 0, or > 0 if key1 is less than,
> > equal to, or greater than key2, respectively.  This is consistent
> > with the rest of the kernel and the C library.  Clarify some comments
> > and refactor the sibling_update function out of existence.  Check the
> > return value of btree_updkeys().
> 
> The changelogs go below the "-- " marker so that they don't appear
> in the git log.  That is unless they actually are useful like this
> one and should be merged into the actual patch description instead
> of being worded incrementally.
> 
> > +++ b/fs/xfs/libxfs/xfs_btree.c
> > @@ -51,7 +51,6 @@ static const __uint32_t xfs_magics[2][XFS_BTNUM_MAX] = {
> >  #define xfs_btree_magic(cur) \
> >  	xfs_magics[!!((cur)->bc_flags & XFS_BTREE_CRC_BLOCKS)][cur->bc_btnum]
> >  
> > -
> >  STATIC int				/* error (0 or EFSCORRUPTED) */
> >  xfs_btree_check_lblock(
> >  	struct xfs_btree_cur	*cur,	/* btree cursor */
> 
> Random whitespace change that probably shouldn't be in the patch.

Oops.

> > @@ -428,6 +427,50 @@ xfs_btree_dup_cursor(
> >   * into a btree block (xfs_btree_*_offset) or return a pointer to the given
> >   * record, key or pointer (xfs_btree_*_addr).  Note that all addressing
> >   * inside the btree block is done using indices starting at one, not zero!
> > + *
> > + * If XFS_BTREE_OVERLAPPING is set, then this btree supports keys containing
> 
> And here we already have the flag I asked for in the last patch.  I
> think that should be enough to drop the new methods.

(As I mentioned in a previous reply, I used to open code this:

if (cur->bc_flags & XFS_BTREE_OVERLAPPING)
	xfs_btree_get_node_overlapped(...);
else
	xfs_btree_get_node(...);

but Dave prefers to dispatch this through function pointers so that
the switching logic occurs in only one place.)

> > +/*
> > + * In-core key that holds both low and high keys for overlapped btrees.
> > + * The two keys are packed next to each other on disk, so do the same
> > + * in memory.  Preserve the existing xfs_btree_key as a single key to
> > + * avoid the mental model breakage that would happen if we passed a
> > + * bigkey into a function that operates on a single key.
> > + */
> > +union xfs_btree_bigkey {
> > +	struct xfs_bmbt_key		bmbt;
> > +	xfs_bmdr_key_t			bmbr;	/* bmbt root block */
> > +	xfs_alloc_key_t			alloc;
> > +	struct xfs_inobt_key		inobt;
> > +};
> 
> I don't understand the purpose of this union at all, and the comment
> seems misleading.  Compared to union xfs_btree_key the only difference
> seems to be that xfs_btree_bigkey is missing the
> 'struct xfs_rmap_key rmap' member.  How does that enable us to holds

I think you might be missing a later patch, wherein we add the rmap
stuff to the btree structures, which expands bigkey to look like this:

union xfs_btree_bigkey {
	struct xfs_bmbt_key		bmbt;
	xfs_bmdr_key_t			bmbr;	/* bmbt root block */
	xfs_alloc_key_t			alloc;
	struct xfs_inobt_key		inobt;
	struct {
		struct xfs_rmap_key	rmap;
		struct xfs_rmap_key	rmap_hi;
	};
	struct xfs_refcount_key		refc;
};

bigkey.rmap is the low key, bigkey.rmap_hi is the high key.  None of
the other btrees are overlapped, so they don't get a high key.

> low and high keys?  Also every single user seems to cast it to
> xfs_btree_key which is a little odd and smells unsafe.

On disk, the low and high keys of a pointer reside next to each other.
The btree_split code wants to store the new block's keys somewhere so
that the block can later be insrec'd into a higher btree level.  It
would be convenient if this incore storage could also store the two
keys right next to each other so that we can memcpy key_len bytes from
the temporary storage into the on-disk btree block and not have to
special case that code.

I thought about simply declaring an on-stack array of two union
xfs_btree_keys.  The array is big enough to contain both keys and
eliminates the need for casting.  On the other hand it's weird because
the two keys have to be aligned to xfs_rmap_key boundaries, not
xfs_btree_key, which means that the high key isn't necessarily stored
in the second array element like the code would suggest.

Then I thought about stuffing both low and high keys into
xfs_rmap_key like so:

struct xfs_rmap_key {
	__be32		rm_startblock;	/* extent start block */
	__be64		rm_owner;	/* extent owner */
	__be64		rm_offset;	/* offset within the owner */
	__be32		rm_hi_startblock;	/* extent start block */
	__be64		rm_hi_owner;	/* extent owner */
	__be64		rm_hi_offset;	/* offset within the owner */
} __attribute__((packed));

But that was even uglier, because an overlapped btree has two keys
associated with a pointer, not one gigantic key.  It's also a
non-starter because sometimes we want to be able to treat the high
fields as a distinct key and then feed that key to the btree key
handling functions; when we do this, the hi_ fields point past the end
of the allotted space.  The overlapped query range function and the
btree scrubbers in later patches want to use high keys in this manner.

So then there was this way:

union xfs_btree_key {
	struct xfs_bmbt_key		bmbt;
	xfs_bmdr_key_t			bmbr;	/* bmbt root block */
	xfs_alloc_key_t			alloc;
	struct xfs_inobt_key		inobt;
	struct xfs_rmap_key		rmap[2];
	struct xfs_refcount_key		refc;
};

This gives us the storage we want and avoids casts, but it still
doesn't fix the problem that sometimes we want to create a key pointer
to just the high fields and treat that as a pointer.

So I created the separate bigkey structure to get the storage size I
wanted, and cast it to xfs_btree_key wherever it gets fed into the
other parts of the btree code.  It's smelly like you say, but at least
we have a distinct type to help future us identify the three smelly
places where we do this.

What I really wanted to do instead of bigkey was this:

struct xfs_btree_key *key = kmalloc(cur->bc_ops->key_len);

...except then we have a memory allocation.

<shrug> I don't have a problem with replacing the bigkey variables
with two-element array and just living with the fact that the high key
will not be found at key[1], but I worry that future me won't remember
that subtlety.  Whereas tracing the key pointers back to the bigkey on
the stack is not subtle and even better the debugger correctly locates
the high key contents.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
