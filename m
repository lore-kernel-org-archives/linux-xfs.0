Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E06247F3F
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 06:14:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A2427304059
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 04:14:13 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1UCCpUDRAcn703pO for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 04:14:12 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UdIbx-0008T0-9L
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:14:09 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UdIbm-0005G2-Ss
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:13:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 29/30] xfsdb: support version 5 superblock in versionnum
	command
Date: Fri, 17 May 2013 21:13:24 +1000
Message-Id: <1368789205-19969-30-git-send-email-david@fromorbit.com>
In-Reply-To: <1368789205-19969-1-git-send-email-david@fromorbit.com>
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
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

While there, add visibility of the new superblock fields in the "sb"
command.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/sb.c |   46 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 41 insertions(+), 5 deletions(-)

diff --git a/db/sb.c b/db/sb.c
index 54ca7dd..d178f58 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -108,7 +108,19 @@ const field_t	sb_flds[] = {
 	{ "logsectsize", FLDT_UINT16D, OI(OFF(logsectsize)), C1, 0, TYP_NONE },
 	{ "logsunit", FLDT_UINT32D, OI(OFF(logsunit)), C1, 0, TYP_NONE },
 	{ "features2", FLDT_UINT32X, OI(OFF(features2)), C1, 0, TYP_NONE },
-	{ "bad_features2", FLDT_UINT32X, OI(OFF(bad_features2)), C1, 0, TYP_NONE },
+	{ "bad_features2", FLDT_UINT32X, OI(OFF(bad_features2)),
+		C1, 0, TYP_NONE },
+	{ "features_compat", FLDT_UINT32X, OI(OFF(features_compat)),
+		C1, 0, TYP_NONE },
+	{ "features_ro_compat", FLDT_UINT32X, OI(OFF(features_ro_compat)),
+		C1, 0, TYP_NONE },
+	{ "features_incompat", FLDT_UINT32X, OI(OFF(features_incompat)),
+		C1, 0, TYP_NONE },
+	{ "features_log_incompat", FLDT_UINT32X, OI(OFF(features_log_incompat)),
+		C1, 0, TYP_NONE },
+	{ "crc", FLDT_UINT32X, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "pquotino", FLDT_INO, OI(OFF(pquotino)), C1, 0, TYP_INODE },
+	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
@@ -597,6 +609,8 @@ version_string(
 		strcpy(s, "V3");
 	else if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
 		strcpy(s, "V4");
+	else if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
+		strcpy(s, "V5");
 
 	if (xfs_sb_version_hasattr(sbp))
 		strcat(s, ",ATTR");
@@ -628,9 +642,17 @@ version_string(
 		strcat(s, ",LAZYSBCOUNT");
 	if (xfs_sb_version_hasprojid32bit(sbp))
 		strcat(s, ",PROJID32BIT");
+	if (xfs_sb_version_hascrc(sbp))
+		strcat(s, ",CRC");
 	return s;
 }
 
+/*
+ * XXX: this only supports reading and writing to version 4 superblock fields.
+ * V5 superblocks always define certain V4 feature bits - they are blocked from
+ * being changed if a V5 sb is detected, but otherwise v5 superblock features
+ * are not handled here.
+ */
 static int
 version_f(
 	int		argc,
@@ -662,12 +684,16 @@ version_f(
 				break;
 			case XFS_SB_VERSION_4:
 				if (xfs_sb_version_hasextflgbit(&mp->m_sb))
-					dbprintf(_("unwritten extents flag"
-						 " is already enabled\n"));
+					dbprintf(
+		_("unwritten extents flag is already enabled\n"));
 				else
 					version = mp->m_sb.sb_versionnum |
 						  XFS_SB_VERSION_EXTFLGBIT;
 				break;
+			case XFS_SB_VERSION_5:
+				dbprintf(
+		_("unwritten extents always enabled for v5 superblocks.\n"));
+				break;
 			}
 		} else if (!strcasecmp(argv[1], "log2")) {
 			switch (XFS_SB_VERSION_NUM(&mp->m_sb)) {
@@ -682,14 +708,24 @@ version_f(
 				break;
 			case XFS_SB_VERSION_4:
 				if (xfs_sb_version_haslogv2(&mp->m_sb))
-					dbprintf(_("version 2 log format"
-						 " is already in use\n"));
+					dbprintf(
+		_("version 2 log format is already in use\n"));
 				else
 					version = mp->m_sb.sb_versionnum |
 						  XFS_SB_VERSION_LOGV2BIT;
 				break;
+			case XFS_SB_VERSION_5:
+				dbprintf(
+		_("Version 2 logs always enabled for v5 superblocks.\n"));
+				break;
 			}
+		} else if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5) {
+			dbprintf(
+		_("%s: Cannot change %s on v5 superblocks.\n"),
+				progname, argv[1]);
+			return 0;
 		} else if (!strcasecmp(argv[1], "attr1")) {
+
 			if (xfs_sb_version_hasattr2(&mp->m_sb)) {
 				if (!(mp->m_sb.sb_features2 &=
 						~XFS_SB_VERSION2_ATTR2BIT))
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
