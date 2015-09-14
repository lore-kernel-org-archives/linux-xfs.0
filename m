Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6AF977F37
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 08:25:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3D4D08F8037
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 06:25:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CFEZNsaPzcIgGxqI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Sep 2015 06:24:57 -0700 (PDT)
Date: Mon, 14 Sep 2015 09:24:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: add missing ilock around dio write last extent
	alignment
Message-ID: <20150914132455.GA22770@bfoster.bfoster>
References: <1441809812-60175-1-git-send-email-bfoster@redhat.com>
	<20150913235835.GV26895@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150913235835.GV26895@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: David Jeffery <djeffery@redhat.com>, xfs@oss.sgi.com

On Mon, Sep 14, 2015 at 09:58:35AM +1000, Dave Chinner wrote:
> On Wed, Sep 09, 2015 at 10:43:32AM -0400, Brian Foster wrote:
> > The iomap codepath (via get_blocks()) acquires and release the inode
> > lock in the case of a direct write that requires block allocation. This
> > is because xfs_iomap_write_direct() allocates a transaction, which means
> > the ilock must be dropped and reacquired after the transaction is
> > allocated and reserved.
> > 
> > xfs_iomap_write_direct() invokes xfs_iomap_eof_align_last_fsb() before
> > the transaction is created and thus before the ilock is reacquired. This
> > can lead to calls to xfs_iread_extents() and reads of the in-core extent
> > list without any synchronization (via xfs_bmap_eof() and
> > xfs_bmap_last_extent()). xfs_iread_extents() assert fails if the ilock
> > is not held, but this is not currently seen in practice as the current
> > callers had already invoked xfs_bmapi_read().
> > 
> > What has been seen in practice are reports of crashes down in the
> > xfs_bmap_eof() codepath on direct writes due to seemingly bogus pointer
> > references from xfs_iext_get_ext(). While an explicit reproducer is not
> > currently available to confirm the cause of the problem, crash analysis
> > and code inspection from David Jeffrey had identified the insufficient
> > locking.
> > 
> > xfs_iomap_eof_align_last_fsb() is called from other contexts with the
> > inode lock already held. __xfs_get_blocks() acquires and drops the ilock
> > with variable flags. Therefore, take the simple approach to cycle ilock
> > around the last extent alignment call from xfs_iomap_write_direct().
> > 
> > Reported-by: David Jeffery <djeffery@redhat.com>
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_iomap.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index 1f86033..4d7534e 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -142,7 +142,9 @@ xfs_iomap_write_direct(
> >  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
> >  	last_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)(offset + count)));
> >  	if ((offset + count) > XFS_ISIZE(ip)) {
> > +		xfs_ilock(ip, XFS_ILOCK_EXCL);
> >  		error = xfs_iomap_eof_align_last_fsb(mp, ip, extsz, &last_fsb);
> > +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 
> XFS_ILOCK_SHARED?
> 

I suspect that is technically sufficient in this particular call path
given that we've called xfs_bmapi_read(). The problem is that there is a
call to xfs_iread_extents() buried a few calls deep in
xfs_bmap_last_extent(). My understanding is that we need the exclusive
lock because it's not safe for multiple threads to populate the in-core
extent list at the same time, so I don't really want to replace the
existing race with a landmine should the context happen to change in the
future.

> Also, looking at __xfs_get_blocks(), we drop the ilock immediately
> before calling xfs_iomap_write_direct(), which we already hold in
> shared mode for the xfs_bmapi_read() for direct IO.
> 
> Can we push that lock dropping into xfs_iomap_write_direct() after
> we've done the xfs_iomap_eof_align_last_fsb() call and before we do
> transaction reservations so we don't need an extra lock round-trip
> here? e.g. xfs_iomap_write_delay() is called under the lock context
> held by __xfs_get_blocks()....
> 

That was my initial thought when looking at this code... e.g., to just
carry the lock over and drop it prior to transaction setup. I didn't go
that route because __xfs_get_blocks() uses a variable locking mode and
it seemed ugly to pass along the lock mode to xfs_iomap_direct_write().
Further, given the above it also looked like we'd have to check and
cycle the ilock EXCL if it were ILOCK_SHARED. Finally,
xfs_iomap_direct_write() has a call to xfs_qm_dqattach() which itself
acquires ILOCK_EXCL. Looking at xfs_iomap_write_delay(), we do have a
dqattach_locked() variant but it also expects to have ILOCK_EXCL.

Hmm, so in the common case both the extent list and a quota are handled
once and thus the only notable lock cycle is the align_last_fsb() case.
I think we could do something like this:

- Create a shared lock safe variant of xfs_iomap_eof_align_last_fsb() to
  be called from xfs_iomap_write_direct().
- __xfs_get_blocks() continues to call xfs_ilock_data_map_shared(), but
  unconditionally demotes XFS_ILOCK_EXCL to XFS_ILOCK_SHARED before
  calling xfs_iomap_write_direct().
- xfs_iomap_write_direct() moves the xfs_qm_dqattach() call to
  immediately before the transaction allocation. E.g., it executes the
  existing align_last_fsb() bits and whatnot under XFS_ILOCK_SHARED, drops
  the lock, potentially attaches the quota and carries on as normal with
  the transaction.

The only thing I'm not sure about is the shared lock safe version of
xfs_iomap_eof_align_last_fsb(). The xfs_iread_extents() call is a few
calls deep and xfs_bmap_last_extent() is called from other contexts. I
suppose we could call it as is and pull up an assert to check for
XFS_IFEXTENTS such that the situation is explicitly documented in the
appropriate context (we do already have the assert in
xfs_iread_extents() if it were called). Also, I take it we can safely
assume the in-core extent list is still around if we still hold the lock
from the xfs_bmapi_read() call. Thoughts? I guess I'll float another
patch...

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
