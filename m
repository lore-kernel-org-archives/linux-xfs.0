Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 008F47CB9
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 14:40:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 65F92AC001
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 12:40:16 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id nkhbOcl9TDizq2Sg (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Mar 2016 12:40:13 -0800 (PST)
Date: Tue, 1 Mar 2016 12:40:13 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: block allocations for the refcount btree
Message-ID: <20160301204013.GA23128@infradead.org>
References: <20160210093011.GA19147@infradead.org>
	<20160210095010.GC23904@birch.djwong.org>
	<20160210190738.GA13051@infradead.org>
	<20160210214058.GN14668@dastard>
	<20160212191046.GA28421@infradead.org>
	<20160301181809.GC27973@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160301181809.GC27973@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

On Tue, Mar 01, 2016 at 10:18:09AM -0800, Darrick J. Wong wrote:
> One side effect of the per-ag block reservation code is that it reserves all
> the blocks that the refcountbt will ever need at mount time, which includes
> decreasing the incore fdblocks counter at mount and putting it back at unmount
> time.  This /should/ eliminate the need for reserving blocks in truncate
> transactions, though clearly this isn't being done correctly.

We're still accouting these blocks in t_blk_res_used through
xfs_alloc_vextent -> xfs_alloc_ag_vextent -> xfs_trans_mod_sb.

I don't really see how the reservation code changes anything about
that accounting.  It just ensures the allocation will succeed through
xfs_ag_resv_needed in xfs_alloc_ag_vextent, and then removes the
allocated block from the reservation using xfs_ag_resv_alloc_block.

Maybe we need to find a way to not account for these blocks.

> So what I'm saying is that I think this problem was with the AGresv code not
> doing accounting correctly, and that I've fixed it in a subsequent rewrite of
> the AGresv code.  I'll post it later, after I figure out why generic/333
> regresses with the new code.

Ok, let's see if the new version helps with the above issue.

> However, there's one thing to be aware of -- if the AGresv uses up all the
> blocks that were preallocated at mount time, the allocator will grab any free
> blocks available and charge the blocks to the transaction, just like before.
> If this ever happens (in theory we reserve enough blocks so that we can have a
> refcount record for every block in the AG) then we'll still have this problem.

It seems like we should simply avoid that this case ever happens.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
