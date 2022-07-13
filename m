Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42833C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jul 2022 01:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiGMBnN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 21:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiGMBnM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 21:43:12 -0400
Received: from mail-ot1-f68.google.com (mail-ot1-f68.google.com [209.85.210.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6535F32EEA;
        Tue, 12 Jul 2022 18:43:11 -0700 (PDT)
Received: by mail-ot1-f68.google.com with SMTP id by10-20020a056830608a00b0061c1ac80e1dso7378760otb.13;
        Tue, 12 Jul 2022 18:43:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oUKpzDsdXkSvS+VF8FDte+ED11p+mInw/DC/Lpc79ZE=;
        b=rzGDSUjDvArCL9cKJMJc7rN6foJ6XhScscVbT/2YMYoMWUGzx0aGPr9zIgS2MSMss0
         0Lw/j5DdeN7MyKNsauy7J8u8TX//7fxc+fZI08Gt0YbUrcp6GpMSRq7xC0LQRjsPaVv1
         qnsTeGTfzV/XRQQdFkSZ2cR6X+Ctno1eYYXCESuEVu83Ro6G3DFUDmuEqBhWVNSFrCsn
         varae9yTDgQu+puSp84N5QnmQ1AAYkSg9Q/BYA4mzpREJa4ynxHUkB2iy1yNIS3LrWIq
         XzDQBiZrFl7mFU+b4KdtFYW4KNKECSC0AAmnSR6Mddccs6rMkbJ4pcBKX8L5SsCN3jxF
         IXQA==
X-Gm-Message-State: AJIora+mLNmWW07vTpywNEp68X/wXPFmW0V0fIL3DuLqDqjbMgRfNWAR
        /ZhnUCyhwEOuciSvk4exbw==
X-Google-Smtp-Source: AGRyM1s/Ox9kMv8DzxDTlYWEHEro97vlK3KKzUNmSJi9EczaBh+v/YioqYWtLNYPNCCo6OhDquMxLg==
X-Received: by 2002:a9d:60d:0:b0:61c:4462:1ae1 with SMTP id 13-20020a9d060d000000b0061c44621ae1mr406309otn.363.1657676590738;
        Tue, 12 Jul 2022 18:43:10 -0700 (PDT)
Received: from localhost.localdomain ([156.146.53.107])
        by smtp.gmail.com with ESMTPSA id d8-20020a056870e24800b0010490c6b552sm5523905oac.35.2022.07.12.18.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 18:43:10 -0700 (PDT)
From:   sunliming <sunliming@kylinos.cn>
To:     hch@lst.de, djwong@kernel.org, dchinner@redhat.com
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        sunliming@kylinos.cn, kelulanainsley@gmail.com,
        kernel test robot <lkp@intel.com>
Subject: [PATCH RESEND] xfs: fix for variable set but not used warning
Date:   Wed, 13 Jul 2022 09:43:00 +0800
Message-Id: <20220713014300.5108-1-sunliming@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix below kernel warning:

fs/xfs/scrub/repair.c:539:19: warning: variable 'agno' set but not used [-Wunused-but-set-variable]

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: sunliming <sunliming@kylinos.cn>
---
 fs/xfs/scrub/repair.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index a02ec8fbc8ac..032de115e373 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -533,14 +533,12 @@ xrep_reap_block(
 {
 	struct xfs_btree_cur		*cur;
 	struct xfs_buf			*agf_bp = NULL;
-	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
 	bool				has_other_rmap;
 	int				error;
 
-	agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
 	agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
-	ASSERT(agno == sc->sa.pag->pag_agno);
+	ASSERT(XFS_FSB_TO_AGNO(sc->mp, fsbno) == sc->sa.pag->pag_agno);
 
 	/*
 	 * If we are repairing per-inode metadata, we need to read in the AGF
-- 
2.25.1

