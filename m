Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VG6ZqC178969 for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:06:35 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 685E914678E3
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 09:09:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id RHlQBIFPGhCPEXgG for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 09:09:02 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OJ7Xy-00017V-3s
	for xfs@oss.sgi.com; Mon, 31 May 2010 16:09:02 +0000
Message-Id: <20100531160901.981749888@bombadil.infradead.org>
Date: Mon, 31 May 2010 12:07:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 14/17] xfs: remove the unused XFS_LOG_SLEEP and
	XFS_LOG_NOSLEEP flags
References: <20100531160727.842750532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-dead-log-flags
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2010-05-29 18:21:05.762255846 +0200
+++ xfs/fs/xfs/xfs_log.c	2010-05-29 18:22:52.309004835 +0200
@@ -333,7 +333,6 @@ xfs_log_reserve(
 	int			retval = 0;
 
 	ASSERT(client == XFS_TRANSACTION || client == XFS_LOG);
-	ASSERT((flags & XFS_LOG_NOSLEEP) == 0);
 
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return XFS_ERROR(EIO);
Index: xfs/fs/xfs/xfs_log.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log.h	2010-05-29 18:22:26.023003369 +0200
+++ xfs/fs/xfs/xfs_log.h	2010-05-29 18:22:52.309004835 +0200
@@ -55,14 +55,10 @@ static inline xfs_lsn_t	_lsn_cmp(xfs_lsn
 /*
  * Flags to xfs_log_reserve()
  *
- *	XFS_LOG_SLEEP:	 If space is not available, sleep (default)
- *	XFS_LOG_NOSLEEP: If space is not available, return error
  *	XFS_LOG_PERM_RESERV: Permanent reservation.  When writes are
  *		performed against this type of reservation, the reservation
  *		is not decreased.  Long running transactions should use this.
  */
-#define XFS_LOG_SLEEP		0x0
-#define XFS_LOG_NOSLEEP		0x1
 #define XFS_LOG_PERM_RESERV	0x2
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
