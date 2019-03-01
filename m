Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45896 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfCAX13 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:27:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NOK8m123071
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:27 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2qtwkut8y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:27:27 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x21NRQ5A031740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:27 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x21NRQxt020845
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:26 GMT
Subject: [PATCH 06/23] xfs_scrub: rename the global nr_threads
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:27:25 -0800
Message-ID: <155148284558.16677.15018253328352883955.stgit@magnolia>
In-Reply-To: <155148280859.16677.6057998944865066232.stgit@magnolia>
References: <155148280859.16677.6057998944865066232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Various functions have nr_threads local variables that shadow the global
one.  Since the global one forces the number of threads we use, change
its name to remove this ambiguity and reflect what it really does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c    |    4 ++--
 scrub/disk.c      |    4 ++--
 scrub/xfs_scrub.c |    6 +++---
 scrub/xfs_scrub.h |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)


diff --git a/scrub/common.c b/scrub/common.c
index 78afc4bf..c877c7c8 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -231,8 +231,8 @@ unsigned int
 scrub_nproc(
 	struct scrub_ctx	*ctx)
 {
-	if (nr_threads)
-		return nr_threads;
+	if (force_nr_threads)
+		return force_nr_threads;
 	return ctx->nr_io_threads;
 }
 
diff --git a/scrub/disk.c b/scrub/disk.c
index 7daa508e..dd109533 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -75,8 +75,8 @@ unsigned int
 disk_heads(
 	struct disk		*disk)
 {
-	if (nr_threads)
-		return nr_threads;
+	if (force_nr_threads)
+		return force_nr_threads;
 	return __disk_heads(disk);
 }
 
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index b8138000..71fc274f 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -133,7 +133,7 @@ unsigned int			bg_mode;
 int				nproc;
 
 /* Number of threads we're allowed to use. */
-unsigned int			nr_threads;
+unsigned int			force_nr_threads;
 
 /* Verbosity; higher values print more information. */
 bool				verbose;
@@ -589,7 +589,7 @@ main(
 			}
 			break;
 		case 'b':
-			nr_threads = 1;
+			force_nr_threads = 1;
 			bg_mode++;
 			break;
 		case 'C':
@@ -659,7 +659,7 @@ main(
 			perror("nr_threads");
 			usage();
 		}
-		nr_threads = x;
+		force_nr_threads = x;
 	}
 
 	if (optind != argc - 1)
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index a961d8fd..a459e4b5 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -10,7 +10,7 @@ extern char *progname;
 
 #define _PATH_PROC_MOUNTS	"/proc/mounts"
 
-extern unsigned int		nr_threads;
+extern unsigned int		force_nr_threads;
 extern unsigned int		bg_mode;
 extern unsigned int		debug;
 extern int			nproc;
