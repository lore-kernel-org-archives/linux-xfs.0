Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 044577F3F
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 22:40:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E622F8F8035
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 20:40:11 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	QBKy0hr4ERjoyA3w for <xfs@oss.sgi.com>;
	Tue, 23 Jul 2013 20:40:10 -0700 (PDT)
Date: Wed, 24 Jul 2013 13:40:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 6/7] xfs: check that eofblocks ioctl caller can write
	matched inodes
Message-ID: <20130724034007.GN19986@dastard>
References: <20130717114746.4e133042@oracle.com>
	<20130719060221.GX11674@dastard>
	<20130719121321.5d78beeb@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130719121321.5d78beeb@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Fri, Jul 19, 2013 at 12:13:21PM -0400, Dwight Engen wrote:
> On Fri, 19 Jul 2013 16:02:21 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Wed, Jul 17, 2013 at 11:47:46AM -0400, Dwight Engen wrote:
> > > Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> > 
> > What's the reason for this patch?
> 
> Its trying to ensure we only allow the XFS_IOC_FREE_EOFBLOCKS
> caller to affect the indoes they should be able to.
> http://oss.sgi.com/archives/xfs/2013-06/msg00955.html has a bit more
> background. This isn't really related to user namespaces per-se, so I
> guess it should be a separate patch, but since I modified the
> eofblocks structure I was trying to fix this as well.

background needs to be in the commit message.

> 
> > > ---
> > >  fs/xfs/xfs_fs.h     | 1 +
> > >  fs/xfs/xfs_icache.c | 4 ++++
> > >  fs/xfs/xfs_ioctl.c  | 2 ++
> > >  3 files changed, 7 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> > > index 7eb4a5e..aee4b12 100644
> > > --- a/fs/xfs/xfs_fs.h
> > > +++ b/fs/xfs/xfs_fs.h
> > > @@ -361,6 +361,7 @@ struct xfs_fs_eofblocks {
> > >  #define XFS_EOF_FLAGS_GID		(1 << 2) /* filter by gid
> > > */ #define XFS_EOF_FLAGS_PRID		(1 << 3) /* filter by
> > > project id */ #define XFS_EOF_FLAGS_MINFILESIZE	(1 << 4) /*
> > > filter by min file size */ +#define XFS_EOF_FLAGS_PERM_CHECK
> > > (1 << 5) /* check can write inode */ #define
> > > XFS_EOF_FLAGS_VALID	\ (XFS_EOF_FLAGS_SYNC |	\
> > >  	 XFS_EOF_FLAGS_UID |	\
> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index d873ab9e..728283a 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > > @@ -1247,6 +1247,10 @@ xfs_inode_free_eofblocks(
> > >  		if (!xfs_inode_match_id(ip, eofb))
> > >  			return 0;
> > >  
> > > +		if (eofb->eof_flags & XFS_EOF_FLAGS_PERM_CHECK &&
> > > +		    inode_permission(VFS_I(ip), MAY_WRITE))
> > > +			return 0;
> > 
> > This assumes we are walking fully instantiated VFS inodes. That's
> > not necessarily true - we may be walking inodes that have already
> > been dropped from the VFS and are waiting for background reclaim to
> > clean them up. I suspect that this doesn't need to be done - we
> > normally stop background modification processes like this when we
> > convert the filesystem to read-only. I suspect the eof-blocks scan
> > code is missing that, and so it can potentially run on a RO
> > filesystem. That needs fixing similar to the way we stop and start
> > the periodic log work...
> 
> So if there isn't a good way to check per-inode, maybe for now we
> should just restrict the ioctl caller to be capable(CAP_SYS_ADMIN)?

What, exactly, are you trying to check here?

> > Also, gcc should throw warnings on that code (strange, it didn't
> > here on gcc-4.7) as it needs more parenthesis. i.e
> 
> I don't think it needs them (& is higher precedence than &&), but I can
> add them for clarity if you like.

I know what the precedence is, but code that looks like:

	(a & b && c & d && b & d && ..) 

needs time to verify that it is correct. Indeed, when I see the
above, I think "was it supposed to be":

	(a && b && c && d && b & d && ..) 

Parenthesis remove any ambiguity in intention here - they clearly
separate intended logic from typos. Same goes for | vs ||....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
