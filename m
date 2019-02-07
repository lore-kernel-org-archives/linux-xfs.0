Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38822 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbfBGS45 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Feb 2019 13:56:57 -0500
Date: Thu, 7 Feb 2019 10:56:52 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/8] xfs: add magic numbers to dquot buffer ops
Message-ID: <20190207185652.GH7991@magnolia>
References: <20190207184105.17064-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207184105.17064-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add dquot magic numbers to the buffer ops type, in case we ever want to
use them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index d293f371dd54..b956638a3532 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -277,6 +277,8 @@ xfs_dquot_buf_write_verify(
 
 const struct xfs_buf_ops xfs_dquot_buf_ops = {
 	.name = "xfs_dquot",
+	.magic = { cpu_to_be16(XFS_DQUOT_MAGIC),
+		   cpu_to_be16(XFS_DQUOT_MAGIC) },
 	.verify_read = xfs_dquot_buf_read_verify,
 	.verify_write = xfs_dquot_buf_write_verify,
 	.verify_struct = xfs_dquot_buf_verify_struct,
@@ -284,6 +286,8 @@ const struct xfs_buf_ops xfs_dquot_buf_ops = {
 
 const struct xfs_buf_ops xfs_dquot_buf_ra_ops = {
 	.name = "xfs_dquot_ra",
+	.magic = { cpu_to_be16(XFS_DQUOT_MAGIC),
+		   cpu_to_be16(XFS_DQUOT_MAGIC) },
 	.verify_read = xfs_dquot_buf_readahead_verify,
 	.verify_write = xfs_dquot_buf_write_verify,
 };
