Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46580 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfGCPLg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jul 2019 11:11:36 -0400
Date: Wed, 3 Jul 2019 08:09:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 9/9] xfs: allow bulkstat_single of special inodes
Message-ID: <20190703150902.GV1404256@magnolia>
References: <156158193320.495715.6675123051075804739.stgit@magnolia>
 <156158199168.495715.1433536766420003523.stgit@magnolia>
 <20190703132525.GI26057@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703132525.GI26057@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, allison.henderson@oracle.com

On Wed, Jul 03, 2019 at 09:25:25AM -0400, Brian Foster wrote:
> On Wed, Jun 26, 2019 at 01:46:31PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a new ireq flag (for single bulkstats) that enables userspace to
> > ask us for a special inode number instead of interpreting @ino as a
> > literal inode number.  This enables us to query the root inode easily.
> > 
> 
> Seems reasonable, though what's the use case for this? A brief
> description in the commit log would be helpful.

I will add:

"The reason for adding the ability to query specifically the root
directory inode is that certain programs (xfsdump and xfsrestore) want
to confirm when they've been pointed to the root directory.  The
userspace code assumes the root directory is always the first result
from calling bulkstat with lastino == 0, but this isn't true if the
(initial btree roots + initial AGFL + inode alignment padding) is itself
long enough to be allocated to new inodes if all of those blocks should
happen to be free at the same time.  Rather than make userspace guess
at internal filesystem state, we provide a direct query."

> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_fs.h |   11 ++++++++++-
> >  fs/xfs/xfs_ioctl.c     |   10 ++++++++++
> >  2 files changed, 20 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 77c06850ac52..1489bce07d66 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -482,7 +482,16 @@ struct xfs_ireq {
> >  	uint64_t	reserved[2];	/* must be zero			*/
> >  };
> >  
> > -#define XFS_IREQ_FLAGS_ALL	(0)
> > +/*
> > + * The @ino value is a special value, not a literal inode number.  See the
> > + * XFS_IREQ_SPECIAL_* values below.
> > + */
> > +#define XFS_IREQ_SPECIAL	(1 << 0)
> > +
> > +#define XFS_IREQ_FLAGS_ALL	(XFS_IREQ_SPECIAL)
> > +
> > +/* Operate on the root directory inode. */
> > +#define XFS_IREQ_SPECIAL_ROOT	(1)
> >  
> >  /*
> >   * ioctl structures for v5 bulkstat and inumbers requests
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index f71341cd8340..3bb5f980fabf 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -961,6 +961,16 @@ xfs_ireq_setup(
> >  	    memchr_inv(hdr->reserved, 0, sizeof(hdr->reserved)))
> >  		return -EINVAL;
> >  
> > +	if (hdr->flags & XFS_IREQ_SPECIAL) {
> > +		switch (hdr->ino) {
> > +		case XFS_IREQ_SPECIAL_ROOT:
> > +			hdr->ino = mp->m_sb.sb_rootino;
> > +			break;
> 
> Do you envision other ->ino magic values? I'm curious about the need for
> the special flag along with a magic inode value as opposed to just a
> "root dir" flag or some such.

I was thinking about a "return bulkstat of the fd" flag too, though I
haven't really come up with a use case for it yet.  Further on, if we
ever see Dave's subvolumes patchset again, we might want to be able to
query the ino/gen of the subvolumes root dir so that we can open a file
handle to it.

Basically the flag enables us to have 2^64 magic values instead of ~30.
We're probably never going to use that many but might as well reserve
the space for future flexibility.

--D

> Brian
> 
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> >  	if (XFS_INO_TO_AGNO(mp, hdr->ino) >= mp->m_sb.sb_agcount)
> >  		return -EINVAL;
> >  
> > 
