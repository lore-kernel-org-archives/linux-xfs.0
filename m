Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:37398 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751569AbeD3Foo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 01:44:44 -0400
Subject: [PATCH 11/13] xfs: report failing address when dquot verifier fails
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 29 Apr 2018 22:44:23 -0700
Message-ID: <152506706374.21553.4200526089187640194.stgit@magnolia>
In-Reply-To: <152506698177.21553.13500862866416804148.stgit@magnolia>
References: <152506698177.21553.13500862866416804148.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@lst.de

From: Darrick J. Wong <darrick.wong@oracle.com>

Pass the failing address through to the corruption report when dquot
verifiers fail.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dquot_buf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 8b7a6c3cb599..a1e6cf15b171 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -229,7 +229,7 @@ xfs_dquot_buf_read_verify(
 	else {
 		fa = xfs_dquot_buf_verify(mp, bp);
 		if (fa)
-			xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 	}
 }
 
@@ -266,7 +266,7 @@ xfs_dquot_buf_write_verify(
 
 	fa = xfs_dquot_buf_verify(mp, bp);
 	if (fa)
-		xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 }
 
 const struct xfs_buf_ops xfs_dquot_buf_ops = {

