Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7WijR203687 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:32:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E9799185E8EA
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3m5L8Odc1aDKpMYD for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:01 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LRLwv-00031r-F6
	for xfs@oss.sgi.com; Mon, 26 Jan 2009 07:32:01 +0000
Message-Id: <20090126073201.333455000@bombadil.infradead.org>
Date: Mon, 26 Jan 2009 02:31:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/17] xfs: remove iclog calculation special cases
References: <20090126073136.384490000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-iclogs-calculation
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

Our default has been to always use 8 32KB log buffers for a while now, so
remove the special casing for larger block size filesystem to use the same
or even lower number of buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2009-01-21 21:03:27.862294904 +0100
+++ xfs/fs/xfs/xfs_log.c	2009-01-24 18:15:18.336779335 +0100
@@ -1164,32 +1164,8 @@ xlog_get_iclog_buffer_size(xfs_mount_t	*
 	log->l_iclog_hsize = BBSIZE;
 	log->l_iclog_heads = 1;
 
-	/*
-	 * For 16KB, we use 3 32KB buffers.  For 32KB block sizes, we use
-	 * 4 32KB buffers.  For 64KB block sizes, we use 8 32KB buffers.
-	 */
-	if (mp->m_sb.sb_blocksize >= 16*1024) {
-		log->l_iclog_size = XLOG_BIG_RECORD_BSIZE;
-		log->l_iclog_size_log = XLOG_BIG_RECORD_BSHIFT;
-		if (mp->m_logbufs <= 0) {
-			switch (mp->m_sb.sb_blocksize) {
-			    case 16*1024:			/* 16 KB */
-				log->l_iclog_bufs = 3;
-				break;
-			    case 32*1024:			/* 32 KB */
-				log->l_iclog_bufs = 4;
-				break;
-			    case 64*1024:			/* 64 KB */
-				log->l_iclog_bufs = 8;
-				break;
-			    default:
-				xlog_panic("XFS: Invalid blocksize");
-				break;
-			}
-		}
-	}
-
-done:	/* are we being asked to make the sizes selected above visible? */
+done:
+	/* are we being asked to make the sizes selected above visible? */
 	if (mp->m_logbufs == 0)
 		mp->m_logbufs = log->l_iclog_bufs;
 	if (mp->m_logbsize == 0)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
