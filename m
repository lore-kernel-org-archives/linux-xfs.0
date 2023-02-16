Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF92C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjBPVFv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjBPVFu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:05:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFF5505D3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:05:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2203BB8217A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A53C433D2;
        Thu, 16 Feb 2023 21:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581546;
        bh=6cOgyUW9y6GN5eP5G8D80u6r5GILEMLNN7CpNCsLgJg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=OMUi739qzljWx7TzA0tNuoBKRt/HaYU3a7QcJbtpj46v5ZzCU9Wk7er0tuQvp97WJ
         8DtIkfuZJiHqGXnmcVYuvqYQjfTSNtraWbZmqzokvaemzqOGnwviBEFhRRD+YepN92
         jdnIuPANnlt/8sTrN5Aks/bXi2o6bLc7mDB+3lhisL5sISMjcstqgXnDuc/rFMUHld
         OUOJ5BLQ07bjqGXh9XY6q8hufXT34F298xaQcr4ad5VYzMo6e0BQ98j0dxful5Wc9O
         akmF1DUthtK6DxV2sq1sC6SxgneAuT+ixUQbUFuxt/qCTRUbgQSem51sKQA6FcVCwM
         hXwL0l2sYRN9A==
Date:   Thu, 16 Feb 2023 13:05:46 -0800
Subject: [PATCH 10/10] xfs_scrub: use parent pointers when possible to report
 file operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657880389.3477097.12099364278909899946.stgit@magnolia>
In-Reply-To: <167657880257.3477097.11495108667073036392.stgit@magnolia>
References: <167657880257.3477097.11495108667073036392.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If parent pointers are available, use them to supply file paths when
doing things to files, instead of merely printing the inode number.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/common.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)


diff --git a/scrub/common.c b/scrub/common.c
index 49a87f41..9f3cde9b 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -12,6 +12,7 @@
 #include "xfs_scrub.h"
 #include "common.h"
 #include "progress.h"
+#include "libfrog/pptrs.h"
 
 extern char		*progname;
 
@@ -407,6 +408,26 @@ scrub_render_ino_descr(
 	uint32_t		agino;
 	int			ret;
 
+	if (ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_PARENT) {
+		struct xfs_handle handle;
+
+		memcpy(&handle.ha_fsid, ctx->fshandle, sizeof(handle.ha_fsid));
+		handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
+				sizeof(handle.ha_fid.fid_len);
+		handle.ha_fid.fid_pad = 0;
+		handle.ha_fid.fid_ino = ino;
+		handle.ha_fid.fid_gen = gen;
+
+		ret = handle_to_path(&handle, sizeof(struct xfs_handle), buf,
+				buflen);
+		/*
+		 * If successful, return any positive integer to use the
+		 * formatted error string.
+		 */
+		if (ret == 0)
+			return 1;
+	}
+
 	agno = cvt_ino_to_agno(&ctx->mnt, ino);
 	agino = cvt_ino_to_agino(&ctx->mnt, ino);
 	ret = snprintf(buf, buflen, _("inode %"PRIu64" (%"PRIu32"/%"PRIu32")%s"),

