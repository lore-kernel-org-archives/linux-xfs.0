Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53424 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbeI0Bvr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 21:51:47 -0400
Subject: [PATCH 24/24] docs: add XFS metadump structure to DS&A book
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 26 Sep 2018 12:37:09 -0700
Message-ID: <153799062911.31202.3852633815917896152.stgit@magnolia>
In-Reply-To: <153799045443.31202.17537455000771265705.stgit@magnolia>
References: <153799045443.31202.17537455000771265705.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 Documentation/filesystems/xfs/ondisk/auxiliary.rst |    2 +
 Documentation/filesystems/xfs/ondisk/metadump.rst  |   72 ++++++++++++++++++++
 2 files changed, 74 insertions(+)
 create mode 100644 Documentation/filesystems/xfs/ondisk/metadump.rst


diff --git a/Documentation/filesystems/xfs/ondisk/auxiliary.rst b/Documentation/filesystems/xfs/ondisk/auxiliary.rst
index d77db8d084d5..65b9964cb145 100644
--- a/Documentation/filesystems/xfs/ondisk/auxiliary.rst
+++ b/Documentation/filesystems/xfs/ondisk/auxiliary.rst
@@ -2,3 +2,5 @@
 
 Auxiliary Data Structures
 =========================
+
+.. include:: metadump.rst
diff --git a/Documentation/filesystems/xfs/ondisk/metadump.rst b/Documentation/filesystems/xfs/ondisk/metadump.rst
new file mode 100644
index 000000000000..cb8c2665d559
--- /dev/null
+++ b/Documentation/filesystems/xfs/ondisk/metadump.rst
@@ -0,0 +1,72 @@
+.. SPDX-License-Identifier: CC-BY-SA-3.0+
+
+Metadata Dumps
+--------------
+
+The xfs\_metadump and xfs\_mdrestore tools are used to create a sparse
+snapshot of a live file system and to restore that snapshot onto a block
+device for debugging purposes. Only the metadata are captured in the snapshot,
+and the metadata blocks may be obscured for privacy reasons.
+
+A metadump file starts with a xfs\_metablock that records the addresses of the
+blocks that follow. Following that are the metadata blocks captured from the
+filesystem. The first block following the first superblock must be the
+superblock from AG 0. If the metadump has more blocks than can be pointed to
+by the xfs\_metablock.mb\_daddr area, the sequence of xfs\_metablock followed
+by metadata blocks is repeated.
+
+**Metadata Dump Format.**
+
+.. code:: c
+
+    struct xfs_metablock {
+        __be32      mb_magic;
+        __be16      mb_count;
+        uint8_t     mb_blocklog;
+        uint8_t     mb_reserved;
+        __be64      mb_daddr[];
+    };
+
+**mb\_magic**
+    The magic number, "XFSM" (0x5846534d).
+
+**mb\_count**
+    Number of blocks indexed by this record. This value must not exceed (1 <<
+    mb\_blocklog) - sizeof(struct xfs\_metablock).
+
+**mb\_blocklog**
+    The log size of a metadump block. This size of a metadump block 512 bytes,
+    so this value should be 9.
+
+**mb\_reserved**
+    Reserved. Should be zero.
+
+**mb\_daddr**
+    An array of disk addresses. Each of the mb\_count blocks (of size (1 <<
+    mb\_blocklog) following the xfs\_metablock should be written back to the
+    address pointed to by the corresponding mb\_daddr entry.
+
+Dump Obfuscation
+~~~~~~~~~~~~~~~~
+
+Unless explicitly disabled, the xfs\_metadump tool obfuscates empty block
+space and naming information to avoid leaking sensitive information into the
+metadump file. xfs\_metadump does not copy user data blocks.
+
+The obfuscation policy is as follows:
+
+-  File and extended attribute names are both considered "names".
+
+-  Names longer than 8 characters are totally rewritten with a name that
+   matches the hash of the old name.
+
+-  Names between 5 and 8 characters are partially rewritten to match the hash
+   of the old name.
+
+-  Names shorter than 5 characters are not obscured at all.
+
+-  Names that cross a block boundary are not obscured at all.
+
+-  Extended attribute values are zeroed.
+
+-  Empty parts of metadata blocks are zeroed.
