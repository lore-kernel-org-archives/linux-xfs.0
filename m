Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94287C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbiGRUab (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235704AbiGRUa1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:30:27 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B5AE84
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:26 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id 5so10080691plk.9
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l7X57nv7+7Yj5pQ4HD4axkjmjcF7W8rDi18NhJOK5qg=;
        b=OhntbqAcjywxM+yH36w0rfuXMrqBN6VVoMN6aIRARCgBAHjZAbdQ5spTVOkBfHNTQq
         ay3dZlICOVatoe38Zo5jQnafqcaTPQqxfX0ARmXmwEL7S1PTY2VMqYtCPVTVDGptoV90
         Tg8iT46hNw1j4YPf5qtCWJv6/f6lHNd5XLvP5aLZqLD5FQORxo63yC1WYLhcZGzqFSuH
         5J/MGQhU1X/nvBS+CU6WrWimi9MlY82GEvjxFKRAK4AFS51V8+xk/udcVwaj6r63KhXJ
         CYpqVHUl4woLw/lK9cufU75EmPKHRQcdmnSncQvpt9Ln22hL7CjLeDbugNjmqoJ3cocz
         r5Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l7X57nv7+7Yj5pQ4HD4axkjmjcF7W8rDi18NhJOK5qg=;
        b=ra0aU50ytmUQGt93Dj1glMTxiZQoSENanrrkmtDfLZ9uHtTwwdoOdwEKmjfHac7lAA
         2OxDAdHpGtGeVyHyXjhE4NguI99do2EcVCy635mLHKdFjkYF+rM7nAmpDAFctxk0xYDd
         ta8KUiv60XKGcL4FC0me7iD7t/iZtb5tWSdwbbeTZuOqNQ0BGpUURYybxxvkG2hA1dEv
         EMQFVSr5Pi92hB5g6MbBO3gJvI4S7i+Lh9J8yCCDh8Fpnz4cjjew0zqmrix7tijTywfc
         yOIHm2CdeSCuRGKoGn+uzhEE90BQGQdw+gpI/jUtM3YpUg/+X1YkCyRPsZonf8nW8rbH
         pQWA==
X-Gm-Message-State: AJIora9JHKW9yjrFoPxUiuFuxTJN2YrhPc2SG0WBcsgi0/5VsBdV9qc0
        158Lbp1RIhgK/OUdw2huxWtbaPmJImDNfA==
X-Google-Smtp-Source: AGRyM1tcF0rvoQDq0sKldsPZeuCjjzH75HvO/4YfznUBTiihOhQaoYGDNyD0bTQd/tTLReg7iW29gg==
X-Received: by 2002:a17:90b:4c0c:b0:1ef:e4f6:409f with SMTP id na12-20020a17090b4c0c00b001efe4f6409fmr39802300pjb.227.1658176226048;
        Mon, 18 Jul 2022 13:30:26 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cd67:7482:195c:2daf])
        by smtp.gmail.com with ESMTPSA id 11-20020a17090a0ccb00b001ef7fd7954esm11890148pjt.20.2022.07.18.13.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 13:30:25 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 5/9] xfs: fix perag reference leak on iteration race with growfs
Date:   Mon, 18 Jul 2022 13:29:55 -0700
Message-Id: <20220718202959.1611129-6-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
In-Reply-To: <20220718202959.1611129-1-leah.rumancik@gmail.com>
References: <20220718202959.1611129-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 892a666fafa19ab04b5e948f6c92f98f1dafb489 ]

The for_each_perag*() set of macros are hacky in that some (i.e.
those based on sb_agcount) rely on the assumption that perag
iteration terminates naturally with a NULL perag at the specified
end_agno. Others allow for the final AG to have a valid perag and
require the calling function to clean up any potential leftover
xfs_perag reference on termination of the loop.

Aside from providing a subtly inconsistent interface, the former
variant is racy with growfs because growfs can create discoverable
post-eofs perags before the final superblock update that completes
the grow operation and increases sb_agcount. This leads to the
following assert failure (reproduced by xfs/104) in the perag free
path during unmount:

 XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0, file: fs/xfs/libxfs/xfs_ag.c, line: 195

This occurs because one of the many for_each_perag() loops in the
code that is expected to terminate with a NULL pag (and thus has no
post-loop xfs_perag_put() check) raced with a growfs and found a
non-NULL post-EOFS perag, but terminated naturally based on the
end_agno check without releasing the post-EOFS perag.

Rework the iteration logic to lift the agno check from the main for
loop conditional to the iteration helper function. The for loop now
purely terminates on a NULL pag and xfs_perag_next() avoids taking a
reference to any perag beyond end_agno in the first place.

Fixes: f250eedcf762 ("xfs: make for_each_perag... a first class citizen")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_ag.h | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 4585ebb3f450..3f597cad2c33 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -116,30 +116,26 @@ void xfs_perag_put(struct xfs_perag *pag);
 
 /*
  * Perag iteration APIs
- *
- * XXX: for_each_perag_range() usage really needs an iterator to clean up when
- * we terminate at end_agno because we may have taken a reference to the perag
- * beyond end_agno. Right now callers have to be careful to catch and clean that
- * up themselves. This is not necessary for the callers of for_each_perag() and
- * for_each_perag_from() because they terminate at sb_agcount where there are
- * no perag structures in tree beyond end_agno.
  */
 static inline struct xfs_perag *
 xfs_perag_next(
 	struct xfs_perag	*pag,
-	xfs_agnumber_t		*agno)
+	xfs_agnumber_t		*agno,
+	xfs_agnumber_t		end_agno)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 
 	*agno = pag->pag_agno + 1;
 	xfs_perag_put(pag);
+	if (*agno > end_agno)
+		return NULL;
 	return xfs_perag_get(mp, *agno);
 }
 
 #define for_each_perag_range(mp, agno, end_agno, pag) \
 	for ((pag) = xfs_perag_get((mp), (agno)); \
-		(pag) != NULL && (agno) <= (end_agno); \
-		(pag) = xfs_perag_next((pag), &(agno)))
+		(pag) != NULL; \
+		(pag) = xfs_perag_next((pag), &(agno), (end_agno)))
 
 #define for_each_perag_from(mp, agno, pag) \
 	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
-- 
2.37.0.170.g444d1eabd0-goog

