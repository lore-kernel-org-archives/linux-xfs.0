Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12E9oYc055443 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 08:09:50 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	95O52Zfc9kkdMGbi (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 06:09:48 -0800 (PST)
Date: Thu, 2 Feb 2012 09:09:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Trailing garbage in event tracing output
Message-ID: <20120202140947.GA16244@infradead.org>
References: <20120202115211.GA1259@nsrc.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20120202115211.GA1259@nsrc.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Candler <B.Candler@pobox.com>
Cc: xfs@oss.sgi.com


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 02, 2012 at 11:52:11AM +0000, Brian Candler wrote:
> Just a minor issue, but when I did some XFS tracing using the instructions
> at http://lwn.net/Articles/341899/ I found that there was trailing garbage
> in the filenames logged in xfs_lookup.  Example:

> (where I think the real filename was "000000295aSl688"). I would guess the
> logger is expecting null-terminated strings but they aren't.

That's indeed the case.  See the attched patch to fix the issue.  To
apply it against the 3.0 kernel you'll probably have to edit it to
remove "linux-2.6/" directory in the filenames.


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=xfs-fix-filename-tracing

From: Christoph Hellwig <hch@lst.de>
Subject: xfs: trace xfs_name strings correctly 

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
 

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--VbJkn9YxBvnuCH5J--
