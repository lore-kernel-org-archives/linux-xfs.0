Return-Path: <SRS0=kyg5=BY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCE1C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E35120771
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:09:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n0PwIP06"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgHNIJr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Aug 2020 04:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgHNIJr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Aug 2020 04:09:47 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AB4C061383
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:09:46 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id i92so5348882pje.0
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=axLzhupzIrWw+rrgJQfKNHh/9nAL8yvvXXMYamkBd/M=;
        b=n0PwIP06lmxRl4agzJZMLtCHDwVmMo6VYSXdqm77bHXVhonPKxyv0fasX6ExmTRzE+
         EvqpMNHZLTOw27inf7ThIiKtszBj6MdbKajJXYKkTO8cNul0uT9gxmYOtc7YKt1lgqiN
         sMv4MACwa3Nmms47/KiyiNDpWbH6cHykvc58aRU2+S16IqwTVZ8XyQdqzla4PFMxmScC
         uHRxsg8XJ7kPBTOiGdsJm5oFPpB5vp2XV0HORK6S9fDus+Qbc/EIppkSYq1x6zAWNW+N
         X5vuc2ghtd9eDafd4eDPKrOPejPotpxM9Bz8NxAKTzvhRPtnGM3QISld4UhUp5SVk7oE
         d2uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=axLzhupzIrWw+rrgJQfKNHh/9nAL8yvvXXMYamkBd/M=;
        b=odGV61byQS2UI79xK7T+gVd/mDJEP+qVUM3or3aXt5kkdH/rHgS/0xgBZXHnwuIx7n
         dfUceQ8Z/LRjbxvBemzrsIZ/+Naqflp12PH+QMNIRmq9H1VHWDVNLaLBi9czf7M9rdqV
         6bgcT5mZDjO0ksNTRj/BZcalk5LSGmc4HAwSxuhdl/CCwzpBb7EDMw4gWqfv1fyogGbJ
         lrf9YYe4qz1HmsmciEKrKlQ80SdVh5bp6u8jLoThW0PvvbQiDTABil8p6kWFb5bnqOzv
         oxxoVEGgdxGOiyp0EjH5b7y46Xifm18rwMAySVBlpH0cVCmA1d0GkmLJcD5eDRa/8nQq
         tYiA==
X-Gm-Message-State: AOAM531NNGPuye//7X1PJAWcZfviXCELTINn5FFspGENN5gkPc0UeEeV
        d88J0rawlxxJSa+YatGysJ7M50OXqT8=
X-Google-Smtp-Source: ABdhPJwHDeXs5gHpZEHjTsroZ3nSqwaWLm/x4488YJ0xmjbSnl+bBwXCER3oeBMcCZVFTPv26eX+Cw==
X-Received: by 2002:a17:90b:816:: with SMTP id bk22mr1360140pjb.185.1597392586299;
        Fri, 14 Aug 2020 01:09:46 -0700 (PDT)
Received: from localhost.localdomain ([122.179.47.119])
        by smtp.gmail.com with ESMTPSA id z17sm8594289pfq.38.2020.08.14.01.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 01:09:45 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V2 03/10] xfs: Check for extent overflow when deleting an extent
Date:   Fri, 14 Aug 2020 13:38:26 +0530
Message-Id: <20200814080833.84760-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200814080833.84760-1-chandanrlinux@gmail.com>
References: <20200814080833.84760-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Deleting a file range from the middle of an existing extent can cause
the per-inode extent count to increase by 1. This commit checks for
extent count overflow in such cases.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 6 ++++++
 fs/xfs/xfs_bmap_item.c         | 4 ++++
 fs/xfs/xfs_bmap_util.c         | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 3e7e4b980d49..228359cf9738 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -35,6 +35,12 @@ struct xfs_ifork {
 #define	XFS_IFBROOT	0x04	/* i_broot points to the bmap b-tree root */
 
 #define XFS_IEXT_ADD_CNT 1
+/*
+ * Removing an extent from the middle of an existing extent
+ * can cause the extent count to increase by 1.
+ * i.e. | Old extent | Hole | Old extent |
+ */
+#define XFS_IEXT_REMOVE_CNT 1
 
 /*
  * Fork handling.
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ec3691372e7c..b9c35fb10de4 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -519,6 +519,10 @@ xfs_bui_item_recover(
 	}
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, whichfork, XFS_IEXT_REMOVE_CNT);
+	if (error)
+		goto err_inode;
+
 	count = bmap->me_len;
 	error = xfs_trans_log_finish_bmap_update(tp, budp, type, ip, whichfork,
 			bmap->me_startoff, bmap->me_startblock, &count, state);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index c470f2cd6e66..94abdb547c7f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -891,6 +891,11 @@ xfs_unmap_extent(
 
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_REMOVE_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, done);
 	if (error)
 		goto out_trans_cancel;
-- 
2.28.0

