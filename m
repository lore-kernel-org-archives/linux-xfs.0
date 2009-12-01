Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB1JHdra159581 for <xfs@oss.sgi.com>; Tue, 1 Dec 2009 13:17:39 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ABC264C8DD9
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2009 11:18:09 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id FIAHEQW8t48EBzX4 for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2009 11:18:09 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id DE2A5AAE3B8
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2009 13:18:08 -0600 (CST)
Message-ID: <4B156BE3.2080107@sandeen.net>
Date: Tue, 01 Dec 2009 13:17:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_db: modify bad_features2 when modifying features2
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

The "attr1" command in xfs_db, for example, only modifies the features2
field; when mounted, the kernel will find a mismatch between features2
and bad_features2, and attr2 gets turned back on.

I think the simplest fix is to modify do_version to modify both fields,
but not if there is an existing mismatch that should be investigated
first.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/db/sb.c b/db/sb.c
index 7c61b15..961a939 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -556,6 +556,12 @@ do_version(xfs_agnumber_t agno, __uint16_t version, __uint32_t features)
 	if (!get_sb(agno, &tsb))
 		return 0;
 
+	if (xfs_sb_has_mismatched_features2(&tsb)) {
+		dbprintf(_("Superblock has mismatched features2 fields, "
+			   "skipping modification\n"));
+		return 0;
+	}
+
 	if ((version & XFS_SB_VERSION_LOGV2BIT) &&
 					!xfs_sb_version_haslogv2(&tsb)) {
 		tsb.sb_logsunit = 1;
@@ -564,7 +570,8 @@ do_version(xfs_agnumber_t agno, __uint16_t version, __uint32_t features)
 
 	tsb.sb_versionnum = version;
 	tsb.sb_features2 = features;
-	fields |= XFS_SB_VERSIONNUM | XFS_SB_FEATURES2;
+	tsb.sb_bad_features2 = features;
+	fields |= XFS_SB_VERSIONNUM | XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2;
 	libxfs_sb_to_disk(iocur_top->data, &tsb, fields);
 	write_cur();
 	return 1;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
