Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D3D3D7F3F
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 18:24:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 80805AC004
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 16:24:35 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	zRjafxMC4OlsLW0G for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2014 16:24:32 -0800 (PST)
Date: Wed, 26 Nov 2014 11:24:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] vfs: add support for a lazytime mount option
Message-ID: <20141126002414.GC9561@dastard>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-3-git-send-email-tytso@mit.edu>
	<20141125015239.GD27262@dastard> <20141125043335.GF31339@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141125043335.GF31339@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 24, 2014 at 11:33:35PM -0500, Theodore Ts'o wrote:
> On Tue, Nov 25, 2014 at 12:52:39PM +1100, Dave Chinner wrote:
> > > +static void flush_sb_dirty_time(struct super_block *sb)
> > > +{
>   ...
> > > +}
> > 
> > This just seems wrong to me, not to mention extremely expensive when we have
> > millions of cached inodes on the superblock.
> 
> #1, It only gets called on a sync(2) or syncfs(2), which can be pretty
> expensive as it is, so I didn't really worry about it.
> 
> #2, We're already iterating over all of the inodes in the sync(2) or
> syncfs(2) path, so the code path in question is already O(N) in the
> number of inodes.
> 
> > Why can't we just add a function like mark_inode_dirty_time() which
> > puts the inode on the dirty inode list with a writeback time 24
> > hours in the future rather than 30s in the future?
> 
> I was concerned about putting them on the dirty inode list because it
> would be extra inodes for the writeback threads would have to skip
> over and ignore (since they would not be dirty in the inde or data
> pages sense).

Create another list - we already have multiple dirty inode lists in
the struct bdi_writeback....

> Another solution would be to use a separate linked list for dirtytime
> inodes, but that means adding some extra fields to the inode
> structure, which some might view as bloat. 

We already have an i_wb_list in the inode for tracking the dirty
list the inode belongs to.

> Given #1 and #2 above,
> yes, we're doubling the CPU cost for sync(2) and syncfs(2), since
> we're not iterating over all of the inodes twice, but I believe that
> is a better trade-off than bloating the inode structure with an extra
> set of linked lists or increasing the CPU cost to the writeback path
> (which gets executed way more often than the sync or syncfs paths).

There is no need to bloat the inode at all, therefore we shouldn't
be causing sync/syncfs regressions by enabling lazytime...

> > Eviction is too late for this. I'm pretty sure that it won't get
> > this far as iput_final() should catch the I_DIRTY_TIME in the !drop
> > case via write_inode_now().
> 
> Actually, the tracepoint for fs_lazytime_evict() does get triggered
> from time to time; but only when the inode is evicted due to memory
> pressure, i.e., via the evict_inodes() path.

That's indicative of a bug - if it's dirty then you shouldn't be
evicting it. The LRU shrinker explicitly avoids reclaiming dirty
inodes. Also, evict_inodes() is only called in the unmount path,
and that happens after a sync_filesystem() call so that shouldn't be
finding dirty inodes, either....

> I thought about possibly doing this in iput_final(), but that would
> mean that whenever we closed the last fd on the file, we would push
> the inode out to disk.

I get the feeling from your responses that you really don't
understand the VFS inode lifecycle or the writeback code works.
Inodes don't get dropped form the inode cache when the last open FD
on them is closed unless they are an unlinked file. The dentry cache
still holds a reference to the inode....

> For files that we are writing, that's not so
> bad; but if we enable strictatime with lazytime, then we would be
> updating the atime for inodes that had been only been read on every
> close --- which in the case of say, all of the files in the kernel
> tree, would be a little unfortunate.
> 
> Of course, the combination of strict atime and lazytime would result
> in a pretty heavy write load on a umount or sync(2), so I suspect
> keeping the relatime mode would make sense for most people, but I for
> those people who need strict Posix compliance, it seemed like doing
> something that worked well for strictatime plus lazytime would be a
> good thing, which is why I tried to defer things as much as possible.
> 
> > 	if (!datasync && (inode->i_state & I_DIRTY_TIME)) {
> > 
> > > +		spin_lock(&inode->i_lock);
> > > +		inode->i_state |= I_DIRTY_SYNC;
> > > +		spin_unlock(&inode->i_lock);
> > > +	}
> > >  	return file->f_op->fsync(file, start, end, datasync);
> > 
> > When we mark the inode I_DIRTY_TIME, we should also be marking it
> > I_DIRTY_SYNC so that all the sync operations know that they should
> > be writing this inode. That's partly why I also think these inodes
> > should be tracked on the dirty inode list....
> 
> The whole point of what I was doing is that I_DIRTY_TIME was not part
> of I_DIRTY, and that when in update_time() we set I_DIRTY_TIME instead
> of I_DIRTY_SYNC.

I_DIRTY_SYNC only matters once you get the inode into the fsync code
or deep into the inode writeback code (i.e.
__writeback_single_inode()). if we don't expire the inode at the
high level writeback code, then the only time we'll get into
__writeback_single_inode() is through specific foreground attempts
to write the inode. In which case, we should be writing the inode if
it is I_DIRTY_TIME, and so I_DIRTY_SYNC will trigger all the correct
code paths to be taken to get us to writing it.

And then we don't need hacks like the above to get fsync to write
the inode....

> The goal is that these inodes would not end up on
> the dirty list, because that way they wouldn't be forced out to disk
> until either (a) the inode is written out for other reasons (i.e., a
> change in i_size or i_blocks, etc.), (b) the inode is explicitly
> fsync'ed, or (c) the the umount(2), sync(2), or syncfs(2) of the file
> system.

Precisely. If we don't expire the inode from the dirty list, and it
will only get written back when inode writeback is explicitly asked
for.

> That way, the timestamps are in the memory copy inode, but *not*
> written on disk until they are opportunistically written out due to
> some other modification of the inode which sets I_DIRTY_SYNC.
> 
> If we were to set I_DIRTY_SYNC alongside I_DIRTY_TIME, and put these
> inodes on the dirty inode list, then I_DIRTY_TIME would effectively be
> a no-op, and there would be no point to this whole exercise.

Except for the fact that I_DIRTY_TIME would result in the inode
being put on a different dirty list, and then when it's marked dirty
properly it can be moved onto the dirty inode list that will trigger
background writeback in 30s....

> If there is significant objections to doing this in the VFS layer, I'm
> happy to go back to doing this as in ext4-specific code.
> The main reason why I redid this patch set as a VFS specific change
> was because Cristoph and others specifically requested it.  But if you
> strongly object, I can always go back to doing this in the ext4 code....

Don't be a drama queen, Ted. lazytime is something that needs to be
done at the VFS but it needs to be done efficiently.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
