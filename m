Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9DBDCCA47F
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235635AbiGRUaa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235703AbiGRUa0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:30:26 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB29EB87D
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:25 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x18-20020a17090a8a9200b001ef83b332f5so19406947pjn.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5V+dUMUtOOVzuI+5oNGbZWUwyEJ44SkpXvqIoGIdykk=;
        b=YxyK/29PorfEB6ePJc7Y7IEf4/UZdsuTxr3nq3g/kbUr3wXvJdn2YyICtARvPDZX5v
         btQAzVYz5rpGPTLryrafqEbtDxFEaasvYvf9FkAvRNaTwzTrgdxjNJlAJryUJltA+wRb
         QcaSNsQGkSj51N8QmY7mCQsuoNPk7GcA0VhvCyB39NYKa1dUyj3RGC1WYcQPOvmPSkMM
         BVDq3TH19iomztzlCZoS8mYUiPheaCeLqTuQ+O3HiFexW4JkOxMicrAIDe/5OeMW/arD
         gRUG0b8OcTf9nhAZXqxiOBm3Wowu+DheMhwgNWffVUqoFPhx41JHWPxtltE81dPubrGY
         A/yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5V+dUMUtOOVzuI+5oNGbZWUwyEJ44SkpXvqIoGIdykk=;
        b=cwRKLTTYo5TqcVPvkgMwaXCkNRPdT+5Fw52IeNB2uhJV5cnTI7HriRlVwNZNt65CdM
         +OFs6N19Bthgxzi1iHfkLG3+TCGhqZ/Ln3o6daLJG9C2P1TAXPn5Quh2gzbM5Lymgfwa
         mkuTGq2uvuDLwxKlnuH2PO4K6qXXmsNqQ97DcZiWJoPWvgqkzS3lbHbhOGyzHIc80D34
         sPNhft/3CZi0TXt+NdX+qzW8wb34Y36kyRGqQuck4fIjiBM7Q53BoQmo4OysWMnJLZAJ
         Ajqteqxt5vI03Jq7Zz0FMxgdERMCZZEryzyRVYBE77HLu1Amq/c3+CQAwrMjjyags3cC
         RFvg==
X-Gm-Message-State: AJIora/eFem6IfqGx9p8ODJ9JXRvSw73bDn1V0d4y0ndOc/1U2Dzb82R
        DtXMDpQwhBOO4F7yKMGBhGnvI8VICbt+vg==
X-Google-Smtp-Source: AGRyM1uTTSTWZgBq+qUzS8DGf7IfC50e6SPKnB4W+d697ODh+gGtyQ1kS5I/Stznbtu5gy9+NOibpw==
X-Received: by 2002:a17:90b:4b4a:b0:1ef:fc95:3c4f with SMTP id mi10-20020a17090b4b4a00b001effc953c4fmr33183403pjb.138.1658176225063;
        Mon, 18 Jul 2022 13:30:25 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cd67:7482:195c:2daf])
        by smtp.gmail.com with ESMTPSA id 11-20020a17090a0ccb00b001ef7fd7954esm11890148pjt.20.2022.07.18.13.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 13:30:24 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 4/9] xfs: terminate perag iteration reliably on agcount
Date:   Mon, 18 Jul 2022 13:29:54 -0700
Message-Id: <20220718202959.1611129-5-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
In-Reply-To: <20220718202959.1611129-1-leah.rumancik@gmail.com>
References: <20220718202959.1611129-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 8ed004eb9d07a5d6114db3e97a166707c186262d ]

The for_each_perag_from() iteration macro relies on sb_agcount to
process every perag currently within EOFS from a given starting
point. It's perfectly valid to have perag structures beyond
sb_agcount, however, such as if a growfs is in progress. If a perag
loop happens to race with growfs in this manner, it will actually
attempt to process the post-EOFS perag where ->pag_agno ==
sb_agcount. This is reproduced by xfs/104 and manifests as the
following assert failure in superblock write verifier context:

 XFS: Assertion failed: agno < mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c, line: 22

Update the corresponding macro to only process perags that are
within the current sb_agcount.

Fixes: 58d43a7e3263 ("xfs: pass perags around in fsmap data dev functions")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_ag.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 134e8635dee1..4585ebb3f450 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -142,7 +142,7 @@ xfs_perag_next(
 		(pag) = xfs_perag_next((pag), &(agno)))
 
 #define for_each_perag_from(mp, agno, pag) \
-	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
+	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
 
 
 #define for_each_perag(mp, agno, pag) \
-- 
2.37.0.170.g444d1eabd0-goog

