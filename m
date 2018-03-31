Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:25317 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753103AbeCaENl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 31 Mar 2018 00:13:41 -0400
Subject: [PATCH v8 18/18] xfs, dax: introduce xfs_break_dax_layouts()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Mar 2018 21:03:46 -0700
Message-ID: <152246902607.36038.15813002361509305325.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nvdimm@lists.01.org
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.orgjack@suse.cz, snitzer@redhat.com

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
 fs/xfs/xfs_file.c |   60 +++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 49 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 51e6506bdcb1..0342f6fb782f 100644
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
@@ -763,17 +795,23 @@ xfs_break_layouts(
 
 	ASSERT(xfs_isilocked(XFS_I(inode), XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
 
-	switch (reason) {
-	case BREAK_UNMAP:
-		ASSERT(xfs_isilocked(XFS_I(inode), XFS_MMAPLOCK_EXCL));
-		/* fall through */
-	case BREAK_WRITE:
-		error = xfs_break_leased_layouts(inode, iolock, &retry);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return -EINVAL;
-	}
+	do {
+		switch (reason) {
+		case BREAK_UNMAP:
+			ASSERT(xfs_isilocked(XFS_I(inode), XFS_MMAPLOCK_EXCL));
+
+			error = xfs_break_dax_layouts(inode, *iolock, &retry);
+			/* fall through */
+		case BREAK_WRITE:
+			if (error || retry)
+				break;
+			error = xfs_break_leased_layouts(inode, iolock, &retry);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			return -EINVAL;
+		}
+	} while (error == 0 && retry);
 
 	return error;
 }

