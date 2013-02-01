Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 04F4B7F98
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 04:44:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DE4BC8F8039
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 02:44:27 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JUQFkyLjZSl9yCPT for
	<xfs@oss.sgi.com>; Fri, 01 Feb 2013 02:44:27 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 16/18] ext4: update ext4_ext_remove_space trace point
Date: Fri,  1 Feb 2013 11:43:42 +0100
Message-Id: <1359715424-32318-17-git-send-email-lczerner@redhat.com>
In-Reply-To: <1359715424-32318-1-git-send-email-lczerner@redhat.com>
References: <1359715424-32318-1-git-send-email-lczerner@redhat.com>
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
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Add "end" variable.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c           |    6 +++---
 include/trace/events/ext4.h |   21 ++++++++++++++-------
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 966a09e..2b7e521 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2647,7 +2647,7 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 again:
 	ext4_ext_invalidate_cache(inode);
 
-	trace_ext4_ext_remove_space(inode, start, depth);
+	trace_ext4_ext_remove_space(inode, start, end, depth);
 
 	/*
 	 * Check if we are removing extents inside the extent tree. If that
@@ -2813,8 +2813,8 @@ again:
 		}
 	}
 
-	trace_ext4_ext_remove_space_done(inode, start, depth, partial_cluster,
-			path->p_hdr->eh_entries);
+	trace_ext4_ext_remove_space_done(inode, start, end, depth,
+			partial_cluster, path->p_hdr->eh_entries);
 
 	/* If we still have something in the partial cluster and we have removed
 	 * even the first extent, then we should free the blocks in the partial
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 6ab6f8a..5fd98f9 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -2010,14 +2010,16 @@ TRACE_EVENT(ext4_ext_rm_idx,
 );
 
 TRACE_EVENT(ext4_ext_remove_space,
-	TP_PROTO(struct inode *inode, ext4_lblk_t start, int depth),
+	TP_PROTO(struct inode *inode, ext4_lblk_t start,
+		 ext4_lblk_t end, int depth),
 
-	TP_ARGS(inode, start, depth),
+	TP_ARGS(inode, start, end, depth),
 
 	TP_STRUCT__entry(
 		__field(	dev_t,		dev	)
 		__field(	ino_t,		ino	)
 		__field(	ext4_lblk_t,	start	)
+		__field(	ext4_lblk_t,	end	)
 		__field(	int,		depth	)
 	),
 
@@ -2025,26 +2027,29 @@ TRACE_EVENT(ext4_ext_remove_space,
 		__entry->dev	= inode->i_sb->s_dev;
 		__entry->ino	= inode->i_ino;
 		__entry->start	= start;
+		__entry->end	= end;
 		__entry->depth	= depth;
 	),
 
-	TP_printk("dev %d,%d ino %lu since %u depth %d",
+	TP_printk("dev %d,%d ino %lu start %u end %u depth %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  (unsigned) __entry->start,
+		  (unsigned) __entry->end,
 		  __entry->depth)
 );
 
 TRACE_EVENT(ext4_ext_remove_space_done,
-	TP_PROTO(struct inode *inode, ext4_lblk_t start, int depth,
-		ext4_lblk_t partial, unsigned short eh_entries),
+	TP_PROTO(struct inode *inode, ext4_lblk_t start, ext4_lblk_t end,
+		 int depth, ext4_lblk_t partial, unsigned short eh_entries),
 
-	TP_ARGS(inode, start, depth, partial, eh_entries),
+	TP_ARGS(inode, start, end, depth, partial, eh_entries),
 
 	TP_STRUCT__entry(
 		__field(	dev_t,		dev		)
 		__field(	ino_t,		ino		)
 		__field(	ext4_lblk_t,	start		)
+		__field(	ext4_lblk_t,	end		)
 		__field(	int,		depth		)
 		__field(	ext4_lblk_t,	partial		)
 		__field(	unsigned short,	eh_entries	)
@@ -2054,16 +2059,18 @@ TRACE_EVENT(ext4_ext_remove_space_done,
 		__entry->dev		= inode->i_sb->s_dev;
 		__entry->ino		= inode->i_ino;
 		__entry->start		= start;
+		__entry->end		= end;
 		__entry->depth		= depth;
 		__entry->partial	= partial;
 		__entry->eh_entries	= eh_entries;
 	),
 
-	TP_printk("dev %d,%d ino %lu since %u depth %d partial %u "
+	TP_printk("dev %d,%d ino %lu start %u end %u depth %d partial %u "
 		  "remaining_entries %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  (unsigned) __entry->start,
+		  (unsigned) __entry->end,
 		  __entry->depth,
 		  (unsigned) __entry->partial,
 		  (unsigned short) __entry->eh_entries)
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
