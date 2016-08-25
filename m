Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 114EC7DDA
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:38:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BCFF78F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:38:15 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id E3K8Z1qqu3LeKAkv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:38:14 -0700 (PDT)
Subject: [PATCH 57/71] xfs: promote buffered writes to CoW when cowextsz is set
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:38:07 -0700
Message-ID: <147216828776.867.12361135037176012283.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

When we're doing non-cow writes to a part of a file that already has a
CoW reservation by virtue of cowextsz being set, promote the write to
copy-on-write so that the entire extent can get written out as a single
block, thereby reducing post-CoW fragmentation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c |   39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e8d573e..a85bc62 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -666,10 +666,12 @@ xfs_check_page_type(
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
@@ -834,25 +836,13 @@ xfs_writepage_map(
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
@@ -865,6 +855,13 @@ xfs_writepage_map(
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
