Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51013 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932571AbcJRBws (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 21:52:48 -0400
Date: Mon, 17 Oct 2016 18:52:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] docs: update refcount btree to reflect new cow staging
 extent policy
Message-ID: <20161018015243.GC20337@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: linux-xfs@vger.kernel.org

We now record the extents being used to stage a copy on write operation
in the refcount btree with the high bit of rc_startblock set and a
reference count of 1.  Setting the high bit helps us reduce CoW GC time
at mount by moving all the records to the right side of the tree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../XFS_Filesystem_Structure/refcountbt.asciidoc   |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/design/XFS_Filesystem_Structure/refcountbt.asciidoc b/design/XFS_Filesystem_Structure/refcountbt.asciidoc
index dbbb98e..508a9dd 100644
--- a/design/XFS_Filesystem_Structure/refcountbt.asciidoc
+++ b/design/XFS_Filesystem_Structure/refcountbt.asciidoc
@@ -25,7 +25,10 @@ struct xfs_refcount_rec {
 ----
 
 *rc_startblock*::
-AG block number of this record.
+AG block number of this record.  The high bit is set for all records
+referring to an extent that is being used to stage a copy on write
+operation.  This reduces recovery time during mount operations.  The
+reference count of these staging events must only be 1.
 
 *rc_blockcount*::
 The length of this extent.
@@ -81,12 +84,18 @@ lsn = 0x200004ec2
 uuid = f1f89746-e00b-49c9-96b3-ecef0f2f14ae
 owner = 0
 crc = 0xc3962813 (correct)
-recs[1-80] = [startblock,blockcount,refcount]
-        1:[65780,1,2] 2:[65781,1,3] 3:[65785,2,2] 4:[66640,1,2]
-        5:[69602,4,2] 6:[72256,16,2] 7:[72871,4,2] 8:[72879,20,2]
-        9:[73395,4,2] 10:[75063,4,2] 11:[79093,4,2] 12:[86344,16,2]
+recs[1-80] = [startblock,blockcount,refcount,cowflag]
+        1:[65780,1,2,0] 2:[65781,1,3,0] 3:[65785,2,2,0] 4:[66640,1,2,0]
+        5:[69602,4,2,0] 6:[72256,16,2,0] 7:[72871,4,2,0] 8:[72879,20,2,0]
+        9:[73395,4,2,0] 10:[75063,4,2,0] 11:[79093,4,2,0] 12:[86344,16,2,0]
+        ...
+        80:[35235,10,1,1]
 ----
 
+Notice record 80.  The copy on write flag is set and the reference count is
+1, which indicates that the extent 35,235 - 35,244 are being used to stage a
+copy on write activity.  The "cowflag" field is the high bit of rc_startblock.
+
 Record 6 in the reference count B+tree for AG 0 indicates that the AG extent
 starting at block 72,256 and running for 16 blocks has a reference count of 2.
 This means that there are two files sharing the block:
