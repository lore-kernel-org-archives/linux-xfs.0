Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7B1217F5E
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 04:24:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5A8608F8033
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 02:24:05 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id mX0onk8hHQ8vZMz0 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Nov 2014 02:24:04 -0800 (PST)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH-v4 4/7] vfs: add lazytime tracepoints for better debugging
Date: Wed, 26 Nov 2014 05:23:54 -0500
Message-Id: <1416997437-26092-5-git-send-email-tytso@mit.edu>
In-Reply-To: <1416997437-26092-1-git-send-email-tytso@mit.edu>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
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
To: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/fs-writeback.c | 1 +
 fs/inode.c        | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 529480a..3d87174 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -27,6 +27,7 @@
 #include <linux/backing-dev.h>
 #include <linux/tracepoint.h>
 #include <linux/device.h>
+#include <trace/events/fs.h>
 #include "internal.h"
 
 /*
diff --git a/fs/inode.c b/fs/inode.c
index 37c0429..b2fea60 100644
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
@@ -1443,6 +1446,7 @@ retry:
 				inode->i_op->write_time(inode);
 			else if (inode->i_sb->s_op->write_inode)
 				mark_inode_dirty_sync(inode);
+			trace_fs_lazytime_iput(inode);
 			goto retry;
 		}
 		iput_final(inode);
@@ -1561,6 +1565,7 @@ static int update_time(struct inode *inode, struct timespec *time, int flags)
 		inode->i_ts_dirty_day = days_since_boot;
 		spin_unlock(&inode->i_lock);
 		inode_requeue_dirtytime(inode);
+		trace_fs_lazytime_defer(inode);
 		return 0;
 	}
 force_dirty:
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
