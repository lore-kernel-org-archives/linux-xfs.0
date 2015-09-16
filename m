Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 368A97F47
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 17:35:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B6F64AC004
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 15:35:26 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	WN0oJRbbp8DFFCMn for <xfs@oss.sgi.com>;
	Wed, 16 Sep 2015 15:35:24 -0700 (PDT)
Date: Thu, 17 Sep 2015 08:34:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: add missing ilock around dio write last extent
	alignment
Message-ID: <20150916223435.GW26895@dastard>
References: <1441809812-60175-1-git-send-email-bfoster@redhat.com>
	<20150913235835.GV26895@dastard>
	<20150914132455.GA22770@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150914132455.GA22770@bfoster.bfoster>
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
Cc: David Jeffery <djeffery@redhat.com>, xfs@oss.sgi.com

On Mon, Sep 14, 2015 at 09:24:55AM -0400, Brian Foster wrote:
> On Mon, Sep 14, 2015 at 09:58:35AM +1000, Dave Chinner wrote:
> > On Wed, Sep 09, 2015 at 10:43:32AM -0400, Brian Foster wrote:
> > > The iomap codepath (via get_blocks()) acquires and release the inode
> > > lock in the case of a direct write that requires block allocation. This
> > > is because xfs_iomap_write_direct() allocates a transaction, which means
> > > the ilock must be dropped and reacquired after the transaction is
> > > allocated and reserved.
> > > 
> > > xfs_iomap_write_direct() invokes xfs_iomap_eof_align_last_fsb() before
> > > the transaction is created and thus before the ilock is reacquired. This
> > > can lead to calls to xfs_iread_extents() and reads of the in-core extent
> > > list without any synchronization (via xfs_bmap_eof() and
> > > xfs_bmap_last_extent()). xfs_iread_extents() assert fails if the ilock
> > > is not held, but this is not currently seen in practice as the current
> > > callers had already invoked xfs_bmapi_read().
> > > 
> > > What has been seen in practice are reports of crashes down in the
> > > xfs_bmap_eof() codepath on direct writes due to seemingly bogus pointer
> > > references from xfs_iext_get_ext(). While an explicit reproducer is not
> > > currently available to confirm the cause of the problem, crash analysis
> > > and code inspection from David Jeffrey had identified the insufficient
> > > locking.
> > > 
> > > xfs_iomap_eof_align_last_fsb() is called from other contexts with the
> > > inode lock already held. __xfs_get_blocks() acquires and drops the ilock
> > > with variable flags. Therefore, take the simple approach to cycle ilock
> > > around the last extent alignment call from xfs_iomap_write_direct().
> > > 
> > > Reported-by: David Jeffery <djeffery@redhat.com>
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_iomap.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > > index 1f86033..4d7534e 100644
> > > --- a/fs/xfs/xfs_iomap.c
> > > +++ b/fs/xfs/xfs_iomap.c
> > > @@ -142,7 +142,9 @@ xfs_iomap_write_direct(
> > >  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
> > >  	last_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)(offset + count)));
> > >  	if ((offset + count) > XFS_ISIZE(ip)) {
> > > +		xfs_ilock(ip, XFS_ILOCK_EXCL);
> > >  		error = xfs_iomap_eof_align_last_fsb(mp, ip, extsz, &last_fsb);
> > > +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > 
> > XFS_ILOCK_SHARED?
> > 
> 
> I suspect that is technically sufficient in this particular call path
> given that we've called xfs_bmapi_read(). The problem is that there is a
> call to xfs_iread_extents() buried a few calls deep in
> xfs_bmap_last_extent().

Sure.

> My understanding is that we need the exclusive
> lock because it's not safe for multiple threads to populate the in-core
> extent list at the same time, so I don't really want to replace the
> existing race with a landmine should the context happen to change in the
> future.

yes, but that can't happen here because we are guaranteed to have
the extent list in memory because we've alreay called
xfs_bmapi_read() and that will populate the extent list with the
appropriate lock held.

> > Also, looking at __xfs_get_blocks(), we drop the ilock immediately
> > before calling xfs_iomap_write_direct(), which we already hold in
> > shared mode for the xfs_bmapi_read() for direct IO.
> > 
> > Can we push that lock dropping into xfs_iomap_write_direct() after
> > we've done the xfs_iomap_eof_align_last_fsb() call and before we do
> > transaction reservations so we don't need an extra lock round-trip
> > here? e.g. xfs_iomap_write_delay() is called under the lock context
> > held by __xfs_get_blocks()....
> > 
> 
> That was my initial thought when looking at this code... e.g., to just
> carry the lock over and drop it prior to transaction setup. I didn't go
> that route because __xfs_get_blocks() uses a variable locking mode and
> it seemed ugly to pass along the lock mode to xfs_iomap_direct_write().
> Further, given the above it also looked like we'd have to check and
> cycle the ilock EXCL if it were ILOCK_SHARED. Finally,

No, because the __xfs_get_blocks code calls
xfs_ilock_data_map_shared() for direct IO, so already holds the
correct lock for populating the extent list (not that this matters
here).

> xfs_iomap_direct_write() has a call to xfs_qm_dqattach() which itself
> acquires ILOCK_EXCL. Looking at xfs_iomap_write_delay(), we do have a
> dqattach_locked() variant but it also expects to have ILOCK_EXCL.

That can be moved to after we've calculated the last extent. i.e.
to just before we start the transaction....

> The only thing I'm not sure about is the shared lock safe version of
> xfs_iomap_eof_align_last_fsb().

All the callers are guaranteed to have first populated the extent
list, so this should be safe. If you are really worried, add an
assert that verifies either ILOCK_EXCL or (ILOCK_SHARED && extents
read in)

> xfs_iread_extents() if it were called). Also, I take it we can safely
> assume the in-core extent list is still around if we still hold the lock
> from the xfs_bmapi_read() call. Thoughts? I guess I'll float another
> patch...

Once the extents are read in, they are in memory until the inode is
reclaimed. That won't happen while we have active references to it.
:)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
