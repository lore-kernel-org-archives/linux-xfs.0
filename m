Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF49C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjDFThU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDFThT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:37:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16096E72
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:37:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5B3964B89
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E66C433D2;
        Thu,  6 Apr 2023 19:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809838;
        bh=nXrpHAVtfqRX4uEOQPMAtAeiYBKtaUd1LJTt5lxpaAs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=kl9mY5WDRPSE7zXsk509+A3JPFkQIHgosM7wha2CxkcDQfmZurLMURVzt/ROvrOQ7
         /NY43aiUsYxDnQMgsefi5YjaVfEZ9XF917+mtVzAOSclNm3N+UKY6SOyWHjHpiuWaJ
         Edoi5upA6kZJV1A6RSBkyuBagrSOwJFWIELOnGsHWqz/DG3cOh+i5lrrkmm9JFJWsF
         NtRTalIwk+yYw2TmUlzD17fRV2zcA0pjXo2UzUaF4qorv/GKcZRRwoQPtQiGHGWmFT
         eEgVbefSFjUdtRUI64iZE4kKlgmVhKw5rXFy7ZGMNLTwZ4zyvTglelpj8FZAh23lTw
         v4C13MgFvGAWQ==
Date:   Thu, 06 Apr 2023 12:37:17 -0700
Subject: [PATCH 22/32] xfs_scrub: use parent pointers when possible to report
 file operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827847.616793.16002329266364259157.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
References: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
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
 scrub/common.c |   41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)


diff --git a/scrub/common.c b/scrub/common.c
index 49a87f412..172a32ba6 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -9,6 +9,7 @@
 #include <syslog.h>
 #include "platform_defs.h"
 #include "libfrog/paths.h"
+#include "libfrog/getparents.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "progress.h"
@@ -403,19 +404,55 @@ scrub_render_ino_descr(
 	...)
 {
 	va_list			args;
+	size_t			pathlen = 0;
 	uint32_t		agno;
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
+		if (ret)
+			goto report_inum;
+
+		/*
+		 * Leave at least 16 bytes for the description of what went
+		 * wrong.  If we can't do that, we'll use the inode number.
+		 */
+		pathlen = strlen(buf);
+		if (pathlen >= buflen - 16)
+			goto report_inum;
+
+		if (format) {
+			buf[pathlen] = ' ';
+			buf[pathlen + 1] = 0;
+			pathlen++;
+		}
+
+		goto report_format;
+	}
+
+report_inum:
 	agno = cvt_ino_to_agno(&ctx->mnt, ino);
 	agino = cvt_ino_to_agino(&ctx->mnt, ino);
 	ret = snprintf(buf, buflen, _("inode %"PRIu64" (%"PRIu32"/%"PRIu32")%s"),
 			ino, agno, agino, format ? " " : "");
 	if (ret < 0 || ret >= buflen || format == NULL)
 		return ret;
+	pathlen = ret;
 
+report_format:
 	va_start(args, format);
-	ret += vsnprintf(buf + ret, buflen - ret, format, args);
+	pathlen += vsnprintf(buf + pathlen, buflen - pathlen, format, args);
 	va_end(args);
-	return ret;
+	return pathlen;
 }

