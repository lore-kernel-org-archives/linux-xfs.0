Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56490 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752940AbdIRJQZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 05:16:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 41/78] xfs: check _btree_check_block value
Date: Mon, 18 Sep 2017 11:11:50 +0200
Message-Id: <20170918091132.552622392@linuxfoundation.org>
In-Reply-To: <20170918091126.077483037@linuxfoundation.org>
References: <20170918091126.077483037@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 1e86eabe73b73c82e1110c746ed3ec6d5e1c0a0d upstream.

Check the _btree_check_block return value for the firstrec and lastrec
functions, since we have the ability to signal that the repositioning
did not succeed.

Fixes-coverity-id: 114067
Fixes-coverity-id: 114068
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_btree.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -714,7 +714,8 @@ xfs_btree_firstrec(
 	 * Get the block pointer for this level.
 	 */
 	block = xfs_btree_get_block(cur, level, &bp);
-	xfs_btree_check_block(cur, block, level, bp);
+	if (xfs_btree_check_block(cur, block, level, bp))
+		return 0;
 	/*
 	 * It's empty, there is no such record.
 	 */
@@ -743,7 +744,8 @@ xfs_btree_lastrec(
 	 * Get the block pointer for this level.
 	 */
 	block = xfs_btree_get_block(cur, level, &bp);
-	xfs_btree_check_block(cur, block, level, bp);
+	if (xfs_btree_check_block(cur, block, level, bp))
+		return 0;
 	/*
 	 * It's empty, there is no such record.
 	 */


