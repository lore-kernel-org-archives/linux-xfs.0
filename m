Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABFD5EB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jun 2023 01:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbjFOBmt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jun 2023 21:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237527AbjFOBms (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jun 2023 21:42:48 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A6E1AA
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 18:42:14 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-54f71fa7e41so2715238a12.3
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 18:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686793333; x=1689385333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ryFwOkx+XRLIZLmy0I+0F/aCxz4ugt0ZHp9G+vOyWVo=;
        b=pqaWP+jcoKfabOZDC2KFePgAffa/5lNuF0VXfrG7MFuPBT/aYVB3NlGKsWi/0ZBFK8
         q42A3dFghJJ5RSKctAAadCC0wihO3e4M24kJxn2nJVcO+UYFyormHnRKdJrby880ZidF
         ecSXaoa51rpFA3tC2w9ca1SissKyDI4wxciPTKkQyu8fA/kiW3LRhwH08hoTRSz1jH0W
         sWnM2YY+wz8sUE1nYIMWNXvNo6RxAwB780fclT7A9P3cFOyuSUgB6wSYGrgUR5S54AqZ
         JwCHL/Sizb+LWovBhlbYTDT6oYVD0pch6cMkTLluMCVX6IA227KrYqemBDZD4nCqcRiM
         HeNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686793333; x=1689385333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ryFwOkx+XRLIZLmy0I+0F/aCxz4ugt0ZHp9G+vOyWVo=;
        b=B6qmx8GQMb89o2r5nIjrTWx5l0RmY9qdPxM2aKz+xR2szrCQ7Iu9mVHRV3oH+S9y/3
         3PY/f8lwYAnFujRTFoAwoqMMB7x2PvzhhL7o57jjEwTEYi4bQ3/rTzAZwBMvB/V9pgOW
         tmUmYR/T/NIzZ13pM9NO3pElpHAlM0GYrFy6XGLI9JMbf3Q1E7oDa1CXbu7XJfzMSeC1
         HtwTbfkHrWl2/v3cP9d167JYZGVjNILXS95JydF43JjM8GQa8o6yD0y9bZZLxnPBPES7
         cl2ZQldllERw3DeMtJrwEsKjnQ8OemC5B/o6UtYIe1UbEvQeJYjPacFqmO2gsblyf/p1
         NHuQ==
X-Gm-Message-State: AC+VfDwuzBSmRXbMP0KhV/rna+D9o5QSYBUjWnKMfPa3VWYCcVqJDynb
        Qn7L+SEP1m9+7WFrNtByuHTMo4sDXUlJIzgE+AA=
X-Google-Smtp-Source: ACHHUZ5gmCjLw4GG9sEvVUcxE6jHEqn2kiuBqrU0FPKcTKH7X4+kXK/pXGEoy8YMps45M23buxvYKg==
X-Received: by 2002:a05:6a20:748d:b0:10d:3ff2:452b with SMTP id p13-20020a056a20748d00b0010d3ff2452bmr3454096pzd.18.1686793333542;
        Wed, 14 Jun 2023 18:42:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id p5-20020a170902bd0500b00186a2274382sm12823677pls.76.2023.06.14.18.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 18:42:12 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1q9c01-00BtRi-33;
        Thu, 15 Jun 2023 11:42:09 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1q9c01-00Dklz-1x;
        Thu, 15 Jun 2023 11:42:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     chandanrlinux@gmail.com, wen.gang.wang@oracle.com
Subject: [PATCH 2/3] xfs: allow extent free intents to be retried
Date:   Thu, 15 Jun 2023 11:42:00 +1000
Message-Id: <20230615014201.3171380-3-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230615014201.3171380-1-david@fromorbit.com>
References: <20230615014201.3171380-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Extent freeing neeeds to be able to avoid a busy extent deadlock
when the transaction itself holds the only busy extents in the
allocation group. This may occur if we have an EFI that contains
multiple extents to be freed, and the freeing the second intent
requires the space the first extent free released to expand the
AGFL. If we block on the busy extent at this point, we deadlock.

We hold a dirty transaction that contains a entire atomic extent
free operations within it, so if we can abort the extent free
operation and commit the progress that we've made, the busy extent
can be resolved by a log force. Hence we can restart the aborted
extent free with a new transaction and continue to make
progress without risking deadlocks.

To enable this, we need the EFI processing code to be able to handle
an -EAGAIN error to tell it to commit the current transaction and
retry again. This mechanism is already built into the defer ops
processing (used bythe refcount btree modification intents), so
there's relatively little handling we need to add to the EFI code to
enable this.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_extfree_item.c | 64 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 61 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index f9e36b810663..3b33d27efdce 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -336,6 +336,29 @@ xfs_trans_get_efd(
 	return efdp;
 }
 
+/*
+ * Fill the EFD with all extents from the EFI when we need to roll the
+ * transaction and continue with a new EFI.
+ */
+static void
+xfs_efd_from_efi(
+	struct xfs_efd_log_item	*efdp)
+{
+	struct xfs_efi_log_item *efip = efdp->efd_efip;
+	uint                    i;
+
+	ASSERT(efip->efi_format.efi_nextents > 0);
+
+	if (efdp->efd_next_extent == efip->efi_format.efi_nextents)
+		return;
+
+	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
+	       efdp->efd_format.efd_extents[i] =
+		       efip->efi_format.efi_extents[i];
+	}
+	efdp->efd_next_extent = efip->efi_format.efi_nextents;
+}
+
 /*
  * Free an extent and log it to the EFD. Note that the transaction is marked
  * dirty regardless of whether the extent free succeeds or fails to support the
@@ -378,6 +401,17 @@ xfs_trans_free_extent(
 	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
 	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
 
+	/*
+	 * If we need a new transaction to make progress, the caller will log a
+	 * new EFI with the current contents. It will also log an EFD to cancel
+	 * the existing EFI, and so we need to copy all the unprocessed extents
+	 * in this EFI to the EFD so this works correctly.
+	 */
+	if (error == -EAGAIN) {
+		xfs_efd_from_efi(efdp);
+		return error;
+	}
+
 	next_extent = efdp->efd_next_extent;
 	ASSERT(next_extent < efdp->efd_format.efd_nextents);
 	extp = &(efdp->efd_format.efd_extents[next_extent]);
@@ -495,6 +529,13 @@ xfs_extent_free_finish_item(
 
 	error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
 
+	/*
+	 * Don't free the XEFI if we need a new transaction to complete
+	 * processing of it.
+	 */
+	if (error == -EAGAIN)
+		return error;
+
 	xfs_extent_free_put_group(xefi);
 	kmem_cache_free(xfs_extfree_item_cache, xefi);
 	return error;
@@ -620,6 +661,7 @@ xfs_efi_item_recover(
 	struct xfs_trans		*tp;
 	int				i;
 	int				error = 0;
+	bool				requeue_only = false;
 
 	/*
 	 * First check the validity of the extents described by the
@@ -652,9 +694,25 @@ xfs_efi_item_recover(
 		fake.xefi_startblock = extp->ext_start;
 		fake.xefi_blockcount = extp->ext_len;
 
-		xfs_extent_free_get_group(mp, &fake);
-		error = xfs_trans_free_extent(tp, efdp, &fake);
-		xfs_extent_free_put_group(&fake);
+		if (!requeue_only) {
+			xfs_extent_free_get_group(mp, &fake);
+			error = xfs_trans_free_extent(tp, efdp, &fake);
+			xfs_extent_free_put_group(&fake);
+		}
+
+		/*
+		 * If we can't free the extent without potentially deadlocking,
+		 * requeue the rest of the extents to a new so that they get
+		 * run again later with a new transaction context.
+		 */
+		if (error == -EAGAIN || requeue_only) {
+			xfs_free_extent_later(tp, fake.xefi_startblock,
+				fake.xefi_blockcount, &XFS_RMAP_OINFO_ANY_OWNER);
+			requeue_only = true;
+			error = 0;
+			continue;
+		};
+
 		if (error == -EFSCORRUPTED)
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					extp, sizeof(*extp));
-- 
2.40.1

