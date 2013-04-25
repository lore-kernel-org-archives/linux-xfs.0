Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 73C9B29E03
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 09:12:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E27A9AC007
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 07:12:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id cNcdWTRYr5t2J4QI for <xfs@oss.sgi.com>;
	Thu, 25 Apr 2013 07:12:10 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 2C02763C59BC
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 09:12:09 -0500 (CDT)
Message-ID: <517939B8.2010701@sandeen.net>
Date: Thu, 25 Apr 2013 09:12:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/3 V2] xfsprogs: manpage spelling fixes
References: <5175BB8F.5090604@sandeen.net> <5175BC20.9010403@sandeen.net>
In-Reply-To: <5175BC20.9010403@sandeen.net>
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

Fix several spelling errors in xfsprogs manpages.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: fix serialization, guaranteed

diff --git a/man/man5/projects.5 b/man/man5/projects.5
index d8fb56d..6845540 100644
--- a/man/man5/projects.5
+++ b/man/man5/projects.5
@@ -1,6 +1,6 @@
 .TH projects 5
 .SH NAME
-projects \- persistent project root defintion
+projects \- persistent project root definition
 .SH DESCRIPTION
 The
 .I /etc/projects
diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index fa52152..f707881 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -279,7 +279,7 @@ with
 .BR log= ,
 or as the number fitting in a filesystem block with
 .BR perblock= .
-The mininum (and default)
+The minimum (and default)
 .I value
 is 256 bytes.
 The maximum
@@ -297,7 +297,7 @@ so if no inode size is given on the command line,
 .B mkfs.xfs
 will attempt to choose a size
 such that inode numbers will be < 32 bits.  If an inode size
-is specified, or if a filesystem is sufficently large,
+is specified, or if a filesystem is sufficiently large,
 .B mkfs.xfs
 will warn if this will create inode numbers > 32 significant
 bits.
@@ -450,7 +450,7 @@ suboption is specified.
 This changes the method of logging various persistent counters
 in the superblock.  Under metadata intensive workloads, these
 counters are updated and logged frequently enough that the superblock
-updates become a serialisation point in the filesystem. The
+updates become a serialization point in the filesystem. The
 .I value
 can be either 0 or 1.
 .IP
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 17ac601..0558671 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -64,7 +64,7 @@ and
 Allows execution on a mounted filesystem, provided it is mounted read-only.
 Useful for shell scripts such as
 .BR xfs_check (8),
-which must only operate on filesystems in a guarenteed consistent state
+which must only operate on filesystems in a guaranteed consistent state
 (either unmounted or mounted read-only). These semantics are slightly
 different to that of the
 .B -r
@@ -960,12 +960,12 @@ and
 (1 if the extent is unwritten).
 .TP
 .B keys
-[nonleaf blocks only] array of key records. These are the first key
+[non-leaf blocks only] array of key records. These are the first key
 value of each block in the level below this one. Each record contains
 .BR startoff .
 .TP
 .B ptrs
-[nonleaf blocks only] array of child block pointers.
+[non-leaf blocks only] array of child block pointers.
 Each pointer is a filesystem block number to the next level in the Btree.
 .PD
 .RE
@@ -975,7 +975,7 @@ There is one set of filesystem blocks forming the by-block-number
 allocation Btree for each allocation group. The root block of this
 Btree is designated by the
 .B bnoroot
-field in the coresponding AGF block.
+field in the corresponding AGF block.
 The blocks are linked to sibling left and right blocks at each level,
 as well as by pointers from parent to child blocks.
 Each block has the following fields:
@@ -1004,14 +1004,14 @@ and
 .BR blockcount .
 .TP
 .B keys
-[nonleaf blocks only] array of key records. These are the first value
+[non-leaf blocks only] array of key records. These are the first value
 of each block in the level below this one. Each record contains
 .B startblock
 and
 .BR blockcount .
 .TP
 .B ptrs
-[nonleaf blocks only] array of child block pointers. Each pointer is a
+[non-leaf blocks only] array of child block pointers. Each pointer is a
 block number within the allocation group to the next level in the Btree.
 .PD
 .RE
@@ -1021,7 +1021,7 @@ There is one set of filesystem blocks forming the by-block-count
 allocation Btree for each allocation group. The root block of this
 Btree is designated by the
 .B cntroot
-field in the coresponding AGF block. The blocks are linked to sibling
+field in the corresponding AGF block. The blocks are linked to sibling
 left and right blocks at each level, as well as by pointers from parent
 to child blocks. Each block has the following fields:
 .RS 1.4i
@@ -1049,14 +1049,14 @@ and
 .BR blockcount .
 .TP
 .B keys
-[nonleaf blocks only] array of key records. These are the first value
+[non-leaf blocks only] array of key records. These are the first value
 of each block in the level below this one. Each record contains
 .B blockcount
 and
 .BR startblock .
 .TP
 .B ptrs
-[nonleaf blocks only] array of child block pointers. Each pointer is a
+[non-leaf blocks only] array of child block pointers. Each pointer is a
 block number within the allocation group to the next level in the Btree.
 .PD
 .RE
@@ -1368,7 +1368,7 @@ number of warnings issued about realtime block limit violations.
 There is one set of filesystem blocks forming the inode allocation Btree for
 each allocation group. The root block of this Btree is designated by the
 .B root
-field in the coresponding AGI block.
+field in the corresponding AGI block.
 The blocks are linked to sibling left and right blocks at each level,
 as well as by pointers from parent to child blocks.
 Each block has the following fields:
@@ -1400,12 +1400,12 @@ count of free inodes in this chunk, and
 bitmap, LSB corresponds to inode 0.
 .TP
 .B keys
-[nonleaf blocks only] array of key records. These are the first value of each
+[non-leaf blocks only] array of key records. These are the first value of each
 block in the level below this one. Each record contains
 .BR startino .
 .TP
 .B ptrs
-[nonleaf blocks only] array of child block pointers. Each pointer is a
+[non-leaf blocks only] array of child block pointers. Each pointer is a
 block number within the allocation group to the next level in the Btree.
 .PD
 .RE
diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
index a7d2b68..7b9ba89 100644
--- a/man/man8/xfs_mdrestore.8
+++ b/man/man8/xfs_mdrestore.8
@@ -16,7 +16,7 @@ to a filesystem. The
 .I source
 argument specifies the location of the metadump image and the
 .I target
-argument specifies the destination for the filsystem image.
+argument specifies the destination for the filesystem image.
 If the
 .I source
 is \-, then the metadata image is read from stdin. This allows the output of
diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
index f3b54cc..9327feb 100644
--- a/man/man8/xfs_quota.8
+++ b/man/man8/xfs_quota.8
@@ -623,7 +623,7 @@ can be used to limit recursion level (\-1 is infinite, 0 is top level only,
 1 is first level ... ).
 Option
 .B \-p
-adds posibility to specify project paths in command line without a need
+adds possibility to specify project paths in command line without a need
 for
 .I /etc/projects
 to exist. Note that if projects file exists then it is also used.
diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
index 57c97da..7b296ba 100644
--- a/man/man8/xfs_repair.8
+++ b/man/man8/xfs_repair.8
@@ -170,7 +170,7 @@ Verbose output.
 Repair dangerously. Allow
 .B xfs_repair
 to repair an XFS filesystem mounted read only. This is typically done
-on a root fileystem from single user mode, immediately followed by a reboot.
+on a root filesystem from single user mode, immediately followed by a reboot.
 .TP
 .B \-V
 Prints out the current version number and exits.
@@ -239,7 +239,7 @@ The name assigned is the inode number.
 aborts on most disk I/O errors. Therefore, if you are trying
 to repair a filesystem that was damaged due to a disk drive failure,
 steps should be taken to ensure that all blocks in the filesystem are
-readable and writeable before attempting to use
+readable and writable before attempting to use
 .B xfs_repair
 to repair the filesystem. A possible method is using
 .BR dd (8)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
