Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG6i1cs067283 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:44:01 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id QeFzEkVoUCcTAYuk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 22:46:06 -0800 (PST)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id qAG6k5Ix003831
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:46:06 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	qAG6k5e1005792
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:46:05 GMT
Received: from abhmt107.oracle.com (abhmt107.oracle.com [141.146.116.59])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	qAG6k5t2010460 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:46:05 -0600
Message-ID: <50A5E128.3050302@oracle.com>
Date: Fri, 16 Nov 2012 14:46:00 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 08/15] xfs:  Add tracing support for inode swap
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Add tracing support for swapping inodes.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_dfrag.c |    6 ++++++
 fs/xfs/xfs_trace.h |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index f91b79c..0e3e53c 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -510,6 +510,9 @@ xfs_swap_inodes(
 		goto out_unlock;
 	}
 
+	trace_xfs_swap_inode_before(ip, 0);
+	trace_xfs_swap_inode_before(tip, 1);
+
 	/*
 	 * We need to fail if the file is memory mapped.  Once we have tossed
 	 * all existing pages, the page fault will have no option but to go to
@@ -614,6 +617,9 @@ xfs_swap_inodes(
 
 	error = xfs_trans_commit(tp, 0);
 
+	trace_xfs_swap_inode_after(ip, 0);
+	trace_xfs_swap_inode_after(tip, 1);
+
 out:
 	if (dic)
 		kmem_free(dic);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7d36ccf..b4dcb70 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1664,6 +1664,43 @@ DEFINE_EVENT(xfs_swap_extent_class, name, \
 DEFINE_SWAPEXT_EVENT(xfs_swap_extent_before);
 DEFINE_SWAPEXT_EVENT(xfs_swap_extent_after);
 
+#define XFS_SWAPINO_INODES \
+	{ 0,	"target" }, \
+	{ 1,	"temp" }
+
+DECLARE_EVENT_CLASS(xfs_swap_inode_class,
+	TP_PROTO(struct xfs_inode *ip, int which),
+	TP_ARGS(ip, which),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int, which)
+		__field(xfs_ino_t, ino)
+		__field(int, format)
+		__field(int, fork_off)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->which = which;
+		__entry->ino = ip->i_ino;
+		__entry->format = ip->i_d.di_format;
+		__entry->fork_off = XFS_IFORK_BOFF(ip);
+	),
+	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, fork offset %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_symbolic(__entry->which, XFS_SWAPINO_INODES),
+		  __print_symbolic(__entry->format, XFS_INODE_FORMAT_STR),
+		  __entry->fork_off)
+)
+
+#define DEFINE_SWAPINO_EVENT(name) \
+DEFINE_EVENT(xfs_swap_inode_class, name, \
+	TP_PROTO(struct xfs_inode *ip, int which), \
+	TP_ARGS(ip, which))
+
+DEFINE_SWAPINO_EVENT(xfs_swap_inode_before);
+DEFINE_SWAPINO_EVENT(xfs_swap_inode_after);
+
 DECLARE_EVENT_CLASS(xfs_log_recover_item_class,
 	TP_PROTO(struct xlog *log, struct xlog_recover *trans,
 		struct xlog_recover_item *item, int pass),
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
