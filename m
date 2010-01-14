Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0E1bMAe208859 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 19:37:22 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2040D1C4D8C4
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 17:38:18 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	GEwMI4GkB5y5hFMw for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2010 17:38:18 -0800 (PST)
Received: from discord (unverified [121.44.236.168])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11630446-1927428
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 12:08:17 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NVEf8-0007MY-TX
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 12:38:14 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NVEb5-0003UK-Kr
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 12:34:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs: add tracing to xfs_swap_extents
Date: Thu, 14 Jan 2010 12:33:55 +1100
Message-Id: <1263432836-13368-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1263432836-13368-1-git-send-email-david@fromorbit.com>
References: <1263432836-13368-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

TO be able to diagnose whether the swap extents function is detecting
compatible inode data fork configurations for swapping extents, add
tracing points to the code to allow us to see the format of the
inode forks before and after the swap.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |   53 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dfrag.c           |    5 ++++
 2 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 058fff1..1bb09e7 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -1441,6 +1441,59 @@ TRACE_EVENT(xfs_dir2_leafn_moveents,
 		  __entry->count)
 );
 
+#define XFS_SWAPEXT_INODES \
+	{ 0,	"target" }, \
+	{ 1,	"temp" }
+
+#define XFS_INODE_FORMAT_STR \
+	{ 0,	"invalid" }, \
+	{ 1,	"local" }, \
+	{ 2,	"extent" }, \
+	{ 3,	"btree" }
+
+DECLARE_EVENT_CLASS(xfs_swap_extent_class,
+	TP_PROTO(struct xfs_inode *ip, int which),
+	TP_ARGS(ip, which),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int, which)
+		__field(xfs_ino_t, ino)
+		__field(int, format)
+		__field(int, nex)
+		__field(int, max_nex)
+		__field(int, broot_size)
+		__field(int, fork_off)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->which = which;
+		__entry->ino = ip->i_ino;
+		__entry->format = ip->i_d.di_format;
+		__entry->nex = ip->i_d.di_nextents;
+		__entry->max_nex = ip->i_df.if_ext_max;
+		__entry->broot_size = ip->i_df.if_broot_bytes;
+		__entry->fork_off = XFS_IFORK_BOFF(ip);
+	),
+	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %d, "
+		  "Max in-fork extents %d, broot size %d, fork offset %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_symbolic(__entry->which, XFS_SWAPEXT_INODES),
+		  __print_symbolic(__entry->format, XFS_INODE_FORMAT_STR),
+		  __entry->nex,
+		  __entry->max_nex,
+		  __entry->broot_size,
+		  __entry->fork_off)
+)
+
+#define DEFINE_SWAPEXT_EVENT(name) \
+DEFINE_EVENT(xfs_swap_extent_class, name, \
+	TP_PROTO(struct xfs_inode *ip, int which), \
+	TP_ARGS(ip, which))
+
+DEFINE_SWAPEXT_EVENT(xfs_swap_extent_before);
+DEFINE_SWAPEXT_EVENT(xfs_swap_extent_after);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index 97711d8..eb4e404 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -254,6 +254,9 @@ xfs_swap_extents(
 		goto out_unlock;
 	}
 
+	trace_xfs_swap_extent_before(ip, 0);
+	trace_xfs_swap_extent_before(tip, 1);
+
 	/* check inode formats now that data is flushed */
 	error = xfs_swap_extents_check_format(ip, tip);
 	if (error) {
@@ -421,6 +424,8 @@ xfs_swap_extents(
 
 	error = xfs_trans_commit(tp, XFS_TRANS_SWAPEXT);
 
+	trace_xfs_swap_extent_after(ip, 0);
+	trace_xfs_swap_extent_after(tip, 1);
 out:
 	kmem_free(tempifp);
 	return error;
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
