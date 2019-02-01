Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48212 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbfBATOg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Feb 2019 14:14:36 -0500
Date: Fri, 1 Feb 2019 11:14:24 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 7/8] xfs: add tracepoints for high level iunlink
 operations
Message-ID: <20190201191423.GK5761@magnolia>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897671399.26065.15247361285974787568.stgit@magnolia>
 <20190201190145.GF31203@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190201190145.GF31203@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 01, 2019 at 02:01:46PM -0500, Brian Foster wrote:
> On Thu, Jan 31, 2019 at 03:18:34PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add tracepoints so we can associate high level operations with low level
> > updates.  No functional changes.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_inode.c |    4 ++++
> >  fs/xfs/xfs_trace.h |    3 +++
> >  2 files changed, 7 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index d5b3f8fdac7e..56349497d75b 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -2030,6 +2030,8 @@ xfs_iunlink(
> >  	ASSERT(VFS_I(ip)->i_mode != 0);
> >  	ASSERT(xfs_verify_ino(mp, ip->i_ino));
> >  
> > +	trace_xfs_iunlink(ip);
> > +
> 
> It's worth noting that current inode events print a global inode number
> (i.e., "ino 0x%llx ...") whereas the new iunlink tracepoints from
> previous patches print an agno/agino combination. I haven't looked at
> the actual trace output from an unlink with these changes yet, but I do
> wonder if there's value in having a more consistent format. Hm?

Hmm, I suppose it wouldn't be difficult to add a DEFINE_AG_INODE_EVENT
macrosoup that would make the reporting more consistent for these per-AG
inode operations.

--D

> Brian
> 
> >  	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> >  	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> >  	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
> > @@ -2199,6 +2201,8 @@ xfs_iunlink_remove(
> >  	short			bucket_index;
> >  	int			error;
> >  
> > +	trace_xfs_iunlink_remove(ip);
> > +
> >  	if (!xfs_verify_ino(mp, ip->i_ino))
> >  		return -EFSCORRUPTED;
> >  
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index fbec8f0e1a9a..22d4729143b5 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -3423,6 +3423,9 @@ TRACE_EVENT(xfs_iunlink_update_dinode,
> >  		  __entry->new_ptr)
> >  );
> >  
> > +DEFINE_INODE_EVENT(xfs_iunlink);
> > +DEFINE_INODE_EVENT(xfs_iunlink_remove);
> > +
> >  #endif /* _TRACE_XFS_H */
> >  
> >  #undef TRACE_INCLUDE_PATH
> > 
