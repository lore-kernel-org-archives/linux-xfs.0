Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E07C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjEZCdV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjEZCdV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:33:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09971B6
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:33:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E98F64C5D
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1613C433EF;
        Fri, 26 May 2023 02:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068399;
        bh=R7THaWzhJ7PHrbiM6TIHCfxBUiVprhtu93PoDJpVi+8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=R9ZoGaenFFh3SImChVzIX7slqq74bZ2FkCP9RiZlpikW9fRO1zMuc6JsPJxeYPsKn
         Degi29+Oml/BuTgs9MNJuHV596aB6TrIo8lvsw0LvW2/bL9wnyspbugMZfY16nKeCE
         nP3mI1w/NuMiApAks+p7+/Xq0i43QVWMr5CjAuhEZY3fqY/zgdY+oPYFMzBtZCraee
         OMl8nScCTsBt/TAXPzhVp5OVj/AQ7uomu41qoQk6mkh+mAILCkR8Z40wZMZWOnrHWj
         8/rADY6QRdoP9eMaOOA9eCEATfQ4H/PLZi7x4JBsz+FQfOQI14UrJOBPwRDWd+P45z
         RTWjUWp3V59Xw==
Date:   Thu, 25 May 2023 19:33:17 -0700
Subject: [PATCH 14/14] xfs_scrub: use parent pointers to report lost file data
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078781.3750196.5824757964865526964.stgit@frogsfrogsfrogs>
In-Reply-To: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
References: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If parent pointers are enabled, compute the path to the file while we're
doing the fsmap scan and report that, instead of walking the entire
directory tree to print the paths of the (hopefully few) files that lost
data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase6.c |   62 +++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 50 insertions(+), 12 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index c52d0f1a445..cdadcfb64b8 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -21,6 +21,7 @@
 #include "read_verify.h"
 #include "spacemap.h"
 #include "vfs.h"
+#include "libfrog/bulkstat.h"
 
 /*
  * Phase 6: Verify data file integrity.
@@ -371,6 +372,11 @@ report_dirent_loss(
 	return error;
 }
 
+struct ioerr_filerange {
+	uint64_t		physical;
+	uint64_t		length;
+};
+
 /* Use a fsmap to report metadata lost to a media error. */
 static int
 report_ioerr_fsmap(
@@ -379,16 +385,18 @@ report_ioerr_fsmap(
 	void			*arg)
 {
 	const char		*type;
+	struct xfs_bulkstat	bs = { };
 	char			buf[DESCR_BUFSZ];
-	uint64_t		err_physical = *(uint64_t *)arg;
+	struct ioerr_filerange	*fr = arg;
 	uint64_t		err_off;
+	int			ret;
 
 	/* Don't care about unwritten extents. */
 	if (map->fmr_flags & FMR_OF_PREALLOC)
 		return 0;
 
-	if (err_physical > map->fmr_physical)
-		err_off = err_physical - map->fmr_physical;
+	if (fr->physical > map->fmr_physical)
+		err_off = fr->physical - map->fmr_physical;
 	else
 		err_off = 0;
 
@@ -411,23 +419,43 @@ report_ioerr_fsmap(
 		}
 	}
 
+	if (ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_PARENT) {
+		ret = -xfrog_bulkstat_single(&ctx->mnt, map->fmr_owner, 0, &bs);
+		if (ret)
+			str_liberror(ctx, ret,
+					_("bulkstat for media error report"));
+	}
+
 	/* Report extent maps */
 	if (map->fmr_flags & FMR_OF_EXTENT_MAP) {
 		bool		attr = (map->fmr_flags & FMR_OF_ATTR_FORK);
 
 		scrub_render_ino_descr(ctx, buf, DESCR_BUFSZ,
-				map->fmr_owner, 0, " %s",
+				map->fmr_owner, bs.bs_gen, " %s",
 				attr ? _("extended attribute") :
 				       _("file data"));
 		str_corrupt(ctx, buf, _("media error in extent map"));
 	}
 
 	/*
-	 * XXX: If we had a getparent() call we could report IO errors
-	 * efficiently.  Until then, we'll have to scan the dir tree
-	 * to find the bad file's pathname.
+	 * If directory parent pointers are available, use that to find the
+	 * pathname to a file, and report that path as having lost its
+	 * extended attributes, or the precise offset of the lost file data.
 	 */
+	if (!(ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_PARENT))
+		return 0;
 
+	scrub_render_ino_descr(ctx, buf, DESCR_BUFSZ, map->fmr_owner,
+			bs.bs_gen, NULL);
+
+	if (map->fmr_flags & FMR_OF_ATTR_FORK) {
+		str_corrupt(ctx, buf, _("media error in extended attributes"));
+		return 0;
+	}
+
+	str_unfixable_error(ctx, buf,
+ _("media error at data offset %llu length %llu."),
+			err_off, fr->length);
 	return 0;
 }
 
@@ -442,6 +470,10 @@ report_ioerr(
 	void				*arg)
 {
 	struct fsmap			keys[2];
+	struct ioerr_filerange		fr = {
+		.physical		= start,
+		.length			= length,
+	};
 	struct disk_ioerr_report	*dioerr = arg;
 	dev_t				dev;
 
@@ -457,7 +489,7 @@ report_ioerr(
 	(keys + 1)->fmr_offset = ULLONG_MAX;
 	(keys + 1)->fmr_flags = UINT_MAX;
 	return -scrub_iterate_fsmap(dioerr->ctx, keys, report_ioerr_fsmap,
-			&start);
+			&fr);
 }
 
 /* Report all the media errors found on a disk. */
@@ -501,10 +533,16 @@ report_all_media_errors(
 		return ret;
 	}
 
-	/* Scan the directory tree to get file paths. */
-	ret = scan_fs_tree(ctx, report_dir_loss, report_dirent_loss, vs);
-	if (ret)
-		return ret;
+	/*
+	 * Scan the directory tree to get file paths if we didn't already use
+	 * directory parent pointers to report the loss.
+	 */
+	if (!(ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_PARENT)) {
+		ret = scan_fs_tree(ctx, report_dir_loss, report_dirent_loss,
+				vs);
+		if (ret)
+			return ret;
+	}
 
 	/* Scan for unlinked files. */
 	return scrub_scan_all_inodes(ctx, report_inode_loss, vs);

