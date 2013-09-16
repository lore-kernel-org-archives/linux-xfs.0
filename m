Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A124C7F3F
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 16:55:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6F6E13040D9
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 14:55:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IOQCYOw9D5mcT9qH for
	<xfs@oss.sgi.com>; Mon, 16 Sep 2013 14:55:30 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8GLtTZk027199
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 17:55:29 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r8GLtSRa026755
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 17:55:29 -0400
Message-ID: <52377E50.3040907@redhat.com>
Date: Mon, 16 Sep 2013 16:55:28 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH, RFC] xfstests: add d_type checking to fsstress
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
To: xfs-oss <xfs@oss.sgi.com>

This patch adds a "-D" switch to fsstress so that every time
we call readdir, we stat the dentry & compare it's st_mode
to the d_type.

If -D is specified only once, it ignores DT_UNKNOWN.  If specified
twice, it considers DT_UNKNOWN to be an error.

It skips paths of "./." and "./.." so that we only look at files
newly created within the filesystem.

This could be used in an xfstest; it's noisy on a failures so
would break expected output.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

fsstress doesn't usually do validation, but it's such a handy
framework for creating a ton of random files, this seems like
an ok place to put it.  What do folks think?


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 5d5611f..711ea9a 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -246,6 +246,7 @@ int		rtpct;
 unsigned long	seed = 0;
 ino_t		top_ino;
 int		verbose = 0;
+int		verify_d_type = 0;
 sig_atomic_t	should_stop = 0;
 char		*execute_cmd = NULL;
 int		execute_freq = 1;
@@ -315,7 +316,7 @@ int main(int argc, char **argv)
 	int             nousage = 0;
 	xfs_error_injection_t	        err_inj;
 	struct sigaction action;
-	const char	*allopts = "d:e:f:i:m:M:n:o:p:rs:S:vwx:X:zH";
+	const char	*allopts = "d:De:f:i:m:M:n:o:p:rs:S:vwx:X:zH";
 
 	errrange = errtag = 0;
 	umask(0);
@@ -327,6 +328,9 @@ int main(int argc, char **argv)
 		case 'd':
 			dirname = optarg;
 			break;
+		case 'D':
+			verify_d_type++;
+			break;
 		case 'e':
 			sscanf(optarg, "%d", &errtag);
 			if (errtag < 0) {
@@ -1491,6 +1495,7 @@ usage(void)
 	printf("          [-p nproc][-r len][-s seed][-v][-w][-x cmd][-z][-S][-X ncmd]\n");
 	printf("where\n");
 	printf("   -d dir           specifies the base directory for operations\n");
+	printf("   -D               verify d_type in any readdir operations, 2x to disallow DT_UNKNOWN\n");
 	printf("   -e errtg         specifies error injection stuff\n");
 	printf("   -f op_name=freq  changes the frequency of option name to freq\n");
 	printf("                    the valid operation names are:\n");
@@ -2338,12 +2343,71 @@ getattr_f(int opno, long r)
 	close(fd);
 }
 
+void test_d_type(int opno, pathname_t *f, struct dirent64 *de)
+{
+	struct stat64 sb;
+	char path[PATH_MAX];
+
+	snprintf(path, PATH_MAX, "%s/%s", f->path, de->d_name);
+
+	/* Don't check ./. or ./.. */
+	if (!strncmp(path, "./.", 3))
+		return;
+
+	if (lstat64(path, &sb)) {
+		printf("%d/%d: getdents - can't stat %s\n",
+			procid, opno, path);
+	} else {
+		int bad_d_type = 0;
+
+		switch (de->d_type) {
+			case DT_BLK:
+				if (!S_ISBLK(sb.st_mode))
+					bad_d_type++;
+				break;
+			case DT_CHR:
+				if (!S_ISCHR(sb.st_mode))
+					bad_d_type++;
+				break;
+			case DT_DIR:
+				if (!S_ISDIR(sb.st_mode))
+					bad_d_type++;
+				break;
+			case DT_FIFO:
+				if (!S_ISFIFO(sb.st_mode))
+					bad_d_type++;
+				break;
+			case DT_LNK:
+				if (!S_ISLNK(sb.st_mode))
+					bad_d_type++;
+				break;
+			case DT_REG:
+				if (!S_ISREG(sb.st_mode))
+					bad_d_type++;
+				break;
+			case DT_SOCK:
+				if (!S_ISSOCK(sb.st_mode))
+					bad_d_type++;
+				break;
+			case DT_UNKNOWN:
+				if (verify_d_type > 1)
+					bad_d_type++;
+			break;
+		}
+		if (bad_d_type)
+			printf("%d/%d: getdents - bad d_type %d for %s\n",
+				procid, opno, de->d_type, path);
+			
+	}
+}
+
 void
 getdents_f(int opno, long r)
 {
 	DIR		*dir;
 	pathname_t	f;
 	int		v;
+	struct dirent64	*de;
 
 	init_pathname(&f);
 	if (!get_fname(FT_DIRm, r, &f, NULL, NULL, &v))
@@ -2357,8 +2421,11 @@ getdents_f(int opno, long r)
 		free_pathname(&f);
 		return;
 	}
-	while (readdir64(dir) != NULL)
+	while ((de = readdir64(dir)) != NULL) {
+		if (verify_d_type)
+			test_d_type(opno, &f, de);
 		continue;
+	}
 	if (v)
 		printf("%d/%d: getdents %s 0\n", procid, opno, f.path);
 	free_pathname(&f);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
