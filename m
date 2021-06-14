Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74926C48BE8
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 20:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EAFF60241
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 20:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235114AbhFNVB5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 17:01:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235042AbhFNVB5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jun 2021 17:01:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70311601FC;
        Mon, 14 Jun 2021 20:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623704394;
        bh=QD8799P+2dc1gFdoOXQ++p88ziPo2yP6nq4FaCMH78M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g/e3Sleo2wBZ7/i13Q8+FO7Uj5Wc6vcO3LbN17SMjUZ2BWEGdxcOw6EN8B9/Wfs2C
         4JRyq05UVtZ16c2bJjE8bjlbSgTHPRXETJxgTlOuXehz7v5AWviZ1Ui1eLjQLTNTCU
         ApDTqUTBVBA9QCwRjriQ1SdntwO2qCBmGArQ8siBjNWY2NMTL6oOI6KQK3zCDfAMlz
         Lw6HyUqIBDFgGWu7ugJUv73n3s8+mdYbKjoAKeKWq6uFfsTjTo0iAerpKN0YohmJDe
         /tk9n9PeyklzxvCtEDop3GTrjWx6X+lJ7mf59NsrSDQEbOrUHOJkETRt4yiHv6BAL3
         ga2mYsf00d6HQ==
Subject: [PATCH 10/13] check: use generated group files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Date:   Mon, 14 Jun 2021 13:59:54 -0700
Message-ID: <162370439420.3800603.62743465175210643.stgit@locust>
In-Reply-To: <162370433910.3800603.9623820748404628250.stgit@locust>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
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

