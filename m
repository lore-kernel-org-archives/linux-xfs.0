Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A8BC2BB3F
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Nov 2023 19:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjKTTfX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Nov 2023 14:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjKTTfS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2023 14:35:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CDCA0
        for <linux-xfs@vger.kernel.org>; Mon, 20 Nov 2023 11:35:15 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09A1C433C8;
        Mon, 20 Nov 2023 19:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700508915;
        bh=PuKyNt2mW9SnCcQNDJmo2iPmqHw7enIHKt7zC4/1cZY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FILf+W9ihDhwTRPc5WAJT3E8Scl7Q+Rh5mzRCjiUnSctS4wZvjHKA8I80o/FS8Hr1
         tRD6hui52uy8k96mIopoyGitUDaXKyuMAS0JZmqg1cZCNpDXyE77BwjKLSz7smOQ6x
         2KYabiiBbci/tivG5EzfYwS2rYHuWqjVMJFhTkXWJJAmAJHLbH67eNUV32c3XqFWhy
         xFYWp4xWghV2gFQtn0YWC6z3CZ+sXGOtdvktDCvcByeDM6wBiPw3o4caoWH2zMzKCA
         vILJQZZ+FnRRblvVlmLYoHFSQiZ4IZOa/RohK4wsL6PFHkhr49384HcPP8XXyK2DD+
         iFUyxC2lJhuQA==
Subject: [PATCH 1/2] xfs/601: move this to tests/generic
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Date:   Mon, 20 Nov 2023 11:35:14 -0800
Message-ID: <170050891446.536459.11166010762932928186.stgit@frogsfrogsfrogs>
In-Reply-To: <170050890870.536459.4420904342934916414.stgit@frogsfrogsfrogs>
References: <170050890870.536459.4420904342934916414.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

As per last week's discussion, xfs/601 doesn't have any xfs-specific
functionality in it.  Turn it into a generic test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/734     |    3 ++-
 tests/generic/734.out |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)
 rename tests/{xfs/601 => generic/734} (98%)
 rename tests/{xfs/601.out => generic/734.out} (78%)


diff --git a/tests/xfs/601 b/tests/generic/734
similarity index 98%
rename from tests/xfs/601
rename to tests/generic/734
index 9df46e5ebe..93c2ad90e3 100755
--- a/tests/xfs/601
+++ b/tests/generic/734
@@ -2,7 +2,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright (c) 2023 Oracle.  All Rights Reserved.
 #
-# FS QA Test No. 601
+# FS QA Test No. 734
 #
 # This is a regression test for the kernel commit noted below.  The stale
 # memory exposure can be exploited by creating a file with shared blocks,
@@ -29,6 +29,7 @@ _fixed_by_git_commit kernel 35d30c9cf127 \
 	"iomap: don't skip reading in !uptodate folios when unsharing a range"
 
 # real QA test starts here
+_supported_fs generic
 _require_test_reflink
 _require_cp_reflink
 _require_xfs_io_command "funshare"
diff --git a/tests/xfs/601.out b/tests/generic/734.out
similarity index 78%
rename from tests/xfs/601.out
rename to tests/generic/734.out
index 34d519ca46..174c3f82cb 100644
--- a/tests/xfs/601.out
+++ b/tests/generic/734.out
@@ -1,4 +1,4 @@
-QA output created by 601
+QA output created by 734
 Create the original file and a clone
 Funshare at least one pagecache page
 Check contents

