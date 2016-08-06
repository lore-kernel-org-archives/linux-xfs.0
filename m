Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 63BB47CB0
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 12:25:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B907BAC005
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:25:36 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id sJQqPfUio2eJwBzJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 10:25:34 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 739EC2097C
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:25:33 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3sBTDD6PkDz1048
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 19:25:32 +0200 (CEST)
Resent-Message-ID: <20160813172436.GC3858@nyan>
Resent-To: xfs@oss.sgi.com
Message-Id: <49056a950fa3548694e074995bd7368c4fc0c54d.1471107858.git.felix.janda@posteo.de>
In-Reply-To: <cover.1471107858.git.felix.janda@posteo.de>
References: <cover.1471107858.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sat, 6 Aug 2016 12:45:49 +0200
Subject: [PATCHv2 xfsprogs 05/14] replace ftruncate64 by equivalent ftruncate
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

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 copy/xfs_copy.c           | 2 +-
 fsr/xfs_fsr.c             | 2 +-
 include/darwin.h          | 1 -
 include/freebsd.h         | 1 -
 io/copy_file_range.c      | 4 ++--
 io/truncate.c             | 2 +-
 mdrestore/xfs_mdrestore.c | 2 +-
 mkfs/xfs_mkfs.c           | 2 +-
 8 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 55a9e2c..f038c2e 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -832,7 +832,7 @@ main(int argc, char **argv)
 		if (write_last_block)  {
 			/* ensure regular files are correctly sized */
 
-			if (ftruncate64(target[i].fd, mp->m_sb.sb_dblocks *
+			if (ftruncate(target[i].fd, mp->m_sb.sb_dblocks *
 						source_blocksize))  {
 				do_log(_("%s:  cannot grow data section.\n"),
 					progname);
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 36e0705..d87d020 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1451,7 +1451,7 @@ packfile(char *fname, char *tname, int fd,
 			}
 		}
 	}
-	if (ftruncate64(tfd, statp->bs_size) < 0) {
+	if (ftruncate(tfd, statp->bs_size) < 0) {
 		fsrprintf(_("could not truncate tmpfile: %s : %s\n"),
 				fname, strerror(errno));
 		goto out;
diff --git a/include/darwin.h b/include/darwin.h
index 8708324..5c149a0 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -144,7 +144,6 @@ typedef int64_t		xfs_daddr_t;
 #define lseek64		lseek
 #define pread64		pread
 #define pwrite64	pwrite
-#define ftruncate64	ftruncate
 #define fdatasync	fsync
 #define memalign(a,sz)	valloc(sz)
 
diff --git a/include/freebsd.h b/include/freebsd.h
index f7ab8fa..f5e7fa9 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -34,7 +34,6 @@
 #define __LITTLE_ENDIAN	LITTLE_ENDIAN
 
 /* FreeBSD file API is 64-bit aware */
-#define ftruncate64	ftruncate
 #define lseek64		lseek
 #define pwrite64	pwrite
 #define pread64		pread
diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index 7ba42b6..88203e9 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -72,9 +72,9 @@ copy_src_filesize(int fd)
 static int
 copy_dst_truncate(void)
 {
-	int ret = ftruncate64(file->fd, 0);
+	int ret = ftruncate(file->fd, 0);
 	if (ret < 0)
-		perror("ftruncate64");
+		perror("ftruncate");
 	return ret;
 }
 
diff --git a/io/truncate.c b/io/truncate.c
index f2df168..20bada8 100644
--- a/io/truncate.c
+++ b/io/truncate.c
@@ -38,7 +38,7 @@ truncate_f(
 		return 0;
 	}
 
-	if (ftruncate64(file->fd, offset) < 0) {
+	if (ftruncate(file->fd, offset) < 0) {
 		perror("ftruncate");
 		return 0;
 	}
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 26d61eb..1540dcd 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -124,7 +124,7 @@ perform_restore(
 	if (is_target_file)  {
 		/* ensure regular files are correctly sized */
 
-		if (ftruncate64(dst_fd, sb.sb_dblocks * sb.sb_blocksize))
+		if (ftruncate(dst_fd, sb.sb_dblocks * sb.sb_blocksize))
 			fatal("cannot set filesystem image size: %s\n",
 				strerror(errno));
 	} else  {
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8b98a8a..5d5fcb7 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2815,7 +2815,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	 * code will succeed.
 	 */
 	if (xi.disfile && xi.dsize * xi.dbsize < dblocks * blocksize) {
-		if (ftruncate64(xi.dfd, dblocks * blocksize) < 0) {
+		if (ftruncate(xi.dfd, dblocks * blocksize) < 0) {
 			fprintf(stderr,
 				_("%s: Growing the data section failed\n"),
 				progname);
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
