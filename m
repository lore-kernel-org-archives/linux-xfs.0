Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9JAU6OK178151 for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 05:30:06 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF327F7DE24
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 03:38:05 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id ihU4EnVn6E8vw0RO
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 03:38:05 -0700 (PDT)
Received: by mail-bw0-f53.google.com with SMTP id 11so2102048bke.26
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 03:30:04 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 6/8] xfstests: add fiemap operation
Date: Wed, 19 Oct 2011 14:29:47 +0400
Message-Id: <1319020189-13584-7-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
References: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
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
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, jack@suse.cz, hch@infradead.org, aelder@sgi.com
Cc: Dmitry Monakhov <dmonakhov@openvz.org>

Related bug: http://patchwork.ozlabs.org/patch/118863

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 ltp/fsstress.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index baccbbd..19b5858 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -24,6 +24,9 @@
 #ifdef HAVE_ATTR_ATTRIBUTES_H
 #include <attr/attributes.h>
 #endif
+#ifdef HAVE_LINUX_FIEMAP_H
+#include <linux/fiemap.h>
+#endif
 #ifdef FALLOCATE
 #include <linux/falloc.h>
 #ifndef FALLOC_FL_PUNCH_HOLE
@@ -65,6 +68,7 @@ typedef enum {
 	OP_DWRITE,
 	OP_FALLOCATE,
 	OP_FDATASYNC,
+	OP_FIEMAP,
 	OP_FREESP,
 	OP_FSYNC,
 	OP_GETATTR,
@@ -149,6 +153,7 @@ void	dread_f(int, long);
 void	dwrite_f(int, long);
 void	fallocate_f(int, long);
 void	fdatasync_f(int, long);
+void	fiemap_f(int, long);
 void	freesp_f(int, long);
 void	fsync_f(int, long);
 void	getdents_f(int, long);
@@ -184,6 +189,7 @@ opdesc_t	ops[] = {
 	{ OP_DWRITE, "dwrite", dwrite_f, 4, 1 },
 	{ OP_FALLOCATE, "fallocate", fallocate_f, 1, 1 },
 	{ OP_FDATASYNC, "fdatasync", fdatasync_f, 1, 1 },
+	{ OP_FIEMAP, "fiemap", fiemap_f, 1, 1 },
 	{ OP_FREESP, "freesp", freesp_f, 1, 1 },
 	{ OP_FSYNC, "fsync", fsync_f, 1, 1 },
 	{ OP_GETATTR, "getattr", getattr_f, 1, 0 },
@@ -2162,6 +2168,76 @@ fdatasync_f(int opno, long r)
 	free_pathname(&f);
 	close(fd);
 }
+void
+fiemap_f(int opno, long r)
+{
+#ifdef HAVE_LINUX_FIEMAP_H
+	int		e;
+	pathname_t	f;
+	int		fd;
+	__int64_t	lr;
+	off64_t		off;
+	struct stat64	stb;
+	int		v;
+	char		st[1024];
+	int blocks_to_map;
+	struct fiemap *fiemap;
+
+	init_pathname(&f);
+	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
+		if (v)
+			printf("%d/%d: fiemap - no filename\n", procid, opno);
+		free_pathname(&f);
+		return;
+	}
+	fd = open_path(&f, O_RDWR);
+	e = fd < 0 ? errno : 0;
+	check_cwd();
+	if (fd < 0) {
+		if (v)
+			printf("%d/%d: fiemap - open %s failed %d\n",
+				procid, opno, f.path, e);
+		free_pathname(&f);
+		return;
+	}
+	if (fstat64(fd, &stb) < 0) {
+		if (v)
+			printf("%d/%d: fiemap - fstat64 %s failed %d\n",
+				procid, opno, f.path, errno);
+		free_pathname(&f);
+		close(fd);
+		return;
+	}
+	inode_info(st, sizeof(st), &stb, v);
+	blocks_to_map = random() & 0xffff;
+	fiemap = (struct fiemap *)malloc(sizeof(struct fiemap) +
+			(blocks_to_map * sizeof(struct fiemap_extent)));
+	if (!fiemap) {
+		if (v)
+			printf("%d/%d: malloc failed \n", procid, opno);
+		free_pathname(&f);
+		close(fd);
+		return;
+	}
+	lr = ((__int64_t)random() << 32) + random();
+	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
+	off %= maxfsize;
+	fiemap->fm_flags = random() & (FIEMAP_FLAGS_COMPAT | 0x10000);
+	fiemap->fm_extent_count = blocks_to_map;
+	fiemap->fm_mapped_extents = random() & 0xffff;
+	fiemap->fm_start = off;
+	fiemap->fm_length = ((__int64_t)random() << 32) + random();
+
+	e = ioctl(fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
+	if (v)
+		printf("%d/%d: ioctl(FIEMAP) %s%s %lld %lld %x %d\n",
+		       procid, opno, f.path, st, (long long)fiemap->fm_start,
+		       (long long) fiemap->fm_length, fiemap->fm_flags, e);
+	free(fiemap);
+	free_pathname(&f);
+	close(fd);
+#endif
+}
 
 void
 freesp_f(int opno, long r)
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
