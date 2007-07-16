Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 22:56:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6G5uFbm029960
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 22:56:16 -0700
Date: Mon, 16 Jul 2007 15:55:40 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] introduce fallocate support into xfs_io
Message-ID: <20070716055540.GO12413810@sgi.com>
References: <20070713184125.GA12156@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713184125.GA12156@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu, cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com, dgc@sgi.com, michael.kerrisk@gmx.net

FYI.

Initial support for fallocate-based pre-allocation in
xfs_io for testing. This currently only works on ia64 because
of the hard coded syscall number and will require autoconf
magic to conditionally compile in this support.

This allows simple command-line based testing of fallocate
based allocation such as:

# ~/xfs_io -f -c "falloc_resvsp 0 1024k" -c "bmap -vp" -c stat /mnt/scratch/fred
/mnt/scratch/fred:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..2047]:       96..2143          0 (96..2143)        2048 10000
fd.path = "/mnt/scratch/fred"
fd.flags = non-sync,non-direct,read-write
stat.ino = 131
stat.type = regular file
stat.size = 0
stat.blocks = 2048
fsxattr.xflags = 0x2 [-p------------]
fsxattr.projid = 0
fsxattr.extsize = 0
fsxattr.nextents = 1
fsxattr.naextents = 0
dioattr.mem = 0x200
dioattr.miniosz = 512
dioattr.maxiosz = 2147483136

Or more complex cases:

# ~/xfs_io -f \
> -c "falloc_allocsp 0 1024k" \
> -c "unresvsp 32k 32k" \
> -c "unresvsp 128k 64k" \
> -c "unresvsp 512k 256k" \
> -c"pwrite 0 16k" \
> -c "pwrite 96k 128k" \
> -c "pwrite 640k 384k" \
> -c "bmap -vp" \
> -c "falloc_resvsp 0 1024k" \
> -c "bmap -vvp" /mnt/scratch/fred
wrote 16384/16384 bytes at offset 0
16 KiB, 4 ops; 0.0000 sec (274.123 MiB/sec and 70175.4386 ops/sec)
wrote 131072/131072 bytes at offset 98304
128 KiB, 32 ops; 0.0000 sec (338.753 MiB/sec and 86720.8672 ops/sec)
wrote 393216/393216 bytes at offset 655360
384 KiB, 96 ops; 0.0000 sec (386.200 MiB/sec and 98867.1473 ops/sec)
/mnt/scratch/fred:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..31]:         96..127           0 (96..127)           32
   1: [32..63]:        128..159          0 (128..159)          32 10000
   2: [64..127]:       hole                                    64
   3: [128..191]:      224..287          0 (224..287)          64 10000
   4: [192..447]:      288..543          0 (288..543)         256
   5: [448..1023]:     544..1119         0 (544..1119)        576 10000
   6: [1024..1279]:    hole                                   256
   7: [1280..2047]:    1376..2143        0 (1376..2143)       768
/mnt/scratch/fred:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..31]:         96..127           0 (96..127)           32
   1: [32..191]:       128..287          0 (128..287)         160 10000
   2: [192..447]:      288..543          0 (288..543)         256
   3: [448..1279]:     544..1375         0 (544..1375)        832 10000
   4: [1280..2047]:    1376..2143        0 (1376..2143)       768
 FLAG Values:
    010000 Unwritten preallocated extent
    001000 Doesn't begin on stripe unit
    000100 Doesn't end   on stripe unit
    000010 Doesn't begin on stripe width
    000001 Doesn't end   on stripe width

Yes, that looks like it filled all the holes properly, and the allocator
allocated the right holes on disk to merge adjacent extents when hole
filling. ;)

---
 xfsprogs/io/prealloc.c |   72 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

Index: xfs-cmds/xfsprogs/io/prealloc.c
===================================================================
--- xfs-cmds.orig/xfsprogs/io/prealloc.c	2006-11-15 19:00:31.000000000 +1100
+++ xfs-cmds/xfsprogs/io/prealloc.c	2007-07-16 15:25:44.041513574 +1000
@@ -26,6 +26,8 @@ static cmdinfo_t allocsp_cmd;
 static cmdinfo_t freesp_cmd;
 static cmdinfo_t resvsp_cmd;
 static cmdinfo_t unresvsp_cmd;
+static cmdinfo_t falloc_allocsp_cmd;
+static cmdinfo_t falloc_resvsp_cmd;
 
 static int
 offset_length(
@@ -119,6 +121,56 @@ unresvsp_f(
 	return 0;
 }
 
+/*
+ * Hack, hack, hackety-hack-hack.
+ *
+ * This only works for ia64...
+ */
+#define __NR_fallocate                1303
+
+/*
+ * someday there'll be a real header file
+ */
+#define FALLOC_FL_KEEP_SIZE     0x01
+#define FALLOC_ALLOCATE         0x0
+#define FALLOC_RESV_SPACE       FALLOC_FL_KEEP_SIZE
+
+static int
+fallocate_allocsp_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_flock64_t	segment;
+
+	if (!offset_length(argv[1], argv[2], &segment))
+		return 0;
+
+	if (syscall(__NR_fallocate, file->fd, FALLOC_ALLOCATE,
+			segment.l_start, segment.l_len)) {
+		perror("FALLOC_ALLOCATE");
+		return 0;
+	}
+	return 0;
+}
+
+static int
+fallocate_resvsp_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_flock64_t	segment;
+
+	if (!offset_length(argv[1], argv[2], &segment))
+		return 0;
+
+	if (syscall(__NR_fallocate, file->fd, FALLOC_RESV_SPACE,
+			segment.l_start, segment.l_len)) {
+		perror("FALLOC_ALLOCATE");
+		return 0;
+	}
+	return 0;
+}
+
 void
 prealloc_init(void)
 {
@@ -156,8 +208,28 @@ prealloc_init(void)
 	unresvsp_cmd.oneline =
 		_("frees reserved space associated with part of a file");
 
+	falloc_allocsp_cmd.name = _("falloc_allocsp");
+	falloc_allocsp_cmd.cfunc = fallocate_allocsp_f;
+	falloc_allocsp_cmd.argmin = 2;
+	falloc_allocsp_cmd.argmax = 2;
+	falloc_allocsp_cmd.flags = CMD_NOMAP_OK;
+	falloc_allocsp_cmd.args = _("off len");
+	falloc_allocsp_cmd.oneline =
+		_("allocates space associated with part of a file via fallocate");
+
+	falloc_resvsp_cmd.name = _("falloc_resvsp");
+	falloc_resvsp_cmd.cfunc = fallocate_resvsp_f;
+	falloc_resvsp_cmd.argmin = 2;
+	falloc_resvsp_cmd.argmax = 2;
+	falloc_resvsp_cmd.flags = CMD_NOMAP_OK;
+	falloc_resvsp_cmd.args = _("off len");
+	falloc_resvsp_cmd.oneline =
+		_("reserves space associated with part of a file via fallocate");
+
 	add_command(&allocsp_cmd);
 	add_command(&freesp_cmd);
 	add_command(&resvsp_cmd);
 	add_command(&unresvsp_cmd);
+	add_command(&falloc_allocsp_cmd);
+	add_command(&falloc_resvsp_cmd);
 }
