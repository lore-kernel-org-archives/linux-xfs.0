Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF26C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjCPT2w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjCPT2v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:28:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3512B5FC1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:28:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 376ABCE1E5A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4B3C433EF;
        Thu, 16 Mar 2023 19:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994926;
        bh=uHZUbkfD9V+Ct5G6RCzOMOfaDPhMsKaTZG4jFzDbiUY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=SpQomVVaPJn4elbIerSZmNmg6C+DYfSXrvItkb7jrMwP9VnhdF5rPFHLozdmotNUG
         9atL+lHrXxf1oBztBW30sldTmXAQmNM8KaYZEtW3glxMx+Tnm4sYav7EUNkRU/MZz7
         A2nrpKPmI2tdVRdQjtzAG96JRGIsK/ebP9hkTTyB7zJkxqd7AOxBC58vQErBq0SDfc
         lsEd3SAHbRgHZA8zwL3muL6JB04Jg/xhJINLT+vq7ReuLiavwAevFkHe+2qH8smL9o
         b5vbVVPCeCHslBftGK74/fqKYmWo6TtF1Ucb/kjVf2FKl930ZFXniiQS41jrZpbmbs
         jZQeLHq54s2/A==
Date:   Thu, 16 Mar 2023 12:28:46 -0700
Subject: [PATCH 2/2] xfs_scrub: use parent pointers when possible to report
 file operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899415793.16530.14501677871951795474.stgit@frogsfrogsfrogs>
In-Reply-To: <167899415768.16530.9685924832572537457.stgit@frogsfrogsfrogs>
References: <167899415768.16530.9685924832572537457.stgit@frogsfrogsfrogs>
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
index 49a87f412..9f3cde9bc 100644
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

