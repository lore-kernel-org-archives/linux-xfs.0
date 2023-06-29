Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF3DEB64D7
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jun 2023 02:09:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjF2CJb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 22:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjF2CJa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 22:09:30 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2FA1FF1
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 19:09:28 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b8303cd32aso1724155ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 19:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1688004568; x=1690596568;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aE8PvcqU/J/Vpiol3BHglafYJqTPd07r8CHTUINFUqo=;
        b=5p2jZQsLsT5uTEcPNewUTOBBQUJzACZJnpEHkhBCEEJ5i1AQmi2jvQau3oE2+nGPe+
         2YJMQ8IlwBcc5r527iUj8c9IDPtURekPBF1vqG6kjLuZ5FTHDjork45cwYYjZXssRpWW
         K5X5Ph4i29KXfDvSgqAvY9LZn4CBRaEo6ubwyg+7xkkqRQFbsNNRmW/k5PFGSUzhipJI
         Wx2ZQyb90m4HHFUX12pg/w6hha6BpdNFFyCXbfeOdKyxXHsPsAuA++4U91+liU+gEB3n
         eup8TkiyBe9rPP25qKVLrUX5pBtSDYsIXpy7DvDupFBtI+HZaPFnguDwL2gM/LHRyRSd
         xIzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688004568; x=1690596568;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aE8PvcqU/J/Vpiol3BHglafYJqTPd07r8CHTUINFUqo=;
        b=J9KWgWmEKf0a0cpZCNgw+rwMbGapitTAeRWe2b+6JK8nW0Rea9qLTu8qZrE3Pb96y4
         zXxGvi/C6cdgiBiJNUMknXVbzOgFK4aJvGoxweYi8WRisCDQZl4nwp5n619eyoBiPLV4
         ddVVEKCptXzaW5oOJZn6qWzFLrLHTBN+rPxcB6a3AhjM6czj6SXo3eHZUY2nd2P6YnNW
         6jgGSmQn+Dgcx+0L+/wGm7nxMZY7kmaW7E6WVg3f8yWqqTbfnsUD5imcf+6H3Ltm8AgQ
         UnfXNvdlJ6quttjkILDvaXKuNHUlxOlM1bLhoW1joSuGBwNpIZJCnGVyLnuxaKfsln5C
         UW4Q==
X-Gm-Message-State: AC+VfDy0aQHiDNq7idt7JGCgby6pIfN9F4ZIEXQkkwykvzR3DNqfLGH+
        mw9n4raUe9SJPTClx0+nQvDNJvq74VhV9PSELeU=
X-Google-Smtp-Source: ACHHUZ5k+Xx7HI72xwj0+pYLd3d8QNRio+YfBJmqoX5MJq8yAzgvueAUwWosDvJFxS4ZE57QELhdow==
X-Received: by 2002:a17:903:1210:b0:1b3:cac7:19cd with SMTP id l16-20020a170903121000b001b3cac719cdmr17113075plh.18.1688004568338;
        Wed, 28 Jun 2023 19:09:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id u13-20020a170902a60d00b001b7f71ec608sm6788251plq.155.2023.06.28.19.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 19:09:27 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qEh65-00HSH0-0Z;
        Thu, 29 Jun 2023 12:09:25 +1000
Date:   Thu, 29 Jun 2023 12:09:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/8 V2] xfs: AGF length has never been bounds checked
Message-ID: <ZJzn1QMNdCAXx4Il@dread.disaster.area>
References: <20230627224412.2242198-1-david@fromorbit.com>
 <20230627224412.2242198-8-david@fromorbit.com>
 <20230628175211.GX11441@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230628175211.GX11441@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The AGF verifier does not check that the AGF length field is within
known good bounds. This has never been checked by runtime kernel
code (i.e. the lack of verification goes back to 1993) yet we assume
in many places that it is correct and verify other metdata against
it.

Add length verification to the AGF verifier. The length of the AGF
must be equal to the size of the AG specified in the superblock,
unless it is the last AG in the filesystem. In that case, it must be
less than or equal to sb->sb_agblocks and greater than
XFS_MIN_AG_BLOCKS, which is the smallest AG a growfs operation will
allow to exist.

This requires a bit of rework of the verifier function. We want to
verify metadata before we use it to verify other metadata. Hence
we need to verify the AGF sequence numbers before using them to
verify the length of the AGF. Then we can verify the AGF length
before we verify AGFL fields. Then we can verifier other fields that
are bounds limited by the AGF length.

And, finally, by calculating agf_length only once into a local
variable, we can collapse repeated "if (xfs_has_foo() &&"
conditionaly checks into single checks. This makes the code much
easier to follow as all the checks for a given feature are obviously
in the same place.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---

Version 2:
- growfs will write the new AGFs before the superblock has been
  updated, so we have to skip the new runt AGF seqno check otherwise
  it will fail.

 fs/xfs/libxfs/xfs_alloc.c | 92 +++++++++++++++++++++++++++++------------------
 1 file changed, 57 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 1e72b91daff6..fe7d5ea47b90 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2974,6 +2974,7 @@ xfs_agf_verify(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_agf		*agf = bp->b_addr;
+	uint32_t		agf_length = be32_to_cpu(agf->agf_length);
 
 	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
@@ -2985,18 +2986,49 @@ xfs_agf_verify(
 	if (!xfs_verify_magic(bp, agf->agf_magicnum))
 		return __this_address;
 
-	if (!(XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
-	      be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
-	      be32_to_cpu(agf->agf_flfirst) < xfs_agfl_size(mp) &&
-	      be32_to_cpu(agf->agf_fllast) < xfs_agfl_size(mp) &&
-	      be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp)))
+	if (!XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)))
 		return __this_address;
 
-	if (be32_to_cpu(agf->agf_length) > mp->m_sb.sb_dblocks)
+	/*
+	 * Both agf_seqno and agf_length need to validated before anything else
+	 * block number related in the AGF or AGFL can be checked.
+	 *
+	 * During growfs operations, the perag is not fully initialised,
+	 * so we can't use it for any useful checking. growfs ensures we can't
+	 * use it by using uncached buffers that don't have the perag attached
+	 * so we can detect and avoid this problem.
+	 */
+	if (bp->b_pag && be32_to_cpu(agf->agf_seqno) != bp->b_pag->pag_agno)
+		return __this_address;
+
+	/*
+	 * Only the last AGF in the filesytsem is allowed to be shorter
+	 * than the AG size recorded in the superblock.
+	 */
+	if (agf_length != mp->m_sb.sb_agblocks) {
+		/*
+		 * During growfs, the new last AGF can get here before we
+		 * have updated the superblock. Give it a pass on the seqno
+		 * check.
+		 */
+		if (bp->b_pag &&
+		    be32_to_cpu(agf->agf_seqno) != mp->m_sb.sb_agcount - 1)
+			return __this_address;
+		if (agf_length < XFS_MIN_AG_BLOCKS)
+			return __this_address;
+		if (agf_length > mp->m_sb.sb_agblocks)
+			return __this_address;
+	}
+
+	if (be32_to_cpu(agf->agf_flfirst) >= xfs_agfl_size(mp))
+		return __this_address;
+	if (be32_to_cpu(agf->agf_fllast) >= xfs_agfl_size(mp))
+		return __this_address;
+	if (be32_to_cpu(agf->agf_flcount) > xfs_agfl_size(mp))
 		return __this_address;
 
 	if (be32_to_cpu(agf->agf_freeblks) < be32_to_cpu(agf->agf_longest) ||
-	    be32_to_cpu(agf->agf_freeblks) > be32_to_cpu(agf->agf_length))
+	    be32_to_cpu(agf->agf_freeblks) > agf_length)
 		return __this_address;
 
 	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
@@ -3007,38 +3039,28 @@ xfs_agf_verify(
 						mp->m_alloc_maxlevels)
 		return __this_address;
 
-	if (xfs_has_rmapbt(mp) &&
-	    (be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) < 1 ||
-	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) >
-						mp->m_rmap_maxlevels))
-		return __this_address;
-
-	if (xfs_has_rmapbt(mp) &&
-	    be32_to_cpu(agf->agf_rmap_blocks) > be32_to_cpu(agf->agf_length))
-		return __this_address;
-
-	/*
-	 * during growfs operations, the perag is not fully initialised,
-	 * so we can't use it for any useful checking. growfs ensures we can't
-	 * use it by using uncached buffers that don't have the perag attached
-	 * so we can detect and avoid this problem.
-	 */
-	if (bp->b_pag && be32_to_cpu(agf->agf_seqno) != bp->b_pag->pag_agno)
-		return __this_address;
-
 	if (xfs_has_lazysbcount(mp) &&
-	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
+	    be32_to_cpu(agf->agf_btreeblks) > agf_length)
 		return __this_address;
 
-	if (xfs_has_reflink(mp) &&
-	    be32_to_cpu(agf->agf_refcount_blocks) >
-	    be32_to_cpu(agf->agf_length))
-		return __this_address;
+	if (xfs_has_rmapbt(mp)) {
+		if (be32_to_cpu(agf->agf_rmap_blocks) > agf_length)
+			return __this_address;
 
-	if (xfs_has_reflink(mp) &&
-	    (be32_to_cpu(agf->agf_refcount_level) < 1 ||
-	     be32_to_cpu(agf->agf_refcount_level) > mp->m_refc_maxlevels))
-		return __this_address;
+		if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) < 1 ||
+		    be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) >
+							mp->m_rmap_maxlevels)
+			return __this_address;
+	}
+
+	if (xfs_has_reflink(mp)) {
+		if (be32_to_cpu(agf->agf_refcount_blocks) > agf_length)
+			return __this_address;
+
+		if (be32_to_cpu(agf->agf_refcount_level) < 1 ||
+		    be32_to_cpu(agf->agf_refcount_level) > mp->m_refc_maxlevels)
+			return __this_address;
+	}
 
 	return NULL;
 }
