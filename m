Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC477C71155
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 16:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E2CA206F7
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 16:26:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="YUoZKq8L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731658AbgKYQZw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 11:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731516AbgKYQZr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 11:25:47 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBC7C0613D4
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 08:25:45 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id h21so2701596wmb.2
        for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2020 08:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lnj1vSewnYJ6/gw6qejvRzkdxRWgCvvqGMHaDGl+NSM=;
        b=YUoZKq8L06+FDLM6Fl810zMa4QNm9z7yylijbYlze6fR8otQLzenAvEmy/fayirA5N
         O41roW+Y0PCq5CiO8xCdkb7te5p4XNiNP2KMYNITnW7GvP766R3pheeUSYaMWtw/NCoq
         hiMpjQptcAu3Wxmv8w5zOIWpXb2cG4iSD2BBk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lnj1vSewnYJ6/gw6qejvRzkdxRWgCvvqGMHaDGl+NSM=;
        b=onSNpJEjgbTsmcLGCzo6kkVZUOSF+vGB2YFzH2JTxUOWTT6kPlkTmxfzAnjnB41qhv
         iIo0HP3j0bT1njynsHdzLpfsWoRQCI7MPpXKl/ukRy6lSyaSeukh2aUGr0bKLpyQegxh
         71MuXzHQrXPXsk+nkTN5aw0u20tiZ14rjYBtuygUtSEke0iDyK0a6VicXKfM6ePH2PXn
         NxpMmd380X18ATGVmrY1mIKMkE2Sj4vXg5gSMF7LEeXA05WMEu4K9nHBiEXAlJ3UVZjf
         UoxjtRKuLAkNDzLkogaxRWorkHylIa3TH38LKkf+49GtZKW6PPNQj90bdg6WkhjNrvsn
         zt2Q==
X-Gm-Message-State: AOAM530y/V3O+fRy7/n3hVauOL/MXtZ+oDB8bnXftU2D1zkmXvFMWqT/
        Cp83KKl70TNAkvgLD19wKE+p7Q==
X-Google-Smtp-Source: ABdhPJzimL6dZ1eWi01TNV2dJDgqjd5jFZPTvE6ZnqLenNCICrynr5xXWljktH5hZBPm90Z1zf9kBQ==
X-Received: by 2002:a7b:cf26:: with SMTP id m6mr4920447wmg.121.1606321544420;
        Wed, 25 Nov 2020 08:25:44 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id a21sm4855187wmb.38.2020.11.25.08.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 08:25:43 -0800 (PST)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Brian Paul <brianp@vmware.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH] drm/ttm: don't set page->mapping
Date:   Wed, 25 Nov 2020 17:25:32 +0100
Message-Id: <20201125162532.1299794-5-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201125162532.1299794-1-daniel.vetter@ffwll.ch>
References: <20201125162532.1299794-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Random observation while trying to review Christian's patch series to
stop looking at struct page for dma-buf imports.

This was originally added in

commit 58aa6622d32af7d2c08d45085f44c54554a16ed7
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Fri Jan 3 11:47:23 2014 +0100

    drm/ttm: Correctly set page mapping and -index members

    Needed for some vm operations; most notably unmap_mapping_range() with
    even_cows = 0.

    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Reviewed-by: Brian Paul <brianp@vmware.com>

but we do not have a single caller of unmap_mapping_range with
even_cows == 0. And all the gem drivers don't do this, so another
small thing we could standardize between drm and ttm drivers.

Plus I don't really see a need for unamp_mapping_range where we don't
want to indiscriminately shoot down all ptes.

Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Brian Paul <brianp@vmware.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
---
 drivers/gpu/drm/ttm/ttm_tt.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index da9eeffe0c6d..5b2eb6d58bb7 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -284,17 +284,6 @@ int ttm_tt_swapout(struct ttm_bo_device *bdev, struct ttm_tt *ttm)
 	return ret;
 }
 
-static void ttm_tt_add_mapping(struct ttm_bo_device *bdev, struct ttm_tt *ttm)
-{
-	pgoff_t i;
-
-	if (ttm->page_flags & TTM_PAGE_FLAG_SG)
-		return;
-
-	for (i = 0; i < ttm->num_pages; ++i)
-		ttm->pages[i]->mapping = bdev->dev_mapping;
-}
-
 int ttm_tt_populate(struct ttm_bo_device *bdev,
 		    struct ttm_tt *ttm, struct ttm_operation_ctx *ctx)
 {
@@ -313,7 +302,6 @@ int ttm_tt_populate(struct ttm_bo_device *bdev,
 	if (ret)
 		return ret;
 
-	ttm_tt_add_mapping(bdev, ttm);
 	ttm->page_flags |= TTM_PAGE_FLAG_PRIV_POPULATED;
 	if (unlikely(ttm->page_flags & TTM_PAGE_FLAG_SWAPPED)) {
 		ret = ttm_tt_swapin(ttm);
-- 
2.29.2

