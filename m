Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B86EB64DA
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 01:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbjFPB7O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 21:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjFPB7O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 21:59:14 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC88C2952
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 18:59:10 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b4f9583404so1903085ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 18:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686880750; x=1689472750;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=9axUd+7wc8ebxQ8SSBxFzrGoHR53lWGeolExlQNhGlM=;
        b=Ji7DpW284Ql3HU0PmpyFBuLG8JH6au8qAFBjbLdCeyvPErpr9r5RAZmitWf+pRVzQQ
         Dsqu4zpZnM5OI/AqhY9IVBr0a3qRLu4AM5c7k8AFHlFZ1thRZIkLYrjw1nfVldpi2gdA
         kgA9no1b69fxpKVCM7dunAQ9ti4+51trHxzCLmbea8zJI8cz9n9LCFjbZkswYzb6qJc/
         Chm8w2rR4zCHAueb3nP0kFdDEZVU0munoeur/KWh9SjLd7aIF3s99vMAxhCEIO26pL9H
         EBMaFY7yVFYzzcHeUIaZ0YURrrsFQCWIRGO2fc9l43WTfIcEwUucuC9FcBW4oB7WuPym
         j4Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686880750; x=1689472750;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9axUd+7wc8ebxQ8SSBxFzrGoHR53lWGeolExlQNhGlM=;
        b=YvuXSl4F7jeRu3Ly80ttkwGhtUVrfVjaH+5iJf5lXjaJqcmkSIbogt8/gOtbIqA9uZ
         MfEliMiut2HyLICbINUgi2BmW3huCWuM1/aUs+dNZOVIxaZy6tSXKH+8K1SFxwI+LdTp
         ro4x9hWr01X8eyLhkvgrshHB9fKjvcOIvXoqDoWBH1RMYQ5XWthEbkzGP3WT1kGFEk6Y
         aqnVax/tO0ZyggtvhPvVl8S+NrArnGcaugMRj1zWljE3TVyt2QVSdZumDqmMx+S88sjP
         doKoOvsUgBTLAM0U0X6QPQwn6NTy3czx/zb6qbDSB0ypIf+IA59BIc8KaVBBYcNqc6GL
         Ur6A==
X-Gm-Message-State: AC+VfDxmQTsGTrvVuf1wjWgnRL73meJWANFyqMLLgf/ZHmAfHRF/25Tv
        hd3/VC1986/zkOYU0u0Yzx9SzF4Hp5wVW2lTODs=
X-Google-Smtp-Source: ACHHUZ5jJedvupjyYU3j+EdniLzMQITQCeZEEmmg/XpFxvcxj8WxQ0UFGgzQN2qFm+lb+C7A1sr4Mg==
X-Received: by 2002:a17:902:a3c7:b0:1b5:361:cefe with SMTP id q7-20020a170902a3c700b001b50361cefemr568934plb.52.1686880750095;
        Thu, 15 Jun 2023 18:59:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001b3df3ae3f8sm7097574pld.281.2023.06.15.18.59.09
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 18:59:09 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1q9yjz-00CIW4-0w
        for linux-xfs@vger.kernel.org;
        Fri, 16 Jun 2023 11:59:07 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1q9yjy-00G07v-2v
        for linux-xfs@vger.kernel.org;
        Fri, 16 Jun 2023 11:59:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: AGF length has never been bounds checked
Date:   Fri, 16 Jun 2023 11:59:06 +1000
Message-Id: <20230616015906.3813726-1-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
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
---
 fs/xfs/libxfs/xfs_alloc.c | 81 ++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 7c675aae0a0f..78556cad57e5 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2970,6 +2970,7 @@ xfs_agf_verify(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_agf		*agf = bp->b_addr;
+	uint32_t		agf_length = be32_to_cpu(agf->agf_length);
 
 	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
@@ -2981,18 +2982,38 @@ xfs_agf_verify(
 	if (!xfs_verify_magic(bp, agf->agf_magicnum))
 		return __this_address;
 
-	if (!(XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
-	      be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
-	      be32_to_cpu(agf->agf_flfirst) < xfs_agfl_size(mp) &&
-	      be32_to_cpu(agf->agf_fllast) < xfs_agfl_size(mp) &&
-	      be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp)))
+	if (!(XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum))))
 		return __this_address;
 
-	if (be32_to_cpu(agf->agf_length) > mp->m_sb.sb_dblocks)
+	/*
+	 * during growfs operations, the perag is not fully initialised,
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
+	if (be32_to_cpu(agf->agf_flfirst) >= xfs_agfl_size(mp) ||
+	    be32_to_cpu(agf->agf_fllast) >= xfs_agfl_size(mp) ||
+	    be32_to_cpu(agf->agf_flcount) > xfs_agfl_size(mp))
 		return __this_address;
 
 	if (be32_to_cpu(agf->agf_freeblks) < be32_to_cpu(agf->agf_longest) ||
-	    be32_to_cpu(agf->agf_freeblks) > be32_to_cpu(agf->agf_length))
+	    be32_to_cpu(agf->agf_freeblks) > agf_length)
 		return __this_address;
 
 	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
@@ -3003,38 +3024,28 @@ xfs_agf_verify(
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

