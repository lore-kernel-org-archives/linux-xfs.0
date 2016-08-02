Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 20A8E7CAE
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 09:04:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C8A698F8033
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 07:04:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9TbA8vLg8Vz2b4wT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 07:04:14 -0700 (PDT)
Date: Tue, 2 Aug 2016 10:04:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/47] xfs: support btrees with overlapping intervals for
	keys
Message-ID: <20160802140412.GA9205@bfoster.bfoster>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907701258.25461.18255100969448497359.stgit@birch.djwong.org>
	<20160801064818.GJ15590@infradead.org>
	<20160801191126.GE8590@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160801191126.GE8590@birch.djwong.org>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, vishal.l.verma@intel.com

On Mon, Aug 01, 2016 at 12:11:26PM -0700, Darrick J. Wong wrote:
> On Sun, Jul 31, 2016 at 11:48:18PM -0700, Christoph Hellwig wrote:
...
> > 
> > > +++ b/fs/xfs/libxfs/xfs_btree.c
...
> > I don't understand the purpose of this union at all, and the comment
> > seems misleading.  Compared to union xfs_btree_key the only difference
> > seems to be that xfs_btree_bigkey is missing the
> > 'struct xfs_rmap_key rmap' member.  How does that enable us to holds
> 
> I think you might be missing a later patch, wherein we add the rmap
> stuff to the btree structures, which expands bigkey to look like this:
> 
> union xfs_btree_bigkey {
> 	struct xfs_bmbt_key		bmbt;
> 	xfs_bmdr_key_t			bmbr;	/* bmbt root block */
> 	xfs_alloc_key_t			alloc;
> 	struct xfs_inobt_key		inobt;
> 	struct {
> 		struct xfs_rmap_key	rmap;
> 		struct xfs_rmap_key	rmap_hi;
> 	};
> 	struct xfs_refcount_key		refc;
> };
> 
> bigkey.rmap is the low key, bigkey.rmap_hi is the high key.  None of
> the other btrees are overlapped, so they don't get a high key.
> 
> > low and high keys?  Also every single user seems to cast it to
> > xfs_btree_key which is a little odd and smells unsafe.
> 
> On disk, the low and high keys of a pointer reside next to each other.
> The btree_split code wants to store the new block's keys somewhere so
> that the block can later be insrec'd into a higher btree level.  It
> would be convenient if this incore storage could also store the two
> keys right next to each other so that we can memcpy key_len bytes from
> the temporary storage into the on-disk btree block and not have to
> special case that code.
> 
> I thought about simply declaring an on-stack array of two union
> xfs_btree_keys.  The array is big enough to contain both keys and
> eliminates the need for casting.  On the other hand it's weird because
> the two keys have to be aligned to xfs_rmap_key boundaries, not
> xfs_btree_key, which means that the high key isn't necessarily stored
> in the second array element like the code would suggest.
> 

Thanks for writing this up...

I'm wondering if we should define an in-core key structure variant
similar to what we have for in-core records. That structure could
encapsulate the low/high key model and use the already-defined in-core
record structures (I suppose we could define tree-specific ikey
variants, but I'll leave that alone for now). For example:

	struct xfs_btree_ikey {
		union xfs_bree_irec	lo;
		union xfs_btree_irec	hi;
	}

Then define some conversion functions, tease apart the bits of the
generic btree code that use the on-disk structure for in-memory storage
vs. on-disk buffer references, and use the in-core structure for all
instances of the former.

That most certainly would mean more changes (as an indepedent patch) and
tbh, it's not yet clear to me whether we'd run into other roadblocks
that make it too ugly an option or just not worth it. I do feel like
we're trying a bit too hard to retrofit the extra complexity of the
multi-key model into the current design, however, and should try to
explicitly define the multi-key model if we can find a reasonably
elegant way to do so. Even passing around the xfs_btree_bigkey structure
seems safer to me than pretending it's an xfs_btree_key and relying on
key_len to make sure we copy the right amount of data or that we've
defined bigkey in the right layers of the call stack. Thoughts?

Brian

> Then I thought about stuffing both low and high keys into
> xfs_rmap_key like so:
> 
> struct xfs_rmap_key {
> 	__be32		rm_startblock;	/* extent start block */
> 	__be64		rm_owner;	/* extent owner */
> 	__be64		rm_offset;	/* offset within the owner */
> 	__be32		rm_hi_startblock;	/* extent start block */
> 	__be64		rm_hi_owner;	/* extent owner */
> 	__be64		rm_hi_offset;	/* offset within the owner */
> } __attribute__((packed));
> 
> But that was even uglier, because an overlapped btree has two keys
> associated with a pointer, not one gigantic key.  It's also a
> non-starter because sometimes we want to be able to treat the high
> fields as a distinct key and then feed that key to the btree key
> handling functions; when we do this, the hi_ fields point past the end
> of the allotted space.  The overlapped query range function and the
> btree scrubbers in later patches want to use high keys in this manner.
> 
> So then there was this way:
> 
> union xfs_btree_key {
> 	struct xfs_bmbt_key		bmbt;
> 	xfs_bmdr_key_t			bmbr;	/* bmbt root block */
> 	xfs_alloc_key_t			alloc;
> 	struct xfs_inobt_key		inobt;
> 	struct xfs_rmap_key		rmap[2];
> 	struct xfs_refcount_key		refc;
> };
> 
> This gives us the storage we want and avoids casts, but it still
> doesn't fix the problem that sometimes we want to create a key pointer
> to just the high fields and treat that as a pointer.
> 
> So I created the separate bigkey structure to get the storage size I
> wanted, and cast it to xfs_btree_key wherever it gets fed into the
> other parts of the btree code.  It's smelly like you say, but at least
> we have a distinct type to help future us identify the three smelly
> places where we do this.
> 
> What I really wanted to do instead of bigkey was this:
> 
> struct xfs_btree_key *key = kmalloc(cur->bc_ops->key_len);
> 
> ...except then we have a memory allocation.
> 
> <shrug> I don't have a problem with replacing the bigkey variables
> with two-element array and just living with the fact that the high key
> will not be found at key[1], but I worry that future me won't remember
> that subtlety.  Whereas tracing the key pointers back to the bigkey on
> the stack is not subtle and even better the debugger correctly locates
> the high key contents.
> 
> --D
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
