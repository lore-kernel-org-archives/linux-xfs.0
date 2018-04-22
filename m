Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44178 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754465AbeDVPHd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Apr 2018 11:07:33 -0400
Subject: [PATCH 11/13] xfs: report failing address when dquot verifier fails
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 22 Apr 2018 08:07:11 -0700
Message-ID: <152440963171.29601.16982578523210467285.stgit@magnolia>
In-Reply-To: <152440954198.29601.14390250048915099607.stgit@magnolia>
References: <152440954198.29601.14390250048915099607.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, hch@lst.de

From: Darrick J. Wong <darrick.wong@oracle.com>

Pass the failing address through to the corruption report when dquot
verifiers fail.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 8b7a6c3..a1e6cf1 100644
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

