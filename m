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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A99C433E4
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 14:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5449C61A2D
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 14:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhCYOJo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 10:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbhCYOJT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 10:09:19 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195EBC06174A;
        Thu, 25 Mar 2021 07:09:19 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 11so2178535pfn.9;
        Thu, 25 Mar 2021 07:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qKJAfoZxW6CcEJ4e8a+jIHh3UfMmaPIJTJRP9/d5eic=;
        b=pJO5dT3WSyvj3zUMGP5OhTIUIS3sTVLW0t9EkrgNqmbP3Td4OweuQEB8QwsU3RuGtJ
         kbLo0fmn42rL+Y1aetqLrD8kTHeFQiQZSQYNmVS+9j8c4Ljkz8E9t6F8a9JGV0Y3lArs
         du5V+trPJrIC5wN6FbcbqQ0j3UhISMfjaCcV90M0Sj0OGjcqse/2eECFXdO5hAa7W24m
         An5PPV5b3Fph9ObhhL75u1UyPUQavgqqNM7SbSjPhunwpfQY5sp8PYG2DJ25vrlliGjn
         vA8Er0Hq3e3kx+H7GntF8/M38GryIro1nerlW5a6wmqckV39R3uEVRsNfWdGfc7xzJGz
         IoRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qKJAfoZxW6CcEJ4e8a+jIHh3UfMmaPIJTJRP9/d5eic=;
        b=m7feaqhmSKRI5oXMPrrVCGTwcPsndXYWAwxEW1hQD3arX1ZXu1TsVF7XJPu+Al3wBm
         QlJa898BX7+keL3emgAjcRhbXU7sz3ta3qtbTWmpo0SoBHRARAGw7rgHw46oscO0Sunv
         jZOYdBfP43h6YZS0wGo5KW8lRCLaD6kGLHCgVJ3JE0P4YJCkHLsuGDsUf4Zu4pPc8gBf
         E+m4aJe+vlRyXcNPDmfz1z70RQCa5aE+4+8tg6ScjLxMxjkTgvyRFQbXz4EragRyFeF7
         Tl92y1F7bm3nuhTxkyWbMmhDeuQFpDY6GE/49n3/7xECWmeNWDyoC58wiAqMwzHu7rDB
         sYYw==
X-Gm-Message-State: AOAM533RGI/TkSovZGqWZFA3/9ttxMYeJSsA9wBbAtdYBtFFtu3GwZDf
        KdGumkjEKSqpvapB/yxLDG0QvvzPLho=
X-Google-Smtp-Source: ABdhPJzr04yHJRzX7FIx4h7iACT4zmpoTuW54XyBAQ+oI2W4WxnJZdt3mWU89CBE6aywJKFrHpApGQ==
X-Received: by 2002:a62:8f4a:0:b029:20a:448e:7018 with SMTP id n71-20020a628f4a0000b029020a448e7018mr8186347pfd.62.1616681358517;
        Thu, 25 Mar 2021 07:09:18 -0700 (PDT)
Received: from localhost.localdomain ([122.171.175.121])
        by smtp.gmail.com with ESMTPSA id v13sm5673030pfu.54.2021.03.25.07.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 07:09:18 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 3/6] xfs/531: Fix test to execute in multi-block directory config
Date:   Thu, 25 Mar 2021 19:38:54 +0530
Message-Id: <20210325140857.7145-3-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210325140857.7145-1-chandanrlinux@gmail.com>
References: <20210325140857.7145-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs/531 attempts to create $testfile after reduce_max_iextents error tag is
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
 tests/xfs/531     | 11 ++++++++---
 tests/xfs/531.out |  9 ++++++++-
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/tests/xfs/531 b/tests/xfs/531
index caec7848..935c52b0 100755
--- a/tests/xfs/531
+++ b/tests/xfs/531
@@ -49,13 +49,15 @@ nr_blks=30
 
 testfile=$SCRATCH_MNT/testfile
 
-echo "Inject reduce_max_iextents error tag"
-_scratch_inject_error reduce_max_iextents 1
-
 for op in fpunch finsert fcollapse fzero; do
 	echo "* $op regular file"
 
 	echo "Create \$testfile"
+	touch $testfile
+
+	echo "Inject reduce_max_iextents error tag"
+	_scratch_inject_error reduce_max_iextents 1
+
 	$XFS_IO_PROG -f -s \
 		     -c "pwrite -b $((nr_blks * bsize)) 0 $((nr_blks * bsize))" \
 		     $testfile  >> $seqres.full
@@ -75,6 +77,9 @@ for op in fpunch finsert fcollapse fzero; do
 		exit 1
 	fi
 
+	echo "Disable reduce_max_iextents error tag"
+	_scratch_inject_error reduce_max_iextents 0
+
 	rm $testfile
 done
 
diff --git a/tests/xfs/531.out b/tests/xfs/531.out
index f85776c9..6ac90787 100644
--- a/tests/xfs/531.out
+++ b/tests/xfs/531.out
@@ -1,19 +1,26 @@
 QA output created by 531
 Format and mount fs
-Inject reduce_max_iextents error tag
 * fpunch regular file
 Create $testfile
+Inject reduce_max_iextents error tag
 fpunch alternating blocks
 Verify $testfile's extent count
+Disable reduce_max_iextents error tag
 * finsert regular file
 Create $testfile
+Inject reduce_max_iextents error tag
 finsert alternating blocks
 Verify $testfile's extent count
+Disable reduce_max_iextents error tag
 * fcollapse regular file
 Create $testfile
+Inject reduce_max_iextents error tag
 fcollapse alternating blocks
 Verify $testfile's extent count
+Disable reduce_max_iextents error tag
 * fzero regular file
 Create $testfile
+Inject reduce_max_iextents error tag
 fzero alternating blocks
 Verify $testfile's extent count
+Disable reduce_max_iextents error tag
-- 
2.29.2

