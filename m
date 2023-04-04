Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799CFC761A6
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 17:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235742AbjDDRH3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 13:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235731AbjDDRHX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 13:07:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE35F5583
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 10:07:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE36A63770
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 17:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AB6C4339B;
        Tue,  4 Apr 2023 17:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680628038;
        bh=qoZxSpn52sHNObUAoxGrs0sIwFtmGHp5oAdWsoO3k3A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tQ8RJPbDI8doaghBw8U5DG4vK4RzslDHuq/d868kmK+qAbILu+yD50PKy/0M5O8y2
         uEx6gbCrDs0RMVlEyvuyAssvs4gy0IVl6PJ9DeLdWNiWL4sHmrWYYug9m90R2pEL8y
         pXDbG9nCNPB+Gx+hd6Q8XaYNwc1gdlOzmCvFVDPiY/osRHB03pJjvOl7TJPzNfEeVV
         b8EprrVxy9OT9GxFvGEVY6kYr+H/uBDLDmxTa7F/rdVMF6CPdE2WbH2POqR6X3h0eU
         0uWZyBWkRf1Ohr6grivb+66Ro99k0d9Yjp5z0ebEkqFIHeB3sT+LPiqP8kl36/5tTe
         HYFlU763npgOw==
Subject: [PATCH 3/3] xfs: use the directory name hash function for dir
 scrubbing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     torvalds@linux-foundation.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Tue, 04 Apr 2023 10:07:17 -0700
Message-ID: <168062803764.174368.602746493992883985.stgit@frogsfrogsfrogs>
In-Reply-To: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
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
 

