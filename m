Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0CF228255
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:52:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C4FD38F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:52:30 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 8VUBWVRDzi99Eds1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:52:29 -0700 (PDT)
Subject: [PATCH 54/71] xfs_logprint: support cowextsize reporting in log
	contents
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:52:25 -0700
Message-ID: <147216914532.4420.529835785368632546.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 logprint/log_misc.c      |    4 ++++
 logprint/log_print_all.c |    4 ++++
 2 files changed, 8 insertions(+)


diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 479fc14..f6488d9 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -513,6 +513,10 @@ xlog_print_trans_inode_core(
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
