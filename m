Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A6EC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 10:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352426AbiFAKqO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 06:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352256AbiFAKqF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 06:46:05 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B42980201;
        Wed,  1 Jun 2022 03:46:01 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id t6so1772919wra.4;
        Wed, 01 Jun 2022 03:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v9bZ/oogoWoPQX2w9BuFOFgcjiIV4xqYgwERl5n3obI=;
        b=JH3JN35t8gUIVD5gD/t3vR8XdbsMT2ectwVKGHqZFksdi+RXnhYrqMff3Qqy5XMzH2
         9RsE02JwACIHx6sx2C3/dTXEhy2zVLBjtUAe+kjz/+zeCjn4EQYvWCmKWiu8klp6Knjf
         3jCm519DH0+bRF4Sqvt+XWzYqVCNi9lZzK6ZzX7loLfjHg7aCpU3AvMBGlU/1cxliiQJ
         SexK/iF/+7ddSAlWKZ6kwZFb0FjDFCAEn/BGQUEUZ9OJWEZyFNpqVNh9eBEaRYTz3x/W
         qnjqxgBqLFKXu85hRC/rwDXBzB1crA2qZ4+B0ccEB7IxjBOHvfq11mQDmzuLf+bKFG2h
         ikGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v9bZ/oogoWoPQX2w9BuFOFgcjiIV4xqYgwERl5n3obI=;
        b=fIa7EQKobK9eWiY6kCULWewuTvgjHoZNKVJANoLmfBA4+47Fl+8lSTe0EwbaBjiEXE
         Q9UaE4PBYw1AOt4oR0FNUTgPS8KdA0aLjzZIDipbNtJWhmy2JXtGyxobk38nvHJZoXJL
         BQnpU2+KonjDaU8OtOQpM1f7LdtGO/PrATClQU4HZ8AObDfjq8JwFO4uGvNALWNI1rWI
         osijb3aj790G/XdtSdCSMUi7JFJkQQRWBBxg72u8obe93owRQwis2klJDav/d4mBcQQA
         iW9pCUckbjgxTUsPr2ckeHUC77Ti7F79eLs8bSNb8hoH+Hep7xFOal9aP1e3LjXKyfuB
         o+Wg==
X-Gm-Message-State: AOAM531Sw7tVPFbU94oAubU0UyJ+dqQvR+TTHUAUVUaeKlwwj9eRbjCL
        7gWf/UApd3qkimvWatBGWoY=
X-Google-Smtp-Source: ABdhPJylX4igljmylj1H+c7yVoc6LUNus4KHZ1YGMXQlZ70t1Wz98xKBKsZT3bP4LOukKZ85pNQfww==
X-Received: by 2002:a05:6000:18aa:b0:20c:7ec0:b804 with SMTP id b10-20020a05600018aa00b0020c7ec0b804mr51558933wri.128.1654080359423;
        Wed, 01 Jun 2022 03:45:59 -0700 (PDT)
Received: from localhost.localdomain ([77.137.79.96])
        by smtp.gmail.com with ESMTPSA id h9-20020a5d4309000000b002102af52a2csm1562150wrq.9.2022.06.01.03.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 03:45:58 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH 5.10 CANDIDATE 4/8] xfs: fix chown leaking delalloc quota blocks when fssetxattr fails
Date:   Wed,  1 Jun 2022 13:45:43 +0300
Message-Id: <20220601104547.260949-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220601104547.260949-1-amir73il@gmail.com>
References: <20220601104547.260949-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 1aecf3734a95f3c167d1495550ca57556d33f7ec upstream.

While refactoring the quota code to create a function to allocate inode
change transactions, I noticed that xfs_qm_vop_chown_reserve does more
than just make reservations: it also *modifies* the incore counts
directly to handle the owner id change for the delalloc blocks.

I then observed that the fssetxattr code continues validating input
arguments after making the quota reservation but before dirtying the
transaction.  If the routine decides to error out, it fails to undo the
accounting switch!  This leads to incorrect quota reservation and
failure down the line.

We can fix this by making the reservation function do only that -- for
the new dquot, it reserves ondisk and delalloc blocks to the
transaction, and the old dquot hangs on to its incore reservation for
now.  Once we actually switch the dquots, we can then update the incore
reservations because we've dirtied the transaction and it's too late to
turn back now.

No fixes tag because this has been broken since the start of git.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_qm.c | 92 +++++++++++++++++++------------------------------
 1 file changed, 35 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b2a9abee8b2b..64e5da33733b 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1785,6 +1785,29 @@ xfs_qm_vop_chown(
 	xfs_trans_mod_dquot(tp, newdq, bfield, ip->i_d.di_nblocks);
 	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_ICOUNT, 1);
 
+	/*
+	 * Back when we made quota reservations for the chown, we reserved the
+	 * ondisk blocks + delalloc blocks with the new dquot.  Now that we've
+	 * switched the dquots, decrease the new dquot's block reservation
+	 * (having already bumped up the real counter) so that we don't have
+	 * any reservation to give back when we commit.
+	 */
+	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_RES_BLKS,
+			-ip->i_delayed_blks);
+
+	/*
+	 * Give the incore reservation for delalloc blocks back to the old
+	 * dquot.  We don't normally handle delalloc quota reservations
+	 * transactionally, so just lock the dquot and subtract from the
+	 * reservation.  Dirty the transaction because it's too late to turn
+	 * back now.
+	 */
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	xfs_dqlock(prevdq);
+	ASSERT(prevdq->q_blk.reserved >= ip->i_delayed_blks);
+	prevdq->q_blk.reserved -= ip->i_delayed_blks;
+	xfs_dqunlock(prevdq);
+
 	/*
 	 * Take an extra reference, because the inode is going to keep
 	 * this dquot pointer even after the trans_commit.
@@ -1807,84 +1830,39 @@ xfs_qm_vop_chown_reserve(
 	uint			flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	uint64_t		delblks;
 	unsigned int		blkflags;
-	struct xfs_dquot	*udq_unres = NULL;
-	struct xfs_dquot	*gdq_unres = NULL;
-	struct xfs_dquot	*pdq_unres = NULL;
 	struct xfs_dquot	*udq_delblks = NULL;
 	struct xfs_dquot	*gdq_delblks = NULL;
 	struct xfs_dquot	*pdq_delblks = NULL;
-	int			error;
-
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
-	delblks = ip->i_delayed_blks;
 	blkflags = XFS_IS_REALTIME_INODE(ip) ?
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    i_uid_read(VFS_I(ip)) != udqp->q_id) {
+	    i_uid_read(VFS_I(ip)) != udqp->q_id)
 		udq_delblks = udqp;
-		/*
-		 * If there are delayed allocation blocks, then we have to
-		 * unreserve those from the old dquot, and add them to the
-		 * new dquot.
-		 */
-		if (delblks) {
-			ASSERT(ip->i_udquot);
-			udq_unres = ip->i_udquot;
-		}
-	}
+
 	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
-	    i_gid_read(VFS_I(ip)) != gdqp->q_id) {
+	    i_gid_read(VFS_I(ip)) != gdqp->q_id)
 		gdq_delblks = gdqp;
-		if (delblks) {
-			ASSERT(ip->i_gdquot);
-			gdq_unres = ip->i_gdquot;
-		}
-	}
 
 	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
-	    ip->i_d.di_projid != pdqp->q_id) {
+	    ip->i_d.di_projid != pdqp->q_id)
 		pdq_delblks = pdqp;
-		if (delblks) {
-			ASSERT(ip->i_pdquot);
-			pdq_unres = ip->i_pdquot;
-		}
-	}
-
-	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
-				udq_delblks, gdq_delblks, pdq_delblks,
-				ip->i_d.di_nblocks, 1, flags | blkflags);
-	if (error)
-		return error;
 
 	/*
-	 * Do the delayed blks reservations/unreservations now. Since, these
-	 * are done without the help of a transaction, if a reservation fails
-	 * its previous reservations won't be automatically undone by trans
-	 * code. So, we have to do it manually here.
+	 * Reserve enough quota to handle blocks on disk and reserved for a
+	 * delayed allocation.  We'll actually transfer the delalloc
+	 * reservation between dquots at chown time, even though that part is
+	 * only semi-transactional.
 	 */
-	if (delblks) {
-		/*
-		 * Do the reservations first. Unreservation can't fail.
-		 */
-		ASSERT(udq_delblks || gdq_delblks || pdq_delblks);
-		ASSERT(udq_unres || gdq_unres || pdq_unres);
-		error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-			    udq_delblks, gdq_delblks, pdq_delblks,
-			    (xfs_qcnt_t)delblks, 0, flags | blkflags);
-		if (error)
-			return error;
-		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-				udq_unres, gdq_unres, pdq_unres,
-				-((xfs_qcnt_t)delblks), 0, blkflags);
-	}
-
-	return 0;
+	return xfs_trans_reserve_quota_bydquots(tp, ip->i_mount, udq_delblks,
+			gdq_delblks, pdq_delblks,
+			ip->i_d.di_nblocks + ip->i_delayed_blks,
+			1, blkflags | flags);
 }
 
 int
-- 
2.25.1

