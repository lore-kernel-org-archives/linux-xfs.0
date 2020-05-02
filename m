Return-Path: <SRS0=mmaA=6Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7075C3A5A9
	for <linux-xfs@archiver.kernel.org>; Sat,  2 May 2020 13:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 928D82192A
	for <linux-xfs@archiver.kernel.org>; Sat,  2 May 2020 13:38:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rE3NQ9eV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgEBNi5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 2 May 2020 09:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727908AbgEBNi4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 May 2020 09:38:56 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E81C061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  2 May 2020 06:38:56 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x15so3003212pfa.1
        for <linux-xfs@vger.kernel.org>; Sat, 02 May 2020 06:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GrpwkxB8Pn+j07pUNX43jRCbKBSYy1zw7rEJT20U8rk=;
        b=rE3NQ9eVcd4YYKcxEgzFIzado3bWFzE8hsO/h5KGREZHlDT3OFMW4h9r8vjo64dnFv
         l984rNJuIku5hgc72uaUBxGS5aMUurDt6UbgzONwFPsWQELiEKzUx5uCyltzpTl2LSv2
         nwopd/3Fgwq7pN6bMF9JtSw3JwKd6ksqdg1KdIbWlhQ6WQvZC1U1xWPt7l1PSpQbiX93
         wKq+Agl/1DdkOK5y/u8yCNGyNSfbeWKUxUgvFsaEtGYz91GSkvvc5bNUweS6t5oKj0Im
         39xgKhfNuvTiKxJBMseo9kmjZWTrm+nwIPR3LYMlDYWWopnGXSikvrlrYrkrU+Y/Gp4f
         bjYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GrpwkxB8Pn+j07pUNX43jRCbKBSYy1zw7rEJT20U8rk=;
        b=q03ZrJlJPQzCBMrpVIF1QtUWOs9RexayiA8n8PrjQT7CrMkczpOwSEd7utmXN2Gzhp
         LW/hJZc8ac3uCUvGJug6o69JzGAGmjGDon3CsF96eftoWqMYp42ANb81Xsmx8iCxKqhN
         QWuwUb4PP/kScO2yKHkzSbhgtiMgLnTeDstC2fWbpXSRJhwQdIE1O6l760jagOnJWzdA
         Jy5UPtuei+cbfXj7JuacRg7kVs0bGa2y+KLBLhjRzjP8qBKe3GuWoLpA2EmOp/g/TF0Z
         xbUENLdeCmyS50BhkZZZAxvW3dMgsVkU7J/VPCpo6lweWtVzoI1R9nZrhLkGsR+5ap5D
         wd5g==
X-Gm-Message-State: AGi0PuYzy7YzbCAmf2701RFAX3pNgXWth0HDcjaRV7Or6r32zM2YXozl
        pS+XLjJzXaxhp51gSoUOVHkqCko=
X-Google-Smtp-Source: APiQypJwq01a/69mRRpMFf6xIaW0OMlyZ8MOJ/1+o36wMYIzQpGQOn+mwYrZBLlvJY7r/oT3FOazQA==
X-Received: by 2002:a63:6c7:: with SMTP id 190mr8400634pgg.418.1588426735999;
        Sat, 02 May 2020 06:38:55 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id o21sm2117237pjr.37.2020.05.02.06.38.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 02 May 2020 06:38:55 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] metadump: remove redundant bracket and show right SYNOPSIS
Date:   Sat,  2 May 2020 21:38:46 +0800
Message-Id: <1588426726-14791-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The bracket is meaningless, so remove it and show right SYNOPSIS.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 man/man8/xfs_metadump.8 | 1 -
 1 file changed, 1 deletion(-)

diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index 7cda0daf..c0e79d77 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -8,7 +8,6 @@ xfs_metadump \- copy XFS filesystem metadata to a file
 ] [
 .B \-m
 .I max_extents
-]
 ] [
 .B \-l
 .I logdev
-- 
2.20.0

