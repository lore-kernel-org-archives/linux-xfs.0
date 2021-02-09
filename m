Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B63C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59D4E64E4F
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhBIEQf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:16:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230306AbhBIENq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:13:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59E5964EC4;
        Tue,  9 Feb 2021 04:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843844;
        bh=BobK22ALq2mAE0XGYr7SJs943WVxlEAnJyutLwMQaak=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aobLEQPD1rFwj4Av2puHoWsX4Huxp6JClcnOD3Xkqq65lDJ4uhqOJUohbANLqEQZN
         8qBxMRY5AdaistlVDekitj8d765pX39Z3fgNcjqGE8gjAuFWchWcm4nsUk73qYNRHX
         OSWTkQLSSGBU+p9HUURsReTUjsKtsRyUhf0ZjUNoFMyWXQ1xyz0btbNlb+i56HTURF
         gabGMtr+p4lyUFtrGUmrBd/AQ3humWfnWzyZnXEv9ensQUEPIM7CY05UVYgcGr783Q
         0O8segsilybxNl/CGXut/Re4Y4nR78gqlq6aWvncA8BDIxx+QS/0c2JvhtLscKEf5K
         byZIGrkuVRfyw==
Subject: [PATCH 07/10] xfs_repair: set NEEDSREPAIR when we deliberately
 corrupt directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 08 Feb 2021 20:10:44 -0800
Message-ID: <161284384405.3057868.8114203697655713495.stgit@magnolia>
In-Reply-To: <161284380403.3057868.11153586180065627226.stgit@magnolia>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There are a few places in xfs_repair's directory checking code where we
deliberately corrupt a directory entry as a sentinel to trigger a
correction in later repair phase.  In the mean time, the filesystem is
inconsistent, so set the needsrepair flag to force a re-run of repair if
the system goes down.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/agheader.h   |    2 ++
 repair/dir2.c       |    3 +++
 repair/phase6.c     |    7 +++++++
 repair/xfs_repair.c |   37 +++++++++++++++++++++++++++++++++++++
 4 files changed, 49 insertions(+)


diff --git a/repair/agheader.h b/repair/agheader.h
index a63827c8..fa6fe596 100644
--- a/repair/agheader.h
+++ b/repair/agheader.h
@@ -82,3 +82,5 @@ typedef struct fs_geo_list  {
 #define XR_AG_AGF	0x2
 #define XR_AG_AGI	0x4
 #define XR_AG_SB_SEC	0x8
+
+void force_needsrepair(struct xfs_mount *mp);
diff --git a/repair/dir2.c b/repair/dir2.c
index eabdb4f2..922b8a3e 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -15,6 +15,7 @@
 #include "da_util.h"
 #include "prefetch.h"
 #include "progress.h"
+#include "agheader.h"
 
 /*
  * Known bad inode list.  These are seen when the leaf and node
@@ -774,6 +775,7 @@ _("entry at block %u offset %" PRIdPTR " in directory inode %" PRIu64
 				do_warn(
 _("\tclearing inode number in entry at offset %" PRIdPTR "...\n"),
 					(intptr_t)ptr - (intptr_t)d);
+				force_needsrepair(mp);
 				dep->name[0] = '/';
 				*dirty = 1;
 			} else {
@@ -914,6 +916,7 @@ _("entry \"%*.*s\" in directory inode %" PRIu64 " points to self: "),
 		 */
 		if (junkit) {
 			if (!no_modify) {
+				force_needsrepair(mp);
 				dep->name[0] = '/';
 				*dirty = 1;
 				do_warn(_("clearing entry\n"));
diff --git a/repair/phase6.c b/repair/phase6.c
index 14464bef..5ecbe9b2 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1649,6 +1649,7 @@ longform_dir2_entry_check_data(
 			if (entry_junked(
 	_("entry \"%s\" in directory inode %" PRIu64 " points to non-existent inode %" PRIu64 ""),
 					fname, ip->i_ino, inum)) {
+				force_needsrepair(mp);
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
 			}
@@ -1666,6 +1667,7 @@ longform_dir2_entry_check_data(
 			if (entry_junked(
 	_("entry \"%s\" in directory inode %" PRIu64 " points to free inode %" PRIu64),
 					fname, ip->i_ino, inum)) {
+				force_needsrepair(mp);
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
 			}
@@ -1684,6 +1686,7 @@ longform_dir2_entry_check_data(
 				if (entry_junked(
 	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory"),
 						ORPHANAGE, inum, ip->i_ino)) {
+					force_needsrepair(mp);
 					dep->name[0] = '/';
 					libxfs_dir2_data_log_entry(&da, bp, dep);
 				}
@@ -1706,6 +1709,7 @@ longform_dir2_entry_check_data(
 			if (entry_junked(
 	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 					fname, inum, ip->i_ino)) {
+				force_needsrepair(mp);
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
 			}
@@ -1737,6 +1741,7 @@ longform_dir2_entry_check_data(
 				if (entry_junked(
 	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is not in the the first block"), fname,
 						inum, ip->i_ino)) {
+					force_needsrepair(mp);
 					dep->name[0] = '/';
 					libxfs_dir2_data_log_entry(&da, bp, dep);
 				}
@@ -1764,6 +1769,7 @@ longform_dir2_entry_check_data(
 				if (entry_junked(
 	_("entry \"%s\" in dir %" PRIu64 " is not the first entry"),
 						fname, inum, ip->i_ino)) {
+					force_needsrepair(mp);
 					dep->name[0] = '/';
 					libxfs_dir2_data_log_entry(&da, bp, dep);
 				}
@@ -1852,6 +1858,7 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
 				orphanage_ino = 0;
 			nbad++;
 			if (!no_modify)  {
+				force_needsrepair(mp);
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
 				if (verbose)
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index f607afcb..9dc73854 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -754,6 +754,43 @@ clear_needsrepair(
 		libxfs_buf_relse(bp);
 }
 
+/*
+ * Mark the filesystem as needing repair.  This should only be called by code
+ * that deliberately sets invalid sentinel values in the on-disk metadata to
+ * trigger a later reconstruction, and only after we've settled the primary
+ * super contents (i.e. after phase 1).
+ */
+void
+force_needsrepair(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*bp;
+	int			error;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb) ||
+	    xfs_sb_version_needsrepair(&mp->m_sb))
+		return;
+
+	bp = libxfs_getsb(mp);
+	if (!bp || bp->b_error) {
+		do_log(
+	_("couldn't get superblock to set needsrepair, err=%d\n"),
+				bp ? bp->b_error : ENOMEM);
+		return;
+	} else {
+		mp->m_sb.sb_features_incompat |=
+				XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+		libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
+
+		/* Force the primary super to disk immediately. */
+		error = -libxfs_bwrite(bp);
+		if (error)
+			do_log(_("couldn't force needsrepair, err=%d\n"), error);
+	}
+	if (bp)
+		libxfs_buf_relse(bp);
+}
+
 int
 main(int argc, char **argv)
 {

