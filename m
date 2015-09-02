Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5926C7F5F
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 20:25:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D6566AC012
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 18:25:21 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4z5EIYdJZDHnoz3u for <xfs@oss.sgi.com>;
	Tue, 01 Sep 2015 18:25:19 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: add ->pfn_mkwrite support for DAX
Date: Wed,  2 Sep 2015 11:25:00 +1000
Message-Id: <1441157100-1658-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: boaz@plexistor.com, kirill.shutemov@linux.intel.com

From: Dave Chinner <dchinner@redhat.com>

->pfn_mkwrite support is needed so that when a page with allocated
backing store first takes a write fault the timestamps on the
file are updated. THis fixes a generic/080 failure.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c  | 11 +++++++++++
 fs/xfs/xfs_trace.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index de2c237..26535ba 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1546,10 +1546,21 @@ xfs_filemap_fault(
 	return ret;
 }
 
+static int
+xfs_filemap_pfn_mkwrite(
+	struct vm_area_struct	*vma,
+	struct vm_fault		*vmf)
+{
+	trace_xfs_filemap_pfn_mkwrite(XFS_I(file_inode(vma->vm_file)));
+
+	return dax_pfn_mkwrite(vma, vmf);
+}
+
 static const struct vm_operations_struct xfs_file_vm_ops = {
 	.fault		= xfs_filemap_fault,
 	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= xfs_filemap_page_mkwrite,
+	.pfn_mkwrite	= xfs_filemap_pfn_mkwrite,
 };
 
 STATIC int
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8b5432e..63d87f2 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -688,6 +688,7 @@ DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
 
 DEFINE_INODE_EVENT(xfs_filemap_fault);
 DEFINE_INODE_EVENT(xfs_filemap_page_mkwrite);
+DEFINE_INODE_EVENT(xfs_filemap_pfn_mkwrite);
 
 DECLARE_EVENT_CLASS(xfs_iref_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
