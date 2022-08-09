Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4355CC25B0F
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 11:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239907AbiHILR0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 07:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238802AbiHILRZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 07:17:25 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3B3193ED;
        Tue,  9 Aug 2022 04:17:24 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id h13so13950539wrf.6;
        Tue, 09 Aug 2022 04:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=RA4DYuk+FJa2a998BAcW5CxBP4iB3ilKC4//hpI6vps=;
        b=KWwHqC4FHlOG4vetnLtjWZx9sSgDOn8/iOkI2f59Qggvkx7E1m1BpiRstL+aJu4RHp
         iaWYm+hUtGzEXTXSiID8SNS9c6UDLT/JDNL2ljyvAGfVwPlmgo64ZMPBma7/BDYMbt+E
         LYOF2KA54rxGZVbFVUlfkij2vg+VUY09usLaqaUIWBgwLE/+xBuKU2OcvVa7W24/fltm
         QoTG9LG0b1msofy1BTf9zCVY616fY53licMKAIWwsf+iFp4dJLdjpZkt6796ZwconbHc
         wnOqFgIJ0cEbGizKwkQ2WaAsrtMzU0WNLMFMwl75VwbR9CZM4BvCMLd/vS2mNFTN5a17
         L2jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=RA4DYuk+FJa2a998BAcW5CxBP4iB3ilKC4//hpI6vps=;
        b=aShdgH9rRTn3TUHTyO5NYi9wYOTc+P79dMzq6t7vbexQ4X65K6nbDUbFTum9ko/Vgb
         kzs6Nlw9ikc9UIF5fzXYp3jQFwDBDwKCMf1W0+pDl/dwTqfOiJZLDqKmNictY/T8eVtS
         kUEO2ndY6CuOQcVOwRN4JjxWrW6KddSvjyk55XGesMZXUE8+y4wdRqIgkJCR33vQ2xht
         dH5bOLEh2dl1CcPOctnRaSBmgrMF0sQG0UEn7RDNIWy5ex3b2JJTyaBdcUMS4fkONFwe
         HqefMZ10YqAA16PjO9BK3x/4fjgO3y7Uqi27mAy7qcRH2Znd/ax2wnMq0Wc2sW7lKLlQ
         OytA==
X-Gm-Message-State: ACgBeo3NWzPkI2VmHbu3RGsZu3Yph8Vf6MDhCbsvPH0S6qt+xDtCq9zS
        2Ol7J1mgjH/AvrZonadeFLgzoKpnuGw=
X-Google-Smtp-Source: AA6agR44sWewvmDKjtFTdVh6/1iGBV8MLsmIknnGyb8dg4+jVSjjKjovp0kXK1N6/VrDueMKp0s6nQ==
X-Received: by 2002:adf:e3cf:0:b0:220:cc91:94ed with SMTP id k15-20020adfe3cf000000b00220cc9194edmr14778758wrm.36.1660043842798;
        Tue, 09 Aug 2022 04:17:22 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id l2-20020a1ced02000000b003a3170a7af9sm15906169wmh.4.2022.08.09.04.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 04:17:22 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 4/4] xfs: fix I_DONTCACHE
Date:   Tue,  9 Aug 2022 13:17:08 +0200
Message-Id: <20220809111708.92768-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809111708.92768-1-amir73il@gmail.com>
References: <20220809111708.92768-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit f38a032b165d812b0ba8378a5cd237c0888ff65f upstream.

Yup, the VFS hoist broke it, and nobody noticed. Bulkstat workloads
make it clear that it doesn't work as it should.

Fixes: dae2f8ed7992 ("fs: Lift XFS_IDONTCACHE to the VFS layer")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_icache.c | 3 ++-
 fs/xfs/xfs_iops.c   | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index deb99300d171..e69a08ed7de4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -47,8 +47,9 @@ xfs_inode_alloc(
 		return NULL;
 	}
 
-	/* VFS doesn't initialise i_mode! */
+	/* VFS doesn't initialise i_mode or i_state! */
 	VFS_I(ip)->i_mode = 0;
+	VFS_I(ip)->i_state = 0;
 
 	XFS_STATS_INC(mp, vn_active);
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b7f7b31a77d5..6a3026e78a9b 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1328,7 +1328,7 @@ xfs_setup_inode(
 	gfp_t			gfp_mask;
 
 	inode->i_ino = ip->i_ino;
-	inode->i_state = I_NEW;
+	inode->i_state |= I_NEW;
 
 	inode_sb_list_add(inode);
 	/* make the inode look hashed for the writeback code */
-- 
2.25.1

