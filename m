Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAS1x42x121982 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 19:59:04 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ROcVBXCF8NtjNYtD for <xfs@oss.sgi.com>;
	Tue, 27 Nov 2012 18:01:20 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TdWxf-0003zW-Sh
	for xfs@oss.sgi.com; Wed, 28 Nov 2012 13:01:15 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TdWxV-0000SX-PF
	for xfs@oss.sgi.com; Wed, 28 Nov 2012 13:01:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfs: fix sparse reported log CRC endian issue
Date: Wed, 28 Nov 2012 13:01:03 +1100
Message-Id: <1354068063-1692-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1354068063-1692-1-git-send-email-david@fromorbit.com>
References: <1354068063-1692-1-git-send-email-david@fromorbit.com>
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

Not a bug as such, just warning noise from the xlog_cksum()
returning a __be32 type when it shoul dbe returning a __le32 type.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c         |    2 +-
 fs/xfs/xfs_log_priv.h    |    2 +-
 fs/xfs/xfs_log_recover.c |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c49e2c1..46bd9d5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1538,7 +1538,7 @@ xlog_pack_data(
  * This is a little more complicated than it should be because the various
  * headers and the actual data are non-contiguous.
  */
-__be32
+__le32
 xlog_cksum(
 	struct xlog		*log,
 	struct xlog_rec_header	*rhead,
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index dc3498b..16d8d12 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -555,7 +555,7 @@ extern int
 xlog_recover_finish(
 	struct xlog		*log);
 
-extern __be32	 xlog_cksum(struct xlog *log, struct xlog_rec_header *rhead,
+extern __le32	 xlog_cksum(struct xlog *log, struct xlog_rec_header *rhead,
 			    char *dp, int size);
 
 extern kmem_zone_t *xfs_log_ticket_zone;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 9c3651c..96fcbb8 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3233,15 +3233,15 @@ xlog_unpack_data_crc(
 	xfs_caddr_t		dp,
 	struct xlog		*log)
 {
-	__be32			crc;
+	__le32			crc;
 
 	crc = xlog_cksum(log, rhead, dp, be32_to_cpu(rhead->h_len));
 	if (crc != rhead->h_crc) {
 		if (rhead->h_crc || xfs_sb_version_hascrc(&log->l_mp->m_sb)) {
 			xfs_alert(log->l_mp,
 		"log record CRC mismatch: found 0x%x, expected 0x%x.\n",
-					be32_to_cpu(rhead->h_crc),
-					be32_to_cpu(crc));
+					le32_to_cpu(rhead->h_crc),
+					le32_to_cpu(crc));
 			xfs_hex_dump(dp, 32);
 		}
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
