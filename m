Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3B6DD7CBE
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 17:56:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EA3158F8033
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 15:56:36 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	lhyTh3XcGDP6EoFF for <xfs@oss.sgi.com>;
	Sat, 15 Aug 2015 15:56:33 -0700 (PDT)
Date: Sun, 16 Aug 2015 08:56:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: stop holding ILOCK over filldir callbacks
Message-ID: <20150815225631.GY3902@dastard>
References: <1439330648-1057-1-git-send-email-david@fromorbit.com>
	<1439330648-1057-3-git-send-email-david@fromorbit.com>
	<20150814194145.GB18522@bfoster.bfoster>
	<20150814223937.GW3902@dastard>
	<20150815130104.GA56219@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150815130104.GA56219@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: jack@suse.cz, oleg@redhat.com, xfs@oss.sgi.com

On Sat, Aug 15, 2015 at 09:01:04AM -0400, Brian Foster wrote:
> On Sat, Aug 15, 2015 at 08:39:37AM +1000, Dave Chinner wrote:
> > On Fri, Aug 14, 2015 at 03:41:45PM -0400, Brian Foster wrote:
> > > On Wed, Aug 12, 2015 at 08:04:08AM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > The recent change to the readdir locking made in 40194ec ("xfs:
> > > > reinstate the ilock in xfs_readdir") for CXFS directory sanity was
> > > > probably the wrong thing to do. Deep in the readdir code we
> > > > can take page faults in the filldir callback, and so taking a page
> > > > fault while holding an inode ilock creates a new set of locking
> > > > issues that lockdep warns all over the place about.
> > > > 
> > > > The locking order for regular inodes w.r.t. page faults is io_lock
> > > > -> pagefault -> mmap_sem -> ilock. The directory readdir code now
> > > > triggers ilock -> page fault -> mmap_sem. While we cannot deadlock
> > > > at this point, it inverts all the locking patterns that lockdep
> > > > normally sees on XFS inodes, and so triggers lockdep. We worked
> > > > around this with commit 93a8614 ("xfs: fix directory inode iolock
> > > > lockdep false positive"), but that then just moved the lockdep
> > > > warning to deeper in the page fault path and triggered on security
> > > > inode locks. Fixing the shmem issue there just moved the lockdep
> > > > reports somewhere else, and now we are getting false positives from
> > > > filesystem freezing annotations getting confused.
> > > > 
> > > > Further, if we enter memory reclaim in a readdir path, we now get
> > > > lockdep warning about potential deadlocks because the ilock is held
> > > > when we enter reclaim. This, again, is different to a regular file
> > > > in that we never allow memory reclaim to run while holding the ilock
> > > > for regular files. Hence lockdep now throws
> > > > ilock->kmalloc->reclaim->ilock warnings.
> > > > 
> > > > Basically, the problem is that the ilock is being used to protect
> > > > the directory data and the inode metadata, whereas for a regular
> > > > file the iolock protects the data and the ilock protects the
> > > > metadata. From the VFS perspective, the i_mutex serialises all
> > > > accesses to the directory data, and so not holding the ilock for
> > > > readdir doesn't matter. The issue is that CXFS doesn't access
> > > > directory data via the VFS, so it has no "data serialisaton"
> > > > mechanism. Hence we need to hold the IOLOCK in the correct places to
> > > > provide this low level directory data access serialisation.
> > > > 
> > > > The ilock can then be used just when the extent list needs to be
> > > > read, just like we do for regular files. The directory modification
> > > > code can take the iolock exclusive when the ilock is also taken,
> > > > and this then ensures that readdir is correct excluded while
> > > > modifications are in progress.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
.....
> > > > @@ -178,7 +179,9 @@ xfs_dir2_block_getdents(
> > > >  	if (xfs_dir2_dataptr_to_db(geo, ctx->pos) > geo->datablk)
> > > >  		return 0;
> > > >  
> > > > +	lock_mode = xfs_ilock_data_map_shared(dp);
> > > >  	error = xfs_dir3_block_read(NULL, dp, &bp);
> > > > +	xfs_iunlock(dp, lock_mode);
> > > 
> > > Ok, so the iolock bits exclude directory reads/lookups against directory
> > > modification. The ilock around these buffer reads serves the purpose of
> > > the commit 40194ec mentioned above, to protect reading in the extent
> > > tree.
> > 
> > Right.
> > 
> > > The locking all looks fine, but what I'm not quite clear on is where the
> > > requirement for the iolock comes in. Is this necessary because the ilock
> > > has been pushed down?
> > 
> > Yes.
> > 
> > Basically, the ilock currently serialises access to directory data
> > in it's entirity. Not just the inode metadata (i.e. struct xfs_inode
> > and the BMBT in the data forks) but also everything the BMBT points
> > to.
> > 
> 
> Indeed. According to the commit referenced above, this was introduced to
> protect reading in the extent list. Therefore, the exclusive lock is
> only taken when it hasn't yet been read (and only in readdir).

Correct. That's exactly what we do with regular file inodes, too.
having multiple readers trying to populate the in-core extent list
concurrently results in a corrupt extent list. Hence we do that
exclusively so that we block other readers until the extent list is
fully populated.

> > The problem with this is that it means that when reading the
> > directory data we have to hold the ilock to prevent racing with
> > modification - not just inode metadata, but also the directory
> > data blocks themselves. i.e. if we don't hold the ilock, we
> > could read one directory data block, and when we go to read the
> > next we could have raced with a modification that shifted
> > dirents from one block to the next. This would result in missing
> > or duplicate dirents in readdir, even though the BMBT had not
> > changed....
> 
> Makes sense, though I wonder what protected this before if i_mutex
> is not in the mix.  This is sort of what I'm more curious about...

On Irix, it was the IOLOCK (i.e. the VFS didn't have it's own inode
locks - it called into the filesystem to get the filesysetm to lock
the inode appropriately). On linux, the IOLOCK was dropped because
the i_mutex serialised all access to the directory data. But for the
CXFS server on linux, it does't have i_mutex serialisation....

> identifying whether we are purely fixing the original problem referenced
> above or stepping back and establishing a proper general locking scheme
> for directories as we do for regular files. It just sounds more like the
> latter.

Both, really. We're going back to how it used to be done, and
hopefully solving all the outstanding problems at the same time.

[....]

> Sounds good, thanks for the explanation. I haven't had a chance to test
> this yet, but the locking looks fine to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> I'll pull it into the continued testing I've been running next week and
> let you know if anything fires.

Thanks Brian!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
