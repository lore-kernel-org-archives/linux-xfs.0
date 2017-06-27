Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:33004 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752924AbdF0M4Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2017 08:56:25 -0400
Date: Tue, 27 Jun 2017 22:56:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 5/5] xfs: Switch to iomap for SEEK_HOLE / SEEK_DATA
Message-ID: <20170627125615.GQ17542@dastard>
References: <1498487118-6564-1-git-send-email-agruenba@redhat.com>
 <1498487118-6564-6-git-send-email-agruenba@redhat.com>
 <20170627003435.GI4733@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170627003435.GI4733@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Mon, Jun 26, 2017 at 05:34:35PM -0700, Darrick J. Wong wrote:
> [adding Christoph to cc]
> 
> On Mon, Jun 26, 2017 at 04:25:18PM +0200, Andreas Gruenbacher wrote:
> > Switch to the iomap_seek_hole_data vfs helper for implementing lseek
> > SEEK_HOLE / SEEK_DATA.  __xfs_seek_hole_data can go away once it's no
> > longer used by the quota code.
> > 
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > ---
> >  fs/xfs/xfs_file.c | 21 +++++----------------
> >  1 file changed, 5 insertions(+), 16 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 962dafd..94fe89a 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1131,29 +1131,18 @@ xfs_seek_hole_data(
> >  	struct xfs_inode	*ip = XFS_I(inode);
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	uint			lock;
> > -	loff_t			offset, end;
> > -	int			error = 0;
> > +	loff_t			offset;
> >  
> >  	if (XFS_FORCED_SHUTDOWN(mp))
> >  		return -EIO;
> >  
> >  	lock = xfs_ilock_data_map_shared(ip);
> > -
> > -	end = i_size_read(inode);
> > -	offset = __xfs_seek_hole_data(inode, start, end, whence);
> > -	if (offset < 0) {
> > -		error = offset;
> > -		goto out_unlock;
> > -	}
> > -
> > -	offset = vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
> > -
> > -out_unlock:
> > +	offset = iomap_seek_hole_data(inode, start, whence, &xfs_iomap_ops);
> 
> Hm.  We grab the data map ilock above, then we call
> iomap_seek_hole_data, which (eventually) calls xfs_file_iomap_begin,
> which tries to grab the data map ilock.  We shouldn't be grabbing the
> ilock twice, obviously, but on the other hand...
> 
> ...under the old code, we'd take the ilock and do the whole block map
> and page cache scans without ever dropping the ilock.

Which I'm pretty sure I've previously pointed out is broken and
needed fixing (lockdep reports, IIRC), as the lock order is iolock
-> page lock -> ilock.

(yes, I'm using "iolock" as shorthand for inode->i_rwsem)

> This new iomap
> based thing only holds the ilock during ->iomap_begin, which makes me
> worry that someone else can wander in and mess with things while we're
> looking for holes/data?

Locking won't prevent seek races with concurrent modifications from
the perspective of userspace.

i.e. we can lock the inode down, seek to data, unlock it, and before
we get back to userspace something else punches out that data. So by
the time the app gets to use the position set by the seek, there's a
hole where it's being told there *was* data....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
