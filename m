Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D46F37CBE
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2015 17:27:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CAFE78F8035
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2015 15:27:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	vJVuzfpvxLmtBxgR for <xfs@oss.sgi.com>;
	Tue, 21 Apr 2015 15:27:52 -0700 (PDT)
Date: Wed, 22 Apr 2015 08:27:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: question re: xfs inode to inode copy implementation
Message-ID: <20150421222738.GL21261@dastard>
References: <20150421010646.GX8110@shells.gnugeneration.com>
	<20150421042820.GA11601@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150421042820.GA11601@birch.djwong.org>
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

On Mon, Apr 20, 2015 at 09:28:20PM -0700, Darrick J. Wong wrote:
> On Mon, Apr 20, 2015 at 08:06:46PM -0500, xfs@pengaru.com wrote:
> > Hello list,
> > 
> > I'm prototyping something like reflinks in xfs and was wondering if
> > anyone could give me some pointers on the best way to duplicate the
> 
> Heh, funny, I'm working on that too...
> 
> > blocks of the shared inode at the reflink inode, the copy which must
> > occur when breaking the link.
> 
> ...though I'm not sure what "the shared inode at the reflink inode" means.
> Are there somehow three inodes involved with reflinking one file to another?
> 
> > It would be nice to do the transfer via the page cache after allocating
> > the space at the desintation inode, but it doesn't seem like I can use
> > any of the kernel helpers for copying the data via the address_space
> > structs since I don't have a struct file on hand for the copy source.
> > I'm doing this in xfs_file_open() so the only struct file I have is the
> > file being opened for writing - the destination of the copy.
> 
> So you're cloning the entire file's contents (i.e. breaking the reflink) as
> soon as the file is opened rw?
> 
> > What I do have on hand is the shared inode and the destination inode
> > opened and ready to go, and the struct file for the destination.
> 
> The design I'm pursuing is different from yours, I think -- two files can use
> the regular bmbt to point to the same physical blocks, and there's a per-ag
> btree that tracks reference counts for physical extents.  What I'd like to do
> for the CoW operation is to clone the page (somehow), change the bmbt mapping
> to "delayed allocation", and let the dirty pages flush out like normal.
> 
> I haven't figured out /how/ to do this, mind you.  The rest of the bookkeeping
> parts are already written, though.

My first thought on COW was to try to use the write path get_blocks
callback to do all this.  i.e. in __xfs_get_blocks() detect that it
is an overwrite of a shared extent, remove the shared extent
reference and then convert it to delayed alloc extent. (i.e.
xfs_iomap_overwrite_shared()). Then writeback will allocate new
blocks for the data.

The question, however, is how to do this in a manner such that
crashing between the breaking of the shared reference and data
writeback doesn't leave us with a hole instead of data. To deal with
that, I think that we're going to have to break shared extents
during writeback, not during the write. However, we are going to
need a delalloc reservation to do that.

So I suspect we need a new type of extent in the in-core extent tree
- a "delalloc overwrite" extent - so that when we map it in writeback
we can allocate the new extent, do the write to it, and then on IO
completion do the BMBT manipulation to break the shared reference
and insert the new extent. That solves the atomicity problem, and it
allows us to track COW data on a per-inode basis without having
to care about all the other reflink contexts to that same data.

> With reflink enabled, xfsrepair theoretically can solve multiply claimed blocks
> by simply adding the appropriate agblock:refcount entry to the refcount btree
> and it's done.

With rmap, XFS can solve multiply claimed blocks simply by looking
at who really owns the block in the rmap... :P

> > P.S. I've seen Dave Chinner's mention of reflink prototypes in XFS on
> > lwn but haven't been able to find any code, what's the status of that?

No code, because they are prototypes to determine if ideas are sane
and workable.  Similar to what Darrick is doing right now, and we've
talked about it on #xfs a fair bit. Darrick has more time to work on
this right now than I do, so he's the guy doing all the heavy
lifting at the moment...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
