Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46761 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932449AbcJYXGC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:06:02 -0400
Subject: [PATCH 22/39] xfs_logprint: support cowextsize reporting in log
 contents
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:05:55 -0700
Message-ID: <147743675595.11035.1787107506258436197.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 logprint/log_misc.c      |    4 ++++
 logprint/log_print_all.c |    4 ++++
 2 files changed, 8 insertions(+)


diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index e4af09b..dbe5729 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -467,6 +467,10 @@ xlog_print_trans_inode_core(
 	   ip->di_dmstate);
     printf(_("flags 0x%x gen 0x%x\n"),
 	   ip->di_flags, ip->di_gen);
+    if (ip->di_version == 3) {
+        printf(_("flags2 0x%llx cowextsize 0x%x\n"),
+            (unsigned long long)ip->di_flags2, ip->di_cowextsize);
+    }
 }
 
 void
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 0fe354b..46952c4 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -272,6 +272,10 @@ xlog_recover_print_inode_core(
 	     "gen:%d\n"),
 	       (int)di->di_forkoff, di->di_dmevmask, (int)di->di_dmstate,
 	       (int)di->di_flags, di->di_gen);
+	if (di->di_version == 3) {
+		printf(_("flags2 0x%llx cowextsize 0x%x\n"),
+			(unsigned long long)di->di_flags2, di->di_cowextsize);
+	}
 }
 
 STATIC void

