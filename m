Return-Path: <SRS0=Yj0O=D2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B753EC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 09:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6319B22243
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 09:47:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WWWgEM7d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgJSJrg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 05:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727254AbgJSJrf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 05:47:35 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C6AC0613CE
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2020 02:47:35 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g29so5719076pgl.2
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2020 02:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zxjbRyQV5WZRtWwjWHZNUFnqgI5qlvjKeDY7i8UJzMY=;
        b=WWWgEM7dJX8aMg8QV1xcIomcuarB6YJXHDQfJkwqBGJxPgI0IFir2s5NfBgMk2QpQf
         1IytYGhWxlmtisud57fC+Lmlmrydyu4bLf5HyqRGwQKQku6Yh1nN/YZ2g8eX17zw4Wb5
         gL0jYtSu8NCmoxId2zB9P1EYRo7wGQu3dtgTYv62Ef1gSyTut6cZB/Bbj6ZFnOeEx0ls
         rJHScjlN9KLIlZ6rUyPRFqSDnW7L+QkEEua7zkrtZBw74+fHV1XdA9ip6xTMALjPL3qj
         kMGqs8K7zjCOVzcGQ+bmet+LZR72ZV+faKjAqkNwJYYHfE2t2rK4KEOZaqMyzOk2dgQD
         gcSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zxjbRyQV5WZRtWwjWHZNUFnqgI5qlvjKeDY7i8UJzMY=;
        b=WwgQ0j1Bs6KEHTu+wpoDd6YugVyJNsq6WpchJdFEqSjzuLxcCsCTEnsAczkAc6CCl7
         7jkELL9w3yRhYZ6Bw/IyWlZ/3ztmXo8a8jDhSW0FeFXebiriIjtC6QHJgjfodzqBXdBa
         RMG7YjuL+4RA1KihNoOyGo7wtlgfohtCZ5YXrhXUdZ0ZZV/61NOP3ZAMVsJgw2HnqR/q
         PR002Rk5UKvF/x298ZaCmuVXrpMD8ZWWU/pnbhuC65dV47NnRmRFTOzBrEBZBBys+15C
         bWNU10MrV5Ws5RicQDOU+M7CwXYce016HQteKCLfiSu/c9u4gC9yq0aUQGE+hwM5wB0O
         ccGQ==
X-Gm-Message-State: AOAM531tln62RMM3dPbQU3TYe9HLIQjVZnlesbR23RGiNCo+CwGL+Qke
        tpg3bH3ccoNUdxfaabMZ7VEc8Fd/CA==
X-Google-Smtp-Source: ABdhPJyT7P46xT5sWmm1SKqqM8b/AesJcgAXdkxPVnDoGVpOEawMybHwfGDVG05XZJCk5K173DVYNA==
X-Received: by 2002:aa7:9f8d:0:b029:152:28de:812a with SMTP id z13-20020aa79f8d0000b029015228de812amr16304761pfr.65.1603100854974;
        Mon, 19 Oct 2020 02:47:34 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id n16sm11413592pfo.150.2020.10.19.02.47.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 02:47:34 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: remove the unused BBMASK macro
Date:   Mon, 19 Oct 2020 17:47:24 +0800
Message-Id: <1603100845-12205-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

There are no callers of the BBMASK macro, so remove it.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/libxfs/xfs_fs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 2a2e3cfd94f0..8fd1e20f0d73 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -847,7 +847,6 @@ struct xfs_scrub_metadata {
  */
 #define BBSHIFT		9
 #define BBSIZE		(1<<BBSHIFT)
-#define BBMASK		(BBSIZE-1)
 #define BTOBB(bytes)	(((__u64)(bytes) + BBSIZE - 1) >> BBSHIFT)
 #define BTOBBT(bytes)	((__u64)(bytes) >> BBSHIFT)
 #define BBTOB(bbs)	((bbs) << BBSHIFT)
-- 
2.20.0

