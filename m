Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N548XD135554 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:09 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	yZRf6PJH3PMERv2m for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:54 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Paz-0003I5-RB
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:41 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Paz-0003gM-NZ
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 062/102] xfs: trace xfs_name strings correctly
Date: Thu, 23 Aug 2012 15:02:20 +1000
Message-Id: <1345698180-13612-63-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: f616137519feb17b849894fcbe634a021d3fa7db

Strings store in an xfs_name structure are often not NUL terminated,
print them using the correct printf specifiers that make use of the
string length store in the xfs_name structure.

Reported-by: Brian Candler <B.Candler@pobox.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 3509faf..4e544af 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -628,16 +628,19 @@ DECLARE_EVENT_CLASS(xfs_namespace_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, dp_ino)
+		__field(int, namelen)
 		__dynamic_array(char, name, name->len)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(dp)->i_sb->s_dev;
 		__entry->dp_ino = dp->i_ino;
+		__entry->namelen = name->len;
 		memcpy(__get_str(name), name->name, name->len);
 	),
-	TP_printk("dev %d:%d dp ino 0x%llx name %s",
+	TP_printk("dev %d:%d dp ino 0x%llx name %.*s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->dp_ino,
+		  __entry->namelen,
 		  __get_str(name))
 )
 
@@ -659,6 +662,8 @@ TRACE_EVENT(xfs_rename,
 		__field(dev_t, dev)
 		__field(xfs_ino_t, src_dp_ino)
 		__field(xfs_ino_t, target_dp_ino)
+		__field(int, src_namelen)
+		__field(int, target_namelen)
 		__dynamic_array(char, src_name, src_name->len)
 		__dynamic_array(char, target_name, target_name->len)
 	),
@@ -666,15 +671,20 @@ TRACE_EVENT(xfs_rename,
 		__entry->dev = VFS_I(src_dp)->i_sb->s_dev;
 		__entry->src_dp_ino = src_dp->i_ino;
 		__entry->target_dp_ino = target_dp->i_ino;
+		__entry->src_namelen = src_name->len;
+		__entry->target_namelen = target_name->len;
 		memcpy(__get_str(src_name), src_name->name, src_name->len);
-		memcpy(__get_str(target_name), target_name->name, target_name->len);
+		memcpy(__get_str(target_name), target_name->name,
+			target_name->len);
 	),
 	TP_printk("dev %d:%d src dp ino 0x%llx target dp ino 0x%llx"
-		  " src name %s target name %s",
+		  " src name %.*s target name %.*s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->src_dp_ino,
 		  __entry->target_dp_ino,
+		  __entry->src_namelen,
 		  __get_str(src_name),
+		  __entry->target_namelen,
 		  __get_str(target_name))
 )
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
