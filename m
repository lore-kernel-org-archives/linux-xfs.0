Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 662B2C7EE2E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbjEZC1X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234739AbjEZC1U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:27:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C351EB6
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:27:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C9C064C57
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6A2C433D2;
        Fri, 26 May 2023 02:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068038;
        bh=U6Wvbr0mdCHckgOsQ426C60BTt+nws8WM0wXulPw1j4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=n2W6focVgSvV4O0q6S6rIp/U854RdqBm0tD2Lc1jk3pRSjUi3LuH92q/c7QDtt+P2
         +xsyVwrfpy5Ij8ZECUIgw1ksBdOLNGfil3lp0Lspv3af/wmEny3ub19E7CNFpoUbdd
         enhAOTitbFS19pXYMeFRund0T/ukzmkkBxUdEh1HhgnIB+8O0jzUDiXy298VkUxxG0
         9m6/O1SFWxEiuE2yR9F9vzsbzUhDmfDRzOUHv9IXIK4eCNrkCFA0Vl8S1RBUjvnobU
         zZJjCbP6hbppGmMapiSPHltxhOyR1Hg+ReSA/n3A38QtNxwqymFggXhGrFsBVMg5dW
         wRNLBZbWnlDRg==
Date:   Thu, 25 May 2023 19:27:18 -0700
Subject: [PATCH 21/30] xfs_scrub: use parent pointers when possible to report
 file operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078173.3749421.6504474976701985673.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
References: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
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
index f38829ea253..ae22bbd1775 100644
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

