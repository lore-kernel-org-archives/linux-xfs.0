Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67389EB64D7
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Jun 2023 06:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjFWGaQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Jun 2023 02:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjFWGaN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Jun 2023 02:30:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963D5172A
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2023 23:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687501767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=M8jDOmxChVtHNpj0ZbP6Rb9FFegsuTlRQ5nsYUjwXTE=;
        b=C9mkI6mX/CACVLFCOMDCzfruV/u4M1W+UhA+NLAsQ9PiJ49gXCf4kIgFfEIx0x2Dmirj2Y
        TwIeoFqVlsbRk2OayGshu+/Q0CGWyZzZrHiIihunR5MEYn8D1mm5a1x3J7xmrVufGBpkcY
        9/3c/vnUum+e2EewEDVII+7Huewii/s=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-iX8av4WdOemqVQec0RpevQ-1; Fri, 23 Jun 2023 02:29:26 -0400
X-MC-Unique: iX8av4WdOemqVQec0RpevQ-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-666ee6aeddbso72942b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2023 23:29:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687501765; x=1690093765;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M8jDOmxChVtHNpj0ZbP6Rb9FFegsuTlRQ5nsYUjwXTE=;
        b=GmUi2NpPMYFHYDnr6cGIBUgHyOntOEOr/2O7h7FhRren+IrzSniEQKWy8seV3AyHSh
         SuDDdo4c9GLwEkH3/PptXEkbzLsUYUZOQi9xVTMYyzkqHKJLbT+UeDscKSLDsEt7EC/0
         oQFAYjAQmIQ1m6HelQ1C72ZtaMxbcDK4dm55IrO08t9EN4fbBJCEjVEsCEVdOLOPQhNf
         l9SMHYsthgIUa1QEKPIAANFTNVbsxnsH7ZXz4PZgYGvkxMOdGy5X6VSOqA7GvQousluc
         AxGS45ajaW/8tawDfBs+9kYzavd66Zqi09jt8uMkvBKyzxax4zzxNhODUWULTR39XATx
         xCfQ==
X-Gm-Message-State: AC+VfDwSBkALVEJX+Aqm6Uzh+79eBo+oGB9cno1DZj7NvCv+eCxKfSgc
        Mse0KmZ0je4kZJNlLT/n2SQPMdE1uCm60GMgUdvvoO+OrNcoumtBJUKM9sYrQCtLZf9i6QiEBrA
        cFM6y2nvDdyuXwaHB2i32vR1CPhC+lvOlHlwnjE+wLm739ry6d5EHVuW/Z77Y46PWJXSFbVCgut
        zkvaVM
X-Received: by 2002:a05:6a20:430d:b0:11f:38d4:2df with SMTP id h13-20020a056a20430d00b0011f38d402dfmr19427496pzk.20.1687501765006;
        Thu, 22 Jun 2023 23:29:25 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6SAiDdF5M9fqW9pyT+7Lgt5IUl7eHWzOQ/NamPYtqyzkFsH+fcIjoHiJ1QidnsDjjgO3kBvQ==
X-Received: by 2002:a05:6a20:430d:b0:11f:38d4:2df with SMTP id h13-20020a056a20430d00b0011f38d402dfmr19427481pzk.20.1687501764674;
        Thu, 22 Jun 2023 23:29:24 -0700 (PDT)
Received: from anathem.redhat.com ([2001:8003:4b08:fb00:e45d:9492:62e8:873c])
        by smtp.gmail.com with ESMTPSA id x2-20020a170902ea8200b001ae3b51269dsm6335879plb.262.2023.06.22.23.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 23:29:24 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH] xfsrestore: suggest -x rather than assert for false roots
Date:   Fri, 23 Jun 2023 16:29:18 +1000
Message-Id: <20230623062918.636014-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If we're going to have a fix for false root problems its a good idea to
let people know that there's a way to recover, error out with a useful
message that mentions the `-x` option rather than just assert.

Before

  xfsrestore: searching media for directory dump
  xfsrestore: reading directories
  xfsrestore: tree.c:757: tree_begindir: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth' failed.
  Aborted

After

  xfsrestore: ERROR: tree.c:791: tree_begindir: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth` failed.
  xfsrestore: ERROR: False root detected. Recovery may be possible using the `-x` option
  Aborted

Fixes: d7cba74 ("xfsrestore: fix rootdir due to xfsdump bulkstat misuse")
Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 restore/tree.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/restore/tree.c b/restore/tree.c
index bfa07fe..0b65d0f 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -783,8 +783,17 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
 	/* lookup head of hardlink list
 	 */
 	hardh = link_hardh(ino, gen);
-	if (need_fixrootdir == BOOL_FALSE)
-		assert(ino != persp->p_rootino || hardh == persp->p_rooth);
+	if (need_fixrootdir == BOOL_FALSE
+		&& !(ino != persp->p_rootino || hardh == persp->p_rooth)) {
+		mlog(MLOG_ERROR | MLOG_TREE, 
+			"%s:%d: %s: Assertion "
+			"`ino != persp->p_rootino || hardh == persp->p_rooth` failed.\n",
+			__FILE__, __LINE__, __FUNCTION__);
+		mlog(MLOG_ERROR | MLOG_TREE, _(
+			"False root detected. "
+			"Recovery may be possible using the `-x` option\n"));
+		return NH_NULL;
+	};
 
 	/* already present
 	 */
-- 
2.39.3

