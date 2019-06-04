Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58660 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFDVRJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:17:09 -0400
Subject: [PATCH 3/3] common: remove obsolete xfs ioctl typedef usage
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 04 Jun 2019 14:17:01 -0700
Message-ID: <155968302188.1646947.321648284422396629.stgit@magnolia>
In-Reply-To: <155968300283.1646947.2586545304045786757.stgit@magnolia>
References: <155968300283.1646947.2586545304045786757.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert 'xfs_foo_t' typedef usage to 'struct xfs_foo' in preparation for
changes to some of the xfs ioctls.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 ltp/fsstress.c                      |    8 ++++----
 src/bstat.c                         |    6 +++---
 src/bulkstat_unlink_test.c          |    8 ++++----
 src/bulkstat_unlink_test_modified.c |   10 +++++-----
 src/t_immutable.c                   |   12 ++++++------
 5 files changed, 22 insertions(+), 22 deletions(-)


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 279da9f1..d41e776c 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -2152,9 +2152,9 @@ bulkstat_f(int opno, long r)
 	int		fd;
 	__u64		last;
 	int		nent;
-	xfs_bstat_t	*t;
+	struct xfs_bstat	*t;
 	int64_t		total;
-        xfs_fsop_bulkreq_t bsr;
+        struct xfs_fsop_bulkreq bsr;
 
 	last = 0;
 	nent = (r % 999) + 2;
@@ -2185,9 +2185,9 @@ bulkstat1_f(int opno, long r)
 	int		good;
 	__u64		ino;
 	struct stat64	s;
-	xfs_bstat_t	t;
+	struct xfs_bstat	t;
 	int		v;
-        xfs_fsop_bulkreq_t bsr;
+        struct xfs_fsop_bulkreq bsr;
         
 
 	good = random() & 1;
diff --git a/src/bstat.c b/src/bstat.c
index e4367cee..3f3dc2c6 100644
--- a/src/bstat.c
+++ b/src/bstat.c
@@ -20,7 +20,7 @@ dotime(void *ti, char *s)
 }
 
 void
-printbstat(xfs_bstat_t *sp)
+printbstat(struct xfs_bstat *sp)
 {
 	printf("ino %lld mode %#o nlink %d uid %d gid %d rdev %#x\n",
 		(long long)sp->bs_ino, sp->bs_mode, sp->bs_nlink,
@@ -64,7 +64,7 @@ main(int argc, char **argv)
 	int		quiet = 0;
 	int		statit = 0;
 	int		verbose = 0;
-	xfs_bstat_t	*t;
+	struct xfs_bstat	*t;
 	int		ret;
 	jdm_fshandle_t	*fshandlep = NULL;
 	int		fd;
@@ -73,7 +73,7 @@ main(int argc, char **argv)
 	char *cc_readlinkbufp;
 	int cc_readlinkbufsz;
 	int 		c;
-	xfs_fsop_bulkreq_t bulkreq;
+	struct xfs_fsop_bulkreq bulkreq;
 
 	while ((c = getopt(argc, argv, "cdl:qv")) != -1) {
 		switch (c) {
diff --git a/src/bulkstat_unlink_test.c b/src/bulkstat_unlink_test.c
index cdf720ef..d78cc2ac 100644
--- a/src/bulkstat_unlink_test.c
+++ b/src/bulkstat_unlink_test.c
@@ -26,8 +26,8 @@ main(int argc, char *argv[])
 
 	struct stat sbuf;
 	ino_t *inodelist;
-	xfs_fsop_bulkreq_t a;
-	xfs_bstat_t *ret;
+	struct xfs_fsop_bulkreq a;
+	struct xfs_bstat *ret;
 	int iterations;
 	char fname[MAXPATHLEN];
 	char *dirname;
@@ -60,7 +60,7 @@ main(int argc, char *argv[])
 		printf("Runing extended checks.\n");
 
 	inodelist = (ino_t *)malloc(nfiles * sizeof(ino_t));
-	ret = (xfs_bstat_t *)malloc(nfiles * sizeof(xfs_bstat_t));
+	ret = (struct xfs_bstat *)malloc(nfiles * sizeof(struct xfs_bstat));
 
 	for (k=0; k < iterations; k++) {
 		int fd[nfiles + 1];
@@ -69,7 +69,7 @@ main(int argc, char *argv[])
 
 		printf("Iteration %d ... (%d files)", k, nfiles);
 
-		memset(&a, 0, sizeof(xfs_fsop_bulkreq_t));
+		memset(&a, 0, sizeof(struct xfs_fsop_bulkreq));
 		a.lastip = (__u64 *)&last_inode;
 		a.icount = nfiles;
 		a.ubuffer = ret;
diff --git a/src/bulkstat_unlink_test_modified.c b/src/bulkstat_unlink_test_modified.c
index 981d80cc..a106749d 100644
--- a/src/bulkstat_unlink_test_modified.c
+++ b/src/bulkstat_unlink_test_modified.c
@@ -27,8 +27,8 @@ main(int argc, char *argv[])
     struct stat sbuf;
     ino_t *inodelist;
     __u32 *genlist;
-    xfs_fsop_bulkreq_t a;
-    xfs_bstat_t *ret;
+    struct xfs_fsop_bulkreq a;
+    struct xfs_bstat *ret;
     int iterations;
     char fname[MAXPATHLEN];
     char *dirname;
@@ -50,7 +50,7 @@ main(int argc, char *argv[])
 
     inodelist = (ino_t *)malloc(nfiles * sizeof(ino_t));
     genlist = (__u32 *)malloc(nfiles * sizeof(__u32));
-    ret = (xfs_bstat_t *)malloc(nfiles * sizeof(xfs_bstat_t));
+    ret = (struct xfs_bstat *)malloc(nfiles * sizeof(struct xfs_bstat));
 
     for (k=0; k < iterations; k++) {
 	xfs_ino_t last_inode = 0;
@@ -61,8 +61,8 @@ main(int argc, char *argv[])
 
 	memset(inodelist, 0, nfiles * sizeof(ino_t));
 	memset(genlist, 0, nfiles * sizeof(__u32));
-	memset(ret, 0, nfiles * sizeof(xfs_bstat_t));
-	memset(&a, 0, sizeof(xfs_fsop_bulkreq_t));
+	memset(ret, 0, nfiles * sizeof(struct xfs_bstat));
+	memset(&a, 0, sizeof(struct xfs_fsop_bulkreq));
 	a.lastip = (__u64 *)&last_inode;
 	a.icount = nfiles;
 	a.ubuffer = ret;
diff --git a/src/t_immutable.c b/src/t_immutable.c
index eadef78f..86c567ed 100644
--- a/src/t_immutable.c
+++ b/src/t_immutable.c
@@ -228,8 +228,8 @@ static int test_immutable(const char *dir)
 
      if (stfs.f_type == XFS_SUPER_MAGIC && !getuid()) {
 	  jdm_fshandle_t *fshandle;
-	  xfs_bstat_t bstat;
-	  xfs_fsop_bulkreq_t  bulkreq;
+	  struct xfs_bstat bstat;
+	  struct xfs_fsop_bulkreq  bulkreq;
 	  xfs_ino_t ino;
 	  char *dirpath;
 
@@ -903,8 +903,8 @@ static int test_append(const char *dir)
 
      if (stfs.f_type == XFS_SUPER_MAGIC && !getuid()) {
 	  jdm_fshandle_t *fshandle;
-	  xfs_bstat_t bstat;
-	  xfs_fsop_bulkreq_t  bulkreq;
+	  struct xfs_bstat bstat;
+	  struct xfs_fsop_bulkreq  bulkreq;
 	  xfs_ino_t ino;
 	  char *dirpath;
 
@@ -1288,8 +1288,8 @@ static int test_append(const char *dir)
 
      if (stfs.f_type == XFS_SUPER_MAGIC && !getuid()) {
           jdm_fshandle_t *fshandle;
-          xfs_bstat_t bstat;
-          xfs_fsop_bulkreq_t  bulkreq;
+          struct xfs_bstat bstat;
+          struct xfs_fsop_bulkreq  bulkreq;
           xfs_ino_t ino;
           char *dirpath;
 
