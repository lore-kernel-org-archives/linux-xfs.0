Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8OCUgG6180903 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 07:30:42 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B09D71BAB3E5
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 05:31:36 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	12sGJd5vjUhxQOxe for <xfs@oss.sgi.com>;
	Fri, 24 Sep 2010 05:31:36 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	40083799-1927428
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 22:01:35 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Oz7R8-0007V0-Ap
	for xfs@oss.sgi.com; Fri, 24 Sep 2010 22:31:34 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1Oz7Qu-000609-4I
	for xfs@oss.sgi.com; Fri, 24 Sep 2010 22:31:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/18] xfs: introduced uncached buffer read primitve
Date: Fri, 24 Sep 2010 22:31:05 +1000
Message-Id: <1285331476-23015-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1285331476-23015-1-git-send-email-david@fromorbit.com>
References: <1285331476-23015-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   34 ++++++++++++++++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_buf.h |    3 +++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index eca945b..22c7bff 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -638,6 +638,40 @@ xfs_buf_readahead(
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
+	size_t			length,
+	int			flags)
+{
+	xfs_buf_t		*bp;
+	int			error;
+
+	bp = xfs_buf_get_uncached(target, length, flags);
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
index fb30447..57eedc7 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -218,6 +218,9 @@ extern int xfs_buf_associate_memory(xfs_buf_t *, void *, size_t);
 extern void xfs_buf_hold(xfs_buf_t *);
 extern void xfs_buf_readahead(xfs_buftarg_t *, xfs_off_t, size_t,
 				xfs_buf_flags_t);
+struct xfs_buf *xfs_buf_read_uncached(struct xfs_mount *mp,
+				struct xfs_buftarg *target,
+				xfs_daddr_t daddr, size_t length, int flags);
 
 /* Releasing Buffers */
 extern void xfs_buf_free(xfs_buf_t *);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
