Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A661C001B0
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jun 2023 22:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjF0Wo2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jun 2023 18:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjF0WoZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2023 18:44:25 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B99326A4
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 15:44:21 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-666eec46206so4589609b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 15:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687905860; x=1690497860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y8HfHfWhYbh6r3O4pO/b8MI4sO9R7L0l1wq6+nMOuKU=;
        b=u4ZJ0WzqPl0HW5OMvFaacz90LZ8ardlFocLk93osQIX6YML5lcMSkNC6BK97kbnUT8
         EU7p38p0TfqCSc3/zs59Arc9MlVpZiBZgUUFlkC3dyX0fAc8efe4kwS220BzvD5KmOej
         FC/HsDLUaJIgk0XiHVg4Ez7O/PZjMO38Csk/FxB4/ggYe+3Zf28qmmJit0mvOjMCSGIG
         553iH3uI3heIyAU7Dd+Bwju9TKAhjjOFCZe4C38xVlcyKr7XXchGKgpyDqKd2lWyed1E
         vX9qvBR14O95/0Asi74Ljhpd0dgcN/dBynlgIx/7cd03biFNl2mW/nM97ai5hoSpj0y5
         yE7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687905860; x=1690497860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y8HfHfWhYbh6r3O4pO/b8MI4sO9R7L0l1wq6+nMOuKU=;
        b=U0IqsFJamRwwW6NRvuzcwXnapm/R8TX90sR1iBe6aayydCNvi8KuHU6HShOkUwIYXu
         +pjk/WHdiFIFME/z3rmgimu33QdaCsITsFll8mZPrTTd3zhHyrz4AXR3YKUgXyK2x8Km
         ft+iA5KN9VUzM/uHBimBHS1ND8SkqtvVWfXklBmbg5Z0kUx977hMeFlADvlAshJa6ORc
         D36YPZ/BotuxQPXQsqs/YJy6QQW4hB9+3PEGfEX3AwhP9/wMuQesCI7x/EYQKm+KZqhb
         I7EPJcF3/MRdA4isdH3SGLZwm0vLLIB7v3Yc6aWHgy+rbectJ7jqjoNtxuG6bd/p6+01
         O7aw==
X-Gm-Message-State: AC+VfDzz4tt+M37vbsbSZArMUZ4Hzkj4OabM1TAJVWEcdsmQQgmQpcf2
        IRvKMioKPPbjf+JJPN/SYcwAl281erzsUQszPAE=
X-Google-Smtp-Source: ACHHUZ5xEf5S3eUoKxKZ619s8YgkgDXaGKXpo+RNNC0Jd+6uP1F6w2es7l0XCFnUlzP8C8BfjT/odg==
X-Received: by 2002:a05:6a20:138a:b0:129:3c9:ffab with SMTP id hn10-20020a056a20138a00b0012903c9ffabmr4994299pzc.45.1687905860719;
        Tue, 27 Jun 2023 15:44:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id h3-20020a635303000000b0051b9e82d6d6sm6195234pgb.40.2023.06.27.15.44.18
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 15:44:20 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qEHPz-00Gzwn-27
        for linux-xfs@vger.kernel.org;
        Wed, 28 Jun 2023 08:44:15 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qEHPz-009Zmf-0y
        for linux-xfs@vger.kernel.org;
        Wed, 28 Jun 2023 08:44:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 8/8] xfs: fix bounds check in xfs_defer_agfl_block()
Date:   Wed, 28 Jun 2023 08:44:12 +1000
Message-Id: <20230627224412.2242198-9-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230627224412.2242198-1-david@fromorbit.com>
References: <20230627224412.2242198-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Need to happen before we allocate and then leak the xefi. Found by
coverity via an xfsprogs libxfs scan.

Fixes: 7dfee17b13e5 ("xfs: validate block number being freed before adding to xefi")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 7c86a69354fb..9919fdfe1d7e 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2470,25 +2470,26 @@ static int
 xfs_defer_agfl_block(
 	struct xfs_trans		*tp,
 	xfs_agnumber_t			agno,
-	xfs_fsblock_t			agbno,
+	xfs_agblock_t			agbno,
 	struct xfs_owner_info		*oinfo)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_extent_free_item	*xefi;
+	xfs_fsblock_t			fsbno = XFS_AGB_TO_FSB(mp, agno, agbno);
 
 	ASSERT(xfs_extfree_item_cache != NULL);
 	ASSERT(oinfo != NULL);
 
+	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbno(mp, fsbno)))
+		return -EFSCORRUPTED;
+
 	xefi = kmem_cache_zalloc(xfs_extfree_item_cache,
 			       GFP_KERNEL | __GFP_NOFAIL);
-	xefi->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
+	xefi->xefi_startblock = fsbno;
 	xefi->xefi_blockcount = 1;
 	xefi->xefi_owner = oinfo->oi_owner;
 	xefi->xefi_type = XFS_AG_RESV_AGFL;
 
-	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbno(mp, xefi->xefi_startblock)))
-		return -EFSCORRUPTED;
-
 	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
 
 	xfs_extent_free_get_group(mp, xefi);
-- 
2.40.1

