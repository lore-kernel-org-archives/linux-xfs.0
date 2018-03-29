Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43394 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751994AbeC2Pew (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 11:34:52 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 08/10] xfs_repair: remove pre_65_beta option
Date: Thu, 29 Mar 2018 10:34:20 -0500
Message-Id: <1522337662-26260-9-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
References: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Irix 6.5 was released 20 years ago.  Remove this option from
the code.  (nb: it's not present in the manpage.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 repair/globals.h    |  1 -
 repair/xfs_repair.c | 11 -----------
 2 files changed, 12 deletions(-)

diff --git a/repair/globals.h b/repair/globals.h
index c7bbe6f..5192542 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -97,7 +97,6 @@ EXTERN int	dumpcore;		/* abort, not exit on fatal errs */
 EXTERN int	delete_attr_ok;		/* can clear attrs w/o clearing files */
 EXTERN int	force_geo;		/* can set geo on low confidence info */
 EXTERN int	assume_xfs;		/* assume we have an xfs fs */
-EXTERN int	pre_65_beta;		/* fs was mkfs'ed by a version earlier * than 6.5-beta */
 EXTERN char	*log_name;		/* Name of log device */
 EXTERN int	log_spec;		/* Log dev specified as option */
 EXTERN char	*rt_name;		/* Name of realtime device */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 3caf9bb..c2106e4 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -49,8 +49,6 @@
 static char *o_opts[] = {
 #define ASSUME_XFS	0
 	"assume_xfs",
-#define PRE_65_BETA	1
-	"fs_is_pre_65_beta",
 #define	IHASH_SIZE	2
 	"ihash",
 #define	BHASH_SIZE	3
@@ -207,7 +205,6 @@ process_args(int argc, char **argv)
 	sb_inoalignmt = 0;
 	sb_unit = 0;
 	sb_width = 0;
-	pre_65_beta = 0;
 	ag_stride = 0;
 	thread_count = 1;
 	report_interval = PROG_RPT_DEFAULT;
@@ -235,14 +232,6 @@ process_args(int argc, char **argv)
 						respec('o', o_opts, ASSUME_XFS);
 					assume_xfs = 1;
 					break;
-				case PRE_65_BETA:
-					if (val)
-						noval('o', o_opts, PRE_65_BETA);
-					if (pre_65_beta)
-						respec('o', o_opts,
-							PRE_65_BETA);
-					pre_65_beta = 1;
-					break;
 				case IHASH_SIZE:
 					do_warn(
 		_("-o ihash option has been removed and will be ignored\n"));
-- 
1.8.3.1

