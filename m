Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43344 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbdBBH4f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 02:56:35 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/19] xfs: don't print warnings when xfs_log_force fails
Date: Thu,  2 Feb 2017 08:55:57 +0100
Message-Id: <1486022171-8076-6-git-send-email-hch@lst.de>
In-Reply-To: <1486022171-8076-1-git-send-email-hch@lst.de>
References: <1486022171-8076-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

commit 84a4620cfe97c9d57e39b2369bfb77faff55063d upstream.

There are only two reasons for xfs_log_force / xfs_log_force_lsn to fail:
one is an I/O error, for which xlog_bdstrat already logs a warning, and
the second is an already shutdown log due to a previous I/O errors.  In
the latter case we'll already have a previous indication for the actual
error, but the large stream of misleading warnings from xfs_log_force
will probably scroll it out of the message buffer.

Simply removing the warnings thus makes the XFS log reporting significantly
better.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3b74fa0..4017aa9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3324,12 +3324,8 @@ xfs_log_force(
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
@@ -3473,12 +3469,8 @@ xfs_log_force_lsn(
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

