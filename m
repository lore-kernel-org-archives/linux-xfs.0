Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BCEFC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Dec 2021 20:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhLJUZa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Dec 2021 15:25:30 -0500
Received: from sandeen.net ([63.231.237.45]:43508 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344187AbhLJUZ3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Dec 2021 15:25:29 -0500
Received: by sandeen.net (Postfix, from userid 500)
        id B899A450A94; Fri, 10 Dec 2021 14:21:40 -0600 (CST)
From:   Eric Sandeen <sandeen@sandeen.net>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs_repair: don't guess about failure reason in phase6
Date:   Fri, 10 Dec 2021 14:21:37 -0600
Message-Id: <1639167697-15392-5-git-send-email-sandeen@sandeen.net>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1639167697-15392-1-git-send-email-sandeen@sandeen.net>
References: <1639167697-15392-1-git-send-email-sandeen@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

There are many error messages in phase 6 which say
"filesystem may be out of space," when in reality the failure could
have been corruption or some other issue.  Rather than guessing, and
emitting a confusing and possibly-wrong message, use the existing
res_failed() for any xfs_trans_alloc failures, and simply print the
error number in the other cases.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 repair/phase6.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 696a642..df22daa 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1067,9 +1067,7 @@ mv_orphanage(
 			err = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_rename,
 						  nres, 0, 0, &tp);
 			if (err)
-				do_error(
-	_("space reservation failed (%d), filesystem may be out of space\n"),
-					err);
+				res_failed(err);
 
 			libxfs_trans_ijoin(tp, orphanage_ip, 0);
 			libxfs_trans_ijoin(tp, ino_p, 0);
@@ -1078,8 +1076,7 @@ mv_orphanage(
 						ino, nres);
 			if (err)
 				do_error(
-	_("name create failed in %s (%d), filesystem may be out of space\n"),
-					ORPHANAGE, err);
+	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
 
 			if (irec)
 				add_inode_ref(irec, ino_offset);
@@ -1091,8 +1088,7 @@ mv_orphanage(
 					orphanage_ino, nres);
 			if (err)
 				do_error(
-	_("creation of .. entry failed (%d), filesystem may be out of space\n"),
-					err);
+	_("creation of .. entry failed (%d)\n"), err);
 
 			inc_nlink(VFS_I(ino_p));
 			libxfs_trans_log_inode(tp, ino_p, XFS_ILOG_CORE);
@@ -1104,9 +1100,7 @@ mv_orphanage(
 			err = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_rename,
 						  nres, 0, 0, &tp);
 			if (err)
-				do_error(
-	_("space reservation failed (%d), filesystem may be out of space\n"),
-					err);
+				res_failed(err);
 
 			libxfs_trans_ijoin(tp, orphanage_ip, 0);
 			libxfs_trans_ijoin(tp, ino_p, 0);
@@ -1116,8 +1110,7 @@ mv_orphanage(
 						ino, nres);
 			if (err)
 				do_error(
-	_("name create failed in %s (%d), filesystem may be out of space\n"),
-					ORPHANAGE, err);
+	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
 
 			if (irec)
 				add_inode_ref(irec, ino_offset);
@@ -1135,8 +1128,7 @@ mv_orphanage(
 						nres);
 				if (err)
 					do_error(
-	_("name replace op failed (%d), filesystem may be out of space\n"),
-						err);
+	_("name replace op failed (%d)\n"), err);
 			}
 
 			err = -libxfs_trans_commit(tp);
@@ -1156,9 +1148,7 @@ mv_orphanage(
 		err = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove,
 					  nres, 0, 0, &tp);
 		if (err)
-			do_error(
-	_("space reservation failed (%d), filesystem may be out of space\n"),
-				err);
+			res_failed(err);
 
 		libxfs_trans_ijoin(tp, orphanage_ip, 0);
 		libxfs_trans_ijoin(tp, ino_p, 0);
@@ -1167,8 +1157,7 @@ mv_orphanage(
 						nres);
 		if (err)
 			do_error(
-	_("name create failed in %s (%d), filesystem may be out of space\n"),
-				ORPHANAGE, err);
+	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
 		ASSERT(err == 0);
 
 		set_nlink(VFS_I(ino_p), 1);
@@ -1351,8 +1340,7 @@ longform_dir2_rebuild(
 						nres);
 		if (error) {
 			do_warn(
-_("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"),
-				ino, error);
+_("name create failed in ino %" PRIu64 " (%d)\n"), ino, error);
 			goto out_bmap_cancel;
 		}
 
-- 
1.8.3.1

