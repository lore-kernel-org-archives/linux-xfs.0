Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CEBFC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiLaCq5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiLaCq4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:46:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E2CDF76
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:46:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D76FE61D17
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B931C433EF;
        Sat, 31 Dec 2022 02:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454814;
        bh=I6Ws5/tRpVoazQ2VmmnuY4ocp9bfTJGihgb6v94uYgs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EAAvys7mmvvX0JpyoDB0xTPXDcgiQWRv1pBNW0UH0K4LsKyIJP4fnZYFPsFik33g9
         crdrq+htmGQrnYZyT/kSso+vamtGLeDMmkogwrJxFMGveGcOuiQzltai5hSC40vDFb
         2RCcuDWUCGWrSdm6fQMTjbDh6GwIMQ5hoClNFB0EwUSRK06f/JYSGCIvSylINhf1W9
         pGxpLeCBg9CzyJxFF5XZ+u49X2BU3bN4cpg3PH69J2pfflf9UuWbRlIzSGYml+SbuU
         GY60JnJQs1I+kjy7Qn1lK4t1dP5mXfSZfrhYhLLQ7Zo5HYcZAzkV02bkOl6TdS/KNO
         bAVVvofVehYow==
Subject: [PATCH 17/41] xfs: online repair of the realtime rmap btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:58 -0800
Message-ID: <167243879820.732820.16962089889974589438.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Repair the realtime rmap btree while mounted.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rmap.c         |    2 +-
 libxfs/xfs_rmap.h         |    2 ++
 libxfs/xfs_rtrmap_btree.c |    2 +-
 libxfs/xfs_rtrmap_btree.h |    3 +++
 4 files changed, 7 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 74fb9197cbc..967a095c45d 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -263,7 +263,7 @@ xfs_rmap_check_perag_irec(
 	return NULL;
 }
 
-static inline xfs_failaddr_t
+inline xfs_failaddr_t
 xfs_rmap_check_rtgroup_irec(
 	struct xfs_rtgroup		*rtg,
 	const struct xfs_rmap_irec	*irec)
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index e98f37c39f2..9d0aaa16f55 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -215,6 +215,8 @@ xfs_failaddr_t xfs_rmap_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
 xfs_failaddr_t xfs_rmap_check_perag_irec(struct xfs_perag *pag,
 		const struct xfs_rmap_irec *irec);
+xfs_failaddr_t xfs_rmap_check_rtgroup_irec(struct xfs_rtgroup *rtg,
+		const struct xfs_rmap_irec *irec);
 xfs_failaddr_t xfs_rmap_check_irec(struct xfs_btree_cur *cur,
 		const struct xfs_rmap_irec *irec);
 
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index b39ccba497a..05258472592 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -702,7 +702,7 @@ xfs_rtrmapbt_create_path(
 }
 
 /* Calculate the rtrmap btree size for some records. */
-static unsigned long long
+unsigned long long
 xfs_rtrmapbt_calc_size(
 	struct xfs_mount	*mp,
 	unsigned long long	len)
diff --git a/libxfs/xfs_rtrmap_btree.h b/libxfs/xfs_rtrmap_btree.h
index 046a6081673..1f0a6f9620e 100644
--- a/libxfs/xfs_rtrmap_btree.h
+++ b/libxfs/xfs_rtrmap_btree.h
@@ -203,4 +203,7 @@ struct xfs_imeta_update;
 int xfs_rtrmapbt_create(struct xfs_trans **tpp, struct xfs_imeta_path *path,
 		struct xfs_imeta_update *ic, struct xfs_inode **ipp);
 
+unsigned long long xfs_rtrmapbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */

