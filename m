Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422CFC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 09:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16ED22074B
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 09:27:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YQdGWuGo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgFCJ1R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 05:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgFCJ1R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 05:27:17 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F70C05BD43;
        Wed,  3 Jun 2020 02:27:16 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id v2so1229819pfv.7;
        Wed, 03 Jun 2020 02:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uh2CKAA4+lcpMvZ24+L9hYveJ/3JZkbF6Yf7EybVd6s=;
        b=YQdGWuGordLPzE9Cs5yVmg7PFnqFXO+M9bXphmjjZkm52DStTJ3xCvvgytG8oC1Lm8
         E5z4Oac02CW4acOzTzqT7QkI5j97vUpW/F+z6DwHMlelO6fAKgQ7Zoh69vk4zKgWKFg9
         2jjpreQ88K9ijscsgf5VQAL2Mv9VSfSOqrAipBAVuma75ujbGP9b2MoZi45f6HXpbbOg
         x0St/Uvc5v+Dmx2SSZrDyGu6LQHokI0HJ/3x3/dQ4fRnd8PUjpfn2njhOqNAPh7C4TGc
         HPtZ3iWefRIcbzh38ArPhicLGcD+fTW1cwMp6tXudGHkpoEDi5vHMHnxsxknAFbYsjXy
         Lx0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uh2CKAA4+lcpMvZ24+L9hYveJ/3JZkbF6Yf7EybVd6s=;
        b=F5z7CqxcIcBVNhAqkAJ9lG5IRQKwpc4NpNhGoaUOkJTnqX/BokZVRztQK3TwsL3H46
         CH2uYv7+yGixv9eswHzhv0vkUidezkm9FWktgtV2j3dRHJ73BcSFRBocmAePxvlrRfb+
         MRnBphTsfHGGDEleY0VX3qAZqYsce7e+FlFg9oYEfibeFRu0oPIFXyX+b0jP1tUARK06
         YvZAEc+YQZ6q8q3lylizkiIRJoHi7dk/KKc5uvlwaB/3bJ+9js4PkpZ64BxBrnH9Rg/l
         JsnwIMAaJOENFSNO62bZHfwVpTHI07yCMRvb0Ks/7RhNzxnW8NhY5TjRGKwSr8irLT3h
         4yNw==
X-Gm-Message-State: AOAM532EPXl/p+a8CqKeobHPynQ8vn2Rdw2WTQ+pbMvadVacqb20lIeJ
        Pv5HeXrxonQzIkwnuwlTYJQ=
X-Google-Smtp-Source: ABdhPJwoDIi3DdmE4T8lAZgJEwIf5YqN2uLpA5tmOepULiKyZnNGulhA/gbk5mJIzJDoiGOjuxJetQ==
X-Received: by 2002:a17:90a:4809:: with SMTP id a9mr4657256pjh.196.1591176435847;
        Wed, 03 Jun 2020 02:27:15 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id c195sm1411816pfc.203.2020.06.03.02.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 02:27:15 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] xfs: Add the missed xfs_perag_put() for xfs_ifree_cluster()
Date:   Wed,  3 Jun 2020 17:27:07 +0800
Message-Id: <20200603092707.1424619-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_ifree_cluster() calls xfs_perag_get() at the beginning, but forgets to
call xfs_perag_put() in one failed path.
Add the missed function call to fix it.

Fixes: ce92464c180b ("xfs: make xfs_trans_get_buf return an error code")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 fs/xfs/xfs_inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d1772786af29..8845faa8161a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2639,8 +2639,10 @@ xfs_ifree_cluster(
 		error = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno,
 				mp->m_bsize * igeo->blocks_per_cluster,
 				XBF_UNMAPPED, &bp);
-		if (error)
+		if (error) {
+			xfs_perag_put(pag);
 			return error;
+		}
 
 		/*
 		 * This buffer may not have been correctly initialised as we
-- 
2.26.2

