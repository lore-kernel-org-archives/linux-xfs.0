Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0K3bKYL235624 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 21:37:20 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E2B1317746B
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 19:38:19 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	VbjnQ8vl4PeecreU for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 19:38:19 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11651453-1927428
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 14:08:18 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NXROY-00053D-5r
	for xfs@oss.sgi.com; Wed, 20 Jan 2010 14:38:14 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NXROX-00008I-20
	for xfs@oss.sgi.com; Wed, 20 Jan 2010 14:38:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/8] xfstests: fix bulkstat related compile warnings.
Date: Wed, 20 Jan 2010 14:38:02 +1100
Message-Id: <1263958688-435-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1263958688-435-1-git-send-email-david@fromorbit.com>
References: <1263958688-435-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Use correct types for bulkstat structure to avoid pointer warnings.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 ltp/fsstress.c                      |    4 ++--
 src/bulkstat_unlink_test.c          |    2 +-
 src/bulkstat_unlink_test_modified.c |    2 +-
 src/t_immutable.c                   |    6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 6978381..c37cddf 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -1550,7 +1550,7 @@ bulkstat_f(int opno, long r)
 {
 	int		count;
 	int		fd;
-	__uint64_t	last;
+	__u64		last;
 	int		nent;
 	xfs_bstat_t	*t;
 	__int64_t	total;
@@ -1583,7 +1583,7 @@ bulkstat1_f(int opno, long r)
 	pathname_t	f;
 	int		fd;
 	int		good;
-	__uint64_t	ino;
+	__u64		ino;
 	struct stat64	s;
 	xfs_bstat_t	t;
 	int		v;
diff --git a/src/bulkstat_unlink_test.c b/src/bulkstat_unlink_test.c
index 17d07c0..afd69ff 100644
--- a/src/bulkstat_unlink_test.c
+++ b/src/bulkstat_unlink_test.c
@@ -68,7 +68,7 @@ main(int argc, char *argv[])
 		printf("Iteration %d ... (%d files)", k, nfiles);
 
 		memset(&a, 0, sizeof(xfs_fsop_bulkreq_t));
-		a.lastip = &last_inode;
+		a.lastip = (__u64 *)&last_inode;
 		a.icount = nfiles;
 		a.ubuffer = ret;
 		a.ocount = &count;
diff --git a/src/bulkstat_unlink_test_modified.c b/src/bulkstat_unlink_test_modified.c
index 4acc912..3a50d61 100644
--- a/src/bulkstat_unlink_test_modified.c
+++ b/src/bulkstat_unlink_test_modified.c
@@ -61,7 +61,7 @@ main(int argc, char *argv[])
 	memset(genlist, 0, nfiles * sizeof(__u32));
 	memset(ret, 0, nfiles * sizeof(xfs_bstat_t));
 	memset(&a, 0, sizeof(xfs_fsop_bulkreq_t));
-	a.lastip = &last_inode;
+	a.lastip = (__u64 *)&last_inode;
 	a.icount = nfiles;
 	a.ubuffer = ret;
 	a.ocount = &count;
diff --git a/src/t_immutable.c b/src/t_immutable.c
index 07a36cd..7bb3154 100644
--- a/src/t_immutable.c
+++ b/src/t_immutable.c
@@ -283,7 +283,7 @@ static int test_immutable(const char *dir)
 
 	  ino = st.st_ino;
 
-	  bulkreq.lastip = &ino;
+	  bulkreq.lastip = (__u64 *)&ino;
 	  bulkreq.icount = 1;
 	  bulkreq.ubuffer = &bstat;
 	  bulkreq.ocount = NULL;
@@ -943,7 +943,7 @@ static int test_append(const char *dir)
 
 	  ino = st.st_ino;
 
-	  bulkreq.lastip = &ino;
+	  bulkreq.lastip = (__u64 *)&ino;
 	  bulkreq.icount = 1;
 	  bulkreq.ubuffer = &bstat;
 	  bulkreq.ocount = NULL;
@@ -1353,7 +1353,7 @@ static int test_append(const char *dir)
 
           ino = st.st_ino;
 
-          bulkreq.lastip = &ino;
+          bulkreq.lastip = (__u64 *)&ino;
           bulkreq.icount = 1;
           bulkreq.ubuffer = &bstat;
           bulkreq.ocount = NULL;
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
