Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26F7C4363D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 06:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 767F5221F0
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 06:59:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iyp5F3mM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgIWG73 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 02:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgIWG72 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 02:59:28 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6166C061755
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 23:59:28 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mm21so2726480pjb.4
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 23:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1xjEftt6BoWBnurJ2cfbr79NM6CiAL0+326aCaRrEN4=;
        b=Iyp5F3mMk7ubIR46GZQLkSIgXd039J4ehciH0rA4agt/xIDuxAxWaziwDycaeES3g3
         UriqJYMG1pwioN2BW1/RbXBWhy3WBuklhmDXTs38mYte9vafZ5RaJABHTldJYQ0WWnrL
         SGGLBRmAHRS7obYW0iB8R6FvIEUpHVy2weTOr/6rTR+CS2BxJJRmnH/o5ukf1fWmWhxh
         sYpCcIPyyZoR7lmRAHcWMdtvLSpuKv8iwiU0s/kwtA/cy0cNZzFrr6wxsXrcvnYFbFGA
         UU2qfvenm51N0osK9B8lEW3eK21/0DjoShFWaV4rl3K0I6QZU2oSwDpvhr9S0sJKzKJA
         CyQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1xjEftt6BoWBnurJ2cfbr79NM6CiAL0+326aCaRrEN4=;
        b=iZCXo0pa7osy/KXQ9Sqycs1ASmYSUmhKl5DlW0NVCo5/p/YZzYB5KIRbFqX8lRv+CD
         ih5U1JEAoiuZ6jG1j3OEc88729xmscHPb3HhtMAkpQJX2cDgXXMy7BAJh+VmpIGbM/I+
         TOr0e/qOWi1nLEHLCGgv7hwn0jVaHg7SBUaGlLdnSLZSPbNgZeAcqtDYeClnjVDyV9NH
         8RPnsex8ra8a7HogoPMmiEdF8o70Vr8lzOR4MEmTvrUMJRn8Y0qzxSP4+EF2/nCpairG
         uiX7k4vXR9orl9TzPjatPM4f70lAWEgxrjqGb6s+Bx5lBHF1HhhKm2n51jK7Mb/YDLax
         7GwQ==
X-Gm-Message-State: AOAM531haXBsYE+szMgrnF2cfgHylhrWbjBrSQmVaLZEEcsOn2WfJKiL
        XGR5PI4AZnxHLsfdI2oFLyPnciRztD/k
X-Google-Smtp-Source: ABdhPJz0hpumdCPwRzgtFoTKiu8LxFb2OBeXmU30ZS2tRqr+a7IukrXVxkIbNoyOlb6W5mDLwyYMlA==
X-Received: by 2002:a17:902:8d86:b029:d1:9237:6dfd with SMTP id v6-20020a1709028d86b02900d192376dfdmr8216785plo.22.1600844368126;
        Tue, 22 Sep 2020 23:59:28 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id c68sm10685745pfc.31.2020.09.22.23.59.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Sep 2020 23:59:27 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v3 2/7] xfs: use the existing type definition for di_projid
Date:   Wed, 23 Sep 2020 14:59:13 +0800
Message-Id: <1600844358-16601-3-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600844358-16601-1-git-send-email-kaixuxia@tencent.com>
References: <1600844358-16601-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

We have already defined the project ID type prid_t, so maybe should
use it here.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 536666143fe7..ef5eaf33d146 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -17,7 +17,7 @@ struct xfs_dinode;
  */
 struct xfs_icdinode {
 	uint16_t	di_flushiter;	/* incremented on flush */
-	uint32_t	di_projid;	/* owner's project id */
+	prid_t		di_projid;	/* owner's project id */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-- 
2.20.0

