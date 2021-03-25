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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34989C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 14:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 011F961A26
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 14:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhCYOJp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 10:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbhCYOJW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 10:09:22 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFEFC06174A;
        Thu, 25 Mar 2021 07:09:22 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c17so2192791pfn.6;
        Thu, 25 Mar 2021 07:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pSkPb8AvuKEiKWTkefXQ/u24x/nRRxa8+B+oOFLMDlw=;
        b=pgUmA36nNByA/PBjoCIdU0RCeyKq6JaUq/kK6/mK+6wKG3FDaVuaDAF2dH/q/YYvrl
         rd7D50htEqPiHI8fMPM7jxIQcudE06Ca1SxaUWoC60rc0+6plsNbfABs2UrxGCkprvX0
         QPoN/fABVLi0afqC6ZgFD0QYAKQXNrWIg2wfekwNAC8XES8HZbzim73dJRU7YI2tmrah
         u8Z4VSv37ClEvS8d520tp0BDU0x8aZem9RR3wo/V0Bi8kWN/X4RcmlM4DpcLZZKEyQT1
         YKn5Dg2miOELv0uS/EyyFOSDcceRspVGeUvJBYksu7N+kxEXv9Qa/2Zss5d/fYuWWjqf
         MgFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pSkPb8AvuKEiKWTkefXQ/u24x/nRRxa8+B+oOFLMDlw=;
        b=Cpt+iciWE+UjIPcrZsfq7nGpPnkjSAIvkYvrTmqygnKMgm7ycyJHhI08MYS32TTk/i
         dMidmUP5y7l5Gjzu70jT5LjR/y1HTOC6iVT9HGjuF3FL+2FLo7nyX6sgZeNaHsZK9zWL
         qcoQek3PeZY/X5Kngec7nPzomLu1QWOHlunEQ/PvVsot0ZciWrTWTYN4tTT4E06Uyb8r
         aMHzCaur7zf9Fqji3MW6Of99gVXsiAHSqHw/d9hLcOpx+/lzhHnT9QHNj+cJDi9BBBWP
         ioCKZ3LABFpLQY8y/E18ERZvm/P9mZmAWlc6XsTcfyKPGbarcVgswxCKoegq7y4YBDGi
         3Chg==
X-Gm-Message-State: AOAM530GLQmBMVaEk3QyzKCoz4+X6tCiIe+OrKgms5xVZypmF7T2NlIv
        iZya+XYib5mB1CXfeMroExKbh1EdR9U=
X-Google-Smtp-Source: ABdhPJwS2n1wPieqf37216RwW9Nm3xAq9g3LpqVQt8Mn64cXgRzRL9tdTJgaR2xoMQs0r1elj1UNIw==
X-Received: by 2002:a62:7c43:0:b029:1ef:20ce:ba36 with SMTP id x64-20020a627c430000b02901ef20ceba36mr8475349pfc.40.1616681362155;
        Thu, 25 Mar 2021 07:09:22 -0700 (PDT)
Received: from localhost.localdomain ([122.171.175.121])
        by smtp.gmail.com with ESMTPSA id v13sm5673030pfu.54.2021.03.25.07.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 07:09:21 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 5/6] xfs/534: Fix test to execute in multi-block directory config
Date:   Thu, 25 Mar 2021 19:38:56 +0530
Message-Id: <20210325140857.7145-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210325140857.7145-1-chandanrlinux@gmail.com>
References: <20210325140857.7145-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs/534 attempts to create $testfile after reduce_max_iextents error tag is
injected. Creation of $testfile fails when using a multi-block directory test
configuration because,
1. A directory can have a pseudo maximum extent count of 10.
2. In the worst case a directory entry creation operation can consume
   (XFS_DA_NODE_MAXDEPTH + 1 + 1) * (Nr fs blocks in a single directory block)
   extents.
   With 1k fs block size and 4k directory block size, this evaluates to,
   (5 + 1 + 1) * 4
   = 7 * 4
   = 28
   > 10 (Pseudo maximum inode extent count).

This commit fixes the issue by creating $testfile before injecting
reduce_max_iextents error tag.

Reported-by: Darrick J. Wong <djwong@kernel.org>
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/534     | 9 ++++++---
 tests/xfs/534.out | 5 ++++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/tests/xfs/534 b/tests/xfs/534
index a8348526..338282ef 100755
--- a/tests/xfs/534
+++ b/tests/xfs/534
@@ -45,9 +45,6 @@ bsize=$(_get_file_block_size $SCRATCH_MNT)
 
 testfile=${SCRATCH_MNT}/testfile
 
-echo "Inject reduce_max_iextents error tag"
-_scratch_inject_error reduce_max_iextents 1
-
 nr_blks=15
 
 for io in Buffered Direct; do
@@ -62,6 +59,9 @@ for io in Buffered Direct; do
 		xfs_io_flag="-d"
 	fi
 
+	echo "Inject reduce_max_iextents error tag"
+	_scratch_inject_error reduce_max_iextents 1
+
 	echo "$io write to every other block of fallocated space"
 	for i in $(seq 1 2 $((nr_blks - 1))); do
 		$XFS_IO_PROG -f -s $xfs_io_flag -c "pwrite $((i * bsize)) $bsize" \
@@ -76,6 +76,9 @@ for io in Buffered Direct; do
 		exit 1
 	fi
 
+	echo "Disable reduce_max_iextents error tag"
+	_scratch_inject_error reduce_max_iextents 0
+
 	rm $testfile
 done
 
diff --git a/tests/xfs/534.out b/tests/xfs/534.out
index f7c0821b..0a0cd3a6 100644
--- a/tests/xfs/534.out
+++ b/tests/xfs/534.out
@@ -1,11 +1,14 @@
 QA output created by 534
 Format and mount fs
-Inject reduce_max_iextents error tag
 * Buffered write to unwritten extent
 Fallocate 15 blocks
+Inject reduce_max_iextents error tag
 Buffered write to every other block of fallocated space
 Verify $testfile's extent count
+Disable reduce_max_iextents error tag
 * Direct write to unwritten extent
 Fallocate 15 blocks
+Inject reduce_max_iextents error tag
 Direct write to every other block of fallocated space
 Verify $testfile's extent count
+Disable reduce_max_iextents error tag
-- 
2.29.2

