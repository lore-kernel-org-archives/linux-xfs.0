Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB66C001DC
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbjG0W3s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbjG0W3r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:29:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4832D63
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:29:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8CB161F50
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BD7C433C8;
        Thu, 27 Jul 2023 22:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496986;
        bh=PR4Ba8FKWdXqctaZgFsuMGklDjKT8dqrYBfthCOHmvA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=odwbKMIzQ7KmIwONMsRnBa+n5AreXjam9qbL09t9UIo5/XKkmVZVgdvlLH8hn/xIE
         WdAhi5jNeMWBYVOwk/Kx7KVj2CEVgEGC0+EBuNeIz5BEzoG1FGbopYMjAyn6DGPp52
         fL/nLr1gKu0xr3Z7g8Z9HRcuWPWGWRFcFyyfz/cQXEW32rrG6D6+UMF5kkMYm9YzM4
         hbryEhWhIS9qu2JnoVxDBltX0hEA97OmPB89R5exoEfs55W59yepyampp2Tdf5Je9n
         YZ3R+woHma0SlfcwizSMZatWx72P8p4+FcUveXOqjbos0o0jlmoRguvI+frr1uwKVS
         qoFXk34LaxAHQ==
Date:   Thu, 27 Jul 2023 15:29:45 -0700
Subject: [PATCH 2/2] xfs: allow userspace to rebuild metadata structures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <169049625048.922058.11628715914998137912.stgit@frogsfrogsfrogs>
In-Reply-To: <169049625018.922058.9081185927358791336.stgit@frogsfrogsfrogs>
References: <169049625018.922058.9081185927358791336.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a new (superuser-only) flag to the online metadata repair ioctl to
force it to rebuild structures, even if they're not broken.  We will use
this to move metadata structures out of the way during a free space
defragmentation operation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_fs.h |    6 +++++-
 fs/xfs/scrub/scrub.c   |   11 ++++++++++-
 fs/xfs/scrub/trace.h   |    3 ++-
 3 files changed, 17 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 2cbf9ea39b8cc..6360073865dbc 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -743,7 +743,11 @@ struct xfs_scrub_metadata {
  */
 #define XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED (1u << 7)
 
-#define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_IFLAG_REPAIR)
+/* i: Rebuild the data structure. */
+#define XFS_SCRUB_IFLAG_FORCE_REBUILD	(1u << 8)
+
+#define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_IFLAG_REPAIR | \
+				 XFS_SCRUB_IFLAG_FORCE_REBUILD)
 #define XFS_SCRUB_FLAGS_OUT	(XFS_SCRUB_OFLAG_CORRUPT | \
 				 XFS_SCRUB_OFLAG_PREEN | \
 				 XFS_SCRUB_OFLAG_XFAIL | \
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index a2492aae34d4f..b62a5e59dee42 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -411,6 +411,11 @@ xchk_validate_inputs(
 		goto out;
 	}
 
+	/* No rebuild without repair. */
+	if ((sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD) &&
+	    !(sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
+		return -EINVAL;
+
 	/*
 	 * We only want to repair read-write v5+ filesystems.  Defer the check
 	 * for ops->repair until after our scrub confirms that we need to
@@ -539,8 +544,12 @@ xfs_scrub_metadata(
 	    !(sc->flags & XREP_ALREADY_FIXED)) {
 		bool needs_fix = xchk_needs_repair(sc->sm);
 
+		/* Userspace asked us to rebuild the structure regardless. */
+		if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD)
+			needs_fix = true;
+
 		/* Let debug users force us into the repair routines. */
-		if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
+		if (XFS_TEST_ERROR(needs_fix, mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
 			needs_fix = true;
 
 		/*
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 83ed6e01c7df6..4dd807230308e 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -98,7 +98,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 	{ XFS_SCRUB_OFLAG_XCORRUPT,		"xcorrupt" }, \
 	{ XFS_SCRUB_OFLAG_INCOMPLETE,		"incomplete" }, \
 	{ XFS_SCRUB_OFLAG_WARNING,		"warning" }, \
-	{ XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED,	"norepair" }
+	{ XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED,	"norepair" }, \
+	{ XFS_SCRUB_IFLAG_FORCE_REBUILD,	"rebuild" }
 
 #define XFS_SCRUB_STATE_STRINGS \
 	{ XCHK_TRY_HARDER,			"try_harder" }, \

