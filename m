Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49342 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752710AbdBBSjv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 13:39:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 37/51] xfs: dont print warnings when xfs_log_force fails
Date: Thu,  2 Feb 2017 19:37:56 +0100
Message-Id: <20170202183347.043226331@linuxfoundation.org>
In-Reply-To: <20170202183345.067336143@linuxfoundation.org>
References: <20170202183345.067336143@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

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


