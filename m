Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52062 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752294AbcL2IYU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Dec 2016 03:24:20 -0500
Received: from 178.114.99.23.wireless.dyn.drei.com ([178.114.99.23] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1cMVzr-0004Lf-3X
        for linux-xfs@vger.kernel.org; Thu, 29 Dec 2016 08:23:35 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: don't print warnings when xfs_log_force fails
Date: Thu, 29 Dec 2016 09:23:19 +0100
Message-Id: <1482999799-11776-2-git-send-email-hch@lst.de>
In-Reply-To: <1482999799-11776-1-git-send-email-hch@lst.de>
References: <1482999799-11776-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

There are only two reasons for xfs_log_force / xfs_log_force_lsn to fail:
one is an I/O error, for which xlog_bdstrat already logs a warning, and
the second is an already shutdown log due to a previous I/O errors.  In
the latter case we'll already have a previous indication for the actual
error, but the large stream of misleading warnings from xfs_log_force
will probably scroll it out of the message buffer.

Simply removing the warnings thus makes the XFS log reporting significantly
better.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c39ac14..b1469f0 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3317,12 +3317,8 @@ xfs_log_force(
 	xfs_mount_t	*mp,
 	uint		flags)
 {
-	int	error;
-
 	trace_xfs_log_force(mp, 0, _RET_IP_);
-	error = _xfs_log_force(mp, flags, NULL);
-	if (error)
-		xfs_warn(mp, "%s: error %d returned.", __func__, error);
+	_xfs_log_force(mp, flags, NULL);
 }
 
 /*
@@ -3466,12 +3462,8 @@ xfs_log_force_lsn(
 	xfs_lsn_t	lsn,
 	uint		flags)
 {
-	int	error;
-
 	trace_xfs_log_force(mp, lsn, _RET_IP_);
-	error = _xfs_log_force_lsn(mp, lsn, flags, NULL);
-	if (error)
-		xfs_warn(mp, "%s: error %d returned.", __func__, error);
+	_xfs_log_force_lsn(mp, lsn, flags, NULL);
 }
 
 /*
-- 
2.1.4

