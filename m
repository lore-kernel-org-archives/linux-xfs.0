Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCCBC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 18:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbiDNSvl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 14:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiDNSvl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 14:51:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190B9DB4AF
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 11:49:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6DB761A51
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 18:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124DDC385A1;
        Thu, 14 Apr 2022 18:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649962155;
        bh=vojhnXnBfsMPx5o9dcRZkTqkXrSuvNqwckQNOcfAVbQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dpQob0m3jGjapuBAGtOLfbQjAoDrheV7Qvv2++jRGpF1y+CiCd8SRWIhCIuwAlvtP
         x1zaG8O6HNIoEAlWRLlM12UU06prdiHhRPDIMpTupIFJZ5TZwgZK9bIyR8ahvJRHGK
         Q1olKlAKbj6ek4zXbyEKtkyH1LValHUVV3XdGXFgmp53Oiu0TDcUOnbsTVXPWAG0gq
         wfvWZ5D/pOjlhwSel8+Y5u+90caJz0vj6VhZp9Zs1LuRDU/GSZeyYEL8bNgG/HJJ/f
         PAeKxwvaUoz2RFrY4T7cmL1IERUi5i2vaAjTq2HTzRv3dzo0Qw051fg/nWKxKxOfyg
         eKpkDaKomQufw==
Subject: [PATCH 3/4] mkfs: don't let internal logs bump the root dir inode
 chunk to AG 1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 Apr 2022 11:49:14 -0700
Message-ID: <164996215459.226891.14970225993709296570.stgit@magnolia>
In-Reply-To: <164996213753.226891.14458233911347178679.stgit@magnolia>
References: <164996213753.226891.14458233911347178679.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, we don't let an internal log consume every last block in an
AG.  According to the comment, we're doing this to avoid tripping AGF
verifiers if freeblks==0, but on a modern filesystem this isn't
sufficient to avoid problems because we need to have enough space in the
AG to allocate an aligned root inode chunk, if it should be the case
that the log also ends up in AG 0:

$ truncate -s 6366g /tmp/a ; mkfs.xfs -f /tmp/a -d agcount=3200 -l agnum=0
meta-data=/tmp/a                 isize=512    agcount=3200, agsize=521503 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=1668808704, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521492, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
mkfs.xfs: root inode created in AG 1, not AG 0

Therefore, modify the maximum internal log size calculation to constrain
the maximum internal log size so that the aligned inode chunk allocation
will always succeed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index eb4d7fa9..0b1fb746 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3270,6 +3270,49 @@ validate_log_size(uint64_t logblocks, int blocklog, int min_logblocks)
 	}
 }
 
+static void
+adjust_ag0_internal_logblocks(
+	struct mkfs_params	*cfg,
+	struct xfs_mount	*mp,
+	int			min_logblocks,
+	int			*max_logblocks)
+{
+	int			backoff = 0;
+	int			ichunk_blocks;
+
+	/*
+	 * mkfs will trip over the write verifiers if the log is allocated in
+	 * AG 0 and consumes enough space that we cannot allocate a non-sparse
+	 * inode chunk for the root directory.  The inode allocator requires
+	 * that the AG have enough free space for the chunk itself plus enough
+	 * to fix up the freelist with aligned blocks if we need to fill the
+	 * allocation from the AGFL.
+	 */
+	ichunk_blocks = XFS_INODES_PER_CHUNK * cfg->inodesize >> cfg->blocklog;
+	backoff = ichunk_blocks * 4;
+
+	/*
+	 * We try to align inode allocations to the data device stripe unit,
+	 * so ensure there's enough space to perform an aligned allocation.
+	 * The inode geometry structure isn't set up yet, so compute this by
+	 * hand.
+	 */
+	backoff = max(backoff, cfg->dsunit * 2);
+
+	*max_logblocks -= backoff;
+
+	/* If the specified log size is too big, complain. */
+	if (cli_opt_set(&lopts, L_SIZE) && cfg->logblocks > *max_logblocks) {
+		fprintf(stderr,
+_("internal log size %lld too large, must be less than %d\n"),
+			(long long)cfg->logblocks,
+			*max_logblocks);
+		usage();
+	}
+
+	cfg->logblocks = min(cfg->logblocks, *max_logblocks);
+}
+
 static void
 calculate_log_size(
 	struct mkfs_params	*cfg,
@@ -3382,6 +3425,10 @@ _("log ag number %lld too large, must be less than %lld\n"),
 	} else
 		cfg->logagno = (xfs_agnumber_t)(sbp->sb_agcount / 2);
 
+	if (cfg->logagno == 0)
+		adjust_ag0_internal_logblocks(cfg, mp, min_logblocks,
+				&max_logblocks);
+
 	cfg->logstart = XFS_AGB_TO_FSB(mp, cfg->logagno,
 				       libxfs_prealloc_blocks(mp));
 

