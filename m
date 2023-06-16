Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF74DEB64DA
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 01:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbjFPBhe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 21:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjFPBhc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 21:37:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF782948
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 18:37:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 569A461B74
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 01:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5EEC433C0;
        Fri, 16 Jun 2023 01:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686879450;
        bh=3EmRSBlXwI5QjdToEYiAI+OLUGDPjKGRkB2Oqls8igY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sBuPiKcS6bCnTbCdT0ICoAgpDpSSC4qpUj0lXKeB8+TEBbQPG8oiLHwELDFN8oW6G
         lEqfqlvWEfYnogDYJE/uva6Iik1GnV1HRDxY1UuSYWbg3fAvPZ6bXkeavuGh1LGnfe
         gVVQtM0RR3FQHSccFhQo4v4Q+GD8ydaZUsUxjG484LHed1T4w173nOhNfQ4TNUXh9k
         Qut3djZtCc5WkDe23js0D3wRz46YkZm1h3a/7BM2XveLz0ULWoBk10CuOIfRxgCrrP
         iEvC/ngNvInpSp1UQGSUxV3GLlcvwzITUPuVZDLy1YlvHyDJSFfAowEGXQiJ6ZuHJg
         4tzZUW4j2ioNQ==
Subject: [PATCH 6/8] xfs: fix agf/agfl verification on v4 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Thu, 15 Jun 2023 18:37:30 -0700
Message-ID: <168687945015.831530.9252823506836536626.stgit@frogsfrogsfrogs>
In-Reply-To: <168687941600.831530.8013975214397479444.stgit@frogsfrogsfrogs>
References: <168687941600.831530.8013975214397479444.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: e0a8de7da35e5b22b44fa1013ccc0716e17b0c14

When a v4 filesystem has fl_last - fl_first != fl_count, we do not
not detect the corruption and allow the AGF to be used as it if was
fully valid. On V5 filesystems, we reset the AGFL to empty in these
cases and avoid the corruption at a small cost of leaked blocks.

If we don't catch the corruption on V4 filesystems, bad things
happen later when an allocation attempts to trim the free list
and either double-frees stale entries in the AGFl or tries to free
NULLAGBNO entries.

Either way, this is bad. Prevent this from happening by using the
AGFL_NEED_RESET logic for v4 filesysetms, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_alloc.c |   59 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 17 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 8d305c3f..229b22e6 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -624,6 +624,25 @@ xfs_alloc_fixup_trees(
 	return 0;
 }
 
+/*
+ * We do not verify the AGFL contents against AGF-based index counters here,
+ * even though we may have access to the perag that contains shadow copies. We
+ * don't know if the AGF based counters have been checked, and if they have they
+ * still may be inconsistent because they haven't yet been reset on the first
+ * allocation after the AGF has been read in.
+ *
+ * This means we can only check that all agfl entries contain valid or null
+ * values because we can't reliably determine the active range to exclude
+ * NULLAGBNO as a valid value.
+ *
+ * However, we can't even do that for v4 format filesystems because there are
+ * old versions of mkfs out there that does not initialise the AGFL to known,
+ * verifiable values. HEnce we can't tell the difference between a AGFL block
+ * allocated by mkfs and a corrupted AGFL block here on v4 filesystems.
+ *
+ * As a result, we can only fully validate AGFL block numbers when we pull them
+ * from the freelist in xfs_alloc_get_freelist().
+ */
 static xfs_failaddr_t
 xfs_agfl_verify(
 	struct xfs_buf	*bp)
@@ -633,12 +652,6 @@ xfs_agfl_verify(
 	__be32		*agfl_bno = xfs_buf_to_agfl_bno(bp);
 	int		i;
 
-	/*
-	 * There is no verification of non-crc AGFLs because mkfs does not
-	 * initialise the AGFL to zero or NULL. Hence the only valid part of the
-	 * AGFL is what the AGF says is active. We can't get to the AGF, so we
-	 * can't verify just those entries are valid.
-	 */
 	if (!xfs_has_crc(mp))
 		return NULL;
 
@@ -2317,12 +2330,16 @@ xfs_free_agfl_block(
 }
 
 /*
- * Check the agfl fields of the agf for inconsistency or corruption. The purpose
- * is to detect an agfl header padding mismatch between current and early v5
- * kernels. This problem manifests as a 1-slot size difference between the
- * on-disk flcount and the active [first, last] range of a wrapped agfl. This
- * may also catch variants of agfl count corruption unrelated to padding. Either
- * way, we'll reset the agfl and warn the user.
+ * Check the agfl fields of the agf for inconsistency or corruption.
+ *
+ * The original purpose was to detect an agfl header padding mismatch between
+ * current and early v5 kernels. This problem manifests as a 1-slot size
+ * difference between the on-disk flcount and the active [first, last] range of
+ * a wrapped agfl.
+ *
+ * However, we need to use these same checks to catch agfl count corruptions
+ * unrelated to padding. This could occur on any v4 or v5 filesystem, so either
+ * way, we need to reset the agfl and warn the user.
  *
  * Return true if a reset is required before the agfl can be used, false
  * otherwise.
@@ -2338,10 +2355,6 @@ xfs_agfl_needs_reset(
 	int			agfl_size = xfs_agfl_size(mp);
 	int			active;
 
-	/* no agfl header on v4 supers */
-	if (!xfs_has_crc(mp))
-		return false;
-
 	/*
 	 * The agf read verifier catches severe corruption of these fields.
 	 * Repeat some sanity checks to cover a packed -> unpacked mismatch if
@@ -2885,6 +2898,19 @@ xfs_alloc_put_freelist(
 	return 0;
 }
 
+/*
+ * Verify the AGF is consistent.
+ *
+ * We do not verify the AGFL indexes in the AGF are fully consistent here
+ * because of issues with variable on-disk structure sizes. Instead, we check
+ * the agfl indexes for consistency when we initialise the perag from the AGF
+ * information after a read completes.
+ *
+ * If the index is inconsistent, then we mark the perag as needing an AGFL
+ * reset. The first AGFL update performed then resets the AGFL indexes and
+ * refills the AGFL with known good free blocks, allowing the filesystem to
+ * continue operating normally at the cost of a few leaked free space blocks.
+ */
 static xfs_failaddr_t
 xfs_agf_verify(
 	struct xfs_buf		*bp)
@@ -2958,7 +2984,6 @@ xfs_agf_verify(
 		return __this_address;
 
 	return NULL;
-
 }
 
 static void

