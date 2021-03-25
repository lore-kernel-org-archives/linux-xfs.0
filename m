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
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABCB6C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 14:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 853ED61A2E
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 14:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhCYOJn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 10:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbhCYOJR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 10:09:17 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E194C06174A;
        Thu, 25 Mar 2021 07:09:17 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so2768435pjc.2;
        Thu, 25 Mar 2021 07:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iabgT9xxtg44P7FtEYxw1iFtMX3+KsnLU+bhmLAJjfE=;
        b=kFZcaqp0HAUp7v+PvOF1uGUnCGg40+z2DXw5WG4ge6QE+Tl2OyYY5KhcCA0u1BmjlG
         q004TWXAHw6mprlqMBPnwA12Oj1WVxtJ4gM8a4A0W6xn3231AAgNIR2TypHGd9vKucgx
         FOLPanifDZ1HzsD1VC67Y1568/7FoofHAJZ66cxxdLqyB9jZKw4Xso9U7s2WBv5UfwGw
         xOIAMixesqJZMgS6ZD6Pumon9SUqgc6JntMlRrCXTaTBoMDLGhxtB+YnAIJL7UqZTkv3
         pq+f/HSwBRCWmzJS8/IWua7hz9hc7izE9A3Ub77Z+SFhNizkTvlgc/vZlmnTj0TMrxzM
         xzJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iabgT9xxtg44P7FtEYxw1iFtMX3+KsnLU+bhmLAJjfE=;
        b=fZIWs18HoRGTGeKzBAnH739thkV//OSD9S4yvvjfsqAEeusBZ8BKiyMdjiN0JgOoaT
         tveSQVIGnplzDnuPq9sYuPGyrdOvRWHpq85sJoBUtJnyUI/pt7fMM6WDbx3rZCQHgPx9
         A8nfB6Ic4gQ5byROlWJJOgTRp9A5jsiFh+HXuxULj9frtLFPFdnx/eZpjXj7TqxA6KDK
         M9yFxxWLVeoOX+ib2jyOaNKCOqobCrQpcWpT2IO641WEijsUJVt0Dl4LdF7Ax3ybQhDr
         K2sdhoPwYR14xicIMxMY94aWU2qdHEk/76n4QsgzIq8Af5PDTpx5uVe0/Y/HUyePAIc5
         WfvQ==
X-Gm-Message-State: AOAM531WBUhBcdB2kqwBbB/5mpxBATGOc/H5L2K/LdnzB1xeNEJH1oJg
        K3aQchWflOaJwMeGkSkNk7YVN5L3zPY=
X-Google-Smtp-Source: ABdhPJzlvVDLatkTCQzBEu12X9xLCz/o0KezPq/TW2jgOR83bOHWKTYM5ucHp1BbJqjHaISXHrGrNw==
X-Received: by 2002:a17:90a:5d14:: with SMTP id s20mr9037480pji.6.1616681356517;
        Thu, 25 Mar 2021 07:09:16 -0700 (PDT)
Received: from localhost.localdomain ([122.171.175.121])
        by smtp.gmail.com with ESMTPSA id v13sm5673030pfu.54.2021.03.25.07.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 07:09:16 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 2/6] xfs/529: Fix test to execute in multi-block directory config
Date:   Thu, 25 Mar 2021 19:38:53 +0530
Message-Id: <20210325140857.7145-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210325140857.7145-1-chandanrlinux@gmail.com>
References: <20210325140857.7145-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs/529 attempts to create $testfile after reduce_max_iextents error tag is
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
 tests/xfs/529     | 24 +++++++++++++++++++++---
 tests/xfs/529.out |  6 +++++-
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/tests/xfs/529 b/tests/xfs/529
index abe5b1e0..b4533eba 100755
--- a/tests/xfs/529
+++ b/tests/xfs/529
@@ -54,6 +54,8 @@ echo "* Delalloc to written extent conversion"
 
 testfile=$SCRATCH_MNT/testfile
 
+touch $testfile
+
 echo "Inject reduce_max_iextents error tag"
 _scratch_inject_error reduce_max_iextents 1
 
@@ -74,10 +76,18 @@ if (( $nextents > 10 )); then
 	exit 1
 fi
 
+echo "Disable reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 0
+
 rm $testfile
 
 echo "* Fallocate unwritten extents"
 
+touch $testfile
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
 echo "Fallocate fragmented file"
 for i in $(seq 0 2 $((nr_blks - 1))); do
 	$XFS_IO_PROG -f -c "falloc $((i * bsize)) $bsize" $testfile \
@@ -93,10 +103,18 @@ if (( $nextents > 10 )); then
 	exit 1
 fi
 
+echo "Disable reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 0
+
 rm $testfile
 
 echo "* Directio write"
 
+touch $testfile
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
 echo "Create fragmented file via directio writes"
 for i in $(seq 0 2 $((nr_blks - 1))); do
 	$XFS_IO_PROG -d -s -f -c "pwrite $((i * bsize)) $bsize" $testfile \
@@ -112,15 +130,15 @@ if (( $nextents > 10 )); then
 	exit 1
 fi
 
+echo "Disable reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 0
+
 rm $testfile
 
 # Check if XFS gracefully returns with an error code when we try to increase
 # extent count of user quota inode beyond the pseudo max extent count limit.
 echo "* Extend quota inodes"
 
-echo "Disable reduce_max_iextents error tag"
-_scratch_inject_error reduce_max_iextents 0
-
 echo "Consume free space"
 fillerdir=$SCRATCH_MNT/fillerdir
 nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
diff --git a/tests/xfs/529.out b/tests/xfs/529.out
index b2ae3f42..13489d34 100644
--- a/tests/xfs/529.out
+++ b/tests/xfs/529.out
@@ -4,14 +4,18 @@ Format and mount fs
 Inject reduce_max_iextents error tag
 Create fragmented file
 Verify $testfile's extent count
+Disable reduce_max_iextents error tag
 * Fallocate unwritten extents
+Inject reduce_max_iextents error tag
 Fallocate fragmented file
 Verify $testfile's extent count
+Disable reduce_max_iextents error tag
 * Directio write
+Inject reduce_max_iextents error tag
 Create fragmented file via directio writes
 Verify $testfile's extent count
-* Extend quota inodes
 Disable reduce_max_iextents error tag
+* Extend quota inodes
 Consume free space
 Create fragmented filesystem
 Inject reduce_max_iextents error tag
-- 
2.29.2

