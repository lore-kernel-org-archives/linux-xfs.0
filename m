Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39871C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiF1Usx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbiF1Usw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:48:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA132FFC4
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:48:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A22F6182E
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094B5C341C8;
        Tue, 28 Jun 2022 20:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449329;
        bh=ce+nJnYsIb8gdisTpza82ipvThPyNEptPwvmdp/MZGU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LR4Ztfjlp59Pk2kWvTomO3JyFqqM5jD1oNjjkfTX4+hcwO7B4hjCQ88yglc+TugaF
         xcq6rf7maVgmnB+shzu1DKFEcdUpFuJzHD/J9auiMhlMThdmNZ6Z7lahcg3ry/rTAj
         r0c0OSsg2HVa/9QCXff7QpT0OSzmMPbjzQK5hfzPFpz4eDhozCpYMuUv0ygHRgK0Wb
         s4ALZ7SV5LU2BQFBzfLsQDlc1dAo6jy1sJEQas2kWxW5bSxNQ4yc9tQ9kzO61zrjGi
         HJcFMH5He0oDrZTCRWJcpNCxVWUBk6ZG8QOWWKUjYdvKaYjf5GkAuc87CBzpYIo0os
         pBRDOCqJDqacA==
Subject: [PATCH 4/8] libxfs: remove xfs_globals.larp
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:48:48 -0700
Message-ID: <165644932867.1089724.4941357024120616371.stgit@magnolia>
In-Reply-To: <165644930619.1089724.12201433387040577983.stgit@magnolia>
References: <165644930619.1089724.12201433387040577983.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This dummy debugging knob isn't necessary anymore, so get rid of it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h |    7 -------
 libxfs/util.c       |    6 ------
 2 files changed, 13 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 7935e7ea..ba80aa79 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -270,11 +270,4 @@ struct xfs_dquot {
 	int		q_type;
 };
 
-struct xfs_globals {
-#ifdef DEBUG
-       bool    larp;           /* log attribute replay */
-#endif
-};
-extern struct xfs_globals      xfs_globals;
-
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/libxfs/util.c b/libxfs/util.c
index e5e49477..ef01fcf8 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -720,10 +720,4 @@ xfs_fs_mark_healthy(
 	spin_unlock(&mp->m_sb_lock);
 }
 
-struct xfs_globals xfs_globals = {
-#ifdef DEBUG
-        .larp                   =       false,  /* log attribute replay */
-#endif
-};
-
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo) { }

