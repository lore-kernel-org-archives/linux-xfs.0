Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:41404 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754371AbeCUXHi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Mar 2018 19:07:38 -0400
Subject: [PATCH v7 14/14] xfs, dax: introduce xfs_break_dax_layouts()
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 21 Mar 2018 15:58:31 -0700
Message-ID: <152167311132.5268.8502709708606276650.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nvdimm@lists.01.org
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.orgjack@suse.cz

xfs_break_dax_layouts(), similar to xfs_break_leased_layouts(), scans
for busy / pinned dax pages and waits for those pages to go idle before
any potential extent unmap operation.

dax_layout_busy_page() handles synchronizing against new page-busy
events (get_user_pages). It invalidates all mappings to trigger the
get_user_pages slow path which will eventually block on the xfs inode
lock held in XFS_MMAPLOCK_EXCL mode. If dax_layout_busy_page() finds a
busy page it returns it for xfs to wait for the page-idle event that
will fire when the page reference count reaches 1 (recall ZONE_DEVICE
pages are idle at count 1, see generic_dax_pagefree()).

While waiting, the XFS_MMAPLOCK_EXCL lock is dropped in order to not
deadlock the process that might be trying to elevate the page count of
more pages before arranging for any of them to go idle. I.e. the typical
case of submitting I/O is that iov_iter_get_pages() elevates the
reference count of all pages in the I/O before starting I/O on the first
page. The process of elevating the reference count of all pages involved
in an I/O may cause faults that need to take XFS_MMAPLOCK_EXCL.

Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/xfs_file.c |   59 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 49 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7f37fadf007e..d4573f93fddb 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -752,6 +752,38 @@ xfs_file_write_iter(
 	return ret;
 }
 
+static void
+xfs_wait_var_event(
+	struct inode		*inode,
+	uint			iolock,
+	bool			*did_unlock)
+{
+	struct xfs_inode        *ip = XFS_I(inode);
+
+	*did_unlock = true;
+	xfs_iunlock(ip, iolock);
+	schedule();
+	xfs_ilock(ip, iolock);
+}
+
+static int
+xfs_break_dax_layouts(
+	struct inode		*inode,
+	uint			iolock,
+	bool			*did_unlock)
+{
+	struct page		*page;
+
+	*did_unlock = false;
+	page = dax_layout_busy_page(inode->i_mapping);
+	if (!page)
+		return 0;
+
+	return ___wait_var_event(&page->_refcount,
+			atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
+			0, 0, xfs_wait_var_event(inode, iolock, did_unlock));
+}
+
 int
 xfs_break_layouts(
 	struct inode		*inode,
@@ -766,16 +798,23 @@ xfs_break_layouts(
 				| (reason == BREAK_UNMAPI
 					? XFS_MMAPLOCK_EXCL : 0)));
 
-	switch (reason) {
-	case BREAK_UNMAPI:
-		/* fall through */
-	case BREAK_WRITE:
-		error = xfs_break_leased_layouts(inode, iolock, &did_unlock);
-		break;
-	default:
-		error = -EINVAL;
-		break;
-	}
+	do {
+		switch (reason) {
+		case BREAK_UNMAPI:
+			error = xfs_break_dax_layouts(inode, *iolock,
+					&did_unlock);
+			/* fall through */
+		case BREAK_WRITE:
+			if (error || did_unlock)
+				break;
+			error = xfs_break_leased_layouts(inode, iolock,
+					&did_unlock);
+			break;
+		default:
+			error = -EINVAL;
+			break;
+		}
+	} while (error == 0 && did_unlock);
 
 	return error;
 }

