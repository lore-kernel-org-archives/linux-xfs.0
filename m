Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D83EB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jun 2023 19:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjF2Tme (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jun 2023 15:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbjF2Tmd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2023 15:42:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4307C2D4E
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 12:42:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 711E361615
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 19:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0BCC433C8;
        Thu, 29 Jun 2023 19:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688067750;
        bh=IBN+6BTxGjXE1reY/HLR6yMBhAjZqYYLo4fs2n1tal8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zw5w3MqQC0HBnP2iRBpUssn9Nm5OH9HcfOrNBmwRZ4dV8QU3yUL7l/zNpKzKxq3wT
         20T15A/Idt8QX8hKzxyBZrS0558fJUQABXJTuowYVEoZGnDLRYpHGtgGH7P33L+Ns4
         jLeXqTHm4mIDczpg8+TgBySeJaI52gU4XoSBXpfIQAE2t7hdiCQz5jGI9Lmm9ZMhXb
         9vmY3snlbbNNs+L/SbEUIbwVqvNseV+GfHjuwf0N3vXkIxJTvq2J93qx4RWPKMwTqc
         cm2c3SOhWomaXNp1QFRHmgCmnPv17Lj1Hae0NuUn+BkzULGe3dQs1DrNuReigKdR1L
         g7yitsrJ9ogjg==
Date:   Thu, 29 Jun 2023 12:42:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH 9/8] xfs: AGI length should be bounds checked
Message-ID: <20230629194230.GH11441@frogsfrogsfrogs>
References: <20230627224412.2242198-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230627224412.2242198-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Similar to the recent patch strengthening the AGF agf_length
verification, the AGI verifier does not check that the AGI length field
is within known good bounds.  This isn't currently checked by runtime
kernel code, yet we assume in many places that it is correct and verify
other metadata against it.

Add length verification to the AGI verifier.  Just like the AGF length
checking, the length of the AGI must be equal to the size of the AG
specified in the superblock, unless it is the last AG in the filesystem.
In that case, it must be less than or equal to sb->sb_agblocks and
greater than XFS_MIN_AG_BLOCKS, which is the smallest AG a growfs
operation will allow to exist.

There's only one place in the filesystem that actually uses agi_length,
but let's not leave it vulnerable to the same weird nonsense that
generates syzbot bugs, eh?

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
NOTE: Untested, but this patch builds...
---
 fs/xfs/libxfs/xfs_ialloc.c |   49 ++++++++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 1e5fafbc0cdb..fec6713e1fa9 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2486,11 +2486,12 @@ xfs_ialloc_log_agi(
 
 static xfs_failaddr_t
 xfs_agi_verify(
-	struct xfs_buf	*bp)
+	struct xfs_buf		*bp)
 {
-	struct xfs_mount *mp = bp->b_mount;
-	struct xfs_agi	*agi = bp->b_addr;
-	int		i;
+	struct xfs_mount	*mp = bp->b_mount;
+	struct xfs_agi		*agi = bp->b_addr;
+	uint32_t		agi_length = be32_to_cpu(agi->agi_length);
+	int			i;
 
 	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
@@ -2507,6 +2508,37 @@ xfs_agi_verify(
 	if (!XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)))
 		return __this_address;
 
+	/*
+	 * Both agi_seqno and agi_length need to validated before anything else
+	 * block number related in the AGI can be checked.
+	 *
+	 * During growfs operations, the perag is not fully initialised,
+	 * so we can't use it for any useful checking. growfs ensures we can't
+	 * use it by using uncached buffers that don't have the perag attached
+	 * so we can detect and avoid this problem.
+	 */
+	if (bp->b_pag && be32_to_cpu(agi->agi_seqno) != bp->b_pag->pag_agno)
+		return __this_address;
+
+	/*
+	 * Only the last AGI in the filesytsem is allowed to be shorter
+	 * than the AG size recorded in the superblock.
+	 */
+	if (agi_length != mp->m_sb.sb_agblocks) {
+		/*
+		 * During growfs, the new last AGI can get here before we
+		 * have updated the superblock. Give it a pass on the seqno
+		 * check.
+		 */
+		if (bp->b_pag &&
+		    be32_to_cpu(agi->agi_seqno) != mp->m_sb.sb_agcount - 1)
+			return __this_address;
+		if (agi_length < XFS_MIN_AG_BLOCKS)
+			return __this_address;
+		if (agi_length > mp->m_sb.sb_agblocks)
+			return __this_address;
+	}
+
 	if (be32_to_cpu(agi->agi_level) < 1 ||
 	    be32_to_cpu(agi->agi_level) > M_IGEO(mp)->inobt_maxlevels)
 		return __this_address;
@@ -2516,15 +2548,6 @@ xfs_agi_verify(
 	     be32_to_cpu(agi->agi_free_level) > M_IGEO(mp)->inobt_maxlevels))
 		return __this_address;
 
-	/*
-	 * during growfs operations, the perag is not fully initialised,
-	 * so we can't use it for any useful checking. growfs ensures we can't
-	 * use it by using uncached buffers that don't have the perag attached
-	 * so we can detect and avoid this problem.
-	 */
-	if (bp->b_pag && be32_to_cpu(agi->agi_seqno) != bp->b_pag->pag_agno)
-		return __this_address;
-
 	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
 		if (agi->agi_unlinked[i] == cpu_to_be32(NULLAGINO))
 			continue;
