Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:44346 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933071AbeCJHEy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 10 Mar 2018 02:04:54 -0500
Subject: [PATCH v5 11/11] xfs, dax: introduce xfs_break_dax_layouts()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 09 Mar 2018 22:55:48 -0800
Message-ID: <152066494840.40260.6478694186268933246.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nvdimm@lists.01.org
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.orgjack@suse.czross.zwisler@linux.intel.comhch@lst.de, linux-kernel@vger.kernel.org

xfs_break_dax_layouts(), similar to xfs_break_leased_layouts(), scans
for busy / pinned dax pages and waits for those pages to go idle before
any potential extent unmap operation.

dax_layout_busy_page() handles synchronizing against new page-busy
events (get_user_pages). It invalidates all mappings to trigger the
get_user_pages slow path which will eventually block on the xfs inode
log held in XFS_MMAPLOCK_EXCL mode. If dax_layout_busy_page() finds a
busy page it returns it for xfs to wait for the page-idle event that
will fire when the page reference count reaches 1 (recall ZONE_DEVICE
pages are idle at count 1). While waiting, the XFS_MMAPLOCK_EXCL lock is
dropped in order to not deadlock the process that might be trying to
elevate the page count of more pages before arranging for any of them to
go idle. I.e. the typical case of submitting I/O is that
iov_iter_get_pages() elevates the reference count of all pages in the
I/O before starting I/O on the first page.

Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/xfs_file.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 65 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f914f0628dc2..3e7a69cebf95 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -752,6 +752,55 @@ xfs_file_write_iter(
 	return ret;
 }
 
+static int xfs_wait_dax_page(
+		atomic_t                *count,
+		unsigned int            mode)
+{
+	uint                    iolock = XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL;
+	struct page             *page = refcount_to_page(count);
+	struct address_space    *mapping = page->mapping;
+	struct inode            *inode = mapping->host;
+	struct xfs_inode        *ip = XFS_I(inode);
+
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL));
+
+	if (page_ref_count(page) == 1)
+		return 0;
+
+	xfs_iunlock(ip, iolock);
+	schedule();
+	xfs_ilock(ip, iolock);
+
+	if (signal_pending_state(mode, current))
+		return -EINTR;
+	return 1;
+}
+
+static int
+xfs_break_dax_layouts(
+	struct inode		*inode,
+	uint			iolock)
+{
+	struct page		*page;
+	int			ret;
+
+	page = dax_layout_busy_page(inode->i_mapping);
+	if (!page)
+		return 0;
+
+	ret = wait_on_atomic_one(&page->_refcount, xfs_wait_dax_page,
+			TASK_INTERRUPTIBLE);
+
+	if (ret <= 0)
+		return ret;
+
+	/*
+	 * We slept, so need to retry. Yes, this assumes transient page
+	 * pins.
+	 */
+	return -EBUSY;
+}
+
 int
 xfs_break_layouts(
 	struct inode		*inode,
@@ -765,12 +814,25 @@ xfs_break_layouts(
 	if (flags & XFS_BREAK_REMOTE)
 		iolock_assert |= XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL;
 	if (flags & XFS_BREAK_MAPS)
-		iolock_assert |= XFS_MMAPLOCK_EXCL;
+		iolock_assert |= XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL;
 
 	ASSERT(xfs_isilocked(ip, iolock_assert));
 
-	if (flags & XFS_BREAK_REMOTE)
-		ret = xfs_break_leased_layouts(inode, iolock);
+	do {
+		if (flags & XFS_BREAK_REMOTE)
+			ret = xfs_break_leased_layouts(inode, iolock);
+		if (ret)
+			return ret;
+		if (flags & XFS_BREAK_MAPS)
+			ret = xfs_break_dax_layouts(inode, *iolock);
+		/*
+		 * EBUSY indicates that we dropped locks and waited for
+		 * the dax layout to be released. When that happens we
+		 * need to revalidate that no new leases or pinned dax
+		 * mappings have been established.
+		 */
+	} while (ret == -EBUSY);
+
 	return ret;
 }
 

