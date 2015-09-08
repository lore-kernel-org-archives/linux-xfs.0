Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2334A7F37
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2015 09:23:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 10BF28F8050
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2015 07:23:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wBpJHigMxvGZ8LaS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 08 Sep 2015 07:23:41 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 10/11 v2] xfsprogs: make fsr use mntinfo when there is no
	mntent
Date: Tue,  8 Sep 2015 16:23:27 +0200
Message-Id: <1441722207-9141-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <1440590555-20463-10-git-send-email-jtulak@redhat.com>
References: <1440590555-20463-10-git-send-email-jtulak@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: hch@infradead.org, Jan Tulak <jtulak@redhat.com>


For what fsr needs, mntinfo can be used instead of mntent.
Custom mntent struct is used to avoid too big ifdefs:
We only change few lines and the rest of the code can still
use mntent as before.

CHANGE
- subject was: "add dummy mntent for OS X"
- reduced the stuby code.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 fsr/Makefile     |  8 +++++++
 fsr/xfs_fsr.c    | 69 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 include/darwin.h | 20 ++++++++++++++++
 3 files changed, 87 insertions(+), 10 deletions(-)

diff --git a/fsr/Makefile b/fsr/Makefile
index a9d1bf6..d3521b2 100644
--- a/fsr/Makefile
+++ b/fsr/Makefile
@@ -9,6 +9,14 @@ LTCOMMAND = xfs_fsr
 CFILES = xfs_fsr.c
 LLDLIBS = $(LIBHANDLE)
 
+ifeq ($(HAVE_GETMNTENT),yes)
+LCFLAGS += -DHAVE_GETMNTENT
+endif
+
+ifeq ($(HAVE_GETMNTINFO),yes)
+LCFLAGS += -DHAVE_GETMNTINFO
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 5f95cdc..ff791d3 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -32,8 +32,10 @@
 #include <sys/statvfs.h>
 #include <sys/xattr.h>
 
-#ifdef HAVE_MNTENT
+#if defined(HAVE_GETMNTENT)
 #  include <mntent.h>
+#elif defined(HAVE_GETMNTINFO)
+#  include <sys/mount.h>
 #endif
 
 #ifdef __APPLE__
@@ -191,9 +193,10 @@ find_mountpoint(char *mtab, char *argname, struct stat64 *sb)
 {
 	struct mntent *t;
 	struct stat64 ms;
-	FILE *mtabp;
 	char *mntp = NULL;
 
+#if defined(HAVE_GETMNTENT)
+	FILE *mtabp;
 	mtabp = setmntent(mtab, "r");
 	if (!mtabp) {
 		fprintf(stderr, _("%s: cannot read %s\n"),
@@ -202,6 +205,27 @@ find_mountpoint(char *mtab, char *argname, struct stat64 *sb)
 	}
 
 	while ((t = getmntent(mtabp))) {
+#elif defined(HAVE_GETMNTINFO)
+	struct statfs	*stats;
+	int error, i, count;
+	// because "t" is a pointer, but we don't need to use
+	// malloc for this usage
+	struct mntent t_tmp;
+	t = &t_tmp;
+
+		
+	error = 0;
+	if ((count = getmntinfo(&stats, 0)) < 0) {
+		fprintf(stderr, _("%s: getmntinfo() failed: %s\n"),
+				progname, strerror(errno));
+		return 0;
+	}
+
+	for (i = 0; i < count; i++) {
+		mntinfo2mntent(&stats[i], t);
+#else
+# error "How do I extract info about mounted filesystems on this platform?"
+#endif
 		if (S_ISDIR(sb->st_mode)) {		/* mount point */
 			if (stat64(t->mnt_dir, &ms) < 0)
 				continue;
@@ -233,10 +257,11 @@ find_mountpoint(char *mtab, char *argname, struct stat64 *sb)
 		break;
 	}
 
+#if defined(HAVE_GETMNTENT)
 	endmntent(mtabp);
+#endif
 	return mntp;
 }
-
 int
 main(int argc, char **argv)
 {
@@ -411,18 +436,11 @@ usage(int ret)
 static void
 initallfs(char *mtab)
 {
-	FILE *fp;
 	struct mntent *mp;
 	int mi;
 	char *cp;
 	struct stat64 sb;
 
-	fp = setmntent(mtab, "r");
-	if (fp == NULL) {
-		fsrprintf(_("could not open mtab file: %s\n"), mtab);
-		exit(1);
-	}
-
 	/* malloc a number of descriptors, increased later if needed */
 	if (!(fsbase = (fsdesc_t *)malloc(fsbufsize * sizeof(fsdesc_t)))) {
 		fsrprintf(_("out of memory: %s\n"), strerror(errno));
@@ -433,7 +451,36 @@ initallfs(char *mtab)
 	/* find all rw xfs file systems */
 	mi = 0;
 	fs = fsbase;
+
+#if defined(HAVE_GETMNTENT)
+	FILE *fp;
+	fp = setmntent(mtab, "r");
+	if (fp == NULL) {
+		fsrprintf(_("could not open mtab file: %s\n"), mtab);
+		exit(1);
+	}
+
 	while ((mp = getmntent(fp))) {
+#elif defined(HAVE_GETMNTINFO)
+	struct statfs	*stats;
+	int error, i, count;
+	// because "t" is a pointer, but we don't need to use
+	// malloc for this usage
+	struct mntent mp_tmp;
+	mp = &mp_tmp;
+	error = 0;
+	if ((count = getmntinfo(&stats, 0)) < 0) {
+		fprintf(stderr, _("%s: getmntinfo() failed: %s\n"),
+				progname, strerror(errno));
+		exit(1);
+	}
+
+	for (i = 0; i < count; i++) {
+		mntinfo2mntent(&stats[i], mp);
+#else
+# error "How do I extract info about mounted filesystems on this platform?"
+#endif
+
 		int rw = 0;
 
 		if (strcmp(mp->mnt_type, MNTTYPE_XFS ) != 0 ||
@@ -485,7 +532,9 @@ initallfs(char *mtab)
 	}
 	numfs = mi;
 	fsend = (fsbase + numfs);
+#if defined(HAVE_GETMNTENT)
 	endmntent(fp);
+#endif
 	if (numfs == 0) {
 		fsrprintf(_("no rw xfs file systems in mtab: %s\n"), mtab);
 		exit(0);
diff --git a/include/darwin.h b/include/darwin.h
index 288ad1f..0313f46 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -218,7 +218,27 @@ static inline int timer_gettime (timer_t timerid, struct itimerspec *value)
 
 /* FSR */
 
+#  include <sys/mount.h>
+#  include <sys/param.h>
+#include <sys/ucred.h>
+#include <errno.h>
 #define statvfs64 statfs
 #define		_PATH_MOUNTED   "/etc/mtab"
 
+struct mntent
+{
+	char *mnt_fsname;
+	char *mnt_dir;
+	char *mnt_type;
+	char *mnt_opts;
+	int mnt_freq;
+	int mnt_passno;
+};
+
+static inline void mntinfo2mntent (struct statfs * stats, struct mntent * mnt) {
+	mnt->mnt_fsname = stats->f_mntfromname;
+	mnt->mnt_dir = stats->f_mntonname;
+	mnt->mnt_type = stats->f_fstypename;
+}
+
 #endif	/* __XFS_DARWIN_H__ */
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
