Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AE6187CEB
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 02:35:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 172F0AC006
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 00:35:50 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id JPi58X2BAUNVXRr7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 07 Aug 2016 00:35:48 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 8CE5720850
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:47 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3s6XQW0mFJz104K
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:47 +0200 (CEST)
Message-Id: <e62e8eae310f54fee1391ee069e9e6d88a9c5483.1470555003.git.felix.janda@posteo.de>
In-Reply-To: <cover.1470555003.git.felix.janda@posteo.de>
References: <cover.1470555003.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sat, 6 Aug 2016 12:45:54 +0200
Subject: [PATCH xfsprogs 09/14] replace pwrite64 by equivalent pwrite
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1576382363631761885=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1576382363631761885==
Content-Type: text/plain

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 copy/xfs_copy.c           |  2 +-
 include/darwin.h          |  1 -
 include/freebsd.h         |  1 -
 io/pwrite.c               | 10 +++++-----
 libxfs/rdwr.c             |  6 +++---
 mdrestore/xfs_mdrestore.c |  4 ++--
 mkfs/xfs_mkfs.c           |  2 +-
 po/de.po                  |  4 ++--
 po/pl.po                  |  8 ++++----
 9 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index cc5207d..816ab29 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -860,7 +860,7 @@ main(int argc, char **argv)
 
 			off = mp->m_sb.sb_dblocks * source_blocksize;
 			off -= sizeof(lb);
-			if (pwrite64(target[i].fd, lb, sizeof(lb), off) < 0)  {
+			if (pwrite(target[i].fd, lb, sizeof(lb), off) < 0)  {
 				do_log(_("%s:  failed to write last block\n"),
 					progname);
 				do_log(_("\tIs target \"%s\" too small?\n"),
diff --git a/include/darwin.h b/include/darwin.h
index f4dbd9f..fb13915 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -141,7 +141,6 @@ typedef u_int64_t	xfs_ino_t;
 typedef u_int32_t	xfs_dev_t;
 typedef int64_t		xfs_daddr_t;
 
-#define pwrite64	pwrite
 #define fdatasync	fsync
 #define memalign(a,sz)	valloc(sz)
 
diff --git a/include/freebsd.h b/include/freebsd.h
index 041dafe..df924ef 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -34,7 +34,6 @@
 #define __LITTLE_ENDIAN	LITTLE_ENDIAN
 
 /* FreeBSD file API is 64-bit aware */
-#define pwrite64	pwrite
 #define fdatasync	fsync
 #define memalign(a,sz)	valloc(sz)
 
diff --git a/io/pwrite.c b/io/pwrite.c
index 67631ce..7c0bb7f 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -101,7 +101,7 @@ do_pwrite(
 	ssize_t		buffer_size)
 {
 	if (!vectors)
-		return pwrite64(fd, buffer, min(count, buffer_size), offset);
+		return pwrite(fd, buffer, min(count, buffer_size), offset);
 
 	return do_pwritev(fd, offset, count, buffer_size);
 }
@@ -137,7 +137,7 @@ write_random(
 		if (bytes == 0)
 			break;
 		if (bytes < 0) {
-			perror("pwrite64");
+			perror("pwrite");
 			return -1;
 		}
 		ops++;
@@ -175,7 +175,7 @@ write_backward(
 		if (bytes == 0)
 			return ops;
 		if (bytes < 0) {
-			perror("pwrite64");
+			perror("pwrite");
 			return -1;
 		}
 		ops++;
@@ -193,7 +193,7 @@ write_backward(
 		if (bytes == 0)
 			break;
 		if (bytes < 0) {
-			perror("pwrite64");
+			perror("pwrite");
 			return -1;
 		}
 		ops++;
@@ -228,7 +228,7 @@ write_buffer(
 		if (bytes == 0)
 			break;
 		if (bytes < 0) {
-			perror("pwrite64");
+			perror("pwrite");
 			return -1;
 		}
 		ops++;
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 36c39d9..8e9d86a 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1083,16 +1083,16 @@ __write_buf(int fd, void *buf, int len, off64_t offset, int flags)
 {
 	int	sts;
 
-	sts = pwrite64(fd, buf, len, offset);
+	sts = pwrite(fd, buf, len, offset);
 	if (sts < 0) {
 		int error = errno;
-		fprintf(stderr, _("%s: pwrite64 failed: %s\n"),
+		fprintf(stderr, _("%s: pwrite failed: %s\n"),
 			progname, strerror(error));
 		if (flags & LIBXFS_B_EXIT)
 			exit(1);
 		return -error;
 	} else if (sts != len) {
-		fprintf(stderr, _("%s: error - pwrite64 only %d of %d bytes\n"),
+		fprintf(stderr, _("%s: error - pwrite only %d of %d bytes\n"),
 			progname, sts, len);
 		if (flags & LIBXFS_B_EXIT)
 			exit(1);
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 1540dcd..0d399f1 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -134,7 +134,7 @@ perform_restore(
 		off64_t		off;
 
 		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
-		if (pwrite64(dst_fd, lb, sizeof(lb), off) < 0)
+		if (pwrite(dst_fd, lb, sizeof(lb), off) < 0)
 			fatal("failed to write last block, is target too "
 				"small? (error: %s)\n", strerror(errno));
 	}
@@ -146,7 +146,7 @@ perform_restore(
 			print_progress("%lld MB read", bytes_read >> 20);
 
 		for (cur_index = 0; cur_index < mb_count; cur_index++) {
-			if (pwrite64(dst_fd, &block_buffer[cur_index <<
+			if (pwrite(dst_fd, &block_buffer[cur_index <<
 					tmb.mb_blocklog], block_size,
 					be64_to_cpu(block_index[cur_index]) <<
 						BBSHIFT) < 0)
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5d5fcb7..e038d48 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1111,7 +1111,7 @@ zero_old_xfs_structures(
 	off = 0;
 	for (i = 1; i < sb.sb_agcount; i++)  {
 		off += sb.sb_agblocks;
-		if (pwrite64(xi->dfd, buf, new_sb->sb_sectsize,
+		if (pwrite(xi->dfd, buf, new_sb->sb_sectsize,
 					off << sb.sb_blocklog) == -1)
 			break;
 	}
diff --git a/po/de.po b/po/de.po
index ff1930e..fab2667 100644
--- a/po/de.po
+++ b/po/de.po
@@ -5893,8 +5893,8 @@ msgstr "%s: lesen fehlgeschlagen: %s\n"
 
 #: .././libxfs/rdwr.c:502
 #, c-format
-msgid "%s: pwrite64 failed: %s\n"
-msgstr "%s: pwrite64 fehlgeschlagen: %s\n"
+msgid "%s: pwrite failed: %s\n"
+msgstr "%s: pwrite fehlgeschlagen: %s\n"
 
 #: .././libxfs/rdwr.c:509
 #, c-format
diff --git a/po/pl.po b/po/pl.po
index 33a9d81..49209f3 100644
--- a/po/pl.po
+++ b/po/pl.po
@@ -5940,13 +5940,13 @@ msgstr "%s: błąd - odczytano tylko %d z %d bajtów\n"
 
 #: .././libxfs/rdwr.c:878
 #, c-format
-msgid "%s: pwrite64 failed: %s\n"
-msgstr "%s: pwrite64 nie powiodło się: %s\n"
+msgid "%s: pwrite failed: %s\n"
+msgstr "%s: pwrite nie powiodło się: %s\n"
 
 #: .././libxfs/rdwr.c:884
 #, c-format
-msgid "%s: error - pwrite64 only %d of %d bytes\n"
-msgstr "%s: błąd - wykonano pwrite64 tylko %d z %d bajtów\n"
+msgid "%s: error - pwrite only %d of %d bytes\n"
+msgstr "%s: błąd - wykonano pwrite tylko %d z %d bajtów\n"
 
 #: .././libxfs/rdwr.c:920
 #, c-format
-- 
2.7.3


--===============1576382363631761885==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1576382363631761885==--
