Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56372 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932571AbdKBTJn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 15:09:43 -0400
Date: Thu, 2 Nov 2017 20:09:42 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 16/18] xfs: use a b+tree for the in-core extent list
Message-ID: <20171102190942.GA4637@lst.de>
References: <20171031142230.11755-1-hch@lst.de> <20171031142230.11755-17-hch@lst.de> <20171102001428.GN4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102001428.GN4911@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

> > + * Note that we currently always allocate 64-bits worth for pointers in the
> > + * inner nodes or the link pointers in the leaf nodes even on 32-bit
> 
> We do?  sizeof(void *) == 4 on 32-bit; on a i686 machine this evaluates to....

We did :)  Things changed a few times, so I guess I can relax this.

.. and I need to do another test run on i386..

> Does RECS_PER_LEAF reserve two uint64_t for the prev and next pointers
> in struct xfs_iext_leaf?  It'd be a little more clear if the definition
> was:
> 
> RECS_PER_LEAF = (NODE_SIZE - (2 * sizeof(void *))) / sizeof(xfs_iext_rec)

Or rather:

	RECS_PER_LEAF = (NODE_SIZE - (2 * sizeof(struct xfs_iext_leaf *))) \
			sizeof(xfs_iext_rec);

> 
> The L1 cache sizes range from 4 bytes (h8300) to 256 bytes (s390), with
> x64 at 64 bytes and arm64/ppc64 at 128.
> 
> This means that this is broken on h8300 because it's not possible to
> create a leaf containing even one record.  Not that even a 32-byte leaf
> is acceptable in terms of overhead.  Perhaps NODE_SIZE should have a
> minimum?

Hah.  I missed the odd h8300 case.  Maybe we should just make it constant
256 - that's what'll get test most anyway.

> 2^32 max extent records
> RECS_PER_LEAF = 15
> KEYS_PER_NODE = 16
> 
> level 0 = 286,331,154 leaf blocks
> level 1 = 17,895,698 nodes
> level 2 = 1,118,482 nodes
> level 3 = 69,906 nodes
> level 4 = 4,370 nodes
> level 5 = 274 nodes
> level 6 = 18 nodes
> level 7 = 2 nodes
> level 8 = 1 node
> == 305,419,904 blocks, or 78GB of RAM?  The leaves eat 68G, the nodes eat 10G.

Note that leafs and nodes will usually not be fully used up.

So double the above for the worst case.

> > +inline xfs_extnum_t xfs_iext_count(struct xfs_ifork *ifp)
> 
> static inline?

It is used outside this file.

> > +	for (i = nr_entries; i > pos; i--) {
> > +		node->keys[i] = node->keys[i - 1];
> > +		node->ptrs[i] = node->ptrs[i - 1];
> > +	}
> 
> /me wonders if memmove is more appropriate here, but I'm guessing the
> loop came out of lib/btree.c?

Not using memmove has the big advantage of being type safe.  And with
modern compilers opencoding it or not should not matter, although
now that you mention it I'll take a look at the assembly output.
