Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E007C48BE5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 23:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7488861164
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 23:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhFUXMt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 19:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:32882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231246AbhFUXMt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jun 2021 19:12:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A46761042;
        Mon, 21 Jun 2021 23:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624317034;
        bh=WchwrvPZZWKDzYuyzzrlFERLZ63Majyv6K2HYW6SjJA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ru0sBR4L3j8XVJxt200oZ/2Bor3anAMa2ajn0VBwlKF5E1GYgMJHrzB7LHYGikc7/
         K3cGJ81k3lBiDHvqetxOvBzdKWZ6L+xnVAF//N08A5yo6E6/tCURlCVdcrga1R/9oh
         Dz6iJah79LW4Q/XyIYG8rz6wLyx+IanWwLKboPa6A999GPkOarqXGVjv44fVfHarn2
         d9GuhGVwc2AufEkd8uMv2R+RsljBJyZq7rEaZqXfTpn8cVjhGdY861pgLlo82QNGX8
         sHh7oC2PS0LSou15yS1kKFJ9D1amkuh35v7ThlvF61eKeugGtXVLLThaLPmjx+AjfN
         WdoRIinRpgdPA==
Subject: [PATCH 05/13] fstests: clean up open-coded golden output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Date:   Mon, 21 Jun 2021 16:10:34 -0700
Message-ID: <162431703399.4090790.6089193587867854324.stgit@locust>
In-Reply-To: <162431700639.4090790.11684371602638166127.stgit@locust>
References: <162431700639.4090790.11684371602638166127.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix the handful of tests that open-coded 'QA output created by XXX'.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 tests/btrfs/006       |    2 +-
 tests/btrfs/006.out   |    2 +-
 tests/btrfs/012       |    2 +-
 tests/btrfs/012.out   |    2 +-
 tests/generic/184     |    2 +-
 tests/generic/184.out |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/tests/btrfs/006 b/tests/btrfs/006
index 67f1fcd8..8168992f 100755
--- a/tests/btrfs/006
+++ b/tests/btrfs/006
@@ -9,7 +9,7 @@
 #
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-echo "== QA output created by $seq"
+echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
diff --git a/tests/btrfs/006.out b/tests/btrfs/006.out
index a9769721..b7f29f96 100644
--- a/tests/btrfs/006.out
+++ b/tests/btrfs/006.out
@@ -1,4 +1,4 @@
-== QA output created by 006
+QA output created by 006
 == Set filesystem label to TestLabel.006
 == Get filesystem label
 TestLabel.006
diff --git a/tests/btrfs/012 b/tests/btrfs/012
index 2d4cece5..0feca7d9 100755
--- a/tests/btrfs/012
+++ b/tests/btrfs/012
@@ -15,7 +15,7 @@
 #
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-echo "== QA output created by $seq"
+echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
diff --git a/tests/btrfs/012.out b/tests/btrfs/012.out
index 2a41e7e4..7aa5ae94 100644
--- a/tests/btrfs/012.out
+++ b/tests/btrfs/012.out
@@ -1 +1 @@
-== QA output created by 012
+QA output created by 012
diff --git a/tests/generic/184 b/tests/generic/184
index c80d5967..e9169244 100755
--- a/tests/generic/184
+++ b/tests/generic/184
@@ -8,7 +8,7 @@
 #
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq - silence is golden"
+echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
diff --git a/tests/generic/184.out b/tests/generic/184.out
index 2d19691d..4c300543 100644
--- a/tests/generic/184.out
+++ b/tests/generic/184.out
@@ -1 +1 @@
-QA output created by 184 - silence is golden
+QA output created by 184

