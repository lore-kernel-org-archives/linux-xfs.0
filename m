Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47066 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727314AbeJDKRE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Oct 2018 06:17:04 -0400
Subject: [PATCH 05/22] docs: add XFS shared data block chapter to DS&A book
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 03 Oct 2018 20:25:49 -0700
Message-ID: <153862354950.27883.8722770456101190838.stgit@magnolia>
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
 .../filesystems/xfs-data-structures/reflink.rst    |   43 ++++++++++++++++++++
 2 files changed, 44 insertions(+)
 create mode 100644 Documentation/filesystems/xfs-data-structures/reflink.rst


diff --git a/Documentation/filesystems/xfs-data-structures/overview.rst b/Documentation/filesystems/xfs-data-structures/overview.rst
index 457e81c0eb40..d8d668ec6097 100644
--- a/Documentation/filesystems/xfs-data-structures/overview.rst
+++ b/Documentation/filesystems/xfs-data-structures/overview.rst
@@ -45,3 +45,4 @@ latency.
 
 .. include:: self_describing_metadata.rst
 .. include:: delayed_logging.rst
+.. include:: reflink.rst
diff --git a/Documentation/filesystems/xfs-data-structures/reflink.rst b/Documentation/filesystems/xfs-data-structures/reflink.rst
new file mode 100644
index 000000000000..653b3def7e6e
--- /dev/null
+++ b/Documentation/filesystems/xfs-data-structures/reflink.rst
@@ -0,0 +1,43 @@
+.. SPDX-License-Identifier: CC-BY-SA-4.0
+
+Sharing Data Blocks
+-------------------
+
+On a traditional filesystem, there is a 1:1 mapping between a logical block
+offset in a file and a physical block on disk, which is to say that physical
+blocks are not shared. However, there exist various use cases for being able
+to share blocks between files — deduplicating files saves space on archival
+systems; creating space-efficient clones of disk images for virtual machines
+and containers facilitates efficient datacenters; and deferring the payment of
+the allocation cost of a file system tree copy as long as possible makes
+regular work faster. In all of these cases, a write to one of the shared
+copies **must** not affect the other shared copies, which means that writes to
+shared blocks must employ a copy-on-write strategy. Sharing blocks in this
+manner is commonly referred to as "reflinking".
+
+XFS implements block sharing in a fairly straightforward manner. All existing
+data fork structures remain unchanged, save for the addition of a
+per-allocation group `reference count B+tree <#reference-count-b-tree>`__. This
+data structure tracks reference counts for all shared physical blocks, with a
+few rules to maintain compatibility with existing code: If a block is free, it
+will be tracked in the free space B+trees. If a block is owned by a single
+file, it appears in neither the free space nor the reference count B+trees. If
+a block is shared, it will appear in the reference count B+tree with a
+reference count >= 2. The first two cases are established precedent in XFS, so
+the third case is the only behavioral change.
+
+When a filesystem block is shared, the block mapping in the destination file
+is updated to point to that filesystem block and the reference count B+tree
+records are updated to reflect the increased reference count. If a shared
+block is written, a new block will be allocated, the dirty data written to
+this new block, and the file’s block mapping updated to point to the new
+block. If a shared block is unmapped, the reference count records are updated
+to reflect the decreased reference count and the block is also freed if its
+reference count becomes zero. This enables users to create space efficient
+clones of disk images and to copy filesystem subtrees quickly, using the
+standard Linux coreutils packages.
+
+Deduplication employs the same mechanism to share blocks and copy them at
+write time. However, the kernel confirms that the contents of both files are
+identical before updating the destination file’s mapping. This enables XFS to
+be used by userspace deduplication programs such as duperemove.
