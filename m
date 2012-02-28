Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1SB1gbE177528 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 05:01:43 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	2o8TAvUTCisyzkvZ (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Feb 2012 03:01:41 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1S2KoO-0005gY-T3
	for xfs@oss.sgi.com; Tue, 28 Feb 2012 11:01:40 +0000
Date: Tue, 28 Feb 2012 06:01:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: trace xfs_name strings correctly
Message-ID: <20120228110140.GA20760@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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

Strings store in an xfs_name structure are often not NUL terminated,
print them using the correct printf specifiers that make use of the
string length store in the xfs_name structure.

Reported-by: Brian Candler <B.Candler@pobox.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trace.h	2012-02-02 13:11:38.355063111 +0100
+++ xfs/fs/xfs/xfs_trace.h	2012-02-02 14:58:45.800242652 +0100
@@ -627,16 +627,19 @@ DECLARE_EVENT_CLASS(xfs_namespace_class,
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
 
@@ -658,6 +661,8 @@ TRACE_EVENT(xfs_rename,
 		__field(dev_t, dev)
 		__field(xfs_ino_t, src_dp_ino)
 		__field(xfs_ino_t, target_dp_ino)
+		__field(int, src_namelen)
+		__field(int, target_namelen)
 		__dynamic_array(char, src_name, src_name->len)
 		__dynamic_array(char, target_name, target_name->len)
 	),
@@ -665,15 +670,20 @@ TRACE_EVENT(xfs_rename,
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
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
