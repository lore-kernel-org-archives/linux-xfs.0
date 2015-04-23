Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 463D87F37
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 20:14:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BEF82AC004
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 18:13:56 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	b2GcxZdwkxg15pof for <xfs@oss.sgi.com>;
	Wed, 22 Apr 2015 18:13:53 -0700 (PDT)
Date: Thu, 23 Apr 2015 11:13:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: question re: xfs inode to inode copy implementation
Message-ID: <20150423011345.GR21261@dastard>
References: <20150421010646.GX8110@shells.gnugeneration.com>
	<20150421042820.GA11601@birch.djwong.org>
	<20150421222738.GL21261@dastard>
	<20150423004426.GC29335@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150423004426.GC29335@birch.djwong.org>
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

On Wed, Apr 22, 2015 at 05:44:26PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 22, 2015 at 08:27:38AM +1000, Dave Chinner wrote:
> > On Mon, Apr 20, 2015 at 09:28:20PM -0700, Darrick J. Wong wrote:
> > > On Mon, Apr 20, 2015 at 08:06:46PM -0500, xfs@pengaru.com wrote:
> > > > Hello list,
> > > > 
> > > > I'm prototyping something like reflinks in xfs and was wondering if
> > > > anyone could give me some pointers on the best way to duplicate the
> > > 
> > > Heh, funny, I'm working on that too...
> > > 
> > > > blocks of the shared inode at the reflink inode, the copy which must
> > > > occur when breaking the link.
> > > 
> > > ...though I'm not sure what "the shared inode at the reflink inode" means.
> > > Are there somehow three inodes involved with reflinking one file to another?
> > > 
> > > > It would be nice to do the transfer via the page cache after allocating
> > > > the space at the desintation inode, but it doesn't seem like I can use
> > > > any of the kernel helpers for copying the data via the address_space
> > > > structs since I don't have a struct file on hand for the copy source.
> > > > I'm doing this in xfs_file_open() so the only struct file I have is the
> > > > file being opened for writing - the destination of the copy.
> > > 
> > > So you're cloning the entire file's contents (i.e. breaking the reflink) as
> > > soon as the file is opened rw?
> > > 
> > > > What I do have on hand is the shared inode and the destination inode
> > > > opened and ready to go, and the struct file for the destination.
> > > 
> > > The design I'm pursuing is different from yours, I think -- two files can use
> > > the regular bmbt to point to the same physical blocks, and there's a per-ag
> > > btree that tracks reference counts for physical extents.  What I'd like to do
> > > for the CoW operation is to clone the page (somehow), change the bmbt mapping
> > > to "delayed allocation", and let the dirty pages flush out like normal.
> > > 
> > > I haven't figured out /how/ to do this, mind you.  The rest of the bookkeeping
> > > parts are already written, though.
> > 
> > My first thought on COW was to try to use the write path get_blocks
> > callback to do all this.  i.e. in __xfs_get_blocks() detect that it
> > is an overwrite of a shared extent, remove the shared extent
> > reference and then convert it to delayed alloc extent. (i.e.
> > xfs_iomap_overwrite_shared()). Then writeback will allocate new
> > blocks for the data.
> 
> <nod> That was my first thought, too.  I was rather hoping that I could just
> update the incore BMBT to kick off delayed allocation and hope that it flushes
> everything to disk before anything can blow up. (Ha...)  But alas, I hit the
> same conclusion that you'd have to allocate the new block, write it, and only
> then ought you update the BMBT.
> 
> > The question, however, is how to do this in a manner such that
> > crashing between the breaking of the shared reference and data
> > writeback doesn't leave us with a hole instead of data. To deal with
> > that, I think that we're going to have to break shared extents
> > during writeback, not during the write. However, we are going to
> > need a delalloc reservation to do that.
> > 
> > So I suspect we need a new type of extent in the in-core extent tree
> > - a "delalloc overwrite" extent - so that when we map it in writeback
> > we can allocate the new extent, do the write to it, and then on IO
> > completion do the BMBT manipulation to break the shared reference
> > and insert the new extent. That solves the atomicity problem, and it
> > allows us to track COW data on a per-inode basis without having
> > to care about all the other reflink contexts to that same data.
> 
> I think that'll work... in xfs_vm_writepage (more probably xfs_map_blocks) if
> the refcount > 2, allocate a new block, insert a new delalloc-overwrite in-core
> extent with the new block number and set a flag in the ioend to remind
> ourselves to update the bookkeeping later.  During xfs_end_io if that flag is
> set, commit the new in-core extent to disk, decrement the refcounts, and
> free the block if the refcount is 1.

If we are going to track the overwrite in-core, then we are probably
going to need some form of intent/done transaction structure so that
we don't leak the allocated block if we crash before the completion
runs and commits the extent swap. I'd prefer to do that than require
on-disk state to prevent free space leakage in this case.

We could, potentially, abuse the EFI for this. i.e. record an EFI
for the extent in the allocation transaction, then in the completion
record a matching EFD. That way recovery will free the allocated
extent if we don't complete it....

> For O_DIRECT I suppose we could use a similar mechanism -- you'd
> have to set up the delalloc-overwrite extent in
> xfs_iomap_write_direct() and use xfs_end_io_direct_write() to
> update the bmbt and decrement the refcounts in the same way as
> above.

Effectively.

> Hm.  Not sure what'll happen if the write buffer or the block size aren't a
> page size.  Will have to go figure out what XFS does to fill in the rest of a
> block if you try to directio-write to less than a block.  Hoping it's less
> weird than other things I've seen.

Oh, it's weird enough. We allow sector size alignment, but we
serialise all unaligned DIO writes because the sub-block zeroing is
a nightmare to co-ordinate properly. But, really, DIO to a reflink
file is not a performant operation, so maybe we should just punt all
writes to shared extent files to the buffered IO path and not have
to care about COW during DIO writes?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
