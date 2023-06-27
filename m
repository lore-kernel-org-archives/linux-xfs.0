Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACED0C001B3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jun 2023 22:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjF0Wo0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jun 2023 18:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjF0WoY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2023 18:44:24 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC633211E
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 15:44:19 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6687096c6ddso2791866b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 15:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687905859; x=1690497859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nkNsZl7vYsW79WSqtxpYRKvhd3dwbJ/b3snusgn1D54=;
        b=Xx8R0bsI8bvoYq/tKAujz1eJiT58NNO1T6yylfJj2R7a9nWdc1dooEN77u468T+DmS
         1tSYDR3hOsHSuR0i+RIAvUY3gTwMP3J/Ha53TqeSpv6r05zTScVQNKzuR7x8+NKXTrNK
         rt+2ZwzZh0WdGLqUCamj+v4Lhp7uimB+jNUXqTh8Et3aOUHgteoI7VkGuLadmcggkPJJ
         FpcVcKw4TiaIwGRjkGy5SvgDmDgt5qOAS6Cr985w6MChJbiFBhJCsepC4Omn7yY0jOaI
         ylC9DCFQoDNxoJcpp02SeLUIr0UwY2mGd+9y2pmbCy4hls8PDSNW6ubve0DIH5ZnLblU
         yKLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687905859; x=1690497859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nkNsZl7vYsW79WSqtxpYRKvhd3dwbJ/b3snusgn1D54=;
        b=IhiOKKmn6QhgcJrGfurO9+oOJ9nvoUwAQxXJRf1QYxzuRxxSyEu360YgzUaI0cm7nU
         0atEiGIK37Zy3f7waffHE8NfbIWimJA21x5xagoD61T0vvyVM5tyrZqgvTZXMayqSr6J
         t1WRwmASulMsCQv5xPU7KgcDZnPN0GK7xzHR3A257lypkNSmYa+nmi94IocnAjH+bnHV
         AAij1mAFiYKoBxtRJ2vy7AG9FPgzQheFiq2NwaJoUr8rFBM6m1A1ZGxdlvcS8AqMqzzi
         IcgJJ+yN/v1i6sb+LB65ReEjaUEcYZnsVxABAzcvfVGmkVI24+wBeYAiU2ozJYON7fYF
         N8kQ==
X-Gm-Message-State: AC+VfDwO4asSYBCFByfbzTlwBIClFsWmWWF4+gC/fZ4TY6quuxm+CeS7
        kIsIQ7IJsMYy3E9j0f/z+Y/i0k+33wx8NfGsY2I=
X-Google-Smtp-Source: ACHHUZ5JIsisapbs8/L+mOS3fJ+LSNbgWMZmAnFkv6n76rHWvajXVsnqaHikNEOWjH6oSyxvsRxQow==
X-Received: by 2002:a05:6a20:7349:b0:10e:e218:d3f0 with SMTP id v9-20020a056a20734900b0010ee218d3f0mr25799779pzc.54.1687905859304;
        Tue, 27 Jun 2023 15:44:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id x21-20020aa793b5000000b00673e652985esm4448967pff.44.2023.06.27.15.44.17
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 15:44:17 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qEHPz-00Gzwb-1R
        for linux-xfs@vger.kernel.org;
        Wed, 28 Jun 2023 08:44:15 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qEHPz-009ZmL-0L
        for linux-xfs@vger.kernel.org;
        Wed, 28 Jun 2023 08:44:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/8] xfs: allow extent free intents to be retried
Date:   Wed, 28 Jun 2023 08:44:08 +1000
Message-Id: <20230627224412.2242198-5-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230627224412.2242198-1-david@fromorbit.com>
References: <20230627224412.2242198-1-david@fromorbit.com>
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
 fs/xfs/xfs_extfree_item.c | 73 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 70 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 79e65bb6b0a2..098420cbd4a0 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -336,6 +336,34 @@ xfs_trans_get_efd(
 	return efdp;
 }
 
+/*
+ * Fill the EFD with all extents from the EFI when we need to roll the
+ * transaction and continue with a new EFI.
+ *
+ * This simply copies all the extents in the EFI to the EFD rather than make
+ * assumptions about which extents in the EFI have already been processed. We
+ * currently keep the xefi list in the same order as the EFI extent list, but
+ * that may not always be the case. Copying everything avoids leaving a landmine
+ * were we fail to cancel all the extents in an EFI if the xefi list is
+ * processed in a different order to the extents in the EFI.
+ */
+static void
+xfs_efd_from_efi(
+	struct xfs_efd_log_item	*efdp)
+{
+	struct xfs_efi_log_item *efip = efdp->efd_efip;
+	uint                    i;
+
+	ASSERT(efip->efi_format.efi_nextents > 0);
+	ASSERT(efdp->efd_next_extent < efip->efi_format.efi_nextents);
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
@@ -378,6 +406,17 @@ xfs_trans_free_extent(
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
@@ -495,6 +534,13 @@ xfs_extent_free_finish_item(
 
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
@@ -620,6 +666,7 @@ xfs_efi_item_recover(
 	struct xfs_trans		*tp;
 	int				i;
 	int				error = 0;
+	bool				requeue_only = false;
 
 	/*
 	 * First check the validity of the extents described by the
@@ -653,9 +700,29 @@ xfs_efi_item_recover(
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
+			error = xfs_free_extent_later(tp, fake.xefi_startblock,
+					fake.xefi_blockcount,
+					&XFS_RMAP_OINFO_ANY_OWNER,
+					fake.xefi_type);
+			if (!error) {
+				requeue_only = true;
+				error = 0;
+				continue;
+			}
+		};
+
 		if (error == -EFSCORRUPTED)
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					extp, sizeof(*extp));
-- 
2.40.1

