Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n08J9Fr9023304 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 13:09:15 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F93D17C010C
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 11:09:14 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id mKboIizljm7EUnQ1 for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2009 11:09:14 -0800 (PST)
Message-ID: <49664243.1090405@redhat.com>
Date: Thu, 08 Jan 2009 12:13:23 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: add btrfs detection to libdisk
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>
Cc: "MASON,CHRISTOPHER" <CHRIS.MASON@oracle.com>

Now that the btrfs disk format has stabilized, libdisk can
recognize it and mkfs.xfs will not overwrite it w/o "-f" :

# mkfs.btrfs -l 16384 -L mylabel -n 8192 -s 4096 /tmp/fsfile 
fs created label mylabel on /tmp/fsfile
        nodesize 8192 leafsize 16384 sectorsize 4096 size 1.28GB
Btrfs v0.16-37-gb8271dc
# mkfs.xfs /tmp/fsfile 
mkfs.xfs: /tmp/fsfile appears to contain an existing filesystem (btrfs).
mkfs.xfs: Use the -f option to force overwrite.

This'll fix up xfsqa failures when mkfs.btrfs is found, too.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/libdisk/fstype.c b/libdisk/fstype.c
index 775b74b..f84b4e4 100644
--- a/libdisk/fstype.c
+++ b/libdisk/fstype.c
@@ -68,7 +68,7 @@ swapped(unsigned short a) {
     Added jfs - Christoph Hellwig
     Added sysv - Tim Launchbury
     Added udf - Bryce Nesbitt
-    Added gfs/gfs2 - Eric Sandeen
+    Added gfs/gfs2, btrfs - Eric Sandeen
 */
 
 /*
@@ -194,6 +194,7 @@ fstype(const char *device) {
     struct adfs_super_block adfssb;
     struct sysv_super_block svsb;
     struct gfs2_sb gfs2sb;
+    struct btrfs_super_block btrfssb;
     struct stat statbuf;
 
     /* opening and reading an arbitrary unknown path can have
@@ -399,6 +400,17 @@ fstype(const char *device) {
     }
 
     if (!type) {
+	/* block 64 */
+	if (lseek(fd, BTRFS_SUPER_INFO_OFFSET, SEEK_SET) != BTRFS_SUPER_INFO_OFFSET 
+	    || read(fd, (char *) &btrfssb, sizeof(btrfssb)) != sizeof(btrfssb))
+	    goto io_error;
+	if (!strncmp((char *)(btrfssb.magic), BTRFS_MAGIC,
+                    sizeof(btrfssb.magic))) {
+		type = "btrfs";
+	}
+    }
+
+    if (!type) {
 	    /* perhaps the user tries to mount the swap space
 	       on a new disk; warn her before she does mkfs on it */
 	    int pagesize = getpagesize();
diff --git a/libdisk/fstype.h b/libdisk/fstype.h
index cd3eec9..ca97434 100644
--- a/libdisk/fstype.h
+++ b/libdisk/fstype.h
@@ -292,6 +292,32 @@ struct gfs2_sb {
 #define gfsformat(s)		assemble4be(s.sb_fs_format)
 #define gfsmultiformat(s)	assemble4be(s.sb_multihost_format)
 
+/* btrfs constants */
+#define BTRFS_SUPER_INFO_OFFSET (64 * 1024)
+
+/* 32 bytes in various csum fields */
+#define BTRFS_CSUM_SIZE 32
+
+#define BTRFS_FSID_SIZE 16
+
+#define BTRFS_MAGIC "_BHRfS_M"
+
+/*
+ * the super block basically lists the main trees of the FS
+ * it currently lacks any block count etc etc
+ */
+struct btrfs_super_block {
+	char csum[BTRFS_CSUM_SIZE];
+	/* the first 3 fields must match struct btrfs_header */
+	char fsid[BTRFS_FSID_SIZE];    /* FS specific uuid */
+	char bytenr[8]; /* this block number */
+	char flags[8];
+
+	/* allowed to be different from the btrfs_header from here own down */
+	char magic[8];
+	/* more follows but this is all our libdisk cares about*/
+} __attribute__ ((__packed__));
+
 static inline int
 assemble2le(char *p) {
 	return (p[0] | (p[1] << 8));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
