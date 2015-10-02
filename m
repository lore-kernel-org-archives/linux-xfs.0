Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1529F7F58
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 13:19:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0DAAB304039
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:19:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ANOUWB0xqV4lVga4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Oct 2015 11:19:57 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id DD2968C1B8
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 18:19:56 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-128.bos.redhat.com [10.18.41.128])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t92IJu8M023976
	for <xfs@oss.sgi.com>; Fri, 2 Oct 2015 14:19:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 02/18] libxfs: track largest metadata LSN in use via
	verifiers
Date: Fri,  2 Oct 2015 14:19:39 -0400
Message-Id: <1443809995-20395-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1443809995-20395-1-git-send-email-bfoster@redhat.com>
References: <1443809995-20395-1-git-send-email-bfoster@redhat.com>
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
 libxfs/util.c    | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

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
index fcf6e96..6192e6c 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -730,10 +730,43 @@ xfs_verifier_error(
 		  bp->b_bn, BBTOB(bp->b_length));
 }
 
+/*
+ * This is called from I/O verifiers on v5 superblock filesystems. In the
+ * kernel, it validates the metadata LSN parameter against the current LSN of
+ * the active log. We don't have an active log in userspace so this kind of
+ * validation is not required. Therefore, this function always returns true in
+ * userspace.
+ *
+ * xfs_repair piggybacks off this mechanism to help track the largest metadata
+ * LSN in use on a filesystem. Keep a record of the largest LSN seen such that
+ * repair can validate it against the state of the log.
+ */
+xfs_lsn_t	libxfs_max_lsn = 0;
+pthread_mutex_t	libxfs_max_lsn_lock = PTHREAD_MUTEX_INITIALIZER;
+
 bool
 xfs_log_check_lsn(
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
