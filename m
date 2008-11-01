Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 01 Nov 2008 12:06:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA1J64NS005925
	for <xfs@oss.sgi.com>; Sat, 1 Nov 2008 12:06:04 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 000A27AD86B
	for <xfs@oss.sgi.com>; Sat,  1 Nov 2008 12:06:05 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id Nxmeqw4AJnawOmMx for <xfs@oss.sgi.com>; Sat, 01 Nov 2008 12:06:05 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 138AFAC3590
	for <xfs@oss.sgi.com>; Sat,  1 Nov 2008 14:06:05 -0500 (CDT)
Message-ID: <490CA89C.6070709@sandeen.net>
Date: Sat, 01 Nov 2008 14:06:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] libdisk: recognize gfs/gfs2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Recognize gfs & gfs2 disk formats.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs-cmds-build/xfsprogs/libdisk/fstype.c
===================================================================
--- xfs-cmds-build.orig/xfsprogs/libdisk/fstype.c
+++ xfs-cmds-build/xfsprogs/libdisk/fstype.c
@@ -68,6 +68,7 @@ swapped(unsigned short a) {
     Added jfs - Christoph Hellwig
     Added sysv - Tim Launchbury
     Added udf - Bryce Nesbitt
+    Added gfs/gfs2 - Eric Sandeen
 */
 
 /*
@@ -192,6 +193,7 @@ fstype(const char *device) {
     struct hpfs_super_block hpfssb;
     struct adfs_super_block adfssb;
     struct sysv_super_block svsb;
+    struct gfs2_sb gfs2sb;
     struct stat statbuf;
 
     /* opening and reading an arbitrary unknown path can have
@@ -382,6 +384,21 @@ fstype(const char *device) {
     }
 
     if (!type) {
+	/* block 64 */
+	if (lseek(fd, GFS_SUPERBLOCK_OFFSET, SEEK_SET) != GFS_SUPERBLOCK_OFFSET
+	    || read(fd, (char *) &gfs2sb, sizeof(gfs2sb)) != sizeof(gfs2sb))
+	    goto io_error;
+	if (gfsmagic(gfs2sb)) {
+		if (gfsformat(gfs2sb) == GFS_FORMAT_FS &&
+		    gfsmultiformat(gfs2sb) == GFS_FORMAT_MULTI)
+			type = "gfs";
+		else if (gfsformat(gfs2sb) == GFS2_FORMAT_FS &&
+			 gfsmultiformat(gfs2sb) == GFS2_FORMAT_MULTI)
+			type = "gfs2";
+	}
+    }
+
+    if (!type) {
 	    /* perhaps the user tries to mount the swap space
 	       on a new disk; warn her before she does mkfs on it */
 	    int pagesize = getpagesize();
Index: xfs-cmds-build/xfsprogs/libdisk/fstype.h
===================================================================
--- xfs-cmds-build.orig/xfsprogs/libdisk/fstype.h
+++ xfs-cmds-build/xfsprogs/libdisk/fstype.h
@@ -242,6 +242,56 @@ struct ocfs_volume_label {
 #define ocfslabellen(o)	assemble2le(o.label_len)
 #define OCFS_MAGIC	"OracleCFS"
 
+/* Common gfs/gfs2 constants: */
+#define GFS_MAGIC               0x01161970
+#define GFS_DEFAULT_BSIZE       4096
+#define GFS_SUPERBLOCK_OFFSET	(0x10 * GFS_DEFAULT_BSIZE)
+#define GFS_LOCKNAME_LEN        64
+
+/* gfs1 constants: */
+#define GFS_FORMAT_FS           1309
+#define GFS_FORMAT_MULTI        1401
+/* gfs2 constants: */
+#define GFS2_FORMAT_FS          1801
+#define GFS2_FORMAT_MULTI       1900
+
+struct gfs2_meta_header {
+	char mh_magic[4];
+	char mh_type[4];
+	char __pad0[8];          /* Was generation number in gfs1 */
+	char mh_format[4];
+	char __pad1[4];          /* Was incarnation number in gfs1 */
+};
+
+struct gfs2_inum {
+	char no_formal_ino[8];
+	char no_addr[8];
+};
+
+struct gfs2_sb {
+	struct gfs2_meta_header sb_header;
+
+	char sb_fs_format[4];
+	char sb_multihost_format[4];
+	char  __pad0[4];  /* Was superblock flags in gfs1 */
+
+	char sb_bsize[4];
+	char sb_bsize_shift[4];
+	char __pad1[4];   /* Was journal segment size in gfs1 */
+
+	struct gfs2_inum sb_master_dir; /* Was jindex dinode in gfs1 */
+	struct gfs2_inum __pad2; /* Was rindex dinode in gfs1 */
+	struct gfs2_inum sb_root_dir;
+
+	char sb_lockproto[GFS_LOCKNAME_LEN];
+	char sb_locktable[GFS_LOCKNAME_LEN];
+	/* In gfs1, quota and license dinodes followed */
+};
+
+#define gfsmagic(s)		assemble4be(s.sb_header.mh_magic)
+#define gfsformat(s)		assemble4be(s.sb_fs_format)
+#define gfsmultiformat(s)	assemble4be(s.sb_multihost_format)
+
 static inline int
 assemble2le(char *p) {
 	return (p[0] | (p[1] << 8));
@@ -251,3 +301,8 @@ static inline int
 assemble4le(char *p) {
 	return (p[0] | (p[1] << 8) | (p[2] << 16) | (p[3] << 24));
 }
+
+static inline int
+assemble4be(char *p) {
+	return (p[3] | (p[2] << 8) | (p[1] << 16) | (p[0] << 24));
+}
