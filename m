Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6I3eR4U077982 for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 22:40:27 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 449A1ECA969
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 20:40:25 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	vVEzkUmQhRwHMuVX for <xfs@oss.sgi.com>;
	Sun, 17 Jul 2011 20:40:25 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Qiegx-0008Bf-7W
	for xfs@oss.sgi.com; Mon, 18 Jul 2011 13:40:23 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1Qiegx-0002aF-0G
	for xfs@oss.sgi.com; Mon, 18 Jul 2011 13:40:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfs: add size update tracepoint to IO completion
Date: Mon, 18 Jul 2011 13:40:19 +1000
Message-Id: <1310960419-9875-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1310960419-9875-1-git-send-email-david@fromorbit.com>
References: <1310960419-9875-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

For improving insight into IO completion behaviour.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_aops.c  |    1 +
 fs/xfs/linux-2.6/xfs_trace.h |   12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index f865350..63e971e 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -181,6 +181,7 @@ xfs_setfilesize(
 
 	isize = xfs_ioend_new_eof(ioend);
 	if (isize) {
+		trace_xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
 		ip->i_d.di_size = isize;
 		xfs_mark_inode_dirty(ip);
 	}
diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 3bdfcb9..fda0708 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -998,7 +998,8 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
-		__field(loff_t, size)
+		__field(loff_t, isize)
+		__field(loff_t, disize)
 		__field(loff_t, new_size)
 		__field(loff_t, offset)
 		__field(size_t, count)
@@ -1006,16 +1007,18 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
-		__entry->size = ip->i_d.di_size;
+		__entry->isize = ip->i_size;
+		__entry->disize = ip->i_d.di_size;
 		__entry->new_size = ip->i_new_size;
 		__entry->offset = offset;
 		__entry->count = count;
 	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx "
+	TP_printk("dev %d:%d ino 0x%llx isize 0x%llx disize 0x%llx new_size 0x%llx "
 		  "offset 0x%llx count %zd",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-		  __entry->size,
+		  __entry->isize,
+		  __entry->disize,
 		  __entry->new_size,
 		  __entry->offset,
 		  __entry->count)
@@ -1028,6 +1031,7 @@ DEFINE_EVENT(xfs_simple_io_class, name,	\
 DEFINE_SIMPLE_IO_EVENT(xfs_delalloc_enospc);
 DEFINE_SIMPLE_IO_EVENT(xfs_unwritten_convert);
 DEFINE_SIMPLE_IO_EVENT(xfs_get_blocks_notfound);
+DEFINE_SIMPLE_IO_EVENT(xfs_setfilesize);
 
 DECLARE_EVENT_CLASS(xfs_itrunc_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size),
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
