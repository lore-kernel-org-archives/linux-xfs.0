Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46057 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753342AbcJYXDz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:03:55 -0400
Subject: [PATCH 01/39] xfs: convert RUI log formats to use variable length
 arrays
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:03:44 -0700
Message-ID: <147743662427.11035.5343374767358259727.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Use variable length array declarations for RUI log items,
and replace the open coded sizeof formulae with a single function.

[Fix up the logprint code to reflect the new RUI format.]

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 logprint/log_redo.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)


diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index add0764..40e0727 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -240,8 +240,7 @@ xfs_rui_copy_format(
 	int			  continued)
 {
 	uint nextents = ((struct xfs_rui_log_format *)buf)->rui_nextents;
-	uint dst_len = sizeof(struct xfs_rui_log_format) +
-			(nextents - 1) * sizeof(struct xfs_map_extent);
+	uint dst_len = xfs_rui_log_format_sizeof(nextents);
 
 	if (len == dst_len || continued) {
 		memcpy((char *)dst_fmt, buf, len);
@@ -283,8 +282,7 @@ xlog_print_trans_rui(
 
 	/* convert to native format */
 	nextents = src_f->rui_nextents;
-	dst_len = sizeof(struct xfs_rui_log_format) +
-			(nextents - 1) * sizeof(struct xfs_map_extent);
+	dst_len = xfs_rui_log_format_sizeof(nextents);
 
 	if (continued && src_len < core_size) {
 		printf(_("RUI: Not enough data to decode further\n"));

