Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0FAEC7CA2
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 13:37:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C94BA304048
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 11:37:34 -0700 (PDT)
Received: from shadbolt.e.decadent.org.uk (shadbolt.e.decadent.org.uk
	[88.96.1.126]) by cuda.sgi.com with ESMTP id Zx1FQ4vcNpm6RR51
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jun 2016 11:37:32 -0700 (PDT)
Content-Disposition: inline
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 13 Jun 2016 19:36:37 +0100
Message-ID: <lsq.1465842997.496189698@decadent.org.uk>
Subject: [PATCH 3.16 092/114] xfs: use i_mmaplock on read faults
In-Reply-To: <lsq.1465842997.838358341@decadent.org.uk>
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
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>, akpm@linux-foundation.org

3.16.36-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit de0e8c20ba3a65b0f15040aabbefdc1999876e6b upstream.

Take the i_mmaplock over read page faults. These come through the
->fault callout, so we need to wrap the generic implementation
with the i_mmaplock. While there, add tracepoints for the read
fault as it passes through XFS.

This gives us a lock order of mmap_sem -> i_mmaplock -> page_lock
-> i_lock.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com
---
 fs/xfs/xfs_file.c  | 28 +++++++++++++++++++++++++++-
 fs/xfs/xfs_trace.h |  2 ++
 2 files changed, 29 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1417,6 +1417,32 @@ xfs_file_llseek(
 	}
 }
 
+/*
+ * Locking for serialisation of IO during page faults. This results in a lock
+ * ordering of:
+ *
+ * mmap_sem (MM)
+ *   i_mmap_lock (XFS - truncate serialisation)
+ *     page_lock (MM)
+ *       i_lock (XFS - extent map serialisation)
+ */
+STATIC int
+xfs_filemap_fault(
+	struct vm_area_struct	*vma,
+	struct vm_fault		*vmf)
+{
+	struct xfs_inode	*ip = XFS_I(vma->vm_file->f_mapping->host);
+	int			error;
+
+	trace_xfs_filemap_fault(ip);
+
+	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
+	error = filemap_fault(vma, vmf);
+	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
+
+	return error;
+}
+
 const struct file_operations xfs_file_operations = {
 	.llseek		= xfs_file_llseek,
 	.read		= new_sync_read,
@@ -1449,7 +1475,7 @@ const struct file_operations xfs_dir_fil
 };
 
 static const struct vm_operations_struct xfs_file_vm_ops = {
-	.fault		= filemap_fault,
+	.fault		= xfs_filemap_fault,
 	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= xfs_vm_page_mkwrite,
 	.remap_pages	= generic_file_remap_pages,
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -684,6 +684,8 @@ DEFINE_INODE_EVENT(xfs_inode_set_eofbloc
 DEFINE_INODE_EVENT(xfs_inode_clear_eofblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
 
+DEFINE_INODE_EVENT(xfs_filemap_fault);
+
 DECLARE_EVENT_CLASS(xfs_iref_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
 	TP_ARGS(ip, caller_ip),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
