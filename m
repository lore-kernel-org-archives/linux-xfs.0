Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4F3CC7F4E
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 09:11:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0C8D2304051
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 07:11:49 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 41hO0uXxR3pyiDOt (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 07:11:48 -0700 (PDT)
Date: Mon, 21 Apr 2014 07:11:48 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 02/10] xfs: consolidate xfs_bulkstat_single
Message-ID: <20140421141148.GA27064@infradead.org>
References: <535078AD.5050209@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <535078AD.5050209@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Apr 18, 2014 at 08:58:21AM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> In xfs_bulkstat_single(), call xfs_bulkstat_one() and xfs_bulkstat()
> would return different error if either failed, we'd better return the
> proper error in this case.  Moreover, the function argument done is
> useless in terms of xfs_ioc_bulkstat(), hence we can get rid of it.

I've looked at xfs_bulkstat_single I really can't see how falling back
to the full xfs_bulkstat could fix any error.  We probably should just
get rid of the fallback and instead do something like the (lightly tested)
patch below:

---
From: Christoph Hellwig <hch@lst.de>
Subject: xfs: remove xfs_bulkstat_single

xfs_bukstat_one doesn't have any failure case that would go away when
called through xfs_bulkstat, so remove the fallback and the now unessecary
xfs_bulkstat_single function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c  |    4 ++--
 fs/xfs/xfs_itable.c |   48 ------------------------------------------------
 fs/xfs/xfs_itable.h |    7 -------
 3 files changed, 2 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index bcfe612..c6e32d1 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -824,8 +824,8 @@ xfs_ioc_bulkstat(
 		error = xfs_inumbers(mp, &inlast, &count,
 					bulkreq.ubuffer, xfs_inumbers_fmt);
 	else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE)
-		error = xfs_bulkstat_single(mp, &inlast,
-						bulkreq.ubuffer, &done);
+		error = xfs_bulkstat_one(mp, inlast, bulkreq.ubuffer,
+					sizeof(xfs_bstat_t), NULL, &done);
 	else	/* XFS_IOC_FSBULKSTAT */
 		error = xfs_bulkstat(mp, &inlast, &count, xfs_bulkstat_one,
 				     sizeof(xfs_bstat_t), bulkreq.ubuffer,
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index f463382..58fcae0 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -511,54 +511,6 @@ xfs_bulkstat(
 	return rval;
 }
 
-/*
- * Return stat information in bulk (by-inode) for the filesystem.
- * Special case for non-sequential one inode bulkstat.
- */
-int					/* error status */
-xfs_bulkstat_single(
-	xfs_mount_t		*mp,	/* mount point for filesystem */
-	xfs_ino_t		*lastinop, /* inode to return */
-	char			__user *buffer, /* buffer with inode stats */
-	int			*done)	/* 1 if there are more stats to get */
-{
-	int			count;	/* count value for bulkstat call */
-	int			error;	/* return value */
-	xfs_ino_t		ino;	/* filesystem inode number */
-	int			res;	/* result from bs1 */
-
-	/*
-	 * note that requesting valid inode numbers which are not allocated
-	 * to inodes will most likely cause xfs_imap_to_bp to generate warning
-	 * messages about bad magic numbers. This is ok. The fact that
-	 * the inode isn't actually an inode is handled by the
-	 * error check below. Done this way to make the usual case faster
-	 * at the expense of the error case.
-	 */
-
-	ino = *lastinop;
-	error = xfs_bulkstat_one(mp, ino, buffer, sizeof(xfs_bstat_t),
-				 NULL, &res);
-	if (error) {
-		/*
-		 * Special case way failed, do it the "long" way
-		 * to see if that works.
-		 */
-		(*lastinop)--;
-		count = 1;
-		if (xfs_bulkstat(mp, lastinop, &count, xfs_bulkstat_one,
-				sizeof(xfs_bstat_t), buffer, done))
-			return error;
-		if (count == 0 || (xfs_ino_t)*lastinop != ino)
-			return error == EFSCORRUPTED ?
-				XFS_ERROR(EINVAL) : error;
-		else
-			return 0;
-	}
-	*done = 0;
-	return 0;
-}
-
 int
 xfs_inumbers_fmt(
 	void			__user *ubuffer, /* buffer to write to */
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 97295d9..6ea8b39 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -50,13 +50,6 @@ xfs_bulkstat(
 	char		__user *ubuffer,/* buffer with inode stats */
 	int		*done);		/* 1 if there are more stats to get */
 
-int
-xfs_bulkstat_single(
-	xfs_mount_t		*mp,
-	xfs_ino_t		*lastinop,
-	char			__user *buffer,
-	int			*done);
-
 typedef int (*bulkstat_one_fmt_pf)(  /* used size in bytes or negative error */
 	void			__user *ubuffer, /* buffer to write to */
 	int			ubsize,		 /* remaining user buffer sz */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
