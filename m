Return-Path: <SRS0=fxM9=DK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEEF4C4363D
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B57C9206F8
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:57:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RLv/ErL2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725777AbgJCF5N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 3 Oct 2020 01:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCF5N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Oct 2020 01:57:13 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0489C0613D0
        for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2020 22:57:12 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id nl2so460425pjb.1
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2020 22:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3LvJc1UTVx+let4A8iQH95WDRcW3NxmNhVKSEog1EUE=;
        b=RLv/ErL2f4D1IJ/MN29VsR0x16GvcmB/ONc2VH8yGtmowDtzyyIMSE8cRM0VZ60J8c
         4cq1NGyzRbnWtg8ZON84on/uGeOIk1nKfbP8RrJhx0Gcu6gdYooMbATsM1jWdzhe5UnZ
         O1kQBowxcltHzER3WLoF0neUYFHMasOJpnF4ugDQvq1Xh69vu9F635e/geoSaq2NSXX6
         20x+foGK+IQbJWO61hxfY/JxkVXimm5c8xfWy8CzNto0O/t0IJDDJfzLFCZsfdl13b+e
         1N6pBIwrL2ettw2lEgTgGlpnrwZkt37D7l+T/zZyd5F08J+zEeNu+BrkxWpetvV8S9d5
         jdmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3LvJc1UTVx+let4A8iQH95WDRcW3NxmNhVKSEog1EUE=;
        b=O7RoEOGQMFJZRBhqLygmCLkz9H42Dw2HkAz32EnFKTuDMSF+hJD59nPyvinzsVOmOm
         esZU1xpqr+SuzZ1gNXMDCg+ROgqY04fVyZ80VZPlSj89uQUoitaoyFoRPxfDZd/764WO
         CgIrvvgGpol/6nzOBnMhNFgr64EkEwTvpa/0bvTyZ5WZHUs3cpeFxKpmyxVt7xHQ4TvA
         hgr8Bwuq1zYRsCtAIqd9KJp2jqaT1+9eV1vQwkmy547cgOyBDJubolvn4UjDbckHhk1J
         zI5nf5D5KHeaPfKdyUXD5+kVv9lmKdbrNpfDnas3uYISitbfOjQHfad0xpAeQGIubLHM
         OkUg==
X-Gm-Message-State: AOAM533TQbJGChCI9mYcopIcwrIZwwh0+4WYB4YiPRgAF+c9W0mjkLNE
        SSaITf9/saX1JWl996QJghSEzkALcT1vYA==
X-Google-Smtp-Source: ABdhPJwgvVw0312+jWQmH5KO+qZJV0WUDoPhuzhlXuNa16KyLxAnxmdDTl9ZqjM22R1uyC/sds/V2g==
X-Received: by 2002:a17:90a:b942:: with SMTP id f2mr6332980pjw.196.1601704631926;
        Fri, 02 Oct 2020 22:57:11 -0700 (PDT)
Received: from localhost.localdomain ([122.171.168.96])
        by smtp.gmail.com with ESMTPSA id 125sm4106664pff.59.2020.10.02.22.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 22:57:11 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V5 11/12] xfs: Set tp->t_firstblock only once during a transaction's lifetime
Date:   Sat,  3 Oct 2020 11:26:32 +0530
Message-Id: <20201003055633.9379-12-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201003055633.9379-1-chandanrlinux@gmail.com>
References: <20201003055633.9379-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

tp->t_firstblock is supposed to hold the first fs block allocated by the
transaction. There are two cases in the current code base where
tp->t_firstblock is assigned a value unconditionally. This commit makes
sure that we assign to tp->t_firstblock only if its current value is
NULLFSBLOCK.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 51c2d2690f05..5156cbd476f2 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -724,7 +724,8 @@ xfs_bmap_extents_to_btree(
 	 */
 	ASSERT(tp->t_firstblock == NULLFSBLOCK ||
 	       args.agno >= XFS_FSB_TO_AGNO(mp, tp->t_firstblock));
-	tp->t_firstblock = args.fsbno;
+	if (tp->t_firstblock == NULLFSBLOCK)
+		tp->t_firstblock = args.fsbno;
 	cur->bc_ino.allocated++;
 	ip->i_d.di_nblocks++;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
@@ -875,7 +876,8 @@ xfs_bmap_local_to_extents(
 	/* Can't fail, the space was reserved. */
 	ASSERT(args.fsbno != NULLFSBLOCK);
 	ASSERT(args.len == 1);
-	tp->t_firstblock = args.fsbno;
+	if (tp->t_firstblock == NULLFSBLOCK)
+		tp->t_firstblock = args.fsbno;
 	error = xfs_trans_get_buf(tp, args.mp->m_ddev_targp,
 			XFS_FSB_TO_DADDR(args.mp, args.fsbno),
 			args.mp->m_bsize, 0, &bp);
-- 
2.28.0

