Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DCCD77CBB
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 23:24:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3EF57AC004
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 21:24:47 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id pqKIUzq7BNvY1ZaB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Mar 2016 21:24:44 -0800 (PST)
Date: Tue, 1 Mar 2016 21:24:11 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: block allocations for the refcount btree
Message-ID: <20160302052411.GB1902@birch.djwong.org>
References: <20160210093011.GA19147@infradead.org>
	<20160210095010.GC23904@birch.djwong.org>
	<20160210190738.GA13051@infradead.org>
	<20160210214058.GN14668@dastard>
	<20160212191046.GA28421@infradead.org>
	<20160301181809.GC27973@birch.djwong.org>
	<20160301204013.GA23128@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160301204013.GA23128@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 01, 2016 at 12:40:13PM -0800, Christoph Hellwig wrote:
> On Tue, Mar 01, 2016 at 10:18:09AM -0800, Darrick J. Wong wrote:
> > One side effect of the per-ag block reservation code is that it reserves all
> > the blocks that the refcountbt will ever need at mount time, which includes
> > decreasing the incore fdblocks counter at mount and putting it back at unmount
> > time.  This /should/ eliminate the need for reserving blocks in truncate
> > transactions, though clearly this isn't being done correctly.
> 
> We're still accouting these blocks in t_blk_res_used through
> xfs_alloc_vextent -> xfs_alloc_ag_vextent -> xfs_trans_mod_sb.
> 
> I don't really see how the reservation code changes anything about
> that accounting.  It just ensures the allocation will succeed through
> xfs_ag_resv_needed in xfs_alloc_ag_vextent, and then removes the
> allocated block from the reservation using xfs_ag_resv_alloc_block.
> 
> Maybe we need to find a way to not account for these blocks.
> 
> > So what I'm saying is that I think this problem was with the AGresv code not
> > doing accounting correctly, and that I've fixed it in a subsequent rewrite of
> > the AGresv code.  I'll post it later, after I figure out why generic/333
> > regresses with the new code.
> 
> Ok, let's see if the new version helps with the above issue.
> 
> > However, there's one thing to be aware of -- if the AGresv uses up all the
> > blocks that were preallocated at mount time, the allocator will grab any free
> > blocks available and charge the blocks to the transaction, just like before.
> > If this ever happens (in theory we reserve enough blocks so that we can have a
> > refcount record for every block in the AG) then we'll still have this problem.
> 
> It seems like we should simply avoid that this case ever happens.

I've rebased my trees and pushed them all to github.

The for-dave-for-4.6 kernel and progs branches are the giant piles of patches
against Dave's for-next integration trees which (I think) are being reviewed
for 4.6.

The for-dave branches are against upstream as they've always been.

New patches have been added on the end of the patchset.

I noticed that generic/139 crashes for-dave with a 1k block size due something
or other sending us bio->bi_bdev == NULL.  This seems to be sorted out somehow
in for-next.  Other than that I haven't seen any problems... but I've only
run against x64 on bare XFS.  Will run other arches/NFS/etc tonight/tomorrow.

The transaction block reservation complaints should be fixed now, and I
think the transaction reservations have been fixed too... or at least they
don't show up on the tinydisk test setup.  But all that means is that someone
else will find it, probably within the first 3 minutes of testing. :P

kernel:
for-dave-for-4.6: 31bb2360d45ae3920244a808caffd500ad85f2b6 -> b07b3e650891dc3bd439c5c296bfc22b90c1b9a5
for-dave: fc77dbd34c5c99bce46d40a2491937c3bcbd10af -> 163e86bdb2a2dc1ebb91867a247b4e671298fde7

xfsprogs:
for-dave-for-4.6: c062cfe7dbc568ec9ec308ef6a1bf4ef5cd9af2a -> b147a7ea86bf1f3697cea3bfa7909197ee374aba
for-dave: 1abecdabbc9190db2fa7c3dab15931b7b9ddbb0d -> cbda21d47a9ecde446660bb8ffd808e2ac008554

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
