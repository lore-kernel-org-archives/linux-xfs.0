Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E41617F5F
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 03:00:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8CEA8AC003
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 01:00:02 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id HhyljJ5G04G5v1Gi (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Apr 2014 01:00:00 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WYsr1-0006Ga-M2
	for xfs@oss.sgi.com; Sat, 12 Apr 2014 07:59:59 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/9] xfs: remove xfs_filestream_associate
Date: Sat, 12 Apr 2014 10:02:02 +0200
Message-Id: <1397289723-26243-9-git-send-email-hch@lst.de>
In-Reply-To: <1397289723-26243-1-git-send-email-hch@lst.de>
References: <1397289723-26243-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

There is no good reason to create a filestream when a directory entry
is created.  Delay it until the first allocation happens to simply
the code and reduce the amount of mru cache lookups we do.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_filestream.c |   57 +++++++++++++----------------------------------
 fs/xfs/xfs_filestream.h |    1 -
 fs/xfs/xfs_inode.c      |   15 -------------
 3 files changed, 15 insertions(+), 58 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 7b94036..c8a8840 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -318,17 +318,18 @@ out:
 }
 
 /*
- * Return the AG of the filestream the file or directory belongs to, or
- * NULLAGNUMBER otherwise.
+ * Find the right allocation group for a file, either by finding an
+ * existing file stream or creating a new one.
+ *
+ * Returns NULLAGNUMBER in case of an error.
  */
 xfs_agnumber_t
 xfs_filestream_lookup_ag(
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_fstrm_item	*item;
 	struct xfs_inode	*pip = NULL;
-	xfs_agnumber_t		ag = NULLAGNUMBER;
+	xfs_agnumber_t		startag, ag = NULLAGNUMBER;
 	int			ref = 0;
 	struct xfs_mru_cache_elem *mru;
 
@@ -339,45 +340,13 @@ xfs_filestream_lookup_ag(
 		goto out;
 
 	mru = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
-	if (!mru)
-		goto out;
-
-	item = container_of(mru, struct xfs_fstrm_item, mru);
-
-	ag = item->ag;
-	xfs_mru_cache_done(mp->m_filestream);
-
-	ref = xfs_filestream_peek_ag(ip->i_mount, ag);
-out:
-	TRACE_LOOKUP(mp, ip, pip, ag, ref);
-	IRELE(pip);
-	return ag;
-}
-
-/*
- * Make sure a directory has a filestream associated with it.
- *
- * This is called when creating regular files in an directory that has
- * filestreams enabled, so that a stream is ready by the time we need it
- * in the allocator for the files inside the directory.
- */
-int
-xfs_filestream_associate(
-	struct xfs_inode	*pip)
-{
-	struct xfs_mount	*mp = pip->i_mount;
-	struct xfs_mru_cache_elem *mru;
-	xfs_agnumber_t		startag, ag;
-
-	ASSERT(S_ISDIR(pip->i_d.di_mode));
-
-	/*
-	 * If the directory already has a file stream associated we're done.
-	 */
-	mru = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
 	if (mru) {
+		ag = container_of(mru, struct xfs_fstrm_item, mru)->ag;
 		xfs_mru_cache_done(mp->m_filestream);
-		return 0;
+
+		ref = xfs_filestream_peek_ag(ip->i_mount, ag);
+		TRACE_LOOKUP(mp, ip, pip, ag, ref);
+		goto out;
 	}
 
 	/*
@@ -392,7 +361,11 @@ xfs_filestream_associate(
 	} else
 		startag = XFS_INO_TO_AGNO(mp, pip->i_ino);
 
-	return xfs_filestream_pick_ag(pip, startag, &ag, 0, 0);
+	if (xfs_filestream_pick_ag(pip, startag, &ag, 0, 0))
+		ag = NULLAGNUMBER;
+out:
+	IRELE(pip);
+	return ag;
 }
 
 /*
diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
index 578d49e..2de853e 100644
--- a/fs/xfs/xfs_filestream.h
+++ b/fs/xfs/xfs_filestream.h
@@ -26,7 +26,6 @@ int xfs_filestream_mount(struct xfs_mount *mp);
 void xfs_filestream_unmount(struct xfs_mount *mp);
 void xfs_filestream_deassociate(struct xfs_inode *ip);
 xfs_agnumber_t xfs_filestream_lookup_ag(struct xfs_inode *ip);
-int xfs_filestream_associate(struct xfs_inode *dip);
 int xfs_filestream_new_ag(struct xfs_bmalloca *ap, xfs_agnumber_t *agp);
 
 static inline int
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b9b531f..cec18e9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -655,7 +655,6 @@ xfs_ialloc(
 	uint		flags;
 	int		error;
 	timespec_t	tv;
-	int		filestreams = 0;
 
 	/*
 	 * Call the space management code to pick
@@ -772,13 +771,6 @@ xfs_ialloc(
 		flags |= XFS_ILOG_DEV;
 		break;
 	case S_IFREG:
-		/*
-		 * we can't set up filestreams until after the VFS inode
-		 * is set up properly.
-		 */
-		if (pip && xfs_inode_is_filestream(pip))
-			filestreams = 1;
-		/* fall through */
 	case S_IFDIR:
 		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
 			uint	di_flags = 0;
@@ -844,13 +836,6 @@ xfs_ialloc(
 	/* now that we have an i_mode we can setup inode ops and unlock */
 	xfs_setup_inode(ip);
 
-	/* now we have set up the vfs inode we can associate the filestream */
-	if (filestreams) {
-		error = xfs_filestream_associate(pip);
-		if (error)
-			return error;
-	}
-
 	*ipp = ip;
 	return 0;
 }
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
