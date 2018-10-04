Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47344 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbeJDKRL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Oct 2018 06:17:11 -0400
Subject: [PATCH 06/22] docs: add XFS online repair chapter to DS&A book
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 03 Oct 2018 20:25:55 -0700
Message-ID: <153862355578.27883.17216033492327236049.stgit@magnolia>
In-Reply-To: <153862350727.27883.9408120819569795102.stgit@magnolia>
References: <153862350727.27883.9408120819569795102.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net

From: Darrick J. Wong <darrick.wong@oracle.com>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../filesystems/xfs-data-structures/overview.rst   |    1 
 .../xfs-data-structures/reconstruction.rst         |   68 ++++++++++++++++++++
 2 files changed, 69 insertions(+)
 create mode 100644 Documentation/filesystems/xfs-data-structures/reconstruction.rst


diff --git a/Documentation/filesystems/xfs-data-structures/overview.rst b/Documentation/filesystems/xfs-data-structures/overview.rst
index d8d668ec6097..b1b3f711638b 100644
--- a/Documentation/filesystems/xfs-data-structures/overview.rst
+++ b/Documentation/filesystems/xfs-data-structures/overview.rst
@@ -46,3 +46,4 @@ latency.
 .. include:: self_describing_metadata.rst
 .. include:: delayed_logging.rst
 .. include:: reflink.rst
+.. include:: reconstruction.rst
diff --git a/Documentation/filesystems/xfs-data-structures/reconstruction.rst b/Documentation/filesystems/xfs-data-structures/reconstruction.rst
new file mode 100644
index 000000000000..10a7a728c50c
--- /dev/null
+++ b/Documentation/filesystems/xfs-data-structures/reconstruction.rst
@@ -0,0 +1,68 @@
+.. SPDX-License-Identifier: CC-BY-SA-4.0
+
+Metadata Reconstruction
+-----------------------
+
+    **Note**
+
+    This is a theoretical discussion of how reconstruction could work; none of
+    this is implemented as of 2018.
+
+A simple UNIX filesystem can be thought of in terms of a directed acyclic
+graph. To a first approximation, there exists a root directory node, which
+points to other nodes. Those other nodes can themselves be directories or they
+can be files. Each file, in turn, points to data blocks.
+
+XFS adds a few more details to this picture:
+
+-  The real root(s) of an XFS filesystem are the allocation group headers
+   (superblock, AGF, AGI, AGFL).
+
+-  Each allocation group’s headers point to various per-AG B+trees (free
+   space, inode, free inodes, free list, etc.)
+
+-  The free space B+trees point to unused extents;
+
+-  The inode B+trees point to blocks containing inode chunks;
+
+-  All superblocks point to the root directory and the log;
+
+-  Hardlinks mean that multiple directories can point to a single file node;
+
+-  File data block pointers are indexed by file offset;
+
+-  Files and directories can have a second collection of pointers to data
+   blocks which contain extended attributes;
+
+-  Large directories require multiple data blocks to store all the
+   subpointers;
+
+-  Still larger directories use high-offset data blocks to store a B+tree of
+   hashes to directory entries;
+
+-  Large extended attribute forks similarly use high-offset data blocks to
+   store a B+tree of hashes to attribute keys; and
+
+-  Symbolic links can point to data blocks.
+
+The beauty of this massive graph structure is that under normal circumstances,
+everything known to the filesystem is discoverable (access controls
+notwithstanding) from the root. The major weakness of this structure of course
+is that breaking a edge in the graph can render entire subtrees inaccessible.
+xfs\_repair “recovers” from broken directories by scanning for unlinked inodes
+and connecting them to /lost+found, but this isn’t sufficiently general to
+recover from breaks in other parts of the graph structure. Wouldn’t it be
+useful to have back pointers as a secondary data structure? The current repair
+strategy is to reconstruct whatever can be rebuilt, but to scrap anything that
+doesn’t check out.
+
+The `reverse-mapping B+tree <#reverse-mapping-b-tree>`__ fills in part of the
+puzzle. Since it contains copies of every entry in each inode’s data and
+attribute forks, we can fix a corrupted block map with these records.
+Furthermore, if the inode B+trees become corrupt, it is possible to visit all
+inode chunks using the reverse-mapping data. Should XFS ever gain the ability
+to store parent directory information in each inode, it also becomes possible
+to resurrect damaged directory trees, which should reduce the complaints about
+inodes ending up in /lost+found. Everything else in the per-AG primary
+metadata can already be reconstructed via xfs\_repair. Hopefully,
+reconstruction will not turn out to be a fool’s errand.
