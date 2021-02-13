Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05436C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 15:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2E6164E39
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 15:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhBMPZj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Feb 2021 10:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhBMPZi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 Feb 2021 10:25:38 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B36C061756;
        Sat, 13 Feb 2021 07:24:57 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id b14so2589634qkk.0;
        Sat, 13 Feb 2021 07:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cn5DRnKZtx+N/DSDNbOr35OtZ897mnYK7r3wNoPvGrE=;
        b=mBEe7x8c7sg1v2IOuf7iKnCnu/OrkoNoI3jLoweh/k6aEQ8Q6BIeY41h91NFmHB6Sn
         E9EUPaynbDYubK0BbamxIRmbBRKW5DO5BmZUyGw4epYc009pgCkl4WaAn6dixmGl9FeT
         HsBJ1Zys5ax9XGIEaPm7t079uQ/kj5vmlDUVIl7LbF/Xvg4SeRcfmiNFuVnRpvqQIBQZ
         p9bSbG+3L/i4vr1wG0lyCUIeJZX8AsP7MIpCuOQTvxnCrg1+5j1PSS3JDHJSxTiPouAu
         uJmOAbOPkOzqCgvMyvHHKU/01l7u34PAcjCm/NMRDViHW9XBa3SQCVcDxo8paxlcOIbh
         p92Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cn5DRnKZtx+N/DSDNbOr35OtZ897mnYK7r3wNoPvGrE=;
        b=f9mNmKvl8JkKXBks5ZGxSg7c/Gt/f3xmH5TZKDzyRVssuOIiaVDY4hthNo1BGFVyyK
         CoeJQBWs6mOAF7KoN65qhi/OY/pYlkmZlMVbLykm01LmnqEnaspRJL3mUNHc7EJ7zTOt
         HUIhBH9CvsNRssTuU4y304XW8GNbIqZ0o1heD4TwTvyQWjRtWOCp5VpP54CFJ2JGgVhp
         Vw51QH0q0K1caogXqVqo8TCMAPSKaXvCbZUzYJB+2VL+rGUCDZrLvQ2lxFJgpCGBU4t/
         WcKZ0sMxuCjfEgeUTepctkwszpwcPOEPg3EpeBHf6gZjYZgRC0rBIbU1azYRMazuZdhg
         CI8w==
X-Gm-Message-State: AOAM530W5Q0MEfyMseU5xQnoyKn/DMEolvtJUBoXXk3KWVL7M6Glwrm1
        +Vq2LWcBwFF0hKS53ehBD+k=
X-Google-Smtp-Source: ABdhPJzW1XzZh5FgqguEfGBJYHJROuJiGxy4PoqBqhXpi5nlPZUp86aVInua2ljljbvn6FPdH4EO4Q==
X-Received: by 2002:a05:620a:204b:: with SMTP id d11mr7528350qka.429.1613229897120;
        Sat, 13 Feb 2021 07:24:57 -0800 (PST)
Received: from localhost.localdomain ([156.146.55.129])
        by smtp.gmail.com with ESMTPSA id q3sm8364417qkb.73.2021.02.13.07.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 07:24:56 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] docs: ABI: Fix the spelling oustanding to outstanding in the file sysfs-fs-xfs
Date:   Sat, 13 Feb 2021 20:54:36 +0530
Message-Id: <20210213152436.1639458-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


s/oustanding/outstanding/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 Documentation/ABI/testing/sysfs-fs-xfs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-xfs b/Documentation/ABI/testing/sysfs-fs-xfs
index ea0cc8c42093..f704925f6fe9 100644
--- a/Documentation/ABI/testing/sysfs-fs-xfs
+++ b/Documentation/ABI/testing/sysfs-fs-xfs
@@ -33,7 +33,7 @@ Contact:	xfs@oss.sgi.com
 Description:
 		The current state of the log write grant head. It
 		represents the total log reservation of all currently
-		oustanding transactions, including regrants due to
+		outstanding transactions, including regrants due to
 		rolling transactions. The grant head is exported in
 		"cycle:bytes" format.
 Users:		xfstests
--
2.30.1

