Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 39C827F3F
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 14:29:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EDD2E30406B
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 12:29:25 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GECuKZDb2YB8soa8 for
	<xfs@oss.sgi.com>; Mon, 13 Jan 2014 12:29:21 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0DKTKsH007170
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 15:29:21 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s0DKTJsq003577
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 15:29:20 -0500
Message-ID: <52D44C9F.2010600@redhat.com>
Date: Mon, 13 Jan 2014 14:29:19 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: allow override of XFS_IOC_DIOINFO
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

This change allows xfstests runs to simulate apps
which don't bother to call XFS_IOC_DIOINFO, and simply
issue DIO in sizes and alignments of its own choosing.

So i.e.:

# export XFS_DIO_MIN=512

prior to an xfstests run, and these test binaries
should issue 512-aligned DIOs instead of whatever
XFS_IOC_DIOINFO says (i.e. instead of maybe 4k).

(This is in preparation for allowing 512 IOs on
"advanced format" 512/4k disks, when xfs has an
internal 4k sector size).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/ltp/doio.c b/ltp/doio.c
index 0f77863..966cff1 100644
--- a/ltp/doio.c
+++ b/ltp/doio.c
@@ -1471,6 +1471,7 @@ fmt_ioreq(struct io_req *ioreq, struct syscall_info *sy, int fd)
 		      (io->r_uflags & F_WORD_ALIGNED) ? "aligned" : "unaligned");
 
 	if(io->r_oflags & O_DIRECT) {
+		char		*dio_env;
 		struct dioattr	finfo;
 		
 		if(xfsctl(io->r_file, fd, XFS_IOC_DIOINFO, &finfo) == -1) {
@@ -1481,6 +1482,10 @@ fmt_ioreq(struct io_req *ioreq, struct syscall_info *sy, int fd)
 			finfo.d_maxiosz = 1;
 		}
 
+		dio_env = getenv("XFS_DIO_MIN");
+		if (dio_env)
+			finfo.d_mem = finfo.d_miniosz = atoi(dio_env);
+
 		cp += sprintf(cp, "          DIRECT I/O: offset %% %d = %d length %% %d = %d\n",
 			      finfo.d_miniosz,
 			      io->r_offset % finfo.d_miniosz,
@@ -2774,11 +2779,18 @@ int	oflags;
 	free_slot->c_rtc = Reqno;
 
 	if (oflags & O_DIRECT) {
+		char *dio_env;
+
 		if (xfsctl(file, fd, XFS_IOC_DIOINFO, &finfo) == -1) {
 			finfo.d_mem = 1;
 			finfo.d_miniosz = 1;
 			finfo.d_maxiosz = 1;
 		}
+
+		dio_env = getenv("XFS_DIO_MIN");
+		if (dio_env)
+			finfo.d_mem = finfo.d_miniosz = atoi(dio_env);
+
 	} else {
 		finfo.d_mem = 1;
 		finfo.d_miniosz = 1;
diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 499a573..c56f168 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -1930,6 +1930,7 @@ dread_f(int opno, long r)
 	struct stat64	stb;
 	int		v;
 	char		st[1024];
+	char		*dio_env;
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
@@ -1974,6 +1975,11 @@ dread_f(int opno, long r)
 		close(fd);
 		return;
 	}
+
+	dio_env = getenv("XFS_DIO_MIN");
+	if (dio_env)
+		diob.d_mem = diob.d_miniosz = atoi(dio_env);
+
 	align = (__int64_t)diob.d_miniosz;
 	lr = ((__int64_t)random() << 32) + random();
 	off = (off64_t)(lr % stb.st_size);
@@ -2010,6 +2016,7 @@ dwrite_f(int opno, long r)
 	struct stat64	stb;
 	int		v;
 	char		st[1024];
+	char		*dio_env;
 
 	init_pathname(&f);
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
@@ -2046,6 +2053,11 @@ dwrite_f(int opno, long r)
 		close(fd);
 		return;
 	}
+
+	dio_env = getenv("XFS_DIO_MIN");
+	if (dio_env)
+		diob.d_mem = diob.d_miniosz = atoi(dio_env);
+
 	align = (__int64_t)diob.d_miniosz;
 	lr = ((__int64_t)random() << 32) + random();
 	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
diff --git a/ltp/iogen.c b/ltp/iogen.c
index 15f340d..1eaab1f 100644
--- a/ltp/iogen.c
+++ b/ltp/iogen.c
@@ -781,6 +781,7 @@ struct file_info    *rec;
 
 	rec->f_riou = BSIZE;
 	if( (fd = open(rec->f_path, O_RDWR|O_DIRECT, 0)) != -1 ) {
+	    char *dio_env;
 #ifdef XFS_IOC_DIOINFO
 	    if(xfsctl(rec->f_path, fd, XFS_IOC_DIOINFO, &finfo) != -1) {
 #else
@@ -790,6 +791,10 @@ struct file_info    *rec;
 bozo!
 #endif
 #endif
+		dio_env = getenv("XFS_DIO_MIN");
+		if (dio_env)
+		    finfo.d_mem = finfo.d_miniosz = atoi(dio_env);
+
 		rec->f_riou = finfo.d_miniosz;
 	    } else {
 		fprintf(stderr,
@@ -1001,6 +1006,7 @@ bozo!
 	if(Owrite == 2) {
 	    close(fd);
 	    if( (fd = open(path, O_CREAT|O_RDWR|O_DIRECT, 0)) != -1 ) {
+		char *dio_env;
 #ifdef XFS_IOC_DIOINFO
 		if(xfsctl(path, fd, XFS_IOC_DIOINFO, &finfo) == -1) {
 #else
@@ -1018,6 +1024,10 @@ bozo!
 		    /*fprintf(stderr, "%s: miniosz=%d\n", 
 			    path, finfo.d_miniosz);*/
 		}
+
+		dio_env = getenv("XFS_DIO_MIN");
+		if (dio_env)
+			finfo.d_mem = finfo.d_miniosz = atoi(dio_env);
 	    } else {
 		fprintf(stderr, "iogen%s: Error %s (%d) opening file %s with flags O_CREAT|O_RDWR|O_DIRECT\n",
 			TagName, SYSERR, errno, path);
diff --git a/src/unwritten_sync.c b/src/unwritten_sync.c
index 6cdf7e8..bf61adf 100644
--- a/src/unwritten_sync.c
+++ b/src/unwritten_sync.c
@@ -27,6 +27,7 @@ main(int argc, char *argv[])
 	off_t offset;
 	char	*file;
 	int	loops;
+	char	*dio_env;
 
 	if(argc != 3) {
 		fprintf(stderr, "%s <loops> <file>\n", argv[0]);
@@ -53,6 +54,10 @@ main(int argc, char *argv[])
 			exit(1);
 		}
 
+		dio_env = getenv("XFS_DIO_MIN");
+		if (dio_env)
+			dio.d_mem = dio.d_miniosz = atoi(dio_env);
+
 		if ((dio.d_miniosz > IO_SIZE) || (dio.d_maxiosz < IO_SIZE)) {
 			fprintf(stderr, "Test won't work - iosize out of range"
 				" (dio.d_miniosz=%d, dio.d_maxiosz=%d)\n",
diff --git a/tests/btrfs/022 b/tests/btrfs/022
old mode 100644
new mode 100755

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
