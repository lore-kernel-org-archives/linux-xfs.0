Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0PKRAr3074199 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 14:27:10 -0600
Date: Mon, 25 Jan 2010 14:28:39 -0600
From: bpm@sgi.com
Subject: Re: nfs performance delta between filesystems
Message-ID: <20100125202839.GA28087@sgi.com>
References: <20100122185419.63ae6430@harpe.intellique.com>
	<20100122183848.GB28561@sgi.com>
	<20100125150410.GA25699@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100125150410.GA25699@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Jan 25, 2010 at 10:04:10AM -0500, Christoph Hellwig wrote:
> On Fri, Jan 22, 2010 at 12:38:48PM -0600, bpm@sgi.com wrote:
> > Hey Emmanuel,
> > 
> > I did some research on this in April last year on an old, old kernel.
> > One of the codepaths I flagged:
> > 
> > nfsd_create
> >   write_inode_now
> >     __sync_single_inode
> >       write_inode
> >         xfs_fs_write_inode
> > 	  xfs_inode_flush
> > 	    xfs_iflush
> > 
> > There were small gains to be had by reordering the sync of the parent and
> > child syncs where the two inodes were in the same cluster.  The larger
> > problem seemed to be that we're not treating the log as stable storage.
> > By calling write_inode_now we've written the changes to the log first
> > and then gone and also written them out to the inode.  
> > 
> > nfsd_create, nfsd_link, and nfsd_setattr all do this (or do in the old
> > kernel I'm looking at).  I have a patchset that changes
> > this to an fsync so we force the log and call it good.  I'll be happy to
> > dust it off if someone hasn't already addressed this situation.
> 
> Dave and I had had some discussion about this when going through his
> inode writeback changes.  Changing to ->fsync might indeed be the
> easiest option, but on the other hand I'm really trying to get rid of
> the special case of ->fsync without a file argument in the VFS as it
> complicates stackable filesystem layers and also creates a rather
> annoying and under/un documented assumtion that filesystem that need
> the file pointer can't be NFS exported.  One option if we want to
> keep these semantics is to add a new export operation just for
> synchronizations things in NFS.
> 
> But given that the current use case in NFS is to pair one write_inode
> call with one actual VFS operation it might be better to just
> automatically turn on the wsync mount option in XFS, we'd need a hook
> from NFSD into the filesystem to implement this, but I've been looking
> into adding this anyway to allow for checking other paramters like the
> file handle size against filesystem limitations.  Any chance you
> could run your tests against a wsync filesystem?

The original tests were done with the wsync mount option.  I'm not
really sure that it was necessary.  Test case was "tar -xvf
ImageMagick.tar".  'fdatasync' represents whether the export option
controlling usage of write_inode_now vs fsync was set.

internal log, no wsync, no fdatasync
2m48.632s       2m59.676s       2m42.450s

internal log, wsync, no fdatasync
3m1.320s        3m10.961s       2m53.560s

internal log, wsync, fdatasync
1m40.191s       1m38.780s       1m35.758s

external log, no wsync, no fdatasync
1m37.069s       1m37.850s       1m38.303s

external log, wsync, no fdatasync
1m48.948s       1m47.804s       1m50.219s

external log, wsync, fdatasync
1m19.265s       1m19.129s       1m19.635s

> But all this affects metadata performance, and only for sync exports,
> while the OP does a simple dd which is streaming data I/O and uses the
> (extremly unsafe) async export operation that disables the write_inode
> calls.

Right.  This might not apply to Emmanuel's problem.  I've been wondering
if a recent change to not hold the inode mutex over the sync helps in
the streaming io case.  Any idea?

Anyway, looks like Dave's patchset addresses this.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
