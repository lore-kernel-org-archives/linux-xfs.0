Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EAuE2Z121187 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 05:56:14 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A3131E65317
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 03:57:02 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	XCGKeYzN2t62LuMD for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 03:57:02 -0700 (PDT)
Received: from dastard (unverified [121.44.127.68])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	39287352-1927428
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 20:27:01 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OvTBx-0004Om-GS
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:49 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OvTBl-0000QC-4D
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/18] xfs: introduced uncached buffer read primitve
Date: Tue, 14 Sep 2010 20:56:08 +1000
Message-Id: <1284461777-1496-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1284461777-1496-1-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

To avoid the need to use cached buffers for single-shot or buffers
cached at the filesystem level, introduce a new buffer read
primitive that bypasses the cache an reads directly from disk.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   33 +++++++++++++++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_buf.h |    3 +++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 03563d4..8555974 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -638,6 +638,39 @@ xfs_buf_readahead(
 	xfs_buf_read(target, ioff, isize, flags);
 }
 
+/*
+ * Read an uncached buffer from disk. Allocates and returns a locked
+ * buffer containing the disk contents or nothing.
+ */
+struct xfs_buf *
+xfs_buf_read_uncached(
+	struct xfs_mount	*mp,
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		daddr,
+	size_t			length)
+{
+	xfs_buf_t		*bp;
+	int			error;
+
+	bp = xfs_buf_get_uncached(length, target);
+	if (!bp)
+		return NULL;
+
+	/* set up the buffer for a read IO */
+	xfs_buf_lock(bp);
+	XFS_BUF_SET_ADDR(bp, daddr);
+	XFS_BUF_READ(bp);
+	XFS_BUF_BUSY(bp);
+
+	xfsbdstrat(mp, bp);
+	error = xfs_iowait(bp);
+	if (error || bp->b_error) {
+		xfs_buf_relse(bp);
+		return NULL;
+	}
+	return bp;
+}
+
 xfs_buf_t *
 xfs_buf_get_empty(
 	size_t			len,
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 73a3a8e..4d5937d 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -218,6 +218,9 @@ extern int xfs_buf_associate_memory(xfs_buf_t *, void *, size_t);
 extern void xfs_buf_hold(xfs_buf_t *);
 extern void xfs_buf_readahead(xfs_buftarg_t *, xfs_off_t, size_t,
 				xfs_buf_flags_t);
+struct xfs_buf *xfs_buf_read_uncached(struct xfs_mount *mp,
+				struct xfs_buftarg *target,
+				xfs_daddr_t daddr, size_t length);
 
 /* Releasing Buffers */
 extern void xfs_buf_free(xfs_buf_t *);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
