Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8523BC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 05:36:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbiEXFgn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 01:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbiEXFgl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 01:36:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E97D65D0A
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 22:36:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0DA0B81763
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 05:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810C7C34116;
        Tue, 24 May 2022 05:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653370597;
        bh=blXV8pn3X99IbMUB+PZPhohwU95cijBKI+88Q3Vhlew=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kZSDceJWu0AV2u1h5a32nNE33tUm2eim8rcdrB1RsMosOwmJ9IEsXa8hHzrU/p1oz
         AHeCyghxdl7jTN3f7mrZAx8hToxbLTyWGc+adWUprOS8XHDSxgPu9812MDSgtp3MzP
         0sPTCxVU8hMO3mzYnztDBHEtA9tGJxSB75uZNerF80u20t1VX4BM2d1pREVY5kI2dY
         W2tKNi7iGz+IEr2baAWJTLhUo1KPcOl4guEC+h4LEx5sERCuh9GjrW+hzhWJ2fmjU6
         h9JwydjeZ9OV9p13arC9vMywPnFf9sLCdaKdao7FmJ3ORlmFVAxVb0iQkp4DomAyx/
         8flgmIf+j5qFw==
Subject: [PATCH 3/5] xfs: warn about LARP once per mount
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Mon, 23 May 2022 22:36:37 -0700
Message-ID: <165337059702.994444.2041987003230901021.stgit@magnolia>
In-Reply-To: <165337058023.994444.12794741176651030531.stgit@magnolia>
References: <165337058023.994444.12794741176651030531.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Since LARP is an experimental debug-only feature, we should try to warn
about it being in use once per mount, not once per reboot.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c   |    4 ++--
 fs/xfs/xfs_mount.h |    5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 9dc748abdf33..a75f4ffc75f9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3910,8 +3910,8 @@ xfs_attr_use_log_assist(
 	if (error)
 		goto drop_incompat;
 
-	xfs_warn_once(mp,
-"EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
+	xfs_warn_mount(mp, XFS_OPSTATE_WARNED_LARP,
+ "EXPERIMENTAL logged extended attributes feature in use. Use at your own risk!");
 
 	return 0;
 drop_incompat:
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 93a954271db2..ba5d42abf66e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -395,6 +395,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_WARNED_SCRUB	7
 /* Kernel has logged a warning about shrink being used on this fs. */
 #define XFS_OPSTATE_WARNED_SHRINK	8
+/* Kernel has logged a warning about logged xattr updates being used. */
+#define XFS_OPSTATE_WARNED_LARP		9
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -433,7 +435,8 @@ xfs_should_warn(struct xfs_mount *mp, long nr)
 	{ (1UL << XFS_OPSTATE_INODEGC_ENABLED),		"inodegc" }, \
 	{ (1UL << XFS_OPSTATE_BLOCKGC_ENABLED),		"blockgc" }, \
 	{ (1UL << XFS_OPSTATE_WARNED_SCRUB),		"wscrub" }, \
-	{ (1UL << XFS_OPSTATE_WARNED_SHRINK),		"wshrink" }
+	{ (1UL << XFS_OPSTATE_WARNED_SHRINK),		"wshrink" }, \
+	{ (1UL << XFS_OPSTATE_WARNED_LARP),		"wlarp" }
 
 /*
  * Max and min values for mount-option defined I/O

