Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2OMotlG183986 for <xfs@oss.sgi.com>; Thu, 24 Mar 2011 17:50:55 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1905C3799D7
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2011 15:54:00 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	AOWBJEHWEnfrudho for <xfs@oss.sgi.com>;
	Thu, 24 Mar 2011 15:54:00 -0700 (PDT)
Date: Fri, 25 Mar 2011 09:53:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH V2] xfs: preallocation transactions do not need to be
	synchronous
Message-ID: <20110324225357.GI26611@dastard>
References: <1300860870-15471-1-git-send-email-david@fromorbit.com>
	<1300860870-15471-2-git-send-email-david@fromorbit.com>
	<9EBB77E762A6744BACE68EDD6A4796990712DB92@MX31A.corp.emc.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9EBB77E762A6744BACE68EDD6A4796990712DB92@MX31A.corp.emc.com>
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
To: brian.foster@emc.com
Cc: aelder@sgi.com, xfs@oss.sgi.com

On Thu, Mar 24, 2011 at 01:18:06PM -0400, brian.foster@emc.com wrote:
> > -----Original Message-----
> > From: xfs-bounces@oss.sgi.com [mailto:xfs-bounces@oss.sgi.com] On
> > Behalf Of Dave Chinner
> > Sent: Wednesday, March 23, 2011 2:14 AM
> > To: xfs@oss.sgi.com
> > Cc: aelder@sgi.com
> > Subject: [PATCH 1/6] xfs: preallocation transactions do not need to be
> > synchronous
> 
> > diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c index
> > ae59865..baa2cb3 100644
> > --- a/fs/xfs/linux-2.6/xfs_file.c
> > +++ b/fs/xfs/linux-2.6/xfs_file.c
> > @@ -896,6 +896,7 @@ xfs_file_fallocate(
> >  	xfs_flock64_t	bf;
> >  	xfs_inode_t	*ip = XFS_I(inode);
> >  	int		cmd = XFS_IOC_RESVSP;
> > +	int		attr_flags = XFS_ATTR_NOLOCK;
> > 
> >  	if (mode & ~(FALLOC_FL_KEEP_SIZE |
> >  		     FALLOC_FL_PUNCH_HOLE |
> > @@ -922,6 +923,9 @@ xfs_file_fallocate(
> >  			goto out_unlock;
> >  	}
> > 
> > +	if (file->f_flags & O_DSYNC)
> > +		attr_flags |= XFS_ATTR_SYNC;
> > +
> >  	error = -xfs_change_file_space(ip, cmd, &bf, 0, XFS_ATTR_NOLOCK);
> >  	if (error)
> >  		goto out_unlock;
> 
> Where are you passing attr_flags?

Argh. Good catch. That's the problem with having two interfaces that
do the same thing - you're not sure which one is being tested by the
test suite in any given test. Fixed patch below.

> I was looking at this because I noticed a nice performance
> improvement in some Samba tests with the xfs_trans_set_sync() call
> removed, but I have a follow up question... I'd like to back port
> this patch to 2.6.34. The majority of this patch applies
> (manually), but the segment above is problematic in that I have an
> xfs_vn_fallocate() inode operations handler (xfs_iops.c) without
> the file pointer rather than the above file operations handler.

Yup, .fallocate got moved from an inode operation to a file
operation a while back in:

2fe17c1 fallocate should be a file operation

> Without really knowing any of this code, I assume I can IS_SYNC()
> the inode to check for the sync mount situation? Assuming that is
> correct, is there a straightforward way to cover the open(...,
> O_SYNC) situation? I suppose I'm open to hacking the VFS to one
> off this call if I have to, but would rather avoid the ugliness.
> Any comments are appreciated, thanks.

Porting the above commit first is probably the only way to get this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: preallocation transactions do not need to be synchronous

From: Dave Chinner <dchinner@redhat.com>

Preallocation and hole punch transactions are currently synchronous
and this is causing performance problems in some cases. The
transactions don't need to be synchronous as we don't need to
guarantee the preallocation is persistent on disk until a
fdatasync, fsync, sync operation occurs. If the file is opened
O_SYNC or O_DATASYNC, only then should the transaction be issued
synchronously.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_file.c  |    6 +++++-
 fs/xfs/linux-2.6/xfs_ioctl.c |    4 ++++
 fs/xfs/xfs_vnodeops.c        |    3 ++-
 fs/xfs/xfs_vnodeops.h        |    1 +
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index ae59865..0c255b1 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -896,6 +896,7 @@ xfs_file_fallocate(
 	xfs_flock64_t	bf;
 	xfs_inode_t	*ip = XFS_I(inode);
 	int		cmd = XFS_IOC_RESVSP;
+	int		attr_flags = XFS_ATTR_NOLOCK;
 
 	if (mode & ~(FALLOC_FL_KEEP_SIZE |
 		     FALLOC_FL_PUNCH_HOLE |
@@ -922,7 +923,10 @@ xfs_file_fallocate(
 			goto out_unlock;
 	}
 
-	error = -xfs_change_file_space(ip, cmd, &bf, 0, XFS_ATTR_NOLOCK);
+	if (file->f_flags & O_DSYNC)
+		attr_flags |= XFS_ATTR_SYNC;
+
+	error = -xfs_change_file_space(ip, cmd, &bf, 0, attr_flags);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index 0ca0e3c..acca2c5 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -624,6 +624,10 @@ xfs_ioc_space(
 
 	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
 		attr_flags |= XFS_ATTR_NONBLOCK;
+
+	if (filp->f_flags & O_DSYNC)
+		attr_flags |= XFS_ATTR_SYNC;
+
 	if (ioflags & IO_INVIS)
 		attr_flags |= XFS_ATTR_DMI;
 
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 37d8146..c48b421 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2831,7 +2831,8 @@ xfs_change_file_space(
 		ip->i_d.di_flags &= ~XFS_DIFLAG_PREALLOC;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	xfs_trans_set_sync(tp);
+	if (attr_flags & XFS_ATTR_SYNC)
+		xfs_trans_set_sync(tp);
 
 	error = xfs_trans_commit(tp, 0);
 
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index f6702927..3bcd233 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -18,6 +18,7 @@ int xfs_setattr(struct xfs_inode *ip, struct iattr *vap, int flags);
 #define	XFS_ATTR_NONBLOCK	0x02	/* return EAGAIN if operation would block */
 #define XFS_ATTR_NOLOCK		0x04	/* Don't grab any conflicting locks */
 #define XFS_ATTR_NOACL		0x08	/* Don't call xfs_acl_chmod */
+#define XFS_ATTR_SYNC		0x10	/* synchronous operation required */
 
 int xfs_readlink(struct xfs_inode *ip, char *link);
 int xfs_release(struct xfs_inode *ip);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
