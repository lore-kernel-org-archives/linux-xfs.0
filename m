Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB4E1C43464
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5914521D7F
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="plEDvAot"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgIRJs1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Sep 2020 05:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgIRJs0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Sep 2020 05:48:26 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18C2C06174A
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:26 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id bd2so2715739plb.7
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t3a59Iu6i+VIIAVhyyxTUePJP2RlQTqnMF+GOAK8VHE=;
        b=plEDvAotHoUuYMm1KVeFjHlJQhaNgoaS0EJ4gNmSIlK+yQvvtojkq11kSoEypxeUGU
         v16AcsvWmm0d8q9xj+UK0ZqtbjtjLA4IQWCjqvuoq6xFeJF6gOSwHF0hXugEdyE9bZ/O
         hcHoyBG03BLz19rb9TiTr317f5yBfJnSi8LSk/QkYpYvPlP9ZtCkF9fSlVxMbDOVEMwa
         4E9q6RzLCm92xyoqQPhRBk32w4eZD310La9wc4q0xUqHlqJgzZEHAHV06mYj7Bbi8xU+
         05X1KzGXBoQZCjnn5EeVlKaRPl5Q+ijNZ+35BGlElWBVgMiDWUguJKg9zDNG0O35IOXE
         pjXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t3a59Iu6i+VIIAVhyyxTUePJP2RlQTqnMF+GOAK8VHE=;
        b=Mo9OmwG6VGWaf8o+lTo/cwV744eJpp1toKYERYLp6kuEgKe2zoivyJO9UpGa9g5oGP
         Su9AZZIQe3WHZ1CyLw/vyhaool9FZLNAyHX/k8j+0cb/208Uizif6hfXegFzokde8AnC
         EkNV3Dve7zNbH5dLZJgZn0JYoh6S6ZWy21OwSR+oCC9ZPJuoJgmJZ+kF62Pg708NIEsd
         jUnW0466klDa8sk2g87f5A7dhdf7tmQAdI8oR5kAK/m3MvWU4Oml4eJBDZQAZj/4Y3H8
         p7fFHYHapN2wIDOlwxsd2k5rNObCMQoA3uOkXEWYFPktWa0+USzJ29ZSVLmAwRCDqriG
         ozxA==
X-Gm-Message-State: AOAM532SDPrbOIQOIL7L+6xXunW2hnPq4y9idgglOvqFATCdpLhwp8Wb
        TdpprkF/HRmc3IpTGC9hd02gVMp+V0g=
X-Google-Smtp-Source: ABdhPJw5zJnyiKmmHs+RihQjMn4H8Kw0Qid8OUuGT347Y5lsjVjWTxar/MjJSiFjFK7PLUHYWZyEGQ==
X-Received: by 2002:a17:902:c254:b029:d1:f2b3:a46b with SMTP id 20-20020a170902c254b02900d1f2b3a46bmr9825345plg.74.1600422506021;
        Fri, 18 Sep 2020 02:48:26 -0700 (PDT)
Received: from localhost.localdomain ([122.179.62.164])
        by smtp.gmail.com with ESMTPSA id s24sm2227194pjp.53.2020.09.18.02.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 02:48:25 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V4 03/10] xfs: Check for extent overflow when punching a hole
Date:   Fri, 18 Sep 2020 15:17:52 +0530
Message-Id: <20200918094759.2727564-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918094759.2727564-1-chandanrlinux@gmail.com>
References: <20200918094759.2727564-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The extent mapping the file offset at which a hole has to be
inserted will be split into two extents causing extent count to
increase by 1.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
 fs/xfs/xfs_bmap_item.c         |  5 +++++
 fs/xfs/xfs_bmap_util.c         | 10 ++++++++++
 3 files changed, 22 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7fc2b129a2e7..bcac769a7df6 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -40,6 +40,13 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
 
+/*
+ * Punching out an extent from the middle of an existing extent can cause the
+ * extent count to increase by 1.
+ * i.e. | Old extent | Hole | Old extent |
+ */
+#define XFS_IEXT_PUNCH_HOLE_CNT		(1)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ec3691372e7c..5c7d08da8ff1 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -519,6 +519,11 @@ xfs_bui_item_recover(
 	}
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, whichfork,
+			XFS_IEXT_PUNCH_HOLE_CNT);
+	if (error)
+		goto err_inode;
+
 	count = bmap->me_len;
 	error = xfs_trans_log_finish_bmap_update(tp, budp, type, ip, whichfork,
 			bmap->me_startoff, bmap->me_startblock, &count, state);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index dcd6e61df711..0776abd0103c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -891,6 +891,11 @@ xfs_unmap_extent(
 
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_PUNCH_HOLE_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, done);
 	if (error)
 		goto out_trans_cancel;
@@ -1176,6 +1181,11 @@ xfs_insert_file_space(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_PUNCH_HOLE_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * The extent shifting code works on extent granularity. So, if stop_fsb
 	 * is not the starting block of extent, we need to split the extent at
-- 
2.28.0

