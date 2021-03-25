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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4CBFC433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 14:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAC9E61A3C
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 14:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhCYOJo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 10:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbhCYOJV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 10:09:21 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2626C06174A;
        Thu, 25 Mar 2021 07:09:20 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id g15so2208264pfq.3;
        Thu, 25 Mar 2021 07:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/eaE6R17VwgmxiGoSjA6AeF9dbwTrXO5LHyeGFPtIw0=;
        b=kY1rLZueJyCrKR52EE337rheY84IZKGRbETy+XQGHD9fhdbTqObJB7eurK5I5UkeBm
         oOBGSl9Te/fFoDtbPHH1RIh6BxMYto8kAi9WT6+GYlnjUS5vgIc7VrepUJ8RRl166UUE
         hS/+jVFySVNAZgEMWUrin0AJctDro9+FwUAnoBbQfzqdLfXNPR4TS4vuDjTlbyw991tA
         t2VczFPlRlWDnMed6x5HHKinYNBjaPFb128nsPA/8SdsT9JrO+92OCF7JWtiFKqtIDzl
         hTfK0ebgysS9Ujpq/Iwo+f6XazOJ+QTsrohvhWD2Z1fQT3KrBTruX38HRDGlb24CuHRp
         ITFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/eaE6R17VwgmxiGoSjA6AeF9dbwTrXO5LHyeGFPtIw0=;
        b=mfRINbnGpWKS0bOvH/k0gn1NIaGPQBEOrHVQIF721IHDGXOnuSZnRFsRAhF5DBsANO
         r8WVLS5tP4onXK69zF11c8T12n1FFLdchLd7EdkW6RH0biGVetySUlczrUUctGMAYbNL
         U10yI2mSaBlKWwYNmlVtrzX+RBQQjrLKbSeq2Ywynxd0YzrxmC3WqKIfgN+ucfGiT1sL
         FKiIEdIGfTzO5D9t6qf07qanvQ+k/Z6T6EnXBXRkmsqtGT6K3pGQa7/A8d4+av1VaSmB
         AVGvQ1XG5pIByhUClAuOdkh6PCZWmoy80WkiFtZTf3sDgSKR5uZerWw8XYy1ksQ1Kv2T
         bSJQ==
X-Gm-Message-State: AOAM532cuTpB1F9jFjZ1eLrAlcALpGqXKXVwV+F5nGN/puEupuEW/NCT
        LGfrbVzly4+HIsGjJFsbF+oGfj5JitQ=
X-Google-Smtp-Source: ABdhPJxSLbm1nKmt8oJWU8YlxcBPoyUWtS678I1ocbypt1EfWsWtbJS9PY96HlJ4bctI0fdGRNwyBw==
X-Received: by 2002:a62:2c85:0:b029:1ed:39f4:ca0f with SMTP id s127-20020a622c850000b02901ed39f4ca0fmr8472674pfs.11.1616681360346;
        Thu, 25 Mar 2021 07:09:20 -0700 (PDT)
Received: from localhost.localdomain ([122.171.175.121])
        by smtp.gmail.com with ESMTPSA id v13sm5673030pfu.54.2021.03.25.07.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 07:09:20 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 4/6] xfs/532: Fix test to execute in multi-block directory config
Date:   Thu, 25 Mar 2021 19:38:55 +0530
Message-Id: <20210325140857.7145-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210325140857.7145-1-chandanrlinux@gmail.com>
References: <20210325140857.7145-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs/532 attempts to create $testfile after reduce_max_iextents error tag is
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
 tests/xfs/532     | 17 ++++++++++-------
 tests/xfs/532.out |  6 +++---
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/tests/xfs/532 b/tests/xfs/532
index 1c789217..2bed574a 100755
--- a/tests/xfs/532
+++ b/tests/xfs/532
@@ -63,9 +63,6 @@ for dentry in $(ls -1 $fillerdir/); do
 	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
 done
 
-echo "Inject reduce_max_iextents error tag"
-_scratch_inject_error reduce_max_iextents 1
-
 echo "Inject bmap_alloc_minlen_extent error tag"
 _scratch_inject_error bmap_alloc_minlen_extent 1
 
@@ -74,6 +71,9 @@ echo "* Set xattrs"
 echo "Create \$testfile"
 touch $testfile
 
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
 echo "Create xattrs"
 nr_attrs=$((bsize * 20 / attr_len))
 for i in $(seq 1 $nr_attrs); do
@@ -90,6 +90,9 @@ if (( $naextents > 10 )); then
 	exit 1
 fi
 
+echo "Disable reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 0
+
 echo "Remove \$testfile"
 rm $testfile
 
@@ -98,9 +101,6 @@ echo "* Remove xattrs"
 echo "Create \$testfile"
 touch $testfile
 
-echo "Disable reduce_max_iextents error tag"
-_scratch_inject_error reduce_max_iextents 0
-
 echo "Create initial xattr extents"
 
 naextents=0
@@ -132,7 +132,10 @@ if [[ $? == 0 ]]; then
 	exit 1
 fi
 
-rm $testfile && echo "Successfully removed \$testfile"
+echo "Disable reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 0
+
+rm $testfile
 
 # success, all done
 status=0
diff --git a/tests/xfs/532.out b/tests/xfs/532.out
index 8e19d7bc..db52108f 100644
--- a/tests/xfs/532.out
+++ b/tests/xfs/532.out
@@ -2,17 +2,17 @@ QA output created by 532
 Format and mount fs
 Consume free space
 Create fragmented filesystem
-Inject reduce_max_iextents error tag
 Inject bmap_alloc_minlen_extent error tag
 * Set xattrs
 Create $testfile
+Inject reduce_max_iextents error tag
 Create xattrs
 Verify $testfile's naextent count
+Disable reduce_max_iextents error tag
 Remove $testfile
 * Remove xattrs
 Create $testfile
-Disable reduce_max_iextents error tag
 Create initial xattr extents
 Inject reduce_max_iextents error tag
 Remove xattr to trigger -EFBIG
-Successfully removed $testfile
+Disable reduce_max_iextents error tag
-- 
2.29.2

