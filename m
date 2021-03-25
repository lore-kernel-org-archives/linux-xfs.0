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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C53AC433EA
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 14:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCC4F61A2E
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 14:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhCYOJp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 10:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbhCYOJY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 10:09:24 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B30EC06174A;
        Thu, 25 Mar 2021 07:09:24 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id f10so1882195pgl.9;
        Thu, 25 Mar 2021 07:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DC5g5ebjEu4icrsUDPwfgCtRYs/q1+XpwvMS3l0pOOc=;
        b=JdAFkH0kIIOmk68RBUvMIFSxnGu5/wINE/xvjqtwTalCmgxVDhZ2x+b9S5VTlIdaWe
         CwFLuZHarMA0l6fbou1lIY1Cq8u3G/+9u9L/69QYqLpy+KqUXYvbubFbEoPKppI5ZWH9
         3/QjrE1B+zwYkVg9ZHryNIhhPjir0F1Gxj/kdtd9gDd8Q9HNjXKOMXUa7FA7igGyW/q+
         rnrfs+TdSaBOvGJobq7CPchhcd2q10yPw4uZxCzYaEKUpmftMQ9kA094fIakTHNta2HV
         ZHwMaarOowX4BCPlv+KMCITqH+lHfaYs6grsJZEbzynAvNKtXkemzNKalVIr+uhCNqZ2
         pzZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DC5g5ebjEu4icrsUDPwfgCtRYs/q1+XpwvMS3l0pOOc=;
        b=B9rFkoa76ISbOjI1RR3KylXURtIZYvxlVellSfbzdaeJouL4T7KObdGbAfWlHV9o4B
         2c9tfJNXzxEcozYRlysuNxJ2SdhzLb7rYQC+1ky+QpcSOanECpdY3PJD5out3TygJTpi
         BQ3SvBMYoYvEvxTrch+WF5cdUJgaTgckQYuetSpbXDMigFtENpSC2P23Tr4FcJtTJ2HK
         jSZOW84vxn0ibMLt/B7f2F4w0j5NLq5HBlKBt9sRIyGGRoL5uQF83lmt0wcn8cp2SCaA
         q75QNI6Cin61/lvW6sPU8XDkN99EgvtL0ZKHxpGc7TZuOCfJ5A7TVXfomYWWTM0WUhm3
         UW9w==
X-Gm-Message-State: AOAM533gXmmzOdo3nnuCuYEkFvEmdl1u7hHkRer0yx9bj/a89vyhlWcd
        Ig6/5u6LqhK7+tftV7djzmDLpX59RdI=
X-Google-Smtp-Source: ABdhPJwuATbyiHuXPjj8nu05D25okTqL0zVlykrT3LRA00z1NOsN2RX0lkojVqMZSAEQ022t0di5ng==
X-Received: by 2002:a17:902:b60b:b029:e6:ef44:5231 with SMTP id b11-20020a170902b60bb02900e6ef445231mr9783721pls.79.1616681364037;
        Thu, 25 Mar 2021 07:09:24 -0700 (PDT)
Received: from localhost.localdomain ([122.171.175.121])
        by smtp.gmail.com with ESMTPSA id v13sm5673030pfu.54.2021.03.25.07.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 07:09:23 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 6/6] xfs/535: Fix test to execute in multi-block directory config
Date:   Thu, 25 Mar 2021 19:38:57 +0530
Message-Id: <20210325140857.7145-6-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210325140857.7145-1-chandanrlinux@gmail.com>
References: <20210325140857.7145-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs/535 attempts to create $srcfile and $dstfile after reduce_max_iextents
error tag is injected. Creation of these files fails when using a multi-block
directory test configuration because,
1. A directory can have a pseudo maximum extent count of 10.
2. In the worst case a directory entry creation operation can consume
   (XFS_DA_NODE_MAXDEPTH + 1 + 1) * (Nr fs blocks in a single directory block)
   extents.
   With 1k fs block size and 4k directory block size, this evaluates to,
   (5 + 1 + 1) * 4
   = 7 * 4
   = 28
   > 10 (Pseudo maximum inode extent count).

This commit fixes the issue by creating $srcfile and $dstfile before injecting
reduce_max_iextents error tag.

Reported-by: Darrick J. Wong <djwong@kernel.org>
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/535     | 11 +++++++++++
 tests/xfs/535.out |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/tests/xfs/535 b/tests/xfs/535
index 2d82624c..f2a8a3a5 100755
--- a/tests/xfs/535
+++ b/tests/xfs/535
@@ -51,6 +51,9 @@ nr_blks=15
 srcfile=${SCRATCH_MNT}/srcfile
 dstfile=${SCRATCH_MNT}/dstfile
 
+touch $srcfile
+touch $dstfile
+
 echo "Inject reduce_max_iextents error tag"
 _scratch_inject_error reduce_max_iextents 1
 
@@ -77,10 +80,18 @@ if (( $nextents > 10 )); then
 	exit 1
 fi
 
+echo "Disable reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 0
+
 rm $dstfile
 
 echo "* Funshare shared extent"
 
+touch $dstfile
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
 echo "Share the extent with \$dstfile"
 _reflink $srcfile $dstfile >> $seqres.full
 
diff --git a/tests/xfs/535.out b/tests/xfs/535.out
index 4383e921..8f600272 100644
--- a/tests/xfs/535.out
+++ b/tests/xfs/535.out
@@ -6,7 +6,9 @@ Create a $srcfile having an extent of length 15 blocks
 Share the extent with $dstfile
 Buffered write to every other block of $dstfile's shared extent
 Verify $dstfile's extent count
+Disable reduce_max_iextents error tag
 * Funshare shared extent
+Inject reduce_max_iextents error tag
 Share the extent with $dstfile
 Funshare every other block of $dstfile's shared extent
 Verify $dstfile's extent count
-- 
2.29.2

