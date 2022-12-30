Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE319C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbiLaCSZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236196AbiLaCSY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:18:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59D713F62
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:18:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42F3361CAA
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1744C433EF;
        Sat, 31 Dec 2022 02:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453102;
        bh=9ICsG7feLTjjHlbc8H4hqb9Juxn8YcQ8HFDBu9NE6LQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=r5QWhColwbgW3Px6gWQTRywyBEnnvP+oQTNX/PjBaTXSx/rfVYgXMo/euVW8OluGz
         UXKk25eA2y0/ailjI8lG7bs9yI4Yic8JaKL6yymI3YeJeOsnMZwQav+XYFrmwPGYt4
         Z+p9q0SlWZAOVo3SczMUJ4G+wZu518mCmX21cbuFtSHZBcjL6oT6b0ziTJE/Bt7qIa
         yKYlHnfySVeKjDNIXyJ/jRtqMYvr3uXWBooPqcwJ8qUxfku1zLFeSp2QRhWTRieYgJ
         teRIOIx8EqC3EEjl/Kv3L7JVdm5ROhmpW/e87+Lc7OVRHiu0N8K3ZX8WCUsgSUs5jx
         G3vBHGbIwHNHg==
Subject: [PATCH 33/46] xfs_repair: check metadata inode flag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:23 -0800
Message-ID: <167243876365.725900.9776367383934384438.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Check whether or not the metadata inode flag is set appropriately.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/dinode.c          |   14 ++++++++++++++
 2 files changed, 15 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 785354d3ec8..65fa90c8a2f 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -95,6 +95,7 @@
 #define xfs_dinode_calc_crc		libxfs_dinode_calc_crc
 #define xfs_dinode_good_version		libxfs_dinode_good_version
 #define xfs_dinode_verify		libxfs_dinode_verify
+#define xfs_dinode_verify_metaflag	libxfs_dinode_verify_metaflag
 
 #define xfs_dir2_data_bestfree_p	libxfs_dir2_data_bestfree_p
 #define xfs_dir2_data_entry_tag_p	libxfs_dir2_data_entry_tag_p
diff --git a/repair/dinode.c b/repair/dinode.c
index ee34a62ae8b..cf517f77173 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2662,6 +2662,20 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			}
 		}
 
+		if (flags2 & XFS_DIFLAG2_METADATA) {
+			xfs_failaddr_t	fa;
+
+			fa = libxfs_dinode_verify_metaflag(mp, dino, di_mode,
+					be16_to_cpu(dino->di_flags), flags2);
+			if (fa) {
+				if (!uncertain)
+					do_warn(
+	_("inode %" PRIu64 " is incorrectly marked as metadata\n"),
+						lino);
+				goto clear_bad_out;
+			}
+		}
+
 		if ((flags2 & XFS_DIFLAG2_REFLINK) &&
 		    !xfs_has_reflink(mp)) {
 			if (!uncertain) {

