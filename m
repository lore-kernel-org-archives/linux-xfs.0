Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 883987CA0
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 07:04:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3FE23304039
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 05:04:10 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id G4raAmj8giantdHw (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 05:03:59 -0700 (PDT)
Date: Tue, 2 Aug 2016 05:03:54 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/47] xfs: support btrees with overlapping intervals for
	keys
Message-ID: <20160802120354.GA2667@infradead.org>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, vishal.l.verma@intel.com

On Mon, Aug 01, 2016 at 12:11:26PM -0700, Darrick J. Wong wrote:
> > > +/*
> > > + * In-core key that holds both low and high keys for overlapped btrees.
> > > + * The two keys are packed next to each other on disk, so do the same
> > > + * in memory.  Preserve the existing xfs_btree_key as a single key to
> > > + * avoid the mental model breakage that would happen if we passed a
> > > + * bigkey into a function that operates on a single key.
> > > + */
> > > +union xfs_btree_bigkey {
> > > +	struct xfs_bmbt_key		bmbt;
> > > +	xfs_bmdr_key_t			bmbr;	/* bmbt root block */
> > > +	xfs_alloc_key_t			alloc;
> > > +	struct xfs_inobt_key		inobt;
> > > +};
> > 
> > I don't understand the purpose of this union at all, and the comment
> > seems misleading.  Compared to union xfs_btree_key the only difference
> > seems to be that xfs_btree_bigkey is missing the
> > 'struct xfs_rmap_key rmap' member.  How does that enable us to holds
> 
> I think you might be missing a later patch, wherein we add the rmap
> stuff to the btree structures, which expands bigkey to look like this:

Yeah, I was stuck in the middle of tree.  I still think the bigkey
is a very bad idea.  There are only 7 place left that actually
allocate storage for a "union xfs_btree_key".  Everything else uses
fancy pointer arithmetics to get them out of a disk buffer:

 - xfs_btree_lookup
 - xfs_btree_get_leaf_keys_overlapped
 - xfs_btree_update_keys
 - xfs_btree_lshift
 - xfs_btree_rshift
 - xfs_btree_simple_query_range
 - xfs_btree_overlapped_query_range

So just adding the rmap to union xfs_btree_key would simplify things
and remove a potential pitfall at the cost of just a little bit
more stack usage.  And at least of the
init_high_key_from_rec/init_key_from_rec we could probably replace
two on-stack xfs_btree_keys with a single new, bigger xfs_btree_key.

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

Where does that problem occur?  I don't quite understand how having
the bigger structure is a problem if we don't want to initialize all
of it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
