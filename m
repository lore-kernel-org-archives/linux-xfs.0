Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01695C48BC2
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 23:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBDAA61164
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 23:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhFUXNR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 19:13:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230274AbhFUXNQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jun 2021 19:13:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C50360FDB;
        Mon, 21 Jun 2021 23:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624317061;
        bh=EtDE16AP8kQDI6bGAo//XLOCqSL2S2neaTvKqhs1qMo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pmWstlU3y1hMGe+S3do02xKtQqAR+70rnHlKttcjldQmzkjEydbnSPxWv2oG7pr/o
         gXVydXu3bCZI1QSQcNJLPDLT/QkfCX/hkGFUTXIcbKighNW6OagD583owfnO6NgW1T
         vxrHFyVZiunb+tKKTXt6qNw4nYnmzJWGDOujj5aaaGvIkXJmPXOraa+pmeOtIyXooK
         wuHUvpjnBWrwVVS8llwly3qpRHTX5KrI18Cr2MVtRdFsn9FifDgFd5aP0B4QpUkJLN
         6PvtB+4hJHdRx4L0MCg/43rGe8CC+0QA2zU7TGmQamNZHXmnUonQ4LyyHM/Q6XORB3
         chjRIx5Ke0LIg==
Subject: [PATCH 10/13] check: use generated group files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        Eric Biggers <ebiggers@google.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com,
        ebiggers@kernel.org
Date:   Mon, 21 Jun 2021 16:11:01 -0700
Message-ID: <162431706134.4090790.4006205589840103999.stgit@locust>
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

Convert the ./check script to use the automatically generated group list
membership files, as the transition is now complete.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
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

