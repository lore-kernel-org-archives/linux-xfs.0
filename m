Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 428FAC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 14:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED1DD61A2D
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 14:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbhCYOJn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 10:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbhCYOJP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 10:09:15 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D7DC06174A;
        Thu, 25 Mar 2021 07:09:15 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso2764514pji.3;
        Thu, 25 Mar 2021 07:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eaB90L146PD7SZTq3L/Wa2Uewelu5u0Gwdi2oCaULaA=;
        b=O9k7vYv8c7NJnq0aY5xMAjUplsbabbMkbhF+Gs4kUIUMFywMn4N76kmNfOCl+bJZYD
         19Ujl20IVKO46sLL8453B44wS3Knbkq+J/sxbpLsJ6A6cjOgHB/W1janMFIMdb8vnbQE
         EAaCoztlt83cAdHYOdV90kPerzrSzTxPgHa6+wAI92CGSIfgTW44dubS0TKu9fJNQeuy
         UY+y7jGxTNHxblitLFIgXLvHXb60lBgRXXeVKk+mJYqAbVFhY4PtecJuZ1x3DmLqJCBW
         MX71paKFI2qqoysgLNUtBMPPDEYrXun6+mn/T8i2qkS34dLaGFF+Um3veRJvQMjYXJEV
         bMFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eaB90L146PD7SZTq3L/Wa2Uewelu5u0Gwdi2oCaULaA=;
        b=Pt6yuXlSP9en3rLAyi0wLH3/j5O4loUdppNGAL/qMg2G4zwPhwD7lud2hxrgWrdvfm
         0gX9tUeFx6TI6m5thpxNx/n0jS6fiCzjT4Up2CLpCfsv2wCTHtpcQe0lWXxNA2wfLOmm
         7R8qd1FeOkg5+nrlfQQtwEtpCnxGhMN+jaYbJQzsrbpNdbyWrLUH7DjR50X9f03GaZS4
         0bYbSd3XOOzpCPUSYAmaAhk2gWvVhCnpXl7yyOYnv8xB9z1ltdB4J8J3Dv/SCv34MJMq
         lRg/iXP4ogmoEqh1pRsLPiOZn7rsBhUluCMjGVdOwJgiKRldyKgymmWdJIf8lSo2RC42
         KaTw==
X-Gm-Message-State: AOAM530SvGAIAU9ByEqsbZtNg4hZk1EpvRHB1HfBFs2GzKIpS3dN8qJH
        Fq0+74sJejIrykPoUFJ33RiwOeK9r5o=
X-Google-Smtp-Source: ABdhPJw9ns9gKRaelxJMsBX5LSM5svuHRGN2CZMRUhc4J/k2b5xIT7h0we2kxXVPdRA/GUMjy0LUxQ==
X-Received: by 2002:a17:90a:c096:: with SMTP id o22mr9089149pjs.119.1616681354646;
        Thu, 25 Mar 2021 07:09:14 -0700 (PDT)
Received: from localhost.localdomain ([122.171.175.121])
        by smtp.gmail.com with ESMTPSA id v13sm5673030pfu.54.2021.03.25.07.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 07:09:14 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>
Subject: [PATCH 1/6] xfs/529: Execute chown on an existing directory entry
Date:   Thu, 25 Mar 2021 19:38:52 +0530
Message-Id: <20210325140857.7145-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

chown command is being executed on $testfile which is actually deleted just
before the execution of quota inode extent count overflow test. Hence the test
was not getting exercised at all.

This commit fixes the bug by using $fillerdir as the target of chown command.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/529 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/529 b/tests/xfs/529
index 778f6142..abe5b1e0 100755
--- a/tests/xfs/529
+++ b/tests/xfs/529
@@ -150,7 +150,7 @@ nr_quotas=$((nr_quotas_per_block * nr_blks))
 
 echo "Extend uquota file"
 for i in $(seq 0 $nr_quotas_per_block $nr_quotas); do
-	chown $i $testfile >> $seqres.full 2>&1
+	chown $i $fillerdir >> $seqres.full 2>&1
 	[[ $? != 0 ]] && break
 done
 
-- 
2.29.2

