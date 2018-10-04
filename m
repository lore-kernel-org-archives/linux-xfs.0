Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52846 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbeJDKRT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Oct 2018 06:17:19 -0400
Subject: [PATCH 07/22] docs: add XFS common types and magic numbers to DS&A
 book
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 03 Oct 2018 20:26:02 -0700
Message-ID: <153862356229.27883.2970956950937907574.stgit@magnolia>
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
 .../xfs-data-structures/common_types.rst           |   61 ++++
 .../filesystems/xfs-data-structures/magic.rst      |  277 ++++++++++++++++++++
 .../filesystems/xfs-data-structures/overview.rst   |    2 
 3 files changed, 340 insertions(+)
 create mode 100644 Documentation/filesystems/xfs-data-structures/common_types.rst
 create mode 100644 Documentation/filesystems/xfs-data-structures/magic.rst


diff --git a/Documentation/filesystems/xfs-data-structures/common_types.rst b/Documentation/filesystems/xfs-data-structures/common_types.rst
new file mode 100644
index 000000000000..63de847924c6
--- /dev/null
+++ b/Documentation/filesystems/xfs-data-structures/common_types.rst
@@ -0,0 +1,61 @@
+.. SPDX-License-Identifier: CC-BY-SA-4.0
+
+Common XFS Types
+----------------
+
+All the following XFS types can be found in xfs\_types.h. NULL values are
+always -1 on disk (ie. all bits for the value set to one).
+
+**xfs\_ino\_t**
+    Unsigned 64 bit absolute `inode number <#inode-numbers>`__.
+
+**xfs\_off\_t**
+    Signed 64 bit file offset.
+
+**xfs\_daddr\_t**
+    Signed 64 bit disk address (sectors).
+
+**xfs\_agnumber\_t**
+    Unsigned 32 bit `AG number <#allocation-groups>`__.
+
+**xfs\_agblock\_t**
+    Unsigned 32 bit AG relative block number.
+
+**xfs\_extlen\_t**
+    Unsigned 32 bit `extent <#data-extents>`__ length in blocks.
+
+**xfs\_extnum\_t**
+    Signed 32 bit number of extents in a data fork.
+
+**xfs\_aextnum\_t**
+    Signed 16 bit number of extents in an attribute fork.
+
+**xfs\_dablk\_t**
+    Unsigned 32 bit block number for `directories <#directories>`__ and
+    `extended attributes <#extended-attributes>`__.
+
+**xfs\_dahash\_t**
+    Unsigned 32 bit hash of a directory file name or extended attribute name.
+
+**xfs\_fsblock\_t**
+    Unsigned 64 bit filesystem block number combining `AG
+    number <#allocation-groups>`__ and block offset into the AG.
+
+**xfs\_rfsblock\_t**
+    Unsigned 64 bit raw filesystem block number.
+
+**xfs\_rtblock\_t**
+    Unsigned 64 bit extent number in the `real-time <#real-time-devices>`__
+    sub-volume.
+
+**xfs\_fileoff\_t**
+    Unsigned 64 bit block offset into a file.
+
+**xfs\_filblks\_t**
+    Unsigned 64 bit block count for a file.
+
+**uuid\_t**
+    16-byte universally unique identifier (UUID).
+
+**xfs\_fsize\_t**
+    Signed 64 bit byte size of a file.
diff --git a/Documentation/filesystems/xfs-data-structures/magic.rst b/Documentation/filesystems/xfs-data-structures/magic.rst
new file mode 100644
index 000000000000..f5e57581645d
--- /dev/null
+++ b/Documentation/filesystems/xfs-data-structures/magic.rst
@@ -0,0 +1,277 @@
+.. SPDX-License-Identifier: CC-BY-SA-4.0
+
+Magic Numbers
+-------------
+
+These are the magic numbers that are known to XFS, along with links to the
+relevant chapters. Magic numbers tend to have consistent locations:
+
+-  32-bit magic numbers are always at offset zero in the block.
+
+-  16-bit magic numbers for the directory and attribute B+tree are at offset
+   eight.
+
+-  The quota magic number is at offset zero.
+
+-  The inode magic is at the beginning of each inode.
+
+.. list-table::
+   :widths: 28 12 8 34
+   :header-rows: 1
+
+   * - Flag
+     - Hexadecimal
+     - ASCII
+     - Data structure
+   * - XFS_SB_MAGIC
+     - 0x58465342
+     - XFSB
+     - `Superblock <#superblocks>`__
+   * - XFS_AGF_MAGIC
+     - 0x58414746
+     - XAGF
+     - `Free Space <#ag-free-space-block>`__
+   * - XFS_AGI_MAGIC
+     - 0x58414749
+     - XAGI
+     - `Inode Information <#inode-information>`__
+   * - XFS_AGFL_MAGIC
+     - 0x5841464c
+     - XAFL
+     - `Free Space List <#ag-free-list>`__, v5 only
+   * - XFS_DINODE_MAGIC
+     - 0x494e
+     - IN
+     - `Inodes <#inode-core>`__
+   * - XFS_DQUOT_MAGIC
+     - 0x4451
+     - DQ
+     - `Quota Inodes <#quota-inodes>`__
+   * - XFS_SYMLINK_MAGIC
+     - 0x58534c4d
+     - XSLM
+     - `Symbolic Links <#extent-symbolic-links>`__
+   * - XFS_ABTB_MAGIC
+     - 0x41425442
+     - ABTB
+     - `Free Space by Block B+tree <#ag-free-space-b-trees>`__
+   * - XFS_ABTB_CRC_MAGIC
+     - 0x41423342
+     - AB3B
+     - `Free Space by Block B+tree <#ag-free-space-b-trees>`__, v5 only
+   * - XFS_ABTC_MAGIC
+     - 0x41425443
+     - ABTC
+     - `Free Space by Size B+tree <#ag-free-space-b-trees>`__
+   * - XFS_ABTC_CRC_MAGIC
+     - 0x41423343
+     - AB3C
+     - `Free Space by Size B+tree <#ag-free-space-b-trees>`__, v5 only
+   * - XFS_IBT_MAGIC
+     - 0x49414254
+     - IABT
+     - `Inode B+tree <#inode-b-trees>`__
+   * - XFS_IBT_CRC_MAGIC
+     - 0x49414233
+     - IAB3
+     - `Inode B+tree <#inode-b-trees>`__, v5 only
+   * - XFS_FIBT_MAGIC
+     - 0x46494254
+     - FIBT
+     - `Free Inode B+tree <#inode-b-trees>`__
+   * - XFS_FIBT_CRC_MAGIC
+     - 0x46494233
+     - FIB3
+     - `Free Inode B+tree <#inode-b-trees>`__, v5 only
+   * - XFS_BMAP_MAGIC
+     - 0x424d4150
+     - BMAP
+     - `B+Tree Extent List <#b-tree-extent-list>`__
+   * - XFS_BMAP_CRC_MAGIC
+     - 0x424d4133
+     - BMA3
+     - `B+Tree Extent List <#b-tree-extent-list>`__, v5 only
+   * - XLOG_HEADER_MAGIC_NUM
+     - 0xfeedbabe
+     -
+     - `Log Records <#log-records>`__
+   * - XFS_DA_NODE_MAGIC
+     - 0xfebe
+     -
+     - `Directory/Attribute Node <#directory-attribute-internal-node>`__
+   * - XFS_DA3_NODE_MAGIC
+     - 0x3ebe
+     -
+     - `Directory/Attribute Node <#directory-attribute-internal-node>`__, v5 only
+   * - XFS_DIR2_BLOCK_MAGIC
+     - 0x58443242
+     - XD2B
+     - `Block Directory Data <#block-directories>`__
+   * - XFS_DIR3_BLOCK_MAGIC
+     - 0x58444233
+     - XDB3
+     - `Block Directory Data <#block-directories>`__, v5 only
+   * - XFS_DIR2_DATA_MAGIC
+     - 0x58443244
+     - XD2D
+     - `Leaf Directory Data <#leaf-directories>`__
+   * - XFS_DIR3_DATA_MAGIC
+     - 0x58444433
+     - XDD3
+     - `Leaf Directory Data <#leaf-directories>`__, v5 only
+   * - XFS_DIR2_LEAF1_MAGIC
+     - 0xd2f1
+     -
+     - `Leaf Directory <#leaf-directories>`__
+   * - XFS_DIR3_LEAF1_MAGIC
+     - 0x3df1
+     -
+     - `Leaf Directory <#leaf-directories>`__, v5 only
+   * - XFS_DIR2_LEAFN_MAGIC
+     - 0xd2ff
+     -
+     - `Node Directory <#node-directories>`__
+   * - XFS_DIR3_LEAFN_MAGIC
+     - 0x3dff
+     -
+     - `Node Directory <#node-directories>`__, v5 only
+   * - XFS_DIR2_FREE_MAGIC
+     - 0x58443246
+     - XD2F
+     - `Node Directory Free Space <#node-directories>`__
+   * - XFS_DIR3_FREE_MAGIC
+     - 0x58444633
+     - XDF3
+     - `Node Directory Free Space <#node-directories>`__, v5 only
+   * - XFS_ATTR_LEAF_MAGIC
+     - 0xfbee
+     -
+     - `Leaf Attribute <#leaf-attributes>`__
+   * - XFS_ATTR3_LEAF_MAGIC
+     - 0x3bee
+     -
+     - `Leaf Attribute <#leaf-attributes>`__, v5 only
+   * - XFS_ATTR3_RMT_MAGIC
+     - 0x5841524d
+     - XARM
+     - `Remote Attribute Value <#remote-attribute-values>`__, v5 only
+   * - XFS_RMAP_CRC_MAGIC
+     - 0x524d4233
+     - RMB3
+     - `Reverse Mapping B+tree <#reverse-mapping-b-tree>`__, v5 only
+   * - XFS_RTRMAP_CRC_MAGIC
+     - 0x4d415052
+     - MAPR
+     - `Real-Time Reverse Mapping B+tree <#real-time-reverse-mapping-b-tree>`__, v5 only
+   * - XFS_REFC_CRC_MAGIC
+     - 0x52334643
+     - R3FC
+     - `Reference Count B+tree <#reference-count-b-tree>`__, v5 only
+   * - XFS_MD_MAGIC
+     - 0x5846534d
+     - XFSM
+     - `Metadata Dumps <#metadata-dumps>`__
+
+The magic numbers for log items are at offset zero in each log item, but items
+are not aligned to blocks.
+
+.. list-table::
+   :widths: 24 12 8 36
+   :header-rows: 1
+
+   * - Flag
+     - Hexadecimal
+     - ASCII
+     - Data structure
+   * - XFS_TRANS_HEADER_MAGIC
+     - 0x5452414e
+     - TRAN
+     - `Log Transactions <#transaction-headers>`__
+   * - XFS_LI_EFI
+     - 0x1236
+     -
+     - `Extent Freeing Intent Log Item <#intent-to-free-an-extent>`__
+   * - XFS_LI_EFD
+     - 0x1237
+     -
+     - `Extent Freeing Done Log Item <#completion-of-intent-to-free-an-extent>`__
+   * - XFS_LI_IUNLINK
+     - 0x1238
+     -
+     -  Unknown?
+   * - XFS_LI_INODE
+     - 0x123b
+     -
+     - `Inode Updates Log Item <#inode-updates>`__
+   * - XFS_LI_BUF
+     - 0x123c
+     -
+     - `Buffer Writes Log Item <#buffer-log-item>`__
+   * - XFS_LI_DQUOT
+     - 0x123d
+     -
+     - `Update Quota Log Item <#quota-update-data-log-item>`__
+   * - XFS_LI_QUOTAOFF
+     - 0x123e
+     -
+     - `Quota Off Log Item <#disable-quota-log-item>`__
+   * - XFS_LI_ICREATE
+     - 0x123f
+     -
+     - `Inode Creation Log Item <#inode-creation-log-item>`__
+   * - XFS_LI_RUI
+     - 0x1240
+     -
+     - `Reverse Mapping Update Intent <#reverse-mapping-updates-intent>`__
+   * - XFS_LI_RUD
+     - 0x1241
+     -
+     - `Reverse Mapping Update Done <#completion-of-reverse-mapping-updates>`__
+   * - XFS_LI_CUI
+     - 0x1242
+     -
+     - `Reference Count Update Intent <#reference-count-updates-intent>`__
+   * - XFS_LI_CUD
+     - 0x1243
+     -
+     - `Reference Count Update Done <#completion-of-reference-count-updates>`__
+   * - XFS_LI_BUI
+     - 0x1244
+     -
+     - `File Block Mapping Update Intent <#file-block-mapping-intent>`__
+   * - XFS_LI_BUD
+     - 0x1245
+     -
+     - `File Block Mapping Update Done <#completion-of-file-block-mapping-updates>`__
+
+Theoretical Limits
+------------------
+
+XFS can create really big filesystems!
+
++---------------------+---------------------+---------------------+---------------------+
+| Item                | 1KiB blocks         | 4KiB blocks         | 64KiB blocks        |
++=====================+=====================+=====================+=====================+
+| Blocks              | 2\ :sup:`52`        | 2\ :sup:`52`        | 2\ :sup:`52`        |
++---------------------+---------------------+---------------------+---------------------+
+| Inodes              | 2\ :sup:`63`        | 2\ :sup:`63`        | 2\ :sup:`64`        |
++---------------------+---------------------+---------------------+---------------------+
+| Allocation Groups   | 2\ :sup:`32`        | 2\ :sup:`32`        | 2\ :sup:`32`        |
++---------------------+---------------------+---------------------+---------------------+
+| File System Size    | 8EiB                | 8EiB                | 8EiB                |
++---------------------+---------------------+---------------------+---------------------+
+| Blocks per AG       | 2\ :sup:`31`        | 2\ :sup:`31`        | 2\ :sup:`31`        |
++---------------------+---------------------+---------------------+---------------------+
+| Inodes per AG       | 2\ :sup:`32`        | 2\ :sup:`32`        | 2\ :sup:`32`        |
++---------------------+---------------------+---------------------+---------------------+
+| Max AG Size         | 2TiB                | 8TiB                | 128TiB              |
++---------------------+---------------------+---------------------+---------------------+
+| Blocks Per File     | 2\ :sup:`54`        | 2\ :sup:`54`        | 2\ :sup:`54`        |
++---------------------+---------------------+---------------------+---------------------+
+| File Size           | 8EiB                | 8EiB                | 8EiB                |
++---------------------+---------------------+---------------------+---------------------+
+| Max Dir Size        | 32GiB               | 32GiB               | 32GiB               |
++---------------------+---------------------+---------------------+---------------------+
+
+Linux doesn’t suppport files or devices larger than 8EiB, so the block
+limitations are largely ignorable.
diff --git a/Documentation/filesystems/xfs-data-structures/overview.rst b/Documentation/filesystems/xfs-data-structures/overview.rst
index b1b3f711638b..23eb71d65c93 100644
--- a/Documentation/filesystems/xfs-data-structures/overview.rst
+++ b/Documentation/filesystems/xfs-data-structures/overview.rst
@@ -47,3 +47,5 @@ latency.
 .. include:: delayed_logging.rst
 .. include:: reflink.rst
 .. include:: reconstruction.rst
+.. include:: common_types.rst
+.. include:: magic.rst
