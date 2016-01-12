Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A38927F37
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 14:02:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 236D5AC005
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 12:02:32 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id KidPqaoyGx12Rupw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 12:02:21 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id 31D76207AD
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 21:02:20 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3pg2qw0RVpz5vND
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 21:02:20 +0100 (CET)
Date: Tue, 12 Jan 2016 20:59:45 +0100
From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH 2/6] libxfs/linux.c: Replace use of ustat by stat
Message-ID: <20160112195945.GC568@nyan>
References: <cover.1452627740.git.felix.janda@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cover.1452627740.git.felix.janda@posteo.de>
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
To: xfs@oss.sgi.com

ustat has been used to check whether a device file is mounted.
The function is deprecated and not supported by uclibc and musl.
Now do the check using the *mntent functions.

Based on patch by Natanael Copa <ncopa@alpinelinux.org>.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 libxfs/linux.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/libxfs/linux.c b/libxfs/linux.c
index c532d65..e7adcf2 100644
--- a/libxfs/linux.c
+++ b/libxfs/linux.c
@@ -16,11 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#define ustat __kernel_ustat
 #include <mntent.h>
 #include <sys/stat.h>
-#undef ustat
-#include <sys/ustat.h>
 #include <sys/mount.h>
 #include <sys/ioctl.h>
 #include <sys/sysinfo.h>
@@ -51,9 +48,10 @@ static int max_block_alignment;
 int
 platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
 {
-	/* Pad ust; pre-2.6.28 linux copies out too much in 32bit compat mode */
-	struct ustat	ust[2];
-	struct stat64	st;
+	FILE		*f;
+	struct stat64	st, mst;
+	struct mntent	*mnt;
+	char		mounts[MAXPATHLEN];
 
 	if (!s) {
 		if (stat64(block, &st) < 0)
@@ -63,14 +61,27 @@ platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
 		s = &st;
 	}
 
-	if (ustat(s->st_rdev, ust) >= 0) {
+	strcpy(mounts, (!access(PROC_MOUNTED, R_OK)) ? PROC_MOUNTED : MOUNTED);
+	if ((f = setmntent(mounts, "r")) == NULL) {
+		fprintf(stderr,
+		    _("%s: %s possibly contains a mounted filesystem\n"),
+		    progname, name);
+		return 1;
+	}
+	while ((mnt = getmntent(f)) != NULL) {
+		if (stat64(mnt->mnt_dir, &mst) < 0)
+			continue;
+		if (mst.st_dev != s->st_rdev)
+			continue;
+
 		if (verbose)
 			fprintf(stderr,
 				_("%s: %s contains a mounted filesystem\n"),
 				progname, name);
-		return 1;
+		break;
 	}
-	return 0;
+	endmntent(f);
+	return mnt == NULL;
 }
 
 int
-- 
2.4.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
