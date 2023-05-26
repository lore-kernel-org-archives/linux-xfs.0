Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 616F9C7EE2E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjEZCHE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbjEZCGt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:06:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0DD18D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:06:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0731E64C4F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672D5C433EF;
        Fri, 26 May 2023 02:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066807;
        bh=xfhqaMfECqHPo03/ZR5tYNwrTwDzKrdntLYne1rrnkQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=lq7OcslCCrgIGuS2TQgf9Mve34NRuDV3Kap8cOI9s2munKjT+Jr6ohqYlF9t4sYix
         b/FV74kzmn8zq+0pUx+r9eHA/fDhz2sFZGWokBRMbo8nqCza8lrWEcWM8mtuXI/XnB
         iKuauZJQCGh+pfzO2nSuthQGoiZGH8wRyROWzcNDPHZ2yO8LNHA9RVd6alDPMiGnne
         q3go9StZlU5+u/Kp3K7U8AwkUv340qahArZeu+lSbkvVEEwfxYorC/kEK0OOutXrfV
         J1m86QVEVZ6aWVjYEPrh6JpHIV2XHzjzd16x+RMPLeoSLpnPjFy4Xkx1ZhuVYbqoCq
         6eQpVdgb+n8fg==
Date:   Thu, 25 May 2023 19:06:46 -0700
Subject: [PATCH 7/7] xfs: unlock new repair tempfiles after creation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506071864.3743141.12943535834639153909.stgit@frogsfrogsfrogs>
In-Reply-To: <168506071753.3743141.6199971931108916142.stgit@frogsfrogsfrogs>
References: <168506071753.3743141.6199971931108916142.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

After creation, drop the ILOCK on temporary files that have been created
to stage a repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/tempfile.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 1297f1b2e6a6..6c3e338f1118 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -145,6 +145,7 @@ xrep_tempfile_create(
 	xfs_qm_dqrele(pdqp);
 
 	/* Finish setting up the incore / vfs context. */
+	xfs_iunlock(sc->tempip, XFS_ILOCK_EXCL);
 	xfs_setup_iops(sc->tempip);
 	xfs_finish_inode_setup(sc->tempip);
 
@@ -160,6 +161,7 @@ xrep_tempfile_create(
 	 * transactions and deadlocks from xfs_inactive.
 	 */
 	if (sc->tempip) {
+		xfs_iunlock(sc->tempip, XFS_ILOCK_EXCL);
 		xfs_finish_inode_setup(sc->tempip);
 		xchk_irele(sc, sc->tempip);
 	}

