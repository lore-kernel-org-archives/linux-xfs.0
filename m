Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 907FBC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjBPVD0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjBPVD0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:03:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE0C2A16F
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:03:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A49360C48
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B727C433EF;
        Thu, 16 Feb 2023 21:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581404;
        bh=qhLAtemkiBieV3oHDZAz6hz/UkZoYPJBiKbNhVFRGvA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=X7zOwelgGccVGbN+hu8O5S9AoSniI/NlW4T3QWQuDam/ODFi8H5rwTvcmjpkqrgsj
         FeYgEZwARtEHLr2VWZuKi9efod+m7wNXVtw+Dn1abmn1Q7cVr5BLtJqUG5806jF2+Y
         qO0Sb6vnW0U61tEiG/1mqH9LIOWFfBxfWdptTRpgmmebM0y/uoAxTCvCP0ZsAnTaUo
         VxEcTQHKr9i1dTnC+wZN5hmU45ifdLt5qB5orErTEjMHDuCcenF8ouRdNKLzglJpqI
         /szcz0AvTEJJYF5a9WFnwZQmT+ftWon0GeOvyRZfpzRI8DXwAMyE9BouHm8sk36VZG
         1OwzcWM4mxq2A==
Date:   Thu, 16 Feb 2023 13:03:24 -0800
Subject: [PATCH 01/10] xfs_scrub: revert unnecessary code from "implement the
 upper half of parent pointers"
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657880272.3477097.18280720624008495400.stgit@magnolia>
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

Revert this piece which is no longer necessary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/inodes.c |   26 --------------------------
 scrub/inodes.h |    2 --
 2 files changed, 28 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 245dd713..78f0914b 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -19,7 +19,6 @@
 #include "descr.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
-#include "parent.h"
 
 /*
  * Iterate a range of inodes.
@@ -450,28 +449,3 @@ scrub_open_handle(
 	return open_by_fshandle(handle, sizeof(*handle),
 			O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
 }
-
-/* Construct a description for an inode. */
-void
-xfs_scrub_ino_descr(
-	struct scrub_ctx	*ctx,
-	struct xfs_handle	*handle,
-	char			*buf,
-	size_t			buflen)
-{
-	uint64_t		ino;
-	xfs_agnumber_t		agno;
-	xfs_agino_t		agino;
-	int			ret;
-
-	ret = handle_to_path(handle, sizeof(struct xfs_handle), buf, buflen);
-	if (ret >= 0)
-		return;
-
-	ino = handle->ha_fid.fid_ino;
-	agno = ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
-	agino = ino % (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
-	snprintf(buf, buflen, _("inode %"PRIu64" (%u/%u)"), ino, agno,
-			agino);
-}
-
diff --git a/scrub/inodes.h b/scrub/inodes.h
index 189fa282..f0318045 100644
--- a/scrub/inodes.h
+++ b/scrub/inodes.h
@@ -21,7 +21,5 @@ int scrub_scan_all_inodes(struct scrub_ctx *ctx, scrub_inode_iter_fn fn,
 		void *arg);
 
 int scrub_open_handle(struct xfs_handle *handle);
-void xfs_scrub_ino_descr(struct scrub_ctx *ctx, struct xfs_handle *handle,
-		char *buf, size_t buflen);
 
 #endif /* XFS_SCRUB_INODES_H_ */

