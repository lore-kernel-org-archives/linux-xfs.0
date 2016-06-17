Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8E4C07E88
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:28:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 50521304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:28:50 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id yzVZlGBLkgaVDuBv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:28:48 -0700 (PDT)
Subject: [PATCH 101/119] xfs: promote buffered writes to CoW when cowextsz
	is set
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:28:43 -0700
Message-ID: <146612692370.12839.6519871693319312435.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

When we're doing non-cow writes to a part of a file that already has a
CoW reservation by virtue of cowextsz being set, promote the write to
copy-on-write so that the entire extent can get written out as a single
block, thereby reducing post-CoW fragmentation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c |   39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 812bae5..31205fa 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -668,10 +668,12 @@ xfs_check_page_type(
 	bh = head = page_buffers(page);
 	do {
 		if (buffer_unwritten(bh)) {
-			if (type == XFS_IO_UNWRITTEN)
+			if (type == XFS_IO_UNWRITTEN ||
+			    type == XFS_IO_COW)
 				return true;
 		} else if (buffer_delay(bh)) {
-			if (type == XFS_IO_DELALLOC)
+			if (type == XFS_IO_DELALLOC ||
+			    type == XFS_IO_COW)
 				return true;
 		} else if (buffer_dirty(bh) && buffer_mapped(bh)) {
 			if (type == XFS_IO_OVERWRITE ||
@@ -836,25 +838,13 @@ xfs_writepage_map(
 			continue;
 		}
 
-		if (buffer_unwritten(bh)) {
-			if (wpc->io_type != XFS_IO_UNWRITTEN) {
-				wpc->io_type = XFS_IO_UNWRITTEN;
-				wpc->imap_valid = false;
-			}
-		} else if (buffer_delay(bh)) {
-			if (wpc->io_type != XFS_IO_DELALLOC) {
-				wpc->io_type = XFS_IO_DELALLOC;
-				wpc->imap_valid = false;
-			}
-		} else if (buffer_uptodate(bh)) {
-			new_type = xfs_is_cow_io(XFS_I(inode), offset) ?
-					XFS_IO_COW : XFS_IO_OVERWRITE;
-
-			if (wpc->io_type != new_type) {
-				wpc->io_type = new_type;
-				wpc->imap_valid = false;
-			}
-		} else {
+		if (buffer_unwritten(bh))
+			new_type = XFS_IO_UNWRITTEN;
+		else if (buffer_delay(bh))
+			new_type = XFS_IO_DELALLOC;
+		else if (buffer_uptodate(bh))
+			new_type = XFS_IO_OVERWRITE;
+		else {
 			if (PageUptodate(page))
 				ASSERT(buffer_mapped(bh));
 			/*
@@ -867,6 +857,13 @@ xfs_writepage_map(
 			continue;
 		}
 
+		if (xfs_is_cow_io(XFS_I(inode), offset))
+			new_type = XFS_IO_COW;
+		if (wpc->io_type != new_type) {
+			wpc->io_type = new_type;
+			wpc->imap_valid = false;
+		}
+
 		if (wpc->imap_valid)
 			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
 							 offset);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
