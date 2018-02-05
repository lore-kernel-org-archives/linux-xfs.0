Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60736 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbeBEXXB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Feb 2018 18:23:01 -0500
Subject: [PATCH 5/7] xfs_scrub: reclassify some of the warning messages
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 05 Feb 2018 15:22:51 -0800
Message-ID: <151787297178.3743.12195489468667039346.stgit@magnolia>
In-Reply-To: <151787293446.3743.11110014829952400444.stgit@magnolia>
References: <151787293446.3743.11110014829952400444.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Some of the warning messages are actually runtime errors in optional
components, so turn them into informational messages.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/inodes.c |    6 +++---
 scrub/phase6.c |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 57b773e..744b003 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -157,7 +157,7 @@ xfs_iterate_inodes_range(
 		bulkreq.icount = inogrp.xi_alloccount;
 		error = ioctl(ctx->mnt_fd, XFS_IOC_FSBULKSTAT, &bulkreq);
 		if (error)
-			str_warn(ctx, descr, "%s", strerror_r(errno,
+			str_info(ctx, descr, "%s", strerror_r(errno,
 						buf, DESCR_BUFSZ));
 
 		xfs_iterate_inodes_range_check(ctx, &inogrp, bstat);
@@ -181,8 +181,8 @@ xfs_iterate_inodes_range(
 				}
 				snprintf(idescr, DESCR_BUFSZ, "inode %"PRIu64,
 						(uint64_t)bs->bs_ino);
-				str_warn(ctx, idescr, "%s", strerror_r(error,
-						buf, DESCR_BUFSZ));
+				str_info(ctx, idescr,
+_("Changed too many times during scan; giving up."));
 				break;
 			case XFS_ITERATE_INODES_ABORT:
 				error = 0;
diff --git a/scrub/phase6.c b/scrub/phase6.c
index f985950..e255eef 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -188,7 +188,6 @@ xfs_report_verify_inode(
 	void				*arg)
 {
 	char				descr[DESCR_BUFSZ];
-	char				buf[DESCR_BUFSZ];
 	bool				moveon;
 	int				fd;
 	int				error;
@@ -209,7 +208,8 @@ xfs_report_verify_inode(
 		if (error == ESTALE)
 			return error;
 
-		str_warn(ctx, descr, "%s", strerror_r(error, buf, DESCR_BUFSZ));
+		str_info(ctx, descr,
+_("Disappeared during read error reporting."));
 		return error;
 	}
 

