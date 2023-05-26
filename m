Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3009BC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbjEZA4T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbjEZA4S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:56:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1E5199
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:56:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB5D964BF7
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D799C433D2;
        Fri, 26 May 2023 00:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062576;
        bh=4JJdi+R8PJouaKwh3TA5IM3fRFKpFzua4klb3AtNED8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=B5aZHhA39HDZ1J9Fwu09ZWOfzFd+SWzfvoo751H9GzeazqZGRXq6ASC0AR7CzjP7J
         92K4D8otqo9hb/5DG8pyNpH7mIC65UR/Wdxx2EADbrdcpHIxDhTCUmJHGwAsCxz4b6
         mFxu1D4vZT6jGv9yRg7+2A+1emrzbieOZfnYeK6XV/pN2vFpw+PcVi28mwLcEE5Hpm
         xy1aU2Kg+7QuLe/qEL+FyH3UbbmZBoFrCn/Af1PDTCIdraucNjB1Yi8j5VOyvcoUth
         S23NFImc+e3rDO+wI3INlAsHHFzpziqCji9/GdSoN4fu8CahUE+eTvgpj10gvwNCSf
         EN6zmMeR4Esjg==
Date:   Thu, 25 May 2023 17:56:15 -0700
Subject: [PATCH 1/4] xfs: speed up xfs_iwalk_adjust_start a little bit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506059469.3730949.13232718357655512884.stgit@frogsfrogsfrogs>
In-Reply-To: <168506059451.3730949.8525428478120924050.stgit@frogsfrogsfrogs>
References: <168506059451.3730949.8525428478120924050.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Replace the open-coded loop that recomputes freecount with a single call
to a bit weight function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iwalk.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index b3275e8d47b6..4ce85423ef3e 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -22,6 +22,7 @@
 #include "xfs_trans.h"
 #include "xfs_pwork.h"
 #include "xfs_ag.h"
+#include "xfs_bit.h"
 
 /*
  * Walking Inodes in the Filesystem
@@ -131,21 +132,11 @@ xfs_iwalk_adjust_start(
 	struct xfs_inobt_rec_incore	*irec)	/* btree record */
 {
 	int				idx;	/* index into inode chunk */
-	int				i;
 
 	idx = agino - irec->ir_startino;
 
-	/*
-	 * We got a right chunk with some left inodes allocated at it.  Grab
-	 * the chunk record.  Mark all the uninteresting inodes free because
-	 * they're before our start point.
-	 */
-	for (i = 0; i < idx; i++) {
-		if (XFS_INOBT_MASK(i) & ~irec->ir_free)
-			irec->ir_freecount++;
-	}
-
 	irec->ir_free |= xfs_inobt_maskn(0, idx);
+	irec->ir_freecount = hweight64(irec->ir_free);
 }
 
 /* Allocate memory for a walk. */

