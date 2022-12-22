Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45674C10F1B
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Dec 2022 01:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbiLVBxg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Dec 2022 20:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234761AbiLVBxe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2022 20:53:34 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27160248E1
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 17:53:31 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so434975pjm.2
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 17:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ONzAnABRY7ilpXpn1DAhpGpO+unnjPo/NEDhe6rYfvo=;
        b=o728uvYnEFcyhEer7ofjjXhEKlE+6DXTstm8pabC5NUtv/OU09B+7RWBbG75TPkMnD
         VAV0OaAY4bps99P7t2BDKpuQ0RIFSvfddQ5I/YjcVDdZ4Hs3jzHE6MyXO0X9EMyug0IH
         E37vjfLRLynzN202e5mMyMa/K0AwEhuwDw0BiJAMaAK7rHRGgsggZrqMHPdiv9Gq+KX8
         pCDPDjpQtNr9MkhMSKci/Np3GikOvlCJ9IC4qBW/eeKUfP6QYliodv9uRjECTR+2lRL4
         /rMiA7CKqZdBmjb+BfSP+Zn+1jX38LEVvOSHv9lMlXveV07S3kAp6pzb9aB+ehTXzDhY
         qUpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ONzAnABRY7ilpXpn1DAhpGpO+unnjPo/NEDhe6rYfvo=;
        b=F+r/gc8lrggEfrmjESiRmyB1fXv2OK4L+P2D14LH4ZnzYfL96LQH2dnMpaYxfp5EDL
         R6fVXUSQ3ToGNiJholGyQbySMCGzC5O3JqvS3AHMdIXobwZHP2iwzU6yo2J4BAC1G1eV
         zmVXBt81A3JOrCdadTxEPaSfCFk7fdc3yho1XnH1aUCasGFvv6dcqwqzb+owriXpHPcL
         Zz9OglOl9SzR9Wb3CCmhlC1my3w87sCG10aSKcumA1LAWmwyb/Sx8YlcHiHy99zoaAbc
         ELK1pbyBv5EKVvA+ZqQHWisw94QM2ceFMNA0gXgks9z1Fjb3MSdRL2Vcfu/aA5iXmXhv
         BvUA==
X-Gm-Message-State: AFqh2kopFSZXQs7ik19QR1XhPo/ut2uyKCcUdHNR8tcUbtL3MlHTJQLo
        JKUbGzioYSO81PvJgG6KJ1ynIKiu2Ek=
X-Google-Smtp-Source: AMrXdXvhKjadil3wx7eXFYMae7kM7n/wqGiQmbYEKZyCNWhgTcUOAhudONpK5qGGVxXGO8qX/w72Qw==
X-Received: by 2002:a05:6a20:3d1a:b0:a4:b2e4:c561 with SMTP id y26-20020a056a203d1a00b000a4b2e4c561mr6651919pzi.51.1671674010852;
        Wed, 21 Dec 2022 17:53:30 -0800 (PST)
Received: from apollo.hsd1.ca.comcast.net ([2601:646:9181:1cf0::41f2])
        by smtp.gmail.com with ESMTPSA id f10-20020a631f0a000000b004790f514f15sm10405116pgf.22.2022.12.21.17.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 17:53:30 -0800 (PST)
From:   Khem Raj <raj.khem@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Khem Raj <raj.khem@gmail.com>
Subject: [PATCH 1/2] configure: Use AC_SYS_LARGERFILE autoconf macro
Date:   Wed, 21 Dec 2022 17:53:26 -0800
Message-Id: <20221222015327.939932-1-raj.khem@gmail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Helps define largefile support on relevant platforms

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 configure.ac | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/configure.ac b/configure.ac
index c206e111..79aefd2c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -10,6 +10,9 @@ AC_PROG_INSTALL
 LT_INIT
 
 AC_PROG_CC
+
+AC_SYS_LARGEFILE
+
 AC_ARG_VAR(BUILD_CC, [C compiler for build tools])
 if test "${BUILD_CC+set}" != "set"; then
   if test $cross_compiling = no; then
-- 
2.39.0

