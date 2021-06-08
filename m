Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CC6C4743D
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 17:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D95661351
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 17:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhFHRWL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 13:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232979AbhFHRWK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Jun 2021 13:22:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 101CE61351;
        Tue,  8 Jun 2021 17:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623172817;
        bh=gzjW7I6IYs9pr6ogKmsePYbwlXpghFGsvsgKqDzGizA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HLMhCtLIFbV+81zWTI1oKzrmVvJ1tvqvpnm8lGHF9tJBnbaDCpOxnnCCkol1pKwPM
         kuXHlapd1jOzi8JimA+CxdrjBsnpqszpqE5jJqTuk9Q103GOk0QsgmdB6XcqczuzBb
         lAzP1A13sr5Wuw1usVEOnydvE6cbWmaM0E0bk/elyb+tkztFVXy1u3CcVRM9k8xElg
         zmqCuCRXlxqRHJblsyf4HWNguO9t/fLg68DZHpkxnqM/QUHoxncOXZQt3MzZFTnXUY
         pKV2sVAYUsG58L2a6CjW+O9xwh/TWaQw00ZP09sFIODQb/ggYkVP+AU31ODeS8VBr6
         T+9Ro2PiB+C6Q==
Subject: [PATCH 10/13] check: use generated group files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Date:   Tue, 08 Jun 2021 10:20:16 -0700
Message-ID: <162317281679.653489.1178774292862746443.stgit@locust>
In-Reply-To: <162317276202.653489.13006238543620278716.stgit@locust>
References: <162317276202.653489.13006238543620278716.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert the ./check script to use the automatically generated group list
membership files, as the transition is now complete.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 check |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/check b/check
index ba192042..3dab7630 100755
--- a/check
+++ b/check
@@ -124,9 +124,9 @@ get_sub_group_list()
 	local d=$1
 	local grp=$2
 
-	test -s "$SRC_DIR/$d/group" || return 1
+	test -s "$SRC_DIR/$d/group.list" || return 1
 
-	local grpl=$(sed -n < $SRC_DIR/$d/group \
+	local grpl=$(sed -n < $SRC_DIR/$d/group.list \
 		-e 's/#.*//' \
 		-e 's/$/ /' \
 		-e "s;^\($VALID_TEST_NAME\).* $grp .*;$SRC_DIR/$d/\1;p")
@@ -384,7 +384,7 @@ if $have_test_arg; then
 				test_dir=`dirname $t`
 				test_dir=${test_dir#$SRC_DIR/*}
 				test_name=`basename $t`
-				group_file=$SRC_DIR/$test_dir/group
+				group_file=$SRC_DIR/$test_dir/group.list
 
 				if egrep -q "^$test_name" $group_file; then
 					# in group file ... OK

