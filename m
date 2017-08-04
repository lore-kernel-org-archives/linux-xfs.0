Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:25709 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751910AbdHDCfA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Aug 2017 22:35:00 -0400
Subject: [PATCH v2 5/5] xfs: toggle XFS_DIFLAG2_IOMAP_IMMUTABLE in response
 to fallocate
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 03 Aug 2017 19:28:35 -0700
Message-ID: <150181371519.32119.2762945986660101008.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, luto@kernel.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>

After validating the state of the file as not having holes, shared
extents, or active mappings try to commit the
XFS_DIFLAG2_IOMAP_IMMUTABLE flag to the on-disk inode metadata. If that
succeeds then allow the S_IOMAP_IMMUTABLE to be set on the vfs inode.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Suggested-by: "Darrick J. Wong" <darrick.wong@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/xfs_bmap_util.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 70ac2d33ab27..8464c25a2403 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1436,9 +1436,11 @@ xfs_seal_file_space(
 	xfs_off_t		offset,
 	xfs_off_t		len)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
 	struct address_space	*mapping = inode->i_mapping;
 	int			error;
+	struct xfs_trans	*tp;
 
 	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
 
@@ -1454,6 +1456,10 @@ xfs_seal_file_space(
 	if (error)
 		return error;
 
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	/*
 	 * Either the size changed after we performed allocation /
@@ -1486,10 +1492,20 @@ xfs_seal_file_space(
 	if (error < 0)
 		goto out_unlock;
 
+	xfs_trans_ijoin(tp, ip, 0);
+	ip->i_d.di_flags2 |= XFS_DIFLAG2_IOMAP_IMMUTABLE;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	error = xfs_trans_commit(tp);
+	tp = NULL; /* nothing to cancel */
+	if (error)
+		goto out_unlock;
+
 	inode->i_flags |= S_IOMAP_IMMUTABLE;
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (tp)
+		xfs_trans_cancel(tp);
 
 	return error;
 }
@@ -1500,15 +1516,21 @@ xfs_unseal_file_space(
 	xfs_off_t		offset,
 	xfs_off_t		len)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
 	struct address_space	*mapping = inode->i_mapping;
 	int			error;
+	struct xfs_trans	*tp;
 
 	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
 
 	if (offset)
 		return -EINVAL;
 
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	/*
 	 * It does not make sense to unseal less than the full range of
@@ -1527,11 +1549,21 @@ xfs_unseal_file_space(
 	if (mapping_mapped(mapping))
 		goto out_unlock;
 
+	xfs_trans_ijoin(tp, ip, 0);
+	ip->i_d.di_flags2 &= ~XFS_DIFLAG2_IOMAP_IMMUTABLE;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	error = xfs_trans_commit(tp);
+	tp = NULL; /* nothing to cancel */
+	if (error)
+		goto out_unlock;
+
 	inode->i_flags &= ~S_IOMAP_IMMUTABLE;
 	error = 0;
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (tp)
+		xfs_trans_cancel(tp);
 
 	return error;
 }

