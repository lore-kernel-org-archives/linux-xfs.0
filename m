Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55484C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378685AbiEEQJM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381637AbiEEQJK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:09:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD0013F41
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:05:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71300B82DEE
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EA4C385AE;
        Thu,  5 May 2022 16:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766726;
        bh=A042UMTUmrtFn9XHB8VctuhU3311jbwVmCfeBu3pjdc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kOEYvdxAVDZSgjBU3YE6gE4tXqVosYV0n2VPGZ9kKQnQ8r8Yvd/pxClxnT7JQ4lFd
         NprGiDqmbsxLXG5qBhFZAiGvjywNiFZlEtetth9bRwp0o71HJclWWXhgu1CBJAuIuV
         AizD4S2NpU1bBjnPFT+RfAwlnQOwBMC46C6gtKZ3JAvcs6OehsvfApgwSkPGEfOccz
         sqKSFgHsv8GexansLV/T0LkzCEU6TIMMNXBb1A/JudxtL8PgWYZtVh24FNUfthY8hO
         /y15zeEydt6U/w7Y9FKJiPhkd+UQLS/3gmtjiTthUJyvitzBOEAGtIbI3ih3GuJB7+
         48BfWIPbGNz9A==
Subject: [PATCH 3/6] mkfs: don't let internal logs bump the root dir inode
 chunk to AG 1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:05:25 -0700
Message-ID: <165176672573.248587.11315519052535516182.stgit@magnolia>
In-Reply-To: <165176670883.248587.2509972137741301804.stgit@magnolia>
References: <165176670883.248587.2509972137741301804.stgit@magnolia>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
 

