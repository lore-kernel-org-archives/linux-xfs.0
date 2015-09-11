Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C0AE17F50
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 13:55:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B030B8F8040
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:55:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id S2KvmQIym9Wv2NMY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:55:44 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 47593C0A1608
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 18:55:44 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-37.bos.redhat.com [10.18.41.37])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8BIthGR023097
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 14:55:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 02/12] libxfs: track largest metadata LSN in use via
	verifiers
Date: Fri, 11 Sep 2015 14:55:32 -0400
Message-Id: <1441997742-37160-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
References: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
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
 libxfs/util.c    | 31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

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
index 43338b8..236575a 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -730,9 +730,40 @@ xfs_verifier_error(
 		  bp->b_bn, BBTOB(bp->b_length));
 }
 
+/*
+ * This is called from I/O verifiers on v5 superblock filesystems. In the
+ * kernel, it validates the metadata LSN parameter against the current LSN of
+ * the active log. We don't have an active log in userspace so this kind of
+ * validation is not required.
+ *
+ * xfs_repair piggybacks off this mechanism to help track the largest metadata
+ * LSN in use on a filesystem. Keep a record of the largest LSN seen such that
+ * repair can validate it against the state of the log.
+ */
+xfs_lsn_t		libxfs_max_lsn = 0;
+pthread_mutex_t		libxfs_max_lsn_lock = PTHREAD_MUTEX_INITIALIZER;
+
 void
 xfs_detect_invalid_lsn(
 	struct xfs_mount	*mp,
 	xfs_lsn_t		lsn)
 {
+	int			cycle = CYCLE_LSN(lsn);
+	int			block = BLOCK_LSN(lsn);
+	int			max_cycle;
+	int			max_block;
+
+	if (lsn == NULLCOMMITLSN)
+		return;
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
 }
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
