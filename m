Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 724A0EB64DC
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 00:20:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjFTAUa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jun 2023 20:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjFTAU3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jun 2023 20:20:29 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB76E60
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 17:20:27 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 46e09a7af769-6b470ebd670so1432509a34.0
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 17:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687220427; x=1689812427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9uLmVHOOqlEGVnpu4pCCDXlxJ24nmdDN/r/cZHq3dGE=;
        b=lm6k1E3znpxkir8K6LpNw4X6eckqK7yoLdY+0nllQWzgB2uqX0Un32dka03j8+JlCk
         LLKuDSdZYJYLHfSGv768zLUCd3guXX//oJRk6XX+Oplv7j0W0wmYrj8VfH+p+eYdfNoF
         e1LIbSqQNIXSLA8XJWvV6X8fnLXljRxKuZpH6QTPupzMHAS8Xl2hTGTkPXQ7/4YU4lB8
         XRPDLVaUI58btaONE1+goVrjg7sDudlrkbcmzLQj80dUMJn6tT6ZvJRi9hkd9xcc1Mft
         7PcqagW9obAYLNLDsV18ummcZrMUSixGNZlWEer5ttITjTEI+bM+vA297ddmF3H9TTVO
         kemg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687220427; x=1689812427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9uLmVHOOqlEGVnpu4pCCDXlxJ24nmdDN/r/cZHq3dGE=;
        b=Cru/SE+24nWvpYtY/Lup8O+sCKdd8LRGlprKIPx18K34V2oy5hF+ptzaUYnDlbahex
         TM27AgU028aSB2+3PuzF4yCRAxUh0ikNA+ZuwAvmrvuyqgIcmDCLpIoab1HVeSXT1X9W
         cGJvSFgzwhVZI9wjmNqFREieEvPq7qKuikh5SalzxO9sDi0UxEZpFHY9h5S2SndMhLR0
         UgmHu+YhSMZjOG4KHNYVjuWvxw6x1ZB1xogpABlkI13JM1ZcJ6E22tFZdQhb6Th98MF3
         LUMmDrpTKdvoY/Uci3PwJfmBzykd3Plg9QuP9OoFW5ghBQ+tzNGapRakp1KU7YM/1iYA
         KqQA==
X-Gm-Message-State: AC+VfDy6fdKrapKJq14Dzx7YIhZ8VSuApz7FmLTPlXuaE8RCUfK8Jbgz
        PtQ6rP1SfT+ch3schQoyiB3n/qWlO45ZP3magpk=
X-Google-Smtp-Source: ACHHUZ7AAcy+sf6o+aJEwyBkfbDlIC1/1oxFsv0mb5UYyY87j7IzpbjIvh3kCYRYSDdTGo5bqnSNSQ==
X-Received: by 2002:a05:6808:188d:b0:39e:5886:3dde with SMTP id bi13-20020a056808188d00b0039e58863ddemr13311074oib.12.1687220426820;
        Mon, 19 Jun 2023 17:20:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id nd8-20020a17090b4cc800b0025ed38d7dddsm304106pjb.54.2023.06.19.17.20.25
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 17:20:25 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qBP6d-00DqgG-1U
        for linux-xfs@vger.kernel.org;
        Tue, 20 Jun 2023 10:20:23 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qBP6d-004dm8-0P
        for linux-xfs@vger.kernel.org;
        Tue, 20 Jun 2023 10:20:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] xfs: allow extent free intents to be retried
Date:   Tue, 20 Jun 2023 10:20:19 +1000
Message-Id: <20230620002021.1038067-4-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230620002021.1038067-1-david@fromorbit.com>
References: <20230620002021.1038067-1-david@fromorbit.com>
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
 fs/xfs/xfs_extfree_item.c | 72 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index f9e36b810663..840df1f66a1a 100644
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
@@ -652,9 +699,28 @@ xfs_efi_item_recover(
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
+					&XFS_RMAP_OINFO_ANY_OWNER);
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

