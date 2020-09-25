Return-Path: <SRS0=2WGG=DC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22193C4346E
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 02:43:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC79E20888
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 02:43:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ui+idQl+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgIYCn2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 22:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbgIYCn2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 22:43:28 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FCEC0613CE
        for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2020 19:43:28 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id l126so1762470pfd.5
        for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2020 19:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PQ6vzBYJpDyQAloIihibI2K7q7lRpVVfaSwL+x8mY0c=;
        b=ui+idQl+dZSU5xmNFORuB3+g5CYNj9v3XhpEkZ9OMGLuns2VVbB+vELsdpMWmhST7I
         Npu5JsX7i4dIbjAd07UI/BY+9mjdoG3NgNDGiUkElGvYg+12VfBpwBRazKzZ5LIMDsPb
         vw4FgW7qdfvpbcut1zC2pLL5A/c8cmfebIdlaFUaS4rrk3eed2vahMLKM59yHYjY9ZdB
         ZxxSqMvNSIOiSg2QZCbBoSZM6Y27084LBfkt3TuQS+3MLzsgPBDWYo/0QOFqAj19C/2A
         hGGlLJQe5i1Ac43+Nh+aLy04WhIeCOTvbipWfECg0cvR05YE2YsRGLCJ6K4jO71RRjw+
         /sIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PQ6vzBYJpDyQAloIihibI2K7q7lRpVVfaSwL+x8mY0c=;
        b=PXEs+lnY7z0s0RG24mH217jxrhZj1ozIpmUVBp5vjQk3uwbtxVbG/T8PZZE+6nDCBh
         fWuWSiWstVa6l05AbCQTC5wdKMgqnPWwITm0vXq6xmeDzn53RCWzTCG19m7yCw6fuw+N
         Scjitr8B//7f07G27LIOTgxD3tq4o0bUwsBalpVCielBsxKu/lgTmwRbSOr3j86H8cr3
         p+R08AuGlX9+WUeghmzFO5Hhk5xt1ZTj+du6FFLEyk8B1GybNei9Y2jRtoWCMnayvHIi
         qTP2NwRY0FbWn65f9K628xdt8GLw6B8VFTfDR5istge/F59at+WXhbVJynNLLLoiVxKx
         KT3Q==
X-Gm-Message-State: AOAM532Adgul9LT4mZYDbTwE7n04lVkiXVIjW2I9vnRzgO/ek6bw42JJ
        rnYsw0EYI8TP3NXeeL/rwBo+7gqbJVS3
X-Google-Smtp-Source: ABdhPJyYctKU/ou5MchNK4ks/yW3MDmRk5Vg6FhoeiDIvvditkxcf2Of9aJvXNp8Nr4LpgQPjUDEug==
X-Received: by 2002:a05:6a00:15c8:b029:142:2501:35ca with SMTP id o8-20020a056a0015c8b0290142250135camr2078027pfu.42.1601001807438;
        Thu, 24 Sep 2020 19:43:27 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id u15sm523360pjx.50.2020.09.24.19.43.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Sep 2020 19:43:26 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2] xfs: directly call xfs_generic_create() for ->create() and ->mkdir()
Date:   Fri, 25 Sep 2020 10:43:21 +0800
Message-Id: <1601001801-25508-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The current create and mkdir handlers both call the xfs_vn_mknod()
which is a wrapper routine around xfs_generic_create() function.
Actually the create and mkdir handlers can directly call
xfs_generic_create() function and reduce the call chain.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
v2:
 -add the necessary space.

 fs/xfs/xfs_iops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 80a13c8561d8..5e165456da68 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -237,7 +237,7 @@ xfs_vn_create(
 	umode_t		mode,
 	bool		flags)
 {
-	return xfs_vn_mknod(dir, dentry, mode, 0);
+	return xfs_generic_create(dir, dentry, mode, 0, false);
 }
 
 STATIC int
@@ -246,7 +246,7 @@ xfs_vn_mkdir(
 	struct dentry	*dentry,
 	umode_t		mode)
 {
-	return xfs_vn_mknod(dir, dentry, mode|S_IFDIR, 0);
+	return xfs_generic_create(dir, dentry, mode | S_IFDIR, 0, false);
 }
 
 STATIC struct dentry *
-- 
2.20.0

