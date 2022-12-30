Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D32C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236104AbiLaB7B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236108AbiLaB7A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:59:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E30E1C438
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:58:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9D413CE19E8
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB578C433EF;
        Sat, 31 Dec 2022 01:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451935;
        bh=oiyPkmpUWRjM2JmUtdTrVUb9hXtJ8ft02Xa/fpdN8CE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QGPGfxSdLBAqchUKOu1vG7tuwghk2uML0zosvE7irORwdWg0sg97PWB6NjlaJQIzS
         YQLP4B1fw8Y5PCr0Q41gN5LfAFrkLfBNNrNmu+ZLAoGLbJmfmmYnsnUZdUWcOyj/gp
         MJDPab/4pPi5VBvo+ND5GouG7qeJA67FrSp3MfngjeG9iFNcpoHVeEu3xsR0KNCGTN
         eb9Zlra69aINyVmc5N+Cv5neX0TR2t/IkAO+KdLM4evU2ziSzZzc4TKxoJt9Q4sMRi
         C3tQQ3yzEe5Oy12yHSEPzvufiaB05q4IjMCEpmcmePJjW9W58sTRHHJ1H2uD48slcd
         Qjtr2ce1MqopA==
Subject: [PATCH 42/42] xfs: enable realtime reflink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:34 -0800
Message-ID: <167243871493.717073.7033882150807622781.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Enable reflink for realtime devices, sort of.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4abeff701093..a3a0011272e5 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1656,14 +1656,27 @@ xfs_fs_fill_super(
 "EXPERIMENTAL realtime allocation group feature in use. Use at your own risk!");
 
 	if (xfs_has_reflink(mp)) {
-		if (mp->m_sb.sb_rblocks) {
+		/*
+		 * Reflink doesn't support rt extent sizes larger than a single
+		 * block because we would have to perform unshare-around for
+		 * rtext-unaligned write requests.
+		 */
+		if (xfs_has_realtime(mp) && mp->m_sb.sb_rextsize != 1) {
 			xfs_alert(mp,
-	"reflink not compatible with realtime device!");
+	"reflink not compatible with realtime extent size %u!",
+					mp->m_sb.sb_rextsize);
 			error = -EINVAL;
 			goto out_filestream_unmount;
 		}
 
-		if (xfs_globals.always_cow) {
+		/*
+		 * always-cow mode is not supported on filesystems with rt
+		 * extent sizes larger than a single block because we'd have
+		 * to perform write-around for unaligned writes because remap
+		 * requests must be aligned to an rt extent.
+		 */
+		if (xfs_globals.always_cow &&
+		    (!xfs_has_realtime(mp) || mp->m_sb.sb_rextsize == 1)) {
 			xfs_info(mp, "using DEBUG-only always_cow mode.");
 			mp->m_always_cow = true;
 		}

