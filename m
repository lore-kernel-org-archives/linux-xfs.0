Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B35C4363D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 14:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F6932311A
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 14:30:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nx+S+hcf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgIXOaY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 10:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgIXOaY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 10:30:24 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C1CC0613CE
        for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2020 07:30:24 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d19so1791076pld.0
        for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2020 07:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=i5k3a/8VhkZ2yM5Xi3vg718tPLh7mrMVH9TZsdEHrQk=;
        b=nx+S+hcfpK2IJeoTk5Ovb+yU2DFL4PrItpLz0Fj34NFxgXXUJ/w5YCK6TSK9xv+o9l
         oj0WSbZKyHbyn7cc33Gnnzqt8x/3N6EMAcPER2AZklAaV2m+TFbYUhjnsodd86h0TZ56
         0K3xLJpEuzK+3zmZUrFxqweyDyyrhvotOPy5iMv9nvhc7MZ5w0B2Gb0qodhimrpUAEzb
         HBsTIdWvkR+gluZiIrs9IEqaQdiPmWazF8SbxO+8CdPINbmPu1jMORJLOOQWmUIG7f2u
         ugZaqXM7RB/psnqZmKl12+cmkoUx3+dyNkXI6Xh/KlWSg29j674fvNaw/OlQiowr2aXl
         vtLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=i5k3a/8VhkZ2yM5Xi3vg718tPLh7mrMVH9TZsdEHrQk=;
        b=uRg/Qjg7fJa+JctBFzaO5XeUtPEpkz/hsTOgTzS/Dob6kO5SrgiVSn50+KruVoUJLl
         PiMmNUzJMAoPxX4dV6aZ9FIAN6A6s9rDwAojJcLBjB9Gshj2F8M4OzGRkf8TqVMuB6Kc
         803L6I2KmK2CaMeUZNgH15HATZfggq55LWKqDzzIKzUyWF+OGdPrAgY9Uns/wmtGjOrr
         rLlf7tIAGqMV4Yvs/7P9s0Df4+C48F6BFNlJvtxW3Gpp/oj9j+Mq3Q0YPexoQnH1TWo4
         aJAJjLzziiNXi7q/NOZgXpjMVsd/0U58g8wXFVNGveLY95LczRbMRQ/g13O3SoHU3xEU
         jKGg==
X-Gm-Message-State: AOAM5319u3Eb48qMtaGP4Hh9BulwTF0h97OSTtp/B94RI1bazaGiuX/I
        jfkEYxmoqnCOF7kE/nWXhx4bkBzVlA==
X-Google-Smtp-Source: ABdhPJxBisJv67msFC+smxT8SD/2RvZ/FhqDxlV7ariFfzw4u8Qis0CKUs2yrJa79/PoJsgYXScbfQ==
X-Received: by 2002:a17:902:8bca:b029:d2:42fe:21da with SMTP id r10-20020a1709028bcab02900d242fe21damr4700987plo.31.1600957823216;
        Thu, 24 Sep 2020 07:30:23 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id f9sm2539051pjq.26.2020.09.24.07.30.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Sep 2020 07:30:22 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [RFC PATCH] xfs: directly call xfs_generic_create() for ->create() and ->mkdir()
Date:   Thu, 24 Sep 2020 22:30:17 +0800
Message-Id: <1600957817-22969-1-git-send-email-kaixuxia@tencent.com>
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
 fs/xfs/xfs_iops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 80a13c8561d8..b29d5b25634c 100644
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
+	return xfs_generic_create(dir, dentry, mode|S_IFDIR, 0, false);
 }
 
 STATIC struct dentry *
-- 
2.20.0

