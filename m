Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6B3457F62
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 11:13:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 48D958F8054
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 09:13:17 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id k0B1tJD61lSzOFzd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jul 2013 09:13:15 -0700 (PDT)
Date: Fri, 19 Jul 2013 12:13:21 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: [PATCH v4 6/7] xfs: check that eofblocks ioctl caller can write
	matched inodes
Message-ID: <20130719121321.5d78beeb@oracle.com>
In-Reply-To: <20130719060221.GX11674@dastard>
References: <20130717114746.4e133042@oracle.com>
	<20130719060221.GX11674@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, 19 Jul 2013 16:02:21 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Jul 17, 2013 at 11:47:46AM -0400, Dwight Engen wrote:
> > Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> 
> What's the reason for this patch?

Its trying to ensure we only allow the XFS_IOC_FREE_EOFBLOCKS
caller to affect the indoes they should be able to.
http://oss.sgi.com/archives/xfs/2013-06/msg00955.html has a bit more
background. This isn't really related to user namespaces per-se, so I
guess it should be a separate patch, but since I modified the
eofblocks structure I was trying to fix this as well.

> > ---
> >  fs/xfs/xfs_fs.h     | 1 +
> >  fs/xfs/xfs_icache.c | 4 ++++
> >  fs/xfs/xfs_ioctl.c  | 2 ++
> >  3 files changed, 7 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> > index 7eb4a5e..aee4b12 100644
> > --- a/fs/xfs/xfs_fs.h
> > +++ b/fs/xfs/xfs_fs.h
> > @@ -361,6 +361,7 @@ struct xfs_fs_eofblocks {
> >  #define XFS_EOF_FLAGS_GID		(1 << 2) /* filter by gid
> > */ #define XFS_EOF_FLAGS_PRID		(1 << 3) /* filter by
> > project id */ #define XFS_EOF_FLAGS_MINFILESIZE	(1 << 4) /*
> > filter by min file size */ +#define XFS_EOF_FLAGS_PERM_CHECK
> > (1 << 5) /* check can write inode */ #define
> > XFS_EOF_FLAGS_VALID	\ (XFS_EOF_FLAGS_SYNC |	\
> >  	 XFS_EOF_FLAGS_UID |	\
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index d873ab9e..728283a 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -1247,6 +1247,10 @@ xfs_inode_free_eofblocks(
> >  		if (!xfs_inode_match_id(ip, eofb))
> >  			return 0;
> >  
> > +		if (eofb->eof_flags & XFS_EOF_FLAGS_PERM_CHECK &&
> > +		    inode_permission(VFS_I(ip), MAY_WRITE))
> > +			return 0;
> 
> This assumes we are walking fully instantiated VFS inodes. That's
> not necessarily true - we may be walking inodes that have already
> been dropped from the VFS and are waiting for background reclaim to
> clean them up. I suspect that this doesn't need to be done - we
> normally stop background modification processes like this when we
> convert the filesystem to read-only. I suspect the eof-blocks scan
> code is missing that, and so it can potentially run on a RO
> filesystem. That needs fixing similar to the way we stop and start
> the periodic log work...

So if there isn't a good way to check per-inode, maybe for now we
should just restrict the ioctl caller to be capable(CAP_SYS_ADMIN)?

> Also, gcc should throw warnings on that code (strange, it didn't
> here on gcc-4.7) as it needs more parenthesis. i.e

I don't think it needs them (& is higher precedence than &&), but I can
add them for clarity if you like.

> 		if ((eofb->eof_flags & XFS_EOF_FLAGS_PERM_CHECK) &&
> 
> >  		/* skip the inode if the file size is too small */
> >  		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
> >  		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
> 
> Oh, I see you are just copying other code. How did I miss that in a
> past review? :( 
> 
> Hmmm - it looks like there's a bunch of them in xfs_inode_match_id()
> as well, and you touched all those if() statements in a previous
> patch. can you go back to the patch that touches
> xfs_inode_match_id() and add the extra () there as well?
 
Yep, I'll update those too.
 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index abbbdcf..e63e359 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1636,6 +1636,8 @@ xfs_file_ioctl(
> >  		    !gid_valid(keofb.eof_gid))
> >  			return XFS_ERROR(EINVAL);
> >  
> > +		keofb.eof_flags |= XFS_EOF_FLAGS_PERM_CHECK;
> 
> We should be checking for the fs being RO here and aborting if it
> is.

inode_permission() would catch that but I agree there is no point
waiting till then to find out.

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
