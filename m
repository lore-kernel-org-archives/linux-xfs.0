Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9708CCA47B
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jul 2022 07:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiGEHjv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 03:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiGEHjt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 03:39:49 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1CBE13D23
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 00:39:47 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 23so10680128pgc.8
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jul 2022 00:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HYdj5hg0Q8e02RlWnqWo6ufpWuEGNSFpJiZs2krzB4g=;
        b=WvSzj3LBmn/3GuHHJr84CG+muzceZw+r4Pz2BYI6AWuQPPVIigmZ3vvjUIfMKBtZ80
         JbA+IKgcUc9ya41MUrCGzINz6zGleY+jkp7AbypsmncLVEdiYbLjcZkQUkmlBeK5GFEA
         Nc1YUf071rDjZp1gTxfYJWSdmAHlwtxHXXsRQmDzCmlaV7KeF9U7u3mKRGCxgsf4grs5
         TwwVEQ38Bn03LWq1ASqyXa4sMCTSgSpaYdtU5LkBMpJmhmzU3uQj5zbySrLF9l1FzAA2
         3QEu8RqP4eUVjddoOvODi2FmQLP3IZEGxg2k4L0/d744Ov9Tf8qzkhuMxaZlQs04eXee
         VjVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HYdj5hg0Q8e02RlWnqWo6ufpWuEGNSFpJiZs2krzB4g=;
        b=Pc3hTYZjQZX15mkqljHtbPI/wT56dESlRb139KbianQkupo83zsAus0RTX9gML1GGh
         aiV6EpnAYZNKHy9rtOUGdK27Qu0oxiev31y7NKMdbVuuYBISM3tIconDmVb8gM3L2QSf
         eeTjAL4cbDfduXFltLByjyzrnJhYK5q9TgovecTFWVNog44HA2SGobvv576uqiw7POD3
         1I4+/X9Y+N1OmFNxp/V+kZ7wsmvdvRhpby2ssgYQ4oQCbV2GcbxQElc4LqN0DtcRt+mL
         BXndXqa7QgBsS3cZHsiXQrcX9ESAj59LC8GU8yT578fwpHSwyTNOqgYO5Q6N7JH/HJWb
         nOrQ==
X-Gm-Message-State: AJIora+F/+V7SysH1//XOmOOvkcxwOlns/N/u2XrhINg+ZDEIIennSWn
        F37CjTkFzz6ZCM6z84nK4QOMy34FrVU=
X-Google-Smtp-Source: AGRyM1sJwE2D62kDXkxvJYg+6QdLBCm9GELJAcdpd4M/9sCob/uxPYCzG0YJLx6c1gmtOfkKx3Ay3A==
X-Received: by 2002:aa7:86cd:0:b0:528:955f:1842 with SMTP id h13-20020aa786cd000000b00528955f1842mr2022691pfo.55.1657006787115;
        Tue, 05 Jul 2022 00:39:47 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-113-80-70.ap-northeast-1.compute.amazonaws.com. [13.113.80.70])
        by smtp.gmail.com with ESMTPSA id w14-20020a170902e88e00b0016a25ba1f46sm5516197plg.256.2022.07.05.00.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 00:39:46 -0700 (PDT)
From:   Zhang Boyang <zhangboyang.id@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     sandeen@sandeen.net, Zhang Boyang <zhangboyang.id@gmail.com>
Subject: [PATCH] mkfs: update manpage of bigtime and inobtcount
Date:   Tue,  5 Jul 2022 15:39:19 +0800
Message-Id: <20220705073919.37251-1-zhangboyang.id@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The bigtime and inobtcount feature is enabled by default by
1c08f0ae28b34d97b0a89c8483ef3c743914e85e (mkfs: enable inobtcount and
bigtime by default). This patch updates the manpage of mkfs to mention
this change.

Signed-off-by: Zhang Boyang <zhangboyang.id@gmail.com>
---
 man/man8/mkfs.xfs.8.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 7b7e4f48..cd69ee0a 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -211,7 +211,7 @@ December 1901 to January 2038, and quota timers from January 1970 to February
 .IP
 By default,
 .B mkfs.xfs
-will not enable this feature.
+will enable this feature.
 If the option
 .B \-m crc=0
 is used, the large timestamp feature is not supported and is disabled.
@@ -264,7 +264,7 @@ This can be used to reduce mount times when the free inode btree is enabled.
 .IP
 By default,
 .B mkfs.xfs
-will not enable this option.
+will enable this option.
 This feature is only available for filesystems created with the (default)
 .B \-m finobt=1
 option set.
-- 
2.30.2

