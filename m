Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD2D1C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 19:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235475AbiCITXV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238364AbiCITXS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 14:23:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688C83E5FB
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 11:22:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93C55618F1
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 19:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C4EC340F4;
        Wed,  9 Mar 2022 19:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646853738;
        bh=LVaSQuobN16vUczm40MeGXTLMWNuC1t2FF5dT5DKGQw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lanSIRhsSfRl73ucs9EnVcmEt/LSTCv+xOpDVfPW1AXOTEAde2UJOhgwqj09r/rj8
         Wy62UkHqKa2gLOGDgRzUXAZM5NzbaYP9bAseeArfFno66Zjnb82y7+UmKs8IVOQyMU
         tO84aeXAjEtI5K4fSvlENj0E55J1UpvLlF5HuY6XDs+EWntfpkyIcbb0M8Fcqj1Gg+
         MumcboPTL0nXhcd0ipiT2ddCEqZvKZ0W1mHhVfO6K7+7sKTmQ/fk6FrGlBjQcOLJDK
         Vzb9iPQKqmzC4JGzt+7fTgKNGyoK/g3E8kiD8bejcaZBGPP7G8gDECaktbGbLYAKPW
         9XIq3OpNgvsbA==
Subject: [PATCH 2/2] xfs: refactor user/group quota chown in
 xfs_setattr_nonsize
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fdmanana@kernel.org,
        andrey.zhadchenko@virtuozzo.com, brauner@kernel.org,
        david@fromorbit.com, hch@lst.de
Date:   Wed, 09 Mar 2022 11:22:17 -0800
Message-ID: <164685373748.495833.4023209082084946055.stgit@magnolia>
In-Reply-To: <164685372611.495833.8601145506549093582.stgit@magnolia>
References: <164685372611.495833.8601145506549093582.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Combine if tests to reduce the indentation levels of the quota chown
calls in xfs_setattr_nonsize.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iops.c |   60 ++++++++++++++++++-----------------------------------
 1 file changed, 20 insertions(+), 40 deletions(-)


diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 4132026f5fb0..f6680dade1d9 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -647,10 +647,10 @@ xfs_setattr_nonsize(
 	int			mask = iattr->ia_valid;
 	xfs_trans_t		*tp;
 	int			error;
-	kuid_t			uid = GLOBAL_ROOT_UID, iuid = GLOBAL_ROOT_UID;
-	kgid_t			gid = GLOBAL_ROOT_GID, igid = GLOBAL_ROOT_GID;
+	kuid_t			uid = GLOBAL_ROOT_UID;
+	kgid_t			gid = GLOBAL_ROOT_GID;
 	struct xfs_dquot	*udqp = NULL, *gdqp = NULL;
-	struct xfs_dquot	*olddquot1 = NULL, *olddquot2 = NULL;
+	struct xfs_dquot	*old_udqp = NULL, *old_gdqp = NULL;
 
 	ASSERT((mask & ATTR_SIZE) == 0);
 
@@ -697,42 +697,22 @@ xfs_setattr_nonsize(
 		goto out_dqrele;
 
 	/*
-	 * Change file ownership.  Must be the owner or privileged.
+	 * Register quota modifications in the transaction.  Must be the owner
+	 * or privileged.  These IDs could have changed since we last looked at
+	 * them.  But, we're assured that if the ownership did change while we
+	 * didn't have the inode locked, inode's dquot(s) would have changed
+	 * also.
 	 */
-	if (mask & (ATTR_UID|ATTR_GID)) {
-		/*
-		 * These IDs could have changed since we last looked at them.
-		 * But, we're assured that if the ownership did change
-		 * while we didn't have the inode locked, inode's dquot(s)
-		 * would have changed also.
-		 */
-		iuid = inode->i_uid;
-		igid = inode->i_gid;
-		gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
-		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
-
-		/*
-		 * Change the ownerships and register quota modifications
-		 * in the transaction.
-		 */
-		if (!uid_eq(iuid, uid)) {
-			if (XFS_IS_UQUOTA_ON(mp)) {
-				ASSERT(mask & ATTR_UID);
-				ASSERT(udqp);
-				olddquot1 = xfs_qm_vop_chown(tp, ip,
-							&ip->i_udquot, udqp);
-			}
-		}
-		if (!gid_eq(igid, gid)) {
-			if (XFS_IS_GQUOTA_ON(mp)) {
-				ASSERT(xfs_has_pquotino(mp) ||
-				       !XFS_IS_PQUOTA_ON(mp));
-				ASSERT(mask & ATTR_GID);
-				ASSERT(gdqp);
-				olddquot2 = xfs_qm_vop_chown(tp, ip,
-							&ip->i_gdquot, gdqp);
-			}
-		}
+	if ((mask & ATTR_UID) && XFS_IS_UQUOTA_ON(mp) &&
+					!uid_eq(inode->i_uid, iattr->ia_uid)) {
+		ASSERT(udqp);
+		old_udqp = xfs_qm_vop_chown(tp, ip, &ip->i_udquot, udqp);
+	}
+	if ((mask & ATTR_GID) && XFS_IS_GQUOTA_ON(mp) &&
+					!gid_eq(inode->i_gid, iattr->ia_gid)) {
+		ASSERT(xfs_has_pquotino(mp) || !XFS_IS_PQUOTA_ON(mp));
+		ASSERT(gdqp);
+		old_gdqp = xfs_qm_vop_chown(tp, ip, &ip->i_gdquot, gdqp);
 	}
 
 	setattr_copy(mnt_userns, inode, iattr);
@@ -747,8 +727,8 @@ xfs_setattr_nonsize(
 	/*
 	 * Release any dquot(s) the inode had kept before chown.
 	 */
-	xfs_qm_dqrele(olddquot1);
-	xfs_qm_dqrele(olddquot2);
+	xfs_qm_dqrele(old_udqp);
+	xfs_qm_dqrele(old_gdqp);
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
 

