Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7795C29DFB
	for <xfs@oss.sgi.com>; Sat, 22 Nov 2014 10:54:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 07294AC006
	for <xfs@oss.sgi.com>; Sat, 22 Nov 2014 08:54:38 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id HaypRj1Pvfs5c8G2 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 22 Nov 2014 08:54:35 -0800 (PST)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH-v2 4/5] vfs: add lazytime tracepoints for better debugging
Date: Sat, 22 Nov 2014 11:54:26 -0500
Message-Id: <1416675267-2191-5-git-send-email-tytso@mit.edu>
In-Reply-To: <1416675267-2191-1-git-send-email-tytso@mit.edu>
References: <1416675267-2191-1-git-send-email-tytso@mit.edu>
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
To: linux-fsdevel@vger.kernel.org
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/fs-writeback.c         |  5 ++++-
 fs/inode.c                |  5 +++++
 include/trace/events/fs.h | 56 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 1 deletion(-)
 create mode 100644 include/trace/events/fs.h

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index eb04277..cab2d6d 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -27,6 +27,7 @@
 #include <linux/backing-dev.h>
 #include <linux/tracepoint.h>
 #include <linux/device.h>
+#include <trace/events/fs.h>
 #include "internal.h"
 
 /*
@@ -1304,8 +1305,10 @@ static void flush_sb_dirty_time(struct super_block *sb)
 		iput(old_inode);
 		old_inode = inode;
 
-		if (dirty_time)
+		if (dirty_time) {
+			trace_fs_lazytime_flush(inode);
 			mark_inode_dirty(inode);
+		}
 		cond_resched();
 		spin_lock(&inode_sb_list_lock);
 	}
diff --git a/fs/inode.c b/fs/inode.c
index 0d939a8..5a9a7b0 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -20,6 +20,9 @@
 #include <linux/list_lru.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/fs.h>
+
 /*
  * Inode locking rules:
  *
@@ -544,6 +547,7 @@ static void evict(struct inode *inode)
 			mark_inode_dirty(inode);
 			inode->i_sb->s_op->write_inode(inode, &wbc);
 		}
+		trace_fs_lazytime_evict(inode);
 	}
 
 	if (!list_empty(&inode->i_wb_list))
@@ -1546,6 +1550,7 @@ static int update_time(struct inode *inode, struct timespec *time, int flags)
 		inode->i_state |= I_DIRTY_TIME;
 		spin_unlock(&inode->i_lock);
 		inode->i_ts_dirty_day = days_since_boot;
+		trace_fs_lazytime_defer(inode);
 		return 0;
 	}
 	inode->i_ts_dirty_day = 0;
diff --git a/include/trace/events/fs.h b/include/trace/events/fs.h
new file mode 100644
index 0000000..ca06d5c
--- /dev/null
+++ b/include/trace/events/fs.h
@@ -0,0 +1,56 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM fs
+
+#if !defined(_TRACE_FS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_FS_H
+
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(fs__inode,
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	uid_t,	uid			)
+		__field(	gid_t,	gid			)
+		__field(	__u16, mode			)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->uid	= i_uid_read(inode);
+		__entry->gid	= i_gid_read(inode);
+		__entry->mode	= inode->i_mode;
+	),
+
+	TP_printk("dev %d,%d ino %lu mode 0%o uid %u gid %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->mode,
+		  __entry->uid, __entry->gid)
+);
+
+DEFINE_EVENT(fs__inode, fs_lazytime_defer,
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode)
+);
+
+DEFINE_EVENT(fs__inode, fs_lazytime_evict,
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode)
+);
+
+DEFINE_EVENT(fs__inode, fs_lazytime_flush,
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode)
+);
+#endif /* _TRACE_FS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
