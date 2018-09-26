Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44888 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbeI0BtH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 21:49:07 -0400
Subject: [PATCH 03/24] docs: add skeleton of XFS Data Structures and
 Algorithms book
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 26 Sep 2018 12:34:34 -0700
Message-ID: <153799047409.31202.12527343491938800847.stgit@magnolia>
In-Reply-To: <153799045443.31202.17537455000771265705.stgit@magnolia>
References: <153799045443.31202.17537455000771265705.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Start adding the main TOC of the XFS data structures and algorithms
book.  We'll add the individual sections in later patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 Documentation/conf.py                              |    2 
 Documentation/filesystems/xfs/index.rst            |    1 
 Documentation/filesystems/xfs/ondisk/about.rst     |  123 ++++++++++++++++++++
 Documentation/filesystems/xfs/ondisk/auxiliary.rst |    4 +
 Documentation/filesystems/xfs/ondisk/dynamic.rst   |    4 +
 Documentation/filesystems/xfs/ondisk/globals.rst   |    4 +
 Documentation/filesystems/xfs/ondisk/index.rst     |   10 ++
 Documentation/filesystems/xfs/ondisk/overview.rst  |   44 +++++++
 8 files changed, 192 insertions(+)
 create mode 100644 Documentation/filesystems/xfs/ondisk/about.rst
 create mode 100644 Documentation/filesystems/xfs/ondisk/auxiliary.rst
 create mode 100644 Documentation/filesystems/xfs/ondisk/dynamic.rst
 create mode 100644 Documentation/filesystems/xfs/ondisk/globals.rst
 create mode 100644 Documentation/filesystems/xfs/ondisk/index.rst
 create mode 100644 Documentation/filesystems/xfs/ondisk/overview.rst


diff --git a/Documentation/conf.py b/Documentation/conf.py
index b691af4831fa..1c08b27aa003 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -381,6 +381,8 @@ latex_documents = [
      'The kernel development community', 'manual'),
     ('driver-api/index', 'driver-api.tex', 'The kernel driver API manual',
      'The kernel development community', 'manual'),
+    ('filesystems/xfs/index', 'xfs.tex', 'The SGI XFS Filesystem',
+     'XFS Filesystem Developers', 'manual'),
     ('filesystems/index', 'filesystems.tex', 'Linux Filesystems API',
      'The kernel development community', 'manual'),
     ('gpu/index', 'gpu.tex', 'Linux GPU Driver Developer\'s Guide',
diff --git a/Documentation/filesystems/xfs/index.rst b/Documentation/filesystems/xfs/index.rst
index f74b8f6ec8a6..83ac3398e57c 100644
--- a/Documentation/filesystems/xfs/index.rst
+++ b/Documentation/filesystems/xfs/index.rst
@@ -14,3 +14,4 @@ have been reviewed by the XFS community.
    :numbered:
 
    xfs
+   ondisk/index
diff --git a/Documentation/filesystems/xfs/ondisk/about.rst b/Documentation/filesystems/xfs/ondisk/about.rst
new file mode 100644
index 000000000000..fe2ce1aa5142
--- /dev/null
+++ b/Documentation/filesystems/xfs/ondisk/about.rst
@@ -0,0 +1,123 @@
+.. SPDX-License-Identifier: CC-BY-SA-3.0+
+
+About this Book
+===============
+
+XFS is a high performance filesystem which was designed to maximize
+parallel throughput and to scale up to extremely large 64-bit storage
+systems. Originally developed by SGI in October 1993 for IRIX, XFS can
+handle large files, large filesystems, many inodes, large directories,
+large file attributes, and large allocations. Filesystems are optimized
+for parallel access by splitting the storage device into semi-autonomous
+allocation groups. XFS employs branching trees (B+ trees) to facilitate
+fast searches of large lists; it also uses delayed extent-based
+allocation to improve data contiguity and IO performance.
+
+This document describes the on-disk layout of an XFS filesystem and how
+to use the debugging tools ``xfs_db`` and ``xfs_logprint`` to inspect
+the metadata structures. It also describes how on-disk metadata relates
+to the higher level design goals.
+
+This book’s source code is available in the Linux kernel git tree.
+Feedback should be sent to the XFS mailing list, currently at:
+``linux-xfs@vger.kernel.org``.
+
+    **Note**
+
+    All fields in XFS metadata structures are in big-endian byte order
+    except for log items which are formatted in host order.
+
+Copyright
+---------
+© Copyright 2006 Silicon Graphics Inc. All rights reserved.  Permission is
+granted to copy, distribute, and/or modify this document under the terms of the
+Creative Commons Attribution-Share Alike, Version 3.0 or any later version
+published by the Creative Commons Corp. A copy of the license is available at
+http://creativecommons.org/licenses/by-sa/3.0/us/ .
+
+Change Log
+----------
+
+.. list-table::
+   :widths: 8 12 14 46
+   :header-rows: 1
+
+   * - Version
+     - Date
+     - Author
+     - Description
+
+   * - 0.1
+     - 2006
+     - Silicon Graphics, Inc.
+     - Initial Release
+
+   * - 1.0
+     - Fri Jul 03 2009
+     - Ryan Lerch
+     - Publican Conversion
+
+   * - 1.1
+     - March 2010
+     - Eric Sandeen
+     - Community Release
+
+   * - 1.99
+     - February 2014
+     - Dave Chinner
+     - AsciiDoc Conversion
+
+   * - 3.0
+     - October 2015
+     - Darrick J. Wong
+     - Miscellaneous fixes.
+       Add missing field definitions.
+       Add some missing xfs_db examples.
+       Add an overview of XFS.
+       Document the journal format.
+       Document the realtime device.
+
+   * - 3.1
+     - October 2015
+     - Darrick J. Wong
+     - Add v5 fields.
+       Discuss metadata integrity.
+       Document the free inode B+tree.
+       Create an index of magic numbers.
+       Document sparse inodes.
+
+   * - 3.14
+     - January 2016
+     - Darrick J. Wong
+     - Document disk format change testing.
+
+   * - 3.141
+     - June 2016
+     - Darrick J. Wong
+     - Document the reverse-mapping btree.
+       Move the b+tree info to a separate chapter.
+       Discuss overlapping interval b+trees.
+       Discuss new log items for atomic updates.
+       Document the reference-count btree.
+       Discuss block sharing, reflink, &amp; deduplication.
+
+   * - 3.1415
+     - July 2016
+     - Darrick J. Wong
+     - Document the real-time reverse-mapping btree.
+
+   * - 3.14159
+     - June 2017
+     - Darrick J. Wong
+     - Add the metadump file format.
+
+   * - 3.141592
+     - May 2018
+     - Darrick J. Wong
+     - Incorporate Dave Chinner's log design document.
+       Incorporate Dave Chinner's self-describing metadata design document.
+
+   * - 4.20
+     - September 2018
+     - Darrick J. Wong
+     - Convert to RestructuredText and move to the kernel source tree.
diff --git a/Documentation/filesystems/xfs/ondisk/auxiliary.rst b/Documentation/filesystems/xfs/ondisk/auxiliary.rst
new file mode 100644
index 000000000000..d77db8d084d5
--- /dev/null
+++ b/Documentation/filesystems/xfs/ondisk/auxiliary.rst
@@ -0,0 +1,4 @@
+.. SPDX-License-Identifier: CC-BY-SA-3.0+
+
+Auxiliary Data Structures
+=========================
diff --git a/Documentation/filesystems/xfs/ondisk/dynamic.rst b/Documentation/filesystems/xfs/ondisk/dynamic.rst
new file mode 100644
index 000000000000..21d6ce5b5f06
--- /dev/null
+++ b/Documentation/filesystems/xfs/ondisk/dynamic.rst
@@ -0,0 +1,4 @@
+.. SPDX-License-Identifier: CC-BY-SA-3.0+
+
+Dynamic Allocated Structures
+============================
diff --git a/Documentation/filesystems/xfs/ondisk/globals.rst b/Documentation/filesystems/xfs/ondisk/globals.rst
new file mode 100644
index 000000000000..baabe867609d
--- /dev/null
+++ b/Documentation/filesystems/xfs/ondisk/globals.rst
@@ -0,0 +1,4 @@
+.. SPDX-License-Identifier: CC-BY-SA-3.0+
+
+Global Structures
+=================
diff --git a/Documentation/filesystems/xfs/ondisk/index.rst b/Documentation/filesystems/xfs/ondisk/index.rst
new file mode 100644
index 000000000000..a17679d39042
--- /dev/null
+++ b/Documentation/filesystems/xfs/ondisk/index.rst
@@ -0,0 +1,10 @@
+.. SPDX-License-Identifier: CC-BY-SA-3.0+
+
+==============================
+Data Structures and Algorithms
+==============================
+.. include:: about.rst
+.. include:: overview.rst
+.. include:: globals.rst
+.. include:: dynamic.rst
+.. include:: auxiliary.rst
diff --git a/Documentation/filesystems/xfs/ondisk/overview.rst b/Documentation/filesystems/xfs/ondisk/overview.rst
new file mode 100644
index 000000000000..ea745e181318
--- /dev/null
+++ b/Documentation/filesystems/xfs/ondisk/overview.rst
@@ -0,0 +1,44 @@
+.. SPDX-License-Identifier: CC-BY-SA-3.0+
+
+High Level Design
+=================
+
+Overview
+--------
+
+XFS presents to users a standard Unix filesystem interface: a rooted tree of
+directories, files, symbolic links, and devices. All five of those entities
+are represented inside the filesystem by an index node, or "inode";
+each node is uniquely referenced by an inode number.  Directories consist of
+(name, inode number) tuples and it is possible for multiple tuples to contain
+the same inode number.  Data blocks are associated with files by means of a
+block map in each index node.  It is also possible to attach (key, value)
+tuples to any index node; these are known as "extended attributes", which
+extend beyond the standard Unix file attributes.
+
+Internally, XFS filesystems are divided into a number of equally sized chunks
+called Allocation Groups. Each AG can almost be thought of as an individual
+filesystem that maintains its own space usage, index nodes, and other
+secondary metadata. Having multiple AGs allows XFS to handle most operations
+in parallel without degrading performance as the number of concurrent accesses
+increases. Each allocation group uses multiple B+trees to maintain bookkeeping
+records such as the locations of free blocks, the locations of allocated
+inodes, and the locations of free inodes.
+
+Files, symbolic links, and directories can have up to two block maps, or
+"forks", which associate filesystems blocks with a particular file or
+directory.  The "attribute fork" tracks blocks used to store and index
+extended attributes, whereas the "data fork" tracks file data blocks,
+symbolic link targets, or directory blocks, depending on the type of the inode
+record. Both forks associate a logical offset with an extent of physical
+blocks, which makes sparse files and directories possible. Directory entries
+and extended attributes are contained inside a second-level data structure
+within the blocks that are mapped by the forks. This structure consists of
+variable-length directory or attribute records and possible a second B+tree to
+index these records.
+
+XFS employs a journalling log in which metadata changes are collected so that
+filesystem operations can be carried out atomically in the case of a crash.
+Furthermore, there is the concept of a real-time device wherein allocations
+are tracked more simply and in larger chunks to reduce jitter in allocation
+latency.
