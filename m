Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35076 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750978AbdAJNxs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 08:53:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 201/206] xfs: fix double-cleanup when CUI recovery fails
Date: Tue, 10 Jan 2017 14:38:04 +0100
Message-Id: <20170110131512.314968855@linuxfoundation.org>
In-Reply-To: <20170110131502.767555407@linuxfoundation.org>
References: <20170110131502.767555407@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Dan Carpenter <dan.carpenter@oracle.com>, Christoph Hellwig <hch@lst.de>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 7a21272b088894070391a94fdd1c67014020fa1d upstream.

Dan Carpenter reported a double-free of rcur if _defer_finish fails
while we're recovering CUI items.  Fix the error recovery to prevent
this.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_refcount_item.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -526,13 +526,14 @@ xfs_cui_recover(
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
 	error = xfs_defer_finish(&tp, &dfops, NULL);
 	if (error)
-		goto abort_error;
+		goto abort_defer;
 	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
 	error = xfs_trans_commit(tp);
 	return error;
 
 abort_error:
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
+abort_defer:
 	xfs_defer_cancel(&dfops);
 	xfs_trans_cancel(tp);
 	return error;


