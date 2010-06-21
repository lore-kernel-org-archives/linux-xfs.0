Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L8XSMO113448 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 03:33:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A5251453C5D
	for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:40:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id WwwhQRUJjRLhMpIC for
	<xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:40:13 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OQcUB-0007bz-Vf
	for xfs@oss.sgi.com; Mon, 21 Jun 2010 08:36:08 +0000
Message-Id: <20100621083607.851430261@bombadil.infradead.org>
Date: Mon, 21 Jun 2010 04:35:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/12] xfs: some iget tracing cleanups / fixes
References: <20100621083543.125860679@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-iget-tracing
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

The xfs_iget_alloc/found tracepoints are a bit misnamed and misplaced.
Rename them to xfs_iget_hit/xfs_iget_miss and move them to the beggining
of the xfs_iget_cache_hit/miss functions.  Add a new xfs_iget_reclaim_fail
tracepoint for the case where we fail to re-initialize a VFS inode,
and add a second instance of the xfs_iget_skip tracepoint for the case
of a failed igrab() call.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_trace.h	2010-06-19 10:42:37.374266953 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_trace.h	2010-06-19 14:37:04.680004137 +0200
@@ -558,8 +558,9 @@ DEFINE_EVENT(xfs_iget_class, name, \
 	TP_ARGS(ip))
 DEFINE_IGET_EVENT(xfs_iget_skip);
 DEFINE_IGET_EVENT(xfs_iget_reclaim);
-DEFINE_IGET_EVENT(xfs_iget_found);
-DEFINE_IGET_EVENT(xfs_iget_alloc);
+DEFINE_IGET_EVENT(xfs_iget_reclaim_fail);
+DEFINE_IGET_EVENT(xfs_iget_hit);
+DEFINE_IGET_EVENT(xfs_iget_miss);
 
 DECLARE_EVENT_CLASS(xfs_inode_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2010-06-19 10:44:00.955254311 +0200
+++ xfs/fs/xfs/xfs_iget.c	2010-06-19 10:54:39.000000000 +0200
@@ -208,7 +208,7 @@ xfs_iget_cache_hit(
 			ip->i_flags &= ~XFS_INEW;
 			ip->i_flags |= XFS_IRECLAIMABLE;
 			__xfs_inode_set_reclaim_tag(pag, ip);
-			trace_xfs_iget_reclaim(ip);
+			trace_xfs_iget_reclaim_fail(ip);
 			goto out_error;
 		}
 
@@ -223,6 +223,7 @@ xfs_iget_cache_hit(
 	} else {
 		/* If the VFS inode is being torn down, pause and try again. */
 		if (!igrab(inode)) {
+			trace_xfs_iget_skip(ip);
 			error = EAGAIN;
 			goto out_error;
 		}
@@ -230,6 +231,7 @@ xfs_iget_cache_hit(
 		/* We've got a live one. */
 		spin_unlock(&ip->i_flags_lock);
 		read_unlock(&pag->pag_ici_lock);
+		trace_xfs_iget_hit(ip);
 	}
 
 	if (lock_flags != 0)
@@ -238,7 +240,6 @@ xfs_iget_cache_hit(
 	xfs_iflags_clear(ip, XFS_ISTALE);
 	XFS_STATS_INC(xs_ig_found);
 
-	trace_xfs_iget_found(ip);
 	return 0;
 
 out_error:
@@ -271,7 +272,7 @@ xfs_iget_cache_miss(
 	if (error)
 		goto out_destroy;
 
-	xfs_itrace_entry(ip);
+	trace_xfs_iget_miss(ip);
 
 	if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
 		error = ENOENT;
@@ -317,7 +318,6 @@ xfs_iget_cache_miss(
 	write_unlock(&pag->pag_ici_lock);
 	radix_tree_preload_end();
 
-	trace_xfs_iget_alloc(ip);
 	*ipp = ip;
 	return 0;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
