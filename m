Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E38C32771
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Aug 2022 00:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237787AbiHQA4b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 20:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238081AbiHQA4a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 20:56:30 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68108036C
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:29 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id c19-20020a17090ae11300b001f2f94ed5c6so2265881pjz.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=DIbYtDor/0wJAzsfeKr5gx20UHEliw6C9x2gytVqbts=;
        b=dQ3rgQ0FNxYtHdo9BTGTZD4u6DqXH6fNEw8nU9miMW1RJalgxoSb8gRoYe8JIP8sIv
         CwaMc52KRcNkbo33mamFWon9eMmB+QcCs5HPGEC26bc2U3n5HwIgjy0o++tNJtZb8C5N
         xF7bSY1UKvz5z9tnSeA8eh9gz1Fv1fMqcOyUyEzveup9dN44Mb8u/8r4mxLEsTMr87qM
         tznYqRCSCAUU8XhxLyOwHUl1+NcC9WnFGvhlY51BY1BS2V/S5n0qY4De+F9XIqFfimhm
         iyYlqs9B25znHsbQqf6HrYI2quCqckgB4X+YeDY5yZ7zZR0KxdIheQMlkiFk+fpVYmM+
         FOsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=DIbYtDor/0wJAzsfeKr5gx20UHEliw6C9x2gytVqbts=;
        b=14RitjtfvKOuJUJtnl7sdvMEO6gXhI0fTE8vC8fAU+w49Hsnb7voToiYVG6zIChULM
         vX0rtlp8GARySlUUPVQqpnsfNRjE6kwLC9zC1XRwYi33OZ9GRPhuKLfeVad2ufesepL4
         /ylzx14yMzwMPaIdzGejMzCEA1ZMqgnIW9QtWseOb2EEaaYEDE08dye/04Us9XBbp1Ux
         KGnAm/hwN46vCsTMEf3rIhi0iFlo6iI8LmB/IYB0dKIVbifYQeIGYOb12NNZvDo+LHAz
         40Z9E24WGRsAC0RnABiO/DCYIt37Ghk23JWMK72K1djAoFU4740Ss891x/PtC5gXU0v8
         6UfQ==
X-Gm-Message-State: ACgBeo0A3m8EYWGe6wjx6TltH5CaT8yopARU/N14td8Sd45tL26ykx+h
        Eu2cwEb5fic39Dw4v7y4p0I95+rq1EE/UA==
X-Google-Smtp-Source: AA6agR7YOQeLXNTL++BuFXOabTlob5t6RJjS9/FhAIzrHdvvKSc59xfs/VzxkzZGrG3ulbEleqx0FQ==
X-Received: by 2002:a17:903:286:b0:172:6dd1:bb7a with SMTP id j6-20020a170903028600b001726dd1bb7amr12704287plr.41.1660697788916;
        Tue, 16 Aug 2022 17:56:28 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:eb64:ce74:44c1:343c])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090a5e4e00b001f8aee0d826sm153458pji.53.2022.08.16.17.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 17:56:28 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH CANDIDATE 5.15 2/9] xfs: reserve quota for dir expansion when linking/unlinking files
Date:   Tue, 16 Aug 2022 17:56:03 -0700
Message-Id: <20220817005610.3170067-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
In-Reply-To: <20220817005610.3170067-1-leah.rumancik@gmail.com>
References: <20220817005610.3170067-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 871b9316e7a778ff97bdc34fdb2f2977f616651d ]

XFS does not reserve quota for directory expansion when linking or
unlinking children from a directory.  This means that we don't reject
the expansion with EDQUOT when we're at or near a hard limit, which
means that unprivileged userspace can use link()/unlink() to exceed
quota.

The fix for this is nuanced -- link operations don't always expand the
directory, and we allow a link to proceed with no space reservation if
we don't need to add a block to the directory to handle the addition.
Unlink operations generally do not expand the directory (you'd have to
free a block and then cause a btree split) and we can defer the
directory block freeing if there is no space reservation.

Moreover, there is a further bug in that we do not trigger the blockgc
workers to try to clear space when we're out of quota.

To fix both cases, create a new xfs_trans_alloc_dir function that
allocates the transaction, locks and joins the inodes, and reserves
quota for the directory.  If there isn't sufficient space or quota,
we'll switch the caller to reservationless mode.  This should prevent
quota usage overruns with the least restriction in functionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_inode.c | 46 +++++++++----------------
 fs/xfs/xfs_trans.c | 86 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h |  3 ++
 3 files changed, 106 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c19f3ca605af..f4dec7f6c6d0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1223,7 +1223,7 @@ xfs_link(
 {
 	xfs_mount_t		*mp = tdp->i_mount;
 	xfs_trans_t		*tp;
-	int			error;
+	int			error, nospace_error = 0;
 	int			resblks;
 
 	trace_xfs_link(tdp, target_name);
@@ -1242,19 +1242,11 @@ xfs_link(
 		goto std_return;
 
 	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, resblks, 0, 0, &tp);
-	if (error == -ENOSPC) {
-		resblks = 0;
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, 0, 0, 0, &tp);
-	}
+	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
+			&tp, &nospace_error);
 	if (error)
 		goto std_return;
 
-	xfs_lock_two_inodes(sip, XFS_ILOCK_EXCL, tdp, XFS_ILOCK_EXCL);
-
-	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
-
 	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
 			XFS_IEXT_DIR_MANIP_CNT(mp));
 	if (error)
@@ -1312,6 +1304,8 @@ xfs_link(
  error_return:
 	xfs_trans_cancel(tp);
  std_return:
+	if (error == -ENOSPC && nospace_error)
+		error = nospace_error;
 	return error;
 }
 
@@ -2761,6 +2755,7 @@ xfs_remove(
 	xfs_mount_t		*mp = dp->i_mount;
 	xfs_trans_t             *tp = NULL;
 	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
+	int			dontcare;
 	int                     error = 0;
 	uint			resblks;
 
@@ -2778,31 +2773,24 @@ xfs_remove(
 		goto std_return;
 
 	/*
-	 * We try to get the real space reservation first,
-	 * allowing for directory btree deletion(s) implying
-	 * possible bmap insert(s).  If we can't get the space
-	 * reservation then we use 0 instead, and avoid the bmap
-	 * btree insert(s) in the directory code by, if the bmap
-	 * insert tries to happen, instead trimming the LAST
-	 * block from the directory.
+	 * We try to get the real space reservation first, allowing for
+	 * directory btree deletion(s) implying possible bmap insert(s).  If we
+	 * can't get the space reservation then we use 0 instead, and avoid the
+	 * bmap btree insert(s) in the directory code by, if the bmap insert
+	 * tries to happen, instead trimming the LAST block from the directory.
+	 *
+	 * Ignore EDQUOT and ENOSPC being returned via nospace_error because
+	 * the directory code can handle a reservationless update and we don't
+	 * want to prevent a user from trying to free space by deleting things.
 	 */
 	resblks = XFS_REMOVE_SPACE_RES(mp);
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, resblks, 0, 0, &tp);
-	if (error == -ENOSPC) {
-		resblks = 0;
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, 0, 0, 0,
-				&tp);
-	}
+	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip, &resblks,
+			&tp, &dontcare);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto std_return;
 	}
 
-	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
-
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-
 	/*
 	 * If we're removing a directory perform some additional validation.
 	 */
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 67dec11e34c7..95c183072e7a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1201,3 +1201,89 @@ xfs_trans_alloc_ichange(
 	xfs_trans_cancel(tp);
 	return error;
 }
+
+/*
+ * Allocate an transaction, lock and join the directory and child inodes to it,
+ * and reserve quota for a directory update.  If there isn't sufficient space,
+ * @dblocks will be set to zero for a reservationless directory update and
+ * @nospace_error will be set to a negative errno describing the space
+ * constraint we hit.
+ *
+ * The caller must ensure that the on-disk dquots attached to this inode have
+ * already been allocated and initialized.  The ILOCKs will be dropped when the
+ * transaction is committed or cancelled.
+ */
+int
+xfs_trans_alloc_dir(
+	struct xfs_inode	*dp,
+	struct xfs_trans_res	*resv,
+	struct xfs_inode	*ip,
+	unsigned int		*dblocks,
+	struct xfs_trans	**tpp,
+	int			*nospace_error)
+{
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp = ip->i_mount;
+	unsigned int		resblks;
+	bool			retried = false;
+	int			error;
+
+retry:
+	*nospace_error = 0;
+	resblks = *dblocks;
+	error = xfs_trans_alloc(mp, resv, resblks, 0, 0, &tp);
+	if (error == -ENOSPC) {
+		*nospace_error = error;
+		resblks = 0;
+		error = xfs_trans_alloc(mp, resv, resblks, 0, 0, &tp);
+	}
+	if (error)
+		return error;
+
+	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
+
+	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	error = xfs_qm_dqattach_locked(dp, false);
+	if (error) {
+		/* Caller should have allocated the dquots! */
+		ASSERT(error != -ENOENT);
+		goto out_cancel;
+	}
+
+	error = xfs_qm_dqattach_locked(ip, false);
+	if (error) {
+		/* Caller should have allocated the dquots! */
+		ASSERT(error != -ENOENT);
+		goto out_cancel;
+	}
+
+	if (resblks == 0)
+		goto done;
+
+	error = xfs_trans_reserve_quota_nblks(tp, dp, resblks, 0, false);
+	if (error == -EDQUOT || error == -ENOSPC) {
+		if (!retried) {
+			xfs_trans_cancel(tp);
+			xfs_blockgc_free_quota(dp, 0);
+			retried = true;
+			goto retry;
+		}
+
+		*nospace_error = error;
+		resblks = 0;
+		error = 0;
+	}
+	if (error)
+		goto out_cancel;
+
+done:
+	*tpp = tp;
+	*dblocks = resblks;
+	return 0;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+	return error;
+}
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 50da47f23a07..faba74d4c702 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -265,6 +265,9 @@ int xfs_trans_alloc_icreate(struct xfs_mount *mp, struct xfs_trans_res *resv,
 int xfs_trans_alloc_ichange(struct xfs_inode *ip, struct xfs_dquot *udqp,
 		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp, bool force,
 		struct xfs_trans **tpp);
+int xfs_trans_alloc_dir(struct xfs_inode *dp, struct xfs_trans_res *resv,
+		struct xfs_inode *ip, unsigned int *dblocks,
+		struct xfs_trans **tpp, int *nospace_error);
 
 static inline void
 xfs_trans_set_context(
-- 
2.37.1.595.g718a3a8f04-goog

