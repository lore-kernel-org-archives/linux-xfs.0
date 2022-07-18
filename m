Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B103C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbiGRUaa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235695AbiGRUaX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:30:23 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D5EE84
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:22 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id 5so10080539plk.9
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uun7uirnLaIt3lvLmMhnq7AVCceZQvB3jdEBD7rR2YE=;
        b=kw2Rqx/P9fKSLoVf4GFJfJskgFu1z9Hd0tK5fjVPZKntiDdJdQ2IHP4CR7XW8ZRGFV
         WEvauO6eiQvWKCvDW/3QAmXXEhkCta2IXtWf7xAB8FkB6v8x37KvU33VRFlzJP4Uzg92
         2P4xlxeqOYm2JCgI9uHEgHichfdDmlymFwL/MJZadNGWB+nu6ZM8t76XxmyMkpPS/JyY
         xx4bQPINorgefQwZjdxznXaoK6XBsvcTGfZFBUe6gOM2M4tBJZY4m/HBRKAR43MDouuj
         1olTL8yIT+prhBn6JH6c9eiiBxRrbF0ux2Hl/jaWA/WMyK6e4oPCHkQ1/J40KU486lC8
         OJuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uun7uirnLaIt3lvLmMhnq7AVCceZQvB3jdEBD7rR2YE=;
        b=OMrsPDu8CwR96eMj+UfYoAlbKAr4VuSE5anC7T9T7+2W0x8jPnSnYzdcVLGG72a38C
         ymZKc4d1fslsQZ+VvIwF45E2/Q3a7JYCp8nTYixCEfNDNYI95WC/167Jd2QnICaF2v82
         jBnL7st5JuwXLYutvGBQnaev9u/txML6ItpZ9zzm7h6YDYw86c4s7RCi+6936lIJ3CcQ
         UJ2zD44TbahBsFK5qdU9YhNEsSZCbS5otFQYoiGe1+mxkpTXJ9h8eZO3BB8NM1Eu7KNC
         UnFRIkG8JYV+0OMVfTNSbBZLjybl/fOdrn0h2Chom8L5owXqBnQB7pFgwv4X+lhtokmn
         Qtcg==
X-Gm-Message-State: AJIora9odk06vOhkKKBjd7auIaSmxv0DoiONqJBAbrr62lkqjiJx2a85
        Ll5HdTVYjMjPwNAa7L19Ell56OCP0EnOgg==
X-Google-Smtp-Source: AGRyM1vqc6NvZlWuBX3CyOnOTJJ9ZDZO/UTUbvDBii847eUrwNbkuirDu6aS4vpZaVApJjbnTYqkcg==
X-Received: by 2002:a17:902:f544:b0:16c:5119:d4b6 with SMTP id h4-20020a170902f54400b0016c5119d4b6mr29426994plf.28.1658176221826;
        Mon, 18 Jul 2022 13:30:21 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cd67:7482:195c:2daf])
        by smtp.gmail.com with ESMTPSA id 11-20020a17090a0ccb00b001ef7fd7954esm11890148pjt.20.2022.07.18.13.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 13:30:21 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 2/9] xfs: fold perag loop iteration logic into helper function
Date:   Mon, 18 Jul 2022 13:29:52 -0700
Message-Id: <20220718202959.1611129-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
In-Reply-To: <20220718202959.1611129-1-leah.rumancik@gmail.com>
References: <20220718202959.1611129-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit bf2307b195135ed9c95eebb38920d8bd41843092 ]

Fold the loop iteration logic into a helper in preparation for
further fixups. No functional change in this patch.

[backport: dependency for f1788b5e5ee25bedf00bb4d25f82b93820d61189]

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_ag.h | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 4c6f9045baca..ddb89e10b6ea 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -124,12 +124,22 @@ void xfs_perag_put(struct xfs_perag *pag);
  * for_each_perag_from() because they terminate at sb_agcount where there are
  * no perag structures in tree beyond end_agno.
  */
+static inline struct xfs_perag *
+xfs_perag_next(
+	struct xfs_perag	*pag,
+	xfs_agnumber_t		*next_agno)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	*next_agno = pag->pag_agno + 1;
+	xfs_perag_put(pag);
+	return xfs_perag_get(mp, *next_agno);
+}
+
 #define for_each_perag_range(mp, next_agno, end_agno, pag) \
 	for ((pag) = xfs_perag_get((mp), (next_agno)); \
 		(pag) != NULL && (next_agno) <= (end_agno); \
-		(next_agno) = (pag)->pag_agno + 1, \
-		xfs_perag_put(pag), \
-		(pag) = xfs_perag_get((mp), (next_agno)))
+		(pag) = xfs_perag_next((pag), &(next_agno)))
 
 #define for_each_perag_from(mp, next_agno, pag) \
 	for_each_perag_range((mp), (next_agno), (mp)->m_sb.sb_agcount, (pag))
-- 
2.37.0.170.g444d1eabd0-goog

