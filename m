Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45296 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbdLMGXJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 01:23:09 -0500
Date: Tue, 12 Dec 2017 22:22:38 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/2] tools/xfs: use XFS hacks to override data block device
 placement
Message-ID: <20171213062238.GQ19219@magnolia>
References: <20171213061825.GO19219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213061825.GO19219@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Richard Wareing <rwareing@fb.com>, david@fromorbit.com, hch@infradead.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This (bcc) patch modifies bcc so that we can override some function
return values.  We then create a new python script containing custom
logic to decide where a file's data goes (rtdev or datadev) and inject
the compiled eBPF code into the kernel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 src/cc/compat/linux/bpf.h         |    7 ++
 src/cc/compat/linux/virtual_bpf.h |    3 +
 src/cc/export/helpers.h           |    2 +
 tools/xfs_rt.py                   |  130 +++++++++++++++++++++++++++++++++++++
 4 files changed, 140 insertions(+), 2 deletions(-)
 create mode 100755 tools/xfs_rt.py

diff --git a/src/cc/compat/linux/bpf.h b/src/cc/compat/linux/bpf.h
index f896897..5a3ec0b 100644
--- a/src/cc/compat/linux/bpf.h
+++ b/src/cc/compat/linux/bpf.h
@@ -677,6 +677,10 @@ union bpf_attr {
  *     @buf: buf to fill
  *     @buf_size: size of the buf
  *     Return : 0 on success or negative error code
+ *
+ * int bpf_override_return(pt_regs, rc)
+ *     @pt_regs: pointer to struct pt_regs
+ *     @rc: the return value to set
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -736,7 +740,8 @@ union bpf_attr {
 	FN(xdp_adjust_meta),		\
 	FN(perf_event_read_value),	\
 	FN(perf_prog_read_value),	\
-	FN(getsockopt),
+	FN(getsockopt),			\
+	FN(override_return),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/src/cc/compat/linux/virtual_bpf.h b/src/cc/compat/linux/virtual_bpf.h
index a2bcf07..7fbc365 100644
--- a/src/cc/compat/linux/virtual_bpf.h
+++ b/src/cc/compat/linux/virtual_bpf.h
@@ -735,7 +735,8 @@ union bpf_attr {
 	FN(xdp_adjust_meta),		\
 	FN(perf_event_read_value),	\
 	FN(perf_prog_read_value),	\
-	FN(getsockopt),
+	FN(getsockopt),			\
+	FN(override_return),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/src/cc/export/helpers.h b/src/cc/export/helpers.h
index 2b64ee8..571191e 100644
--- a/src/cc/export/helpers.h
+++ b/src/cc/export/helpers.h
@@ -204,6 +204,8 @@ static int (*bpf_probe_read)(void *dst, u64 size, const void *unsafe_ptr) =
   (void *) BPF_FUNC_probe_read;
 static u64 (*bpf_ktime_get_ns)(void) =
   (void *) BPF_FUNC_ktime_get_ns;
+static void (*bpf_override_return)(void *ctx, unsigned long rc) =
+  (void *) BPF_FUNC_override_return;
 static u32 (*bpf_get_prandom_u32)(void) =
   (void *) BPF_FUNC_get_prandom_u32;
 static int (*bpf_trace_printk_)(const char *fmt, u64 fmt_size, ...) =
diff --git a/tools/xfs_rt.py b/tools/xfs_rt.py
new file mode 100755
index 0000000..b44fa14
--- /dev/null
+++ b/tools/xfs_rt.py
@@ -0,0 +1,130 @@
+#!/usr/bin/python
+# @lint-avoid-python-3-compatibility-imports
+#
+# xfs_rt     Decide on file data block device placement via custom algorithm.
+#            Uses XFS hacks to inject... stuff.
+#
+# Copyright 2017 Oracle, Inc.
+# Licensed under the Apache License, Version 2.0 (the "License")
+
+from __future__ import print_function
+from bcc import BPF
+import argparse
+from time import sleep, strftime
+import ctypes as ct
+
+# arguments
+examples = """examples:
+    ./xfs_rt
+"""
+parser = argparse.ArgumentParser(
+    description="Custom placement of data file blocks on XFS",
+    formatter_class=argparse.RawDescriptionHelpFormatter,
+    epilog=examples)
+args = parser.parse_args()
+debug = 0
+
+# define BPF program
+bpf_text = """
+#include <uapi/linux/ptrace.h>
+#include <linux/fs.h>
+
+struct xfs_fsop_geom {
+	__u32		blocksize;	/* filesystem (data) block size */
+	__u32		rtextsize;	/* realtime extent size		*/
+	__u32		agblocks;	/* fsblocks in an AG		*/
+	__u32		agcount;	/* number of allocation groups	*/
+	__u32		logblocks;	/* fsblocks in the log		*/
+	__u32		sectsize;	/* (data) sector size, bytes	*/
+	__u32		inodesize;	/* inode size in bytes		*/
+	__u32		imaxpct;	/* max allowed inode space(%)	*/
+	__u64		datablocks;	/* fsblocks in data subvolume	*/
+	__u64		rtblocks;	/* fsblocks in realtime subvol	*/
+	__u64		rtextents;	/* rt extents in realtime subvol*/
+	__u64		logstart;	/* starting fsblock of the log	*/
+	unsigned char	uuid[16];	/* unique id of the filesystem	*/
+	__u32		sunit;		/* stripe unit, fsblocks	*/
+	__u32		swidth;		/* stripe width, fsblocks	*/
+	__s32		version;	/* structure version		*/
+	__u32		flags;		/* superblock version flags	*/
+	__u32		logsectsize;	/* log sector size, bytes	*/
+	__u32		rtsectsize;	/* realtime sector size, bytes	*/
+	__u32		dirblocksize;	/* directory block size, bytes	*/
+	__u32		logsunit;	/* log stripe unit, bytes */
+};
+
+/* Output for XFS_FS_COUNTS */
+struct xfs_fsop_counts {
+	__u64	freedata;	/* free data section blocks */
+	__u64	freertx;	/* free rt extents */
+	__u64	freeino;	/* free inodes */
+	__u64	allocino;	/* total allocated inodes */
+};
+
+typedef unsigned long long xfs_ino_t;
+
+int
+xfs_hack_filter_iflags_begin(
+	struct pt_regs		*ctx,
+	struct xfs_fsop_geom	*geo,
+	struct xfs_fsop_counts	*stats,
+	xfs_ino_t		ino,
+	loff_t			offset,
+	loff_t			length,
+	uint			xflags)
+{
+	bool			use_rt = false;
+
+#if 0
+	bpf_trace_printk("B: off=%llu len=%llu xflags=0x%x\\n", offset, length, xflags);
+	bpf_trace_printk("B: dblocks=%llu rblocks=%llu\\n", geo->datablocks, geo->rtblocks);
+	bpf_trace_printk("B: dfree=%llu rfree=%llu\\n", stats->freedata, stats->freertx);
+#endif
+
+	/*
+	 * If the first allocation request is for >64k then we assume this
+	 * is a "large" file and push it to the rt device.
+	 */
+	if (length >= 65536)
+		use_rt = true;
+
+	/*
+	 * Redirect files to the 'other' device if the chosen one is more
+	 * than 80% full.
+	 */
+	if (use_rt && stats->freertx < geo->rtblocks / 5)
+		use_rt = false;
+	else if (!use_rt && stats->freedata < geo->datablocks / 5)
+		use_rt = true;
+
+	if (use_rt)
+		xflags |= FS_XFLAG_REALTIME;
+	else
+		xflags &= ~FS_XFLAG_REALTIME;
+
+	bpf_override_return(ctx, xflags);
+	return 0;
+}
+
+"""
+if debug:
+    print(bpf_text)
+
+# initialize BPF
+b = BPF(text=bpf_text)
+
+# common file functions
+b.attach_kprobe(event="xfs_hack_filter_iflags", fn_name="xfs_hack_filter_iflags_begin")
+
+print("BPF HACKING XFS... Hit Ctrl-C to end.")
+
+# output
+exiting = 0
+while (1):
+    try:
+        sleep(99999999)
+    except KeyboardInterrupt:
+        exiting = 1
+
+    if exiting:
+        exit()
