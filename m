Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A6C327F3F
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 13:06:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 997C0304051
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 11:06:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EIoq19zH6UCLfBiD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Aug 2015 11:06:49 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 495FFA2C32
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 18:06:49 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-103.bos.redhat.com [10.18.41.103])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7SI6mN4007984
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 14:06:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/9] libxfs: track largest metadata LSN in use via verifiers
Date: Fri, 28 Aug 2015 14:06:40 -0400
Message-Id: <1440785207-17543-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1440785207-17543-1-git-send-email-bfoster@redhat.com>
References: <1440785207-17543-1-git-send-email-bfoster@redhat.com>
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

The LSN validation helper is called in the I/O verifier codepath for
metadata that embed a last-modification LSN. While the codepath exists,
this is not used in userspace as in the kernel because the former
doesn't have an active log.

xfs_repair does need to check the validity of the LSN metadata with
respect to the on-disk log, however. Use the LSN validation mechanism to
track the largest LSN that has been seen. Export the value so repair can
use it once it has processed the entire filesystem. Note that the helper
continues to always return true to preserve existing behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 include/libxfs.h |  1 +
 libxfs/util.c    | 28 +++++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index b1604e2..cc06fc6 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -134,6 +134,7 @@ typedef struct {
 #define LIBXFS_DIRECT		0x0020	/* can use direct I/O, not buffered */
 
 extern char	*progname;
+extern xfs_lsn_t libxfs_max_lsn;
 extern int	libxfs_init (libxfs_init_t *);
 extern void	libxfs_destroy (void);
 extern int	libxfs_device_to_fd (dev_t);
diff --git a/libxfs/util.c b/libxfs/util.c
index 96ce31f..0116e3d 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -733,13 +733,39 @@ xfs_verifier_error(
 /*
  * This is called from I/O verifiers on v5 superblock filesystems. In the
  * kernel, it validates the metadata LSN parameter against the current LSN of
- * the active log. We don't have an active log in userspace, so just return
+ * the active log. We don't have an active log in userspace so always return
  * true.
+ *
+ * xfs_repair piggybacks off this mechanism to help track the largest metadata
+ * LSN in use on a filesystem. Keep a record of the largest LSN seen such that
+ * repair can validate it against the state of the log.
  */
+xfs_lsn_t	libxfs_max_lsn = 0;
+pthread_mutex_t	libxfs_max_lsn_lock = PTHREAD_MUTEX_INITIALIZER;
+
 bool
 xfs_valid_lsn(
 	struct xfs_mount	*mp,
 	xfs_lsn_t		lsn)
 {
+	int			cycle = CYCLE_LSN(lsn);
+	int			block = BLOCK_LSN(lsn);
+	int			max_cycle;
+	int			max_block;
+
+	if (lsn == NULLCOMMITLSN)
+		return true;
+
+	pthread_mutex_lock(&libxfs_max_lsn_lock);
+
+	max_cycle = CYCLE_LSN(libxfs_max_lsn);
+	max_block = BLOCK_LSN(libxfs_max_lsn);
+
+	if ((cycle > max_cycle) ||
+	    (cycle == max_cycle && block > max_block))
+		libxfs_max_lsn = lsn;
+
+	pthread_mutex_unlock(&libxfs_max_lsn_lock);
+
 	return true;
 }
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
