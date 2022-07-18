Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C665CCA486
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbiGRUab (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235701AbiGRUa0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:30:26 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF551E84
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:24 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id b9so11672797pfp.10
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cyh3yZHBMcfb2npU737c6fRTuZlaRK61cZgoIcRgJZM=;
        b=N+tmv/oBe9zRbA9LlK2owm59Cl6FI/c1wpPCouC5O7l7/22ry0N/1DftEeathquCHR
         5UNsL341lhqSyefj6P2RTsw99R11L5jyctjnDMjMLlDx6w+iBXWRkZiPIEUPPcbYfeKV
         bFG7Zy9A0BlzDxjPsHKtEyNAdKiNvrQ6YBl5dScUr4zd2Vk3I8PXDCAXR7352EAFR2Sz
         dKon+VTVPQjkn0C8lJz09QbtaaEzQqyuYEViROFtd/A5W+qH6j+ewUqODDmcGFZ57eia
         Bf03EPZME1UnmvQSy6L8x6F0h6n0xgWL2ilVmHC6IeROPAI7o1EuNaDI/osSMxGOGjFF
         vmQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cyh3yZHBMcfb2npU737c6fRTuZlaRK61cZgoIcRgJZM=;
        b=LXIzUnlT2VyHoLVp5EOyNNkvIpSY6PY0srIcYCo1LxOozg+ks6VuawjKXIgmubBBEN
         KHl+Tx4q0Xfm2VHOE64fwkt1Z1DpqK0LnQOAtTD1JgOGI0Rwv4Mgj3vUJImzUa4nPi/+
         c+Ix6IQhrDaDcv8znP8p7XeoJohO+PRdw8i+i1Vut7fEB4ImfmiSe70GwoectDOnkc+H
         8UHnCjtF8N8pa69b2GEQxWZl74d6N6To3WChlUVakbFHSj/uRZr7oUgZ3PPG1z3qkd4i
         dxwg4OFIwQqjuTTDu9W3u1YagnzI2D7vdQvfoGMwZVgxoAWqktxDoJjzuBWlWxZ0hC/L
         qZ+A==
X-Gm-Message-State: AJIora8CjQPrYbwMRctASD/CwU/xLYwevlnUkXoScyc+hJm7kDmycvDH
        Yn+qLKhqaKqEYZXmubtKy8sfRM3uTCgzLQ==
X-Google-Smtp-Source: AGRyM1tKBpcJNSFEV+XEyE7iFwPw/NlXUZkvqM98Rzgu0Ick7+ZJHqmakwnmpIqoUO8ZJyZ4XJ2AQg==
X-Received: by 2002:a63:e80e:0:b0:419:d02c:fc8b with SMTP id s14-20020a63e80e000000b00419d02cfc8bmr17962453pgh.385.1658176224001;
        Mon, 18 Jul 2022 13:30:24 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cd67:7482:195c:2daf])
        by smtp.gmail.com with ESMTPSA id 11-20020a17090a0ccb00b001ef7fd7954esm11890148pjt.20.2022.07.18.13.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 13:30:23 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 3/9] xfs: rename the next_agno perag iteration variable
Date:   Mon, 18 Jul 2022 13:29:53 -0700
Message-Id: <20220718202959.1611129-4-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
In-Reply-To: <20220718202959.1611129-1-leah.rumancik@gmail.com>
References: <20220718202959.1611129-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit f1788b5e5ee25bedf00bb4d25f82b93820d61189 ]

Rename the next_agno variable to be consistent across the several
iteration macros and shorten line length.

[backport: dependency for 8ed004eb9d07a5d6114db3e97a166707c186262d]

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_ag.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index ddb89e10b6ea..134e8635dee1 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -127,22 +127,22 @@ void xfs_perag_put(struct xfs_perag *pag);
 static inline struct xfs_perag *
 xfs_perag_next(
 	struct xfs_perag	*pag,
-	xfs_agnumber_t		*next_agno)
+	xfs_agnumber_t		*agno)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 
-	*next_agno = pag->pag_agno + 1;
+	*agno = pag->pag_agno + 1;
 	xfs_perag_put(pag);
-	return xfs_perag_get(mp, *next_agno);
+	return xfs_perag_get(mp, *agno);
 }
 
-#define for_each_perag_range(mp, next_agno, end_agno, pag) \
-	for ((pag) = xfs_perag_get((mp), (next_agno)); \
-		(pag) != NULL && (next_agno) <= (end_agno); \
-		(pag) = xfs_perag_next((pag), &(next_agno)))
+#define for_each_perag_range(mp, agno, end_agno, pag) \
+	for ((pag) = xfs_perag_get((mp), (agno)); \
+		(pag) != NULL && (agno) <= (end_agno); \
+		(pag) = xfs_perag_next((pag), &(agno)))
 
-#define for_each_perag_from(mp, next_agno, pag) \
-	for_each_perag_range((mp), (next_agno), (mp)->m_sb.sb_agcount, (pag))
+#define for_each_perag_from(mp, agno, pag) \
+	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
 
 
 #define for_each_perag(mp, agno, pag) \
-- 
2.37.0.170.g444d1eabd0-goog

