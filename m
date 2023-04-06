Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4214CC7619A
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 00:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbjDFAEF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 20:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbjDFAEC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 20:04:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241787DA1
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 17:03:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 922F7627F6
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 00:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013E6C433D2;
        Thu,  6 Apr 2023 00:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680739391;
        bh=qoZxSpn52sHNObUAoxGrs0sIwFtmGHp5oAdWsoO3k3A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Nxw4ALzeMMWpodyuGQ5DOOqyE3KSFKr0vJ09SAuzVd2rRHGmpv+RR558O/iAxoJmO
         LpcsWtwvuMsgLKRkp2teyqhmWLQcnvnHbuFZ7WCa3zx5TfyaEdTL/yeQPlOKJVpKit
         QkCJ04RQ8C8KjBr3ASmp2595V3ikGTC9MjsR0DZAscEHai8js0Q8AFCuxtXEYay23y
         j3b2NiLmwH/OjC5oNdm+QSYsA5w0XMdG1HzFjtUbhDuB8XeqUbZ2eNAsMyrWmcKq+j
         MGMy2O/apx6J1a/dFEvVS/KoXLQeDUS2pRO2KdXTpARyOawwgFMjvskSPmwUd6o1Rh
         b76vWz7SkThuw==
Subject: [PATCH 3/4] xfs: use the directory name hash function for dir
 scrubbing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 05 Apr 2023 17:03:10 -0700
Message-ID: <168073939050.1648023.15263963125718682690.stgit@frogsfrogsfrogs>
In-Reply-To: <168073937339.1648023.5029899643925660515.stgit@frogsfrogsfrogs>
References: <168073937339.1648023.5029899643925660515.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The directory code has a directory-specific hash computation function
that includes a modified hash function for case-insensitive lookups.
Hence we must use that function (and not the raw da_hashname) when
checking the dabtree structure.

Found by accidentally breaking xfs/188 to create an abnormally huge
case-insensitive directory and watching scrub break.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index d1b0f23c2c59..aeb815a483ff 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -201,6 +201,7 @@ xchk_dir_rec(
 	struct xchk_da_btree		*ds,
 	int				level)
 {
+	struct xfs_name			dname = { };
 	struct xfs_da_state_blk		*blk = &ds->state->path.blk[level];
 	struct xfs_mount		*mp = ds->state->mp;
 	struct xfs_inode		*dp = ds->dargs.dp;
@@ -297,7 +298,11 @@ xchk_dir_rec(
 		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 		goto out_relse;
 	}
-	calc_hash = xfs_da_hashname(dent->name, dent->namelen);
+
+	/* Does the directory hash match? */
+	dname.name = dent->name;
+	dname.len = dent->namelen;
+	calc_hash = xfs_dir2_hashname(mp, &dname);
 	if (calc_hash != hash)
 		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 

