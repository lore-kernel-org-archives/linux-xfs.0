Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28FFDEB64DC
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jun 2023 22:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjF0Wo2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jun 2023 18:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjF0Wo0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2023 18:44:26 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217812944
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 15:44:22 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-666e3b15370so3359840b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 15:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687905861; x=1690497861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XgXhhqNbFi+/MFXpR0K7xhzjAOkJwBg8lJjaklWSvcA=;
        b=itAlwsAQZXNYjX+H/2/t6ZfBld3O31tQQMTJbzz/MpxIyTpNGkKoU7fE+8lfqirKRh
         Yyi5U8aNwzIvfjYgmg3u992g5uUzuPmvly/0F6GTjik/hu+D8GYk/jXj23/ObH50I0gc
         si3L0z9MN8cjJ/FhboVLkDnyn/cnC7aApLkv8jBv/nHxQbdqzrUEe/WdsYlgJjD9WkKd
         ZeVaJ9MFcZ/gB/MsE2CZl/wldBaQIYEFATEwlt2YNQSNPmnVwhhsFxBF+XL+11PafdqY
         /NbJvLd5h+kjW2ggxclXxOhzbo1Xdr2qGGcsm4Vqtjk/PUWVZEm/C6AndHG5tF5H1YM/
         DSXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687905861; x=1690497861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XgXhhqNbFi+/MFXpR0K7xhzjAOkJwBg8lJjaklWSvcA=;
        b=AZvZvaxX0UeSWypw1qLR0cziwjpebkV3BOkMHBVbQbaNbh7/cQwYtJIsmNkuY5tspL
         FZ8KjlfU2qxi+Z0n9arYL9thEETkaap7MdXiRNTiC0D2cXCO4+U7WWkBsedjvpFeTH/h
         WFps0c9TKkkTREMCxTRh+khO3PjMK6TugeXoU47aQ55iNPLlg/L2lhShBYT9y8+eixxS
         BMxw5Z9bRnacNM+Y1Fm2NXq0pEK+l9Dg2iixdrYJXvIOm4Yj9fMeM5Ur39uLMfK8I3oA
         GJFopMgAejwfGTyrD/UjTqpGuAm2WeINj9AiToBXQvYJLExvWBWowpJS4W+pkw7pyzHe
         CMaA==
X-Gm-Message-State: AC+VfDwDIEY3zwzTcrX83JRRxi1XTbLmOmb2INkVJ5n2s0qW4vlttHCq
        bifWxVtVHZ/wwzkZjrpmqSZ/4C39bdUNBq22yIs=
X-Google-Smtp-Source: ACHHUZ49aXbvIzsF9AeTj++Gor4TVgJelxbvNl1FVSZxXSSsfsnLLt8xpYOEGMdev0yrWeHWUQ/nsA==
X-Received: by 2002:a05:6a00:99c:b0:673:8dfb:af32 with SMTP id u28-20020a056a00099c00b006738dfbaf32mr8611000pfg.26.1687905861294;
        Tue, 27 Jun 2023 15:44:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id p15-20020a63e64f000000b0051b0e564963sm6350434pgj.49.2023.06.27.15.44.18
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 15:44:20 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qEHPz-00Gzwk-1y
        for linux-xfs@vger.kernel.org;
        Wed, 28 Jun 2023 08:44:15 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qEHPz-009Zma-0o
        for linux-xfs@vger.kernel.org;
        Wed, 28 Jun 2023 08:44:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/8] xfs: AGF length has never been bounds checked
Date:   Wed, 28 Jun 2023 08:44:11 +1000
Message-Id: <20230627224412.2242198-8-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230627224412.2242198-1-david@fromorbit.com>
References: <20230627224412.2242198-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
---
 fs/xfs/libxfs/xfs_alloc.c | 86 +++++++++++++++++++++++----------------
 1 file changed, 51 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 1e72b91daff6..7c86a69354fb 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2974,6 +2974,7 @@ xfs_agf_verify(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_agf		*agf = bp->b_addr;
+	uint32_t		agf_length = be32_to_cpu(agf->agf_length);
 
 	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
@@ -2985,18 +2986,43 @@ xfs_agf_verify(
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
+		if (be32_to_cpu(agf->agf_seqno) != mp->m_sb.sb_agcount - 1)
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
@@ -3007,38 +3033,28 @@ xfs_agf_verify(
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
-- 
2.40.1

