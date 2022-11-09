Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1B8C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiKICGz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiKICGw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:06:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BDD68AE3
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:06:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94B1B61882
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DAAC4314E;
        Wed,  9 Nov 2022 02:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959610;
        bh=XQU+SqyUb8sdTOQIqSN6fgw+9i9glN70NEMzoORQRHA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MC4DN1c0rqvhwmTffm47DhL+TZ6Yh6V0Yj49kvyk7v2oBaKuC89n31wmmYN4q47mk
         k0kSuZAEiBSOIXTTB2N8H/mOHMZqunxkvB01IECmdCbCkvSut/kF7A6zPfUq03Ofta
         RyJyqEZkE3cKU1Qw1mNyXwwUV2rQ0VZG3Z3q/ZVUXACblBhXkhZo7oHc6///afA63e
         wGMua3Z/dpQV9EF2dPGTa3D+QewYTy5L1P3S3yK4ObFCIO/XaxPS7O9pDrb19NPSrp
         qxNa/N7wysSKglLHwaGapcN3Rl3GFz/btTcbxEPcaiyMfuTzuRO3M+8hA/KNtlhF/N
         s5ZcsYNWqjCjA==
Subject: [PATCH 12/24] xfs: create a predicate to verify per-AG extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:06:49 -0800
Message-ID: <166795960964.3761583.1986799629757742162.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: b332a16ce61f24b3392f5fc31f2a7be59d314ed4

Create a predicate function to verify that a given agbno/blockcount pair
fit entirely within a single allocation group and don't suffer
mathematical overflows.  Refactor the existng open-coded logic; we're
going to add more calls to this function in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_ag.h       |   15 +++++++++++++++
 libxfs/xfs_alloc.c    |    6 +-----
 libxfs/xfs_refcount.c |    6 +-----
 libxfs/xfs_rmap.c     |    9 ++-------
 4 files changed, 19 insertions(+), 17 deletions(-)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 517a138faa..191b22b9a3 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -133,6 +133,21 @@ xfs_verify_agbno(struct xfs_perag *pag, xfs_agblock_t agbno)
 	return true;
 }
 
+static inline bool
+xfs_verify_agbext(
+	struct xfs_perag	*pag,
+	xfs_agblock_t		agbno,
+	xfs_agblock_t		len)
+{
+	if (agbno + len <= agbno)
+		return false;
+
+	if (!xfs_verify_agbno(pag, agbno))
+		return false;
+
+	return xfs_verify_agbno(pag, agbno + len - 1);
+}
+
 /*
  * Verify that an AG inode number pointer neither points outside the AG
  * nor points at static metadata.
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 3e310ce3e5..8c2c2e832f 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -259,11 +259,7 @@ xfs_alloc_get_rec(
 		goto out_bad_rec;
 
 	/* check for valid extent range, including overflow */
-	if (!xfs_verify_agbno(pag, *bno))
-		goto out_bad_rec;
-	if (*bno > *bno + *len)
-		goto out_bad_rec;
-	if (!xfs_verify_agbno(pag, *bno + *len - 1))
+	if (!xfs_verify_agbext(pag, *bno, *len))
 		goto out_bad_rec;
 
 	return 0;
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 146e833b0d..c1ebc5047b 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -134,11 +134,7 @@ xfs_refcount_get_rec(
 	}
 
 	/* check for valid extent range, including overflow */
-	if (!xfs_verify_agbno(pag, realstart))
-		goto out_bad_rec;
-	if (realstart > realstart + irec->rc_blockcount)
-		goto out_bad_rec;
-	if (!xfs_verify_agbno(pag, realstart + irec->rc_blockcount - 1))
+	if (!xfs_verify_agbext(pag, realstart, irec->rc_blockcount))
 		goto out_bad_rec;
 
 	if (irec->rc_refcount == 0 || irec->rc_refcount > MAXREFCOUNT)
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index fa4ae8fca3..b3caff1da3 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -234,13 +234,8 @@ xfs_rmap_get_rec(
 			goto out_bad_rec;
 	} else {
 		/* check for valid extent range, including overflow */
-		if (!xfs_verify_agbno(pag, irec->rm_startblock))
-			goto out_bad_rec;
-		if (irec->rm_startblock >
-				irec->rm_startblock + irec->rm_blockcount)
-			goto out_bad_rec;
-		if (!xfs_verify_agbno(pag,
-				irec->rm_startblock + irec->rm_blockcount - 1))
+		if (!xfs_verify_agbext(pag, irec->rm_startblock,
+					    irec->rm_blockcount))
 			goto out_bad_rec;
 	}
 

