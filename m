Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2DA607CE8
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 02:35:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 71522AC001
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 00:35:50 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id Jrcdto8EBiizg3Gi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 07 Aug 2016 00:35:47 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id B0EAA20A76
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:46 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3s6XQV1pBqz1043
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:46 +0200 (CEST)
Message-Id: <63ec40703b14df0c99b2d479dc1739c3a2fb3064.1470555003.git.felix.janda@posteo.de>
In-Reply-To: <cover.1470555003.git.felix.janda@posteo.de>
References: <cover.1470555003.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sat, 6 Aug 2016 12:45:50 +0200
Subject: [PATCH xfsprogs 07/14] replace lseek64 by equivalent lseek
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8433870617652352852=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8433870617652352852==
Content-Type: text/plain

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 copy/xfs_copy.c     | 10 +++++-----
 fsr/xfs_fsr.c       | 10 +++++-----
 include/darwin.h    |  1 -
 include/freebsd.h   |  1 -
 io/pread.c          |  6 +++---
 io/seek.c           |  6 +++---
 libxfs/rdwr.c       |  2 +-
 logprint/log_misc.c |  4 ++--
 logprint/logprint.c |  2 +-
 po/de.po            | 16 ++++++++--------
 po/pl.po            | 16 ++++++++--------
 repair/sb.c         |  6 +++---
 12 files changed, 39 insertions(+), 41 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index f038c2e..cc5207d 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -162,7 +162,7 @@ check_errors(void)
 			if (target[i].err_type == 0)
 				do_log(_("write error"));
 			else
-				do_log(_("lseek64 error"));
+				do_log(_("lseek error"));
 			do_log(_(" at offset %lld\n"), target[i].position);
 		}
 	}
@@ -192,7 +192,7 @@ do_write(
 		buf = &w_buf;
 
 	if (target[args->id].position != buf->position)  {
-		if (lseek64(args->fd, buf->position, SEEK_SET) < 0)  {
+		if (lseek(args->fd, buf->position, SEEK_SET) < 0)  {
 			error = target[args->id].err_type = 1;
 		} else  {
 			target[args->id].position = buf->position;
@@ -263,7 +263,7 @@ handler(int sig)
 						target[i].position);
 				} else  {
 					do_warn(
-		_("%s:  lseek64 error on target %d \"%s\" at offset %lld\n"),
+		_("%s:  lseek error on target %d \"%s\" at offset %lld\n"),
 						progname, i, target[i].name,
 						target[i].position);
 				}
@@ -388,9 +388,9 @@ read_wbuf(int fd, wbuf *buf, xfs_mount_t *mp)
 	}
 
 	if (source_position != buf->position)  {
-		lres = lseek64(fd, buf->position, SEEK_SET);
+		lres = lseek(fd, buf->position, SEEK_SET);
 		if (lres < 0LL)  {
-			do_warn(_("%s:  lseek64 failure at offset %lld\n"),
+			do_warn(_("%s:  lseek failure at offset %lld\n"),
 				progname, source_position);
 			die_perror();
 		}
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index d87d020..98390e7 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1318,7 +1318,7 @@ packfile(char *fname, char *tname, int fd,
 				fsrprintf(_("could not trunc tmp %s\n"),
 					   tname);
 			}
-			if (lseek64(tfd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
+			if (lseek(tfd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
 				fsrprintf(_("could not lseek in tmpfile: %s : %s\n"),
 				   tname, strerror(errno));
 				goto out;
@@ -1338,7 +1338,7 @@ packfile(char *fname, char *tname, int fd,
 					" %s\n"), tname);
 				goto out;
 			}
-			if (lseek64(tfd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
+			if (lseek(tfd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
 				fsrprintf(_("could not lseek in tmpfile: %s : %s\n"),
 				   tname, strerror(errno));
 				goto out;
@@ -1346,7 +1346,7 @@ packfile(char *fname, char *tname, int fd,
 		}
 	} /* end of space allocation loop */
 
-	if (lseek64(tfd, 0, SEEK_SET)) {
+	if (lseek(tfd, 0, SEEK_SET)) {
 		fsrprintf(_("Couldn't rewind on temporary file\n"));
 		goto out;
 	}
@@ -1366,12 +1366,12 @@ packfile(char *fname, char *tname, int fd,
 	for (extent = 0; extent < nextents; extent++) {
 		pos = outmap[extent].bmv_offset;
 		if (outmap[extent].bmv_block == -1) {
-			if (lseek64(tfd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
+			if (lseek(tfd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
 				fsrprintf(_("could not lseek in tmpfile: %s : %s\n"),
 				   tname, strerror(errno));
 				goto out;
 			}
-			if (lseek64(fd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
+			if (lseek(fd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
 				fsrprintf(_("could not lseek in file: %s : %s\n"),
 				   fname, strerror(errno));
 				goto out;
diff --git a/include/darwin.h b/include/darwin.h
index 5c149a0..850d733 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -141,7 +141,6 @@ typedef u_int64_t	xfs_ino_t;
 typedef u_int32_t	xfs_dev_t;
 typedef int64_t		xfs_daddr_t;
 
-#define lseek64		lseek
 #define pread64		pread
 #define pwrite64	pwrite
 #define fdatasync	fsync
diff --git a/include/freebsd.h b/include/freebsd.h
index f5e7fa9..784e287 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -34,7 +34,6 @@
 #define __LITTLE_ENDIAN	LITTLE_ENDIAN
 
 /* FreeBSD file API is 64-bit aware */
-#define lseek64		lseek
 #define pwrite64	pwrite
 #define pread64		pread
 #define fdatasync	fsync
diff --git a/io/pread.c b/io/pread.c
index b98355f..cafead0 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -233,7 +233,7 @@ read_random(
 	int		ops = 0;
 
 	srandom(seed);
-	end = lseek64(fd, 0, SEEK_END);
+	end = lseek(fd, 0, SEEK_END);
 	offset = (eof || offset > end) ? end : offset;
 	if ((bytes = (offset % buffersize)))
 		offset -= bytes;
@@ -279,8 +279,8 @@ read_backward(
 	long long	cnt = *count;
 	int		ops = 0;
 
-	end = lseek64(fd, 0, SEEK_END);
-	off = eof ? end : min(end, lseek64(fd, off, SEEK_SET));
+	end = lseek(fd, 0, SEEK_END);
+	off = eof ? end : min(end, lseek(fd, off, SEEK_SET));
 	if ((end = off - cnt) < 0) {
 		cnt += end;	/* subtraction, end is negative */
 		end = 0;
diff --git a/io/seek.c b/io/seek.c
index 35a369e..d06375d 100644
--- a/io/seek.c
+++ b/io/seek.c
@@ -147,7 +147,7 @@ seek_f(
 	 * decide if we want to display that type of entry.
 	 */
 	if (flag & SEEK_HFLAG) {
-		offset = lseek64(file->fd, start, SEEK_HOLE);
+		offset = lseek(file->fd, start, SEEK_HOLE);
 		if ((start == offset) || !(flag & SEEK_DFLAG)) {
 			/*
 			 * this offset is a hole or are only displaying holes.
@@ -162,7 +162,7 @@ seek_f(
 
 	/* The offset is not a hole, or we are looking just for data */
 	current = DATA;
-	offset = lseek64(file->fd, start, SEEK_DATA);
+	offset = lseek(file->fd, start, SEEK_DATA);
 
 found_hole:
 	/*
@@ -202,7 +202,7 @@ found_hole:
 
 		current ^= 1;		/* alternate between data and hole */
 		start = offset;
-		offset = lseek64(file->fd, start, seekinfo[current].seektype);
+		offset = lseek(file->fd, start, seekinfo[current].seektype);
 	}
 	return 0;
 }
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 0ec38c5..cb74b3c 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -88,7 +88,7 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 	fd = libxfs_device_to_fd(btp->dev);
 	start_offset = LIBXFS_BBTOOFF64(start);
 
-	if ((lseek64(fd, start_offset, SEEK_SET)) < 0) {
+	if ((lseek(fd, start_offset, SEEK_SET)) < 0) {
 		fprintf(stderr, _("%s: %s seek to offset %llu failed: %s\n"),
 			progname, __FUNCTION__,
 			(unsigned long long)start_offset, strerror(errno));
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index e6ee832..8a687d5 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -887,8 +887,8 @@ xlog_print_lseek(struct xlog *log, int fd, xfs_daddr_t blkno, int whence)
 		offset = BBTOOFF64(blkno+log->l_logBBstart);
 	else
 		offset = BBTOOFF64(blkno);
-	if (lseek64(fd, offset, whence) < 0) {
-		fprintf(stderr, _("%s: lseek64 to %lld failed: %s\n"),
+	if (lseek(fd, offset, whence) < 0) {
+		fprintf(stderr, _("%s: lseek to %lld failed: %s\n"),
 			progname, (long long)offset, strerror(errno));
 		exit(1);
 	}
diff --git a/logprint/logprint.c b/logprint/logprint.c
index a5c9b32..37b8cb9 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -80,7 +80,7 @@ logstat(xfs_mount_t *mp)
 			x.dname, strerror(errno));
 		exit(1);
 	}
-	lseek64(fd, 0, SEEK_SET);
+	lseek(fd, 0, SEEK_SET);
 	if (read(fd, buf, sizeof(buf)) != sizeof(buf)) {
 		fprintf(stderr, _("    read of XFS superblock failed\n"));
 		exit(1);
diff --git a/po/de.po b/po/de.po
index 61a60f3..ff1930e 100644
--- a/po/de.po
+++ b/po/de.po
@@ -45,8 +45,8 @@ msgid "write error"
 msgstr "Schreibfehler"
 
 #: .././copy/xfs_copy.c:146
-msgid "lseek64 error"
-msgstr "lseek64-Fehler"
+msgid "lseek error"
+msgstr "lseek-Fehler"
 
 #: .././copy/xfs_copy.c:147
 #, c-format
@@ -70,8 +70,8 @@ msgstr "%s: Schreibfehler auf Ziel %d »%s« bei Versatz %lld\n"
 
 #: .././copy/xfs_copy.c:260
 #, c-format
-msgid "%s:  lseek64 error on target %d \"%s\" at offset %lld\n"
-msgstr "%s: lseek64-Fehler auf Ziel %d »%s« bei Versatz %lld\n"
+msgid "%s:  lseek error on target %d \"%s\" at offset %lld\n"
+msgstr "%s: lseek-Fehler auf Ziel %d »%s« bei Versatz %lld\n"
 
 #: .././copy/xfs_copy.c:266
 #, c-format
@@ -104,8 +104,8 @@ msgstr "Aufruf: %s [-bd] [-L Protokolldatei] Quelle Ziel [Ziel ...]\n"
 
 #: .././copy/xfs_copy.c:386
 #, c-format
-msgid "%s:  lseek64 failure at offset %lld\n"
-msgstr "%s:  lseek64-Fehlschlag bei Versatz %lld\n"
+msgid "%s:  lseek failure at offset %lld\n"
+msgstr "%s:  lseek-Fehlschlag bei Versatz %lld\n"
 
 #: .././copy/xfs_copy.c:401
 #, c-format
@@ -6472,8 +6472,8 @@ msgstr "DQUOT: Magische 0x%hx Markierungen 0%ho\n"
 
 #: .././logprint/log_misc.c:821
 #, c-format
-msgid "%s: lseek64 to %lld failed: %s\n"
-msgstr "%s: lseek64 auf %lld fehlgeschlagen: %s\n"
+msgid "%s: lseek to %lld failed: %s\n"
+msgstr "%s: lseek auf %lld fehlgeschlagen: %s\n"
 
 #: .././logprint/log_misc.c:864
 #, c-format
diff --git a/po/pl.po b/po/pl.po
index 9d5128f..33a9d81 100644
--- a/po/pl.po
+++ b/po/pl.po
@@ -44,8 +44,8 @@ msgid "write error"
 msgstr "błąd zapisu"
 
 #: .././copy/xfs_copy.c:146
-msgid "lseek64 error"
-msgstr "błąd lseek64"
+msgid "lseek error"
+msgstr "błąd lseek"
 
 #: .././copy/xfs_copy.c:147
 #, c-format
@@ -69,8 +69,8 @@ msgstr "%s: błąd zapisu przy celu %d \"%s\" pod offsetem %lld\n"
 
 #: .././copy/xfs_copy.c:241
 #, c-format
-msgid "%s:  lseek64 error on target %d \"%s\" at offset %lld\n"
-msgstr "%s: błąd lseek64 przy celu %d \"%s\" pod offsetem %lld\n"
+msgid "%s:  lseek error on target %d \"%s\" at offset %lld\n"
+msgstr "%s: błąd lseek przy celu %d \"%s\" pod offsetem %lld\n"
 
 #: .././copy/xfs_copy.c:247
 #, c-format
@@ -103,8 +103,8 @@ msgstr "Składnia: %s [-bdV] [-L plik_logu] źródło cel [cel ...]\n"
 
 #: .././copy/xfs_copy.c:367
 #, c-format
-msgid "%s:  lseek64 failure at offset %lld\n"
-msgstr "%s: niepowodzenie lseek64 pod offsetem %lld\n"
+msgid "%s:  lseek failure at offset %lld\n"
+msgstr "%s: niepowodzenie lseek pod offsetem %lld\n"
 
 #: .././copy/xfs_copy.c:382
 #, c-format
@@ -6394,8 +6394,8 @@ msgstr ""
 
 #: .././logprint/log_misc.c:863
 #, c-format
-msgid "%s: lseek64 to %lld failed: %s\n"
-msgstr "%s: lseek64 na %lld nie powiodło się: %s\n"
+msgid "%s: lseek to %lld failed: %s\n"
+msgstr "%s: lseek na %lld nie powiodło się: %s\n"
 
 #: .././logprint/log_misc.c:909
 #, c-format
diff --git a/repair/sb.c b/repair/sb.c
index a8170ba..ad1a29f 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -138,7 +138,7 @@ __find_secondary_sb(
 		/*
 		 * read disk 1 MByte at a time.
 		 */
-		if (lseek64(x.dfd, off, SEEK_SET) != off)  {
+		if (lseek(x.dfd, off, SEEK_SET) != off)  {
 			done = 1;
 		}
 
@@ -512,7 +512,7 @@ write_primary_sb(xfs_sb_t *sbp, int size)
 	}
 	memset(buf, 0, size);
 
-	if (lseek64(x.dfd, 0LL, SEEK_SET) != 0LL) {
+	if (lseek(x.dfd, 0LL, SEEK_SET) != 0LL) {
 		free(buf);
 		do_error(_("couldn't seek to offset 0 in filesystem\n"));
 	}
@@ -551,7 +551,7 @@ get_sb(xfs_sb_t *sbp, xfs_off_t off, int size, xfs_agnumber_t agno)
 
 	/* try and read it first */
 
-	if (lseek64(x.dfd, off, SEEK_SET) != off)  {
+	if (lseek(x.dfd, off, SEEK_SET) != off)  {
 		do_warn(
 	_("error reading superblock %u -- seek to offset %" PRId64 " failed\n"),
 			agno, off);
-- 
2.7.3


--===============8433870617652352852==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8433870617652352852==--
