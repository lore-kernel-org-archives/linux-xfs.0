Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F23C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 06:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCC8860F11
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 06:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhGZGDD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 02:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhGZGDD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 02:03:03 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2020C061757;
        Sun, 25 Jul 2021 23:43:31 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso6816651pjf.4;
        Sun, 25 Jul 2021 23:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/iaCvaLOpkt/lr5zM77dZJdmTi3kdFvmuc5yLBJHjUk=;
        b=nqhVB/iNIR4tMmbkxvrm3+C+6xLEJo8GxAEXJJCYWuhoBoVetzFtK0T547DWVXX/BD
         lNFcz/id0wyq//lBh4AoBR8uBXuw/lvVyUaY0rhHrsEUM1tn0n6+MU5sJdR8Gv5J+4eJ
         gTloSOgAniMIkYhfnpqc8d0s/cMMFYUDkGE6Eta8vjMzPLTUNrSCz1GbLNfpGBHA4SSR
         mWkc8U3UaHVDoFHKKExOnS2/fQOvWxgdTVjpRqh2VwtvVITXFD5umCjIGy3/STnwpq+A
         b0bEUMGvsBIkur0V/dOQF4RHLVaH6zH7oqKHrzPSObif2kH+Eop2FVLTc60Va1pktY3q
         2hhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/iaCvaLOpkt/lr5zM77dZJdmTi3kdFvmuc5yLBJHjUk=;
        b=OB0YKJreG/6BLtG6pLygGwUTXsdpdJkAFJj/kw2S9Dft7jJxTuq8ZfiZjPmSiyuOs8
         yeR2b+W5iEI1++ra1xP0xEHsEC4p5UwLt0Trb4wNzASU/0sCCLSIKeSb2mt4D3tIHAEn
         bDRrWEHfwr3yyxOTLli6r1UB60QnLhbF3AnSmDogdvtTXg3oZutS8kh7sbhpxY4XGbhI
         QP5H88YRspEfpLRIcr6+1e0p52vfdkspxXkvpqaLf1Jh4zfAW65w1y+yCdwPBHe/Jv/b
         vzGcgMQHFk2YYTzhlNUuEyTfAbEIu1/b5+X/LW9ryksamDmrHzflhMxdG/xVceU6xn1Z
         YLKw==
X-Gm-Message-State: AOAM533rlbAPv5Yn3Q9Yg0rVkaKj2oQqIgSpJ1ViR2ZhC8D4riEo4sqv
        PEqDTmIY+iRZWgzSz2D5wQvaxlHjGcQ=
X-Google-Smtp-Source: ABdhPJxqJjXaznHGLkQOkVaG4NjoE1IVDJZmcJVrPzleQa5sE1qfBcnvi8p63eCV7b8/6MbVZ/vgAA==
X-Received: by 2002:a63:1960:: with SMTP id 32mr16915820pgz.86.1627281811333;
        Sun, 25 Jul 2021 23:43:31 -0700 (PDT)
Received: from localhost.localdomain ([122.167.58.51])
        by smtp.gmail.com with ESMTPSA id c11sm44411172pfp.0.2021.07.25.23.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 23:43:31 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs/530: Bail out if either of reflink or rmapbt is enabled
Date:   Mon, 26 Jul 2021 12:13:13 +0530
Message-Id: <20210726064313.19153-3-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726064313.19153-1-chandanrlinux@gmail.com>
References: <20210726064313.19153-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

_scratch_do_mkfs constructs a mkfs command line by concatenating the values of
1. $mkfs_cmd
2. $MKFS_OPTIONS
3. $extra_mkfs_options

The corresponding mkfs command line fails if $MKFS_OPTIONS enables either
reflink or rmapbt feature. The failure occurs because the test tries to create
a filesystem with realtime device enabled. In such a case, _scratch_do_mkfs()
will construct and invoke an mkfs command line without including the value of
$MKFS_OPTIONS.

To prevent such silent failures, this commit causes the test to exit if it
detects either reflink or rmapbt feature being enabled.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/530 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tests/xfs/530 b/tests/xfs/530
index 16dc426c..669b061d 100755
--- a/tests/xfs/530
+++ b/tests/xfs/530
@@ -39,6 +39,12 @@ _require_scratch_nocheck
 echo "* Test extending rt inodes"
 
 _scratch_mkfs | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
+
+_xfs_is_reflink_enabled $SCRATCH_DEV && \
+	_notrun "Realtime device cannot be used when reflink feature is enabled"
+_xfs_is_rmapbt_enabled $SCRATCH_DEV && \
+	_notrun "Realtime device cannot be used when rmapbt feature is enabled"
+
 . $tmp.mkfs
 
 echo "Create fake rt volume"
-- 
2.30.2

