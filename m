Return-Path: <SRS0=eBbo=5M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8AC2C43331
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 05:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF04620663
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 05:46:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Guh2UqOy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbgC0FqH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Mar 2020 01:46:07 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44056 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgC0FqH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Mar 2020 01:46:07 -0400
Received: by mail-pg1-f195.google.com with SMTP id 142so4060041pgf.11
        for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2020 22:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TjuK39qT5BQfAMsOHpg1iz/zQaYpLpWj2YKPlpt7H4U=;
        b=Guh2UqOyVPgvA2PEyvnA7cHOuT3bCmwsDsy+8jVED5Ti84QXUUecn78pC3njYR5GJL
         meMgtm9pGeV4tLaeUnYaYMBKv2Z+Vrz5VpGhv7AsClXZ4upobzSGlG1WNNLafHFuE8U3
         mTeAM5C2uUiyxZ+KV46VGzOPmuRoUIBLuvdggt3Dw+GWtLBZfTP4iFJXrs8HtONmCS4v
         6SF78/XeWxTl0AT/qMXDMGpTMs9UfBAXSQbF2d+M1Q2UGJN1vcHgb5blyVKCaPkh3C8H
         /fkjN11vmntJMoEo6q4PqEeoYin7CJDAy1ewrcqoOYUSMs264kVR10SswcnNbcATLFon
         9NZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TjuK39qT5BQfAMsOHpg1iz/zQaYpLpWj2YKPlpt7H4U=;
        b=NMQ18kkd01MUMfuHEnMiu5tCNg2QZGbIMTomfxAYaGGgf8GZMl4/bsc302jZjlKUW0
         hHhlbXz1M65SkuOvtCBlx+tu0Wzf1/IZTFRTegUnvyV0LteKVGKvr4p+iJYFD1LpkiNP
         doJf3gYn/MECuMom5H8lfzkmuFsinV84abatBO+LzjPUSel1ZJpZfnn2xN49r/zoBXkb
         +h9UtSG6DrtBN2oQZjqqLvvBZyKGUFBbz0lVvgoRZxamL+U3aGmAs7BDvq3ByJ6AmN2C
         ebQk1lzhIv52AsGgKu8RFg4d+ccrKAHhHojcfCMFEBGqILkgCI7fLoBrplrfqH5JFa1b
         wIjw==
X-Gm-Message-State: ANhLgQ1an6Hi6DFwGw7fMbPLh0Su0F+ML9/+vmE0XgWru0ZbVo45xb3D
        MQsAOvqd/qYLrjZH96hJOeg028k=
X-Google-Smtp-Source: ADFU+vsqXt0fPr10pPOR1qXcRq01toe98zClr1u9dkK9LoWb1YZ+bG63WEGtNdZCt7iglmzq/C8b5w==
X-Received: by 2002:a62:b402:: with SMTP id h2mr13371395pfn.192.1585287965610;
        Thu, 26 Mar 2020 22:46:05 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id 1sm2964316pjc.32.2020.03.26.22.46.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Mar 2020 22:46:05 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: remove unnecessary judgment from xfs_create
Date:   Fri, 27 Mar 2020 13:45:56 +0800
Message-Id: <1585287956-2808-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Since the "no-allocation" reservations for file creations has
been removed, the resblks value should be larger than zero, so
remove unnecessary judgment.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c5077e6..e41bddf 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1219,8 +1219,7 @@
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-				   resblks ?
-					resblks - XFS_IALLOC_SPACE_RES(mp) : 0);
+					resblks - XFS_IALLOC_SPACE_RES(mp));
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
-- 
1.8.3.1

