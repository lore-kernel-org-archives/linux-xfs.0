Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB32C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 02:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7459610FC
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 02:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhDBCuK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Apr 2021 22:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbhDBCuK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Apr 2021 22:50:10 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CA5C0613E6;
        Thu,  1 Apr 2021 19:50:10 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id g15so2780383pfq.3;
        Thu, 01 Apr 2021 19:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SGcEPtxoU/jjvLy7ZGCbwMzbGMR9tMGIZQSoaOp3l48=;
        b=jJgYdaKYE7W2Rq18EV3J9YPYKx+7CBODxnfiWvKISql7ZMXfR91WEhA0+xbfGvJ6jr
         4Nd10eQxtCbbvuupHKyirQa34hyxzPes+jj/a/Bg9lPdLqNVlFUfAVBSkqCK15GliTf9
         qd9ZauBnVcShbc9VjzfYK37H9NBeqwRWgVKpQvZIOfgM+/VszUO8bW5oBpwgDKcyQDv7
         z63zRiieOmRvKSS/DzgBDGYbtLCWYCU2fQ4Fkf2L6jbKBxEHhSs5Az9PhAoExdmuWYd4
         36DH1Wl/+jpZA34ytvr373CyOFAIKaYjnY76orLUWpuoGq934RbLekzD6pM6S83RbrDu
         1D+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SGcEPtxoU/jjvLy7ZGCbwMzbGMR9tMGIZQSoaOp3l48=;
        b=F2GSMTSrT9ZI2H6yuoWI0n6MMetZzeXNUN0wZSE+KHlgXjHA+CDc0q2LFx05HQeMbd
         L6GVjKGIx0bc2Djojq/dHrGB0tZzBaRoARv5cv7b0XjogP0yhvlsayxuK8GVVTOZxyzo
         2MdMgo0UVtCa3ZcBKF/k6O+Mfu9grPDVpCC2+XbyNJKL9PSKJ1vIcFhoQAFa6IyfjAMG
         e/GFuONNajW3Aks+SaDGz8KGdwdpnH2bxiXAO6Gy6EZbvQhMwZMo6f/iVduCZBCxdUON
         Vfu3PuNr1ad8gLU54gyFHSN2dpsRHodg+uc5R+Bh1bFxCD4584DIZyvITSwG8KBNR84/
         pflA==
X-Gm-Message-State: AOAM530VB+rraDLgxcGE+ramFiU5qDtw3FhqVWsqfiq7z3SW/9zEod22
        7wzM5PoATIZrwQt8T5PpkcZik+c31h8=
X-Google-Smtp-Source: ABdhPJz7+maDiZUHEPyWjBXRTlF2Febws6vnmjTWgYN/CEGkKGWswMuVNeXkli4UH1D6sBHD9u+3QA==
X-Received: by 2002:a63:da04:: with SMTP id c4mr9947002pgh.144.1617331809166;
        Thu, 01 Apr 2021 19:50:09 -0700 (PDT)
Received: from localhost.localdomain ([122.171.33.103])
        by smtp.gmail.com with ESMTPSA id i14sm6720796pjh.17.2021.04.01.19.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 19:50:08 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V2 1/2] xfs/529: Execute chown on an existing directory entry
Date:   Fri,  2 Apr 2021 08:19:39 +0530
Message-Id: <20210402024940.7689-1-chandanrlinux@gmail.com>
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
v1->v2:
  1. Fold patches 2 to 6 into a single patch.
  
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

