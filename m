Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51756 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbeJDLMS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Oct 2018 07:12:18 -0400
Subject: [PATCH 22/22] docs: add XFS metadump structure to DS&A book
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 03 Oct 2018 21:20:49 -0700
Message-ID: <153862684984.26427.12441242440283590000.stgit@magnolia>
In-Reply-To: <153862669110.26427.16504658853992750743.stgit@magnolia>
References: <153862669110.26427.16504658853992750743.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net

From: Darrick J. Wong <darrick.wong@oracle.com>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../filesystems/xfs-data-structures/auxiliary.rst  |    2 +
 .../filesystems/xfs-data-structures/metadump.rst   |   72 ++++++++++++++++++++
 2 files changed, 74 insertions(+)
 create mode 100644 Documentation/filesystems/xfs-data-structures/metadump.rst


diff --git a/Documentation/filesystems/xfs-data-structures/auxiliary.rst b/Documentation/filesystems/xfs-data-structures/auxiliary.rst
index d2fd2f88ad0e..7ed970f0bc28 100644
--- a/Documentation/filesystems/xfs-data-structures/auxiliary.rst
+++ b/Documentation/filesystems/xfs-data-structures/auxiliary.rst
@@ -2,3 +2,5 @@
 
 Auxiliary Data Structures
 =========================
+
+.. include:: metadump.rst
diff --git a/Documentation/filesystems/xfs-data-structures/metadump.rst b/Documentation/filesystems/xfs-data-structures/metadump.rst
new file mode 100644
index 000000000000..51bc966c1f76
--- /dev/null
+++ b/Documentation/filesystems/xfs-data-structures/metadump.rst
@@ -0,0 +1,72 @@
+.. SPDX-License-Identifier: CC-BY-SA-4.0
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
