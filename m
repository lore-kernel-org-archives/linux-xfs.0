Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB054CCA485
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235701AbiGRUac (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235719AbiGRUa2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:30:28 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09780E84
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:28 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 23so11637929pgc.8
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lMP2Cego8XhKiFGgixHMiBIP1WfoUrcyVf57TKL3sZw=;
        b=lISpJJjaHFdck6VwQ/ZGWn8c6vqvzy9PzI/0gWCmq/9G6C0WarTqdg6hbsMxHU/YQG
         Uc6EBGMZuUZML0Qdla47iGAs4L3+DktMFzg6M9vAP7eJ/Z49UBOO1gCu9KURYNP738WX
         IdxxdQ9G4vGkKm6TmjFCpWOJyzRsoyuNQ8pigMaw5Qws7Dg1/f19qmyU69DyBGLmGmEZ
         k7kZm+88+C/GCvk+AXa/e+qy2DL/ccv2uI24BK/fYHKGDdSs1Qh1YAMJt0gSyk9fVvM5
         xHgixvk/aLE1TcVFHO3Nc1Ra53J4hvb5so9r58xiRvtluBq5WdIOpgSyQPJUHkLqs0T9
         UlDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lMP2Cego8XhKiFGgixHMiBIP1WfoUrcyVf57TKL3sZw=;
        b=wempYuXRnMVro5pCHsJC1Grue74F9LWg51M5vBYth2T9unb6AAd4Y7hjEVT4egumEE
         2oUbIxfK751eW6OHhXVUBnij5bfVdBtRwG5Voa15iHlGovB2OIhnMOaYurh/kEJgtuMG
         6ovQJwLvYCLLEBPiCuRSH23LM7uZJdyAydSsQddRbnT0a/QG78eYb61Xszd1Wpkts3NW
         TiqT0OIYRBX1jAk445jI9Ny3iu8i2kr+wes/fVAS9mzXg6hZxgkc6YwHF7YeRYy8broK
         NmXTFQpOYyOSyzVrxFewtlhcBLl/NzBSJw0BSPdmOMbsi1XLcfW3GGXeYhnVxFsdkci5
         gK3w==
X-Gm-Message-State: AJIora/vc1E6Pb+6lyrVMAOqKrh5zxiRtpL/mq9kmu5AmGKxg0mEqYhB
        So2jM9amFaJydu71vjPEiyYFGwGu+AG7Cw==
X-Google-Smtp-Source: AGRyM1uMFOnAqzNG6aIEfqeeZLXnr2BPv1sVWChAgg3/U3FctF/UvPRVJbMdIm+iV3LK2r5I6m6ssA==
X-Received: by 2002:a63:86c8:0:b0:415:366c:f287 with SMTP id x191-20020a6386c8000000b00415366cf287mr25809490pgd.309.1658176227339;
        Mon, 18 Jul 2022 13:30:27 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cd67:7482:195c:2daf])
        by smtp.gmail.com with ESMTPSA id 11-20020a17090a0ccb00b001ef7fd7954esm11890148pjt.20.2022.07.18.13.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 13:30:26 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 6/9] xfs: fix incorrect decoding in xchk_btree_cur_fsbno
Date:   Mon, 18 Jul 2022 13:29:56 -0700
Message-Id: <20220718202959.1611129-7-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
In-Reply-To: <20220718202959.1611129-1-leah.rumancik@gmail.com>
References: <20220718202959.1611129-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 94a14cfd3b6e639c3fb90994ea24e8513f1b0cce ]

During review of subsequent patches, Dave and I noticed that this
function doesn't work quite right -- accessing cur->bc_ino depends on
the ROOT_IN_INODE flag, not LONG_PTRS.  Fix that and the parentheses
isssue.  While we're at it, remove the piece that accesses cur->bc_ag,
because block 0 of an AG is never part of a btree.

Note: This changes the btree scrubber tracepoints behavior -- if the
cursor has no buffer for a certain level, it will always report
NULLFSBLOCK.  It is assumed that anyone tracing the online fsck code
will also be tracing xchk_start/xchk_done or otherwise be aware of what
exactly is being scrubbed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/scrub/trace.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index c0ef53fe6611..93c13763c15e 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -24,10 +24,11 @@ xchk_btree_cur_fsbno(
 	if (level < cur->bc_nlevels && cur->bc_bufs[level])
 		return XFS_DADDR_TO_FSB(cur->bc_mp,
 				xfs_buf_daddr(cur->bc_bufs[level]));
-	if (level == cur->bc_nlevels - 1 && cur->bc_flags & XFS_BTREE_LONG_PTRS)
+
+	if (level == cur->bc_nlevels - 1 &&
+	    (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE))
 		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_ino.ip->i_ino);
-	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS))
-		return XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno, 0);
+
 	return NULLFSBLOCK;
 }
 
-- 
2.37.0.170.g444d1eabd0-goog

