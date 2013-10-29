Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2D19D7F67
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 06:12:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BC46FAC002
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 04:12:15 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	JvsbN2U8brDDI1vL for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 04:12:14 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vb7DN-0000Pi-55
	for xfs@oss.sgi.com; Tue, 29 Oct 2013 22:12:01 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vb7DN-00087w-3a
	for xfs@oss.sgi.com; Tue, 29 Oct 2013 22:12:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/15] xfs: make dir2 ftype offset pointers explicit
Date: Tue, 29 Oct 2013 22:11:55 +1100
Message-Id: <1383045118-31107-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1383045118-31107-1-git-send-email-david@fromorbit.com>
References: <1383045118-31107-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Rather than hiding the ftype field size accounting inside the dirent
padding for the ".." and first entry offset functions for v2
directory formats, add explicit functions that calculate it
correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_da_format.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_da_format.c b/fs/xfs/xfs_da_format.c
index 5991b26..5a5767c 100644
--- a/fs/xfs/xfs_da_format.c
+++ b/fs/xfs/xfs_da_format.c
@@ -334,6 +334,25 @@ xfs_dir2_data_first_entry_p(
 }
 
 static struct xfs_dir2_data_entry *
+xfs_dir2_ftype_data_dotdot_entry_p(
+	struct xfs_dir2_data_hdr *hdr)
+{
+	return (struct xfs_dir2_data_entry *)
+		((char *)hdr + sizeof(struct xfs_dir2_data_hdr) +
+				XFS_DIR3_DATA_ENTSIZE(1));
+}
+
+static struct xfs_dir2_data_entry *
+xfs_dir2_ftype_data_first_entry_p(
+	struct xfs_dir2_data_hdr *hdr)
+{
+	return (struct xfs_dir2_data_entry *)
+		((char *)hdr + sizeof(struct xfs_dir2_data_hdr) +
+				XFS_DIR3_DATA_ENTSIZE(1) +
+				XFS_DIR3_DATA_ENTSIZE(2));
+}
+
+static struct xfs_dir2_data_entry *
 xfs_dir3_data_dot_entry_p(
 	struct xfs_dir2_data_hdr *hdr)
 {
@@ -762,8 +781,8 @@ const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
 
 	.data_dot_entry_p = xfs_dir2_data_dot_entry_p,
-	.data_dotdot_entry_p = xfs_dir2_data_dotdot_entry_p,
-	.data_first_entry_p = xfs_dir2_data_first_entry_p,
+	.data_dotdot_entry_p = xfs_dir2_ftype_data_dotdot_entry_p,
+	.data_first_entry_p = xfs_dir2_ftype_data_first_entry_p,
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
