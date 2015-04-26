Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7963F7F47
	for <xfs@oss.sgi.com>; Sun, 26 Apr 2015 17:42:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4A91D8F8035
	for <xfs@oss.sgi.com>; Sun, 26 Apr 2015 15:42:46 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7PuEUkmQAak65cQN for <xfs@oss.sgi.com>;
	Sun, 26 Apr 2015 15:42:40 -0700 (PDT)
Date: Mon, 27 Apr 2015 08:40:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: question re: xfs inode to inode copy implementation
Message-ID: <20150426224007.GO15810@dastard>
References: <20150421010646.GX8110@shells.gnugeneration.com>
	<20150421042820.GA11601@birch.djwong.org>
	<20150421222738.GL21261@dastard>
	<20150423004426.GC29335@birch.djwong.org>
	<20150423011345.GR21261@dastard>
	<20150423064016.GB11601@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150423064016.GB11601@birch.djwong.org>
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
Cc: vito.caputo@coreos.com, xfs@pengaru.com, xfs <xfs@oss.sgi.com>

On Wed, Apr 22, 2015 at 11:40:16PM -0700, Darrick J. Wong wrote:
> On Thu, Apr 23, 2015 at 11:13:45AM +1000, Dave Chinner wrote:
> > On Wed, Apr 22, 2015 at 05:44:26PM -0700, Darrick J. Wong wrote:
> > > On Wed, Apr 22, 2015 at 08:27:38AM +1000, Dave Chinner wrote:
> > > > On Mon, Apr 20, 2015 at 09:28:20PM -0700, Darrick J. Wong wrote:
> > > > > On Mon, Apr 20, 2015 at 08:06:46PM -0500, xfs@pengaru.com wrote:
> > > > crashing between the breaking of the shared reference and data
> > > > writeback doesn't leave us with a hole instead of data. To deal with
> > > > that, I think that we're going to have to break shared extents
> > > > during writeback, not during the write. However, we are going to
> > > > need a delalloc reservation to do that.
> > > > 
> > > > So I suspect we need a new type of extent in the in-core extent tree
> > > > - a "delalloc overwrite" extent - so that when we map it in writeback
> > > > we can allocate the new extent, do the write to it, and then on IO
> > > > completion do the BMBT manipulation to break the shared reference
> > > > and insert the new extent. That solves the atomicity problem, and it
> > > > allows us to track COW data on a per-inode basis without having
> > > > to care about all the other reflink contexts to that same data.
> > > 
> > > I think that'll work... in xfs_vm_writepage (more probably xfs_map_blocks) if
> > > the refcount > 2, allocate a new block, insert a new delalloc-overwrite in-core
> 
> Speaking of which, should I add a XFS_DIFLAG_ to indicate that a file has
> (or has had) reflinked blocks?  In theory this would save us a trip through
> the reflinkbt for "normal" files when the reflink feature is set, but
> we'd then have to maintain it (and repair would have to check it).

Yes, we probably should have a flag like this. It makes it simple to
determine where to look for extent info, but it also gives us some
redundant information as to whether the inode should have shared
extents rather than have them trashed as duplicate references to an
unshared block in repair...

> > > extent with the new block number and set a flag in the ioend to remind
> > > ourselves to update the bookkeeping later.  During xfs_end_io if that flag is
> > > set, commit the new in-core extent to disk, decrement the refcounts, and
> > > free the block if the refcount is 1.
> > 
> > If we are going to track the overwrite in-core, then we are probably
> > going to need some form of intent/done transaction structure so that
> > we don't leak the allocated block if we crash before the completion
> > runs and commits the extent swap. I'd prefer to do that than require
> > on-disk state to prevent free space leakage in this case.
> >
> > We could, potentially, abuse the EFI for this. i.e. record an EFI
> > for the extent in the allocation transaction, then in the completion
> > record a matching EFD. That way recovery will free the allocated
> > extent if we don't complete it....
> 
> Clever!  I was looking around to see if XFS had something that could
> take care of cleaning up orphans like that.

It's not intended for this purpose, but I think it will work just
fine - as long as the extent is not actually added to the on-disk
bmbt by the allocation transaction.  The EFI is currently committed in
the same transaction that removes the extent from the BMBT to
indicate it is not referenced on disk and then it is freed in the
following transaction that also commits the EFD to indicate it is
referenced again (by the free space tree). The above would work the
opposite way around - EFI commited on removal from the free space
tree, EFD committed on addition to the BMBT...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
