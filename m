Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92366C47087
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 01:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7228F6142D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 01:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbhEZBsY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 21:48:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230147AbhEZBsY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 May 2021 21:48:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDD05613F5;
        Wed, 26 May 2021 01:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621993614;
        bh=bT4zFxjMd2I8ktdalPiDOKcfDLhpX6AqWdJZj5US8E4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oDekW3I3NMJmLXmAMQFLWMEzWMniL+BOhKNu2dDkiueGRC8i4hSrC+e810vB2JM9F
         +SpXQeIGLd1UwZNHls86e+uoqyjsK2N7CSTZpD9Ckw4wwPULk0jeu4rAgigkjz+tpl
         QicJZ+bZJypg1e+JurXsZnAcQ2a9GK5qmz71R3AMAZo8hgOI7vbACpzUbZVvU0UpEb
         G17s5Ee5T/bXoWbnwUw8FqH8OL7C+lotObQrwjWJIO2fYAAhvYO0WLWoK9Zp3Xjhzl
         b3HyqvW7buaiOTD5msANp4aHFVCpxDJ3+KNKFCgIW+9kTpseRBA14MSqrBuo7xwc1f
         9GjlUn5ECSpOQ==
Subject: [PATCH 02/10] fstests: refactor setting test sequence number
 variables
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 25 May 2021 18:46:53 -0700
Message-ID: <162199361370.3744214.15600621285427930583.stgit@locust>
In-Reply-To: <162199360248.3744214.17042613373014687643.stgit@locust>
References: <162199360248.3744214.17042613373014687643.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a helper function to set the seq and seqnum variables.  We will
expand on this in the next patch so that fstests can autogenerate group
files from now on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/test_names |   13 +++++++++++++
 new               |    8 ++------
 2 files changed, 15 insertions(+), 6 deletions(-)


diff --git a/common/test_names b/common/test_names
index 98af40cd..3b0b889a 100644
--- a/common/test_names
+++ b/common/test_names
@@ -10,3 +10,16 @@
 #
 VALID_TEST_ID="[0-9]\{3\}"
 VALID_TEST_NAME="$VALID_TEST_ID-\?[[:alnum:]-]*"
+
+# Initialize the global seq, seqres, here, tmp, and status variables to their
+# defaults.  Group memberships are the only arguments to this helper.
+_set_seq_and_groups()
+{
+	seq=`basename $0`
+	seqres=$RESULT_DIR/$seq
+	echo "QA output created by $seq"
+
+	here=`pwd`
+	tmp=/tmp/$$
+	status=1	# failure is the default!
+}
diff --git a/new b/new
index 357983d9..59e53d08 100755
--- a/new
+++ b/new
@@ -153,13 +153,9 @@ cat <<End-of-File >$tdir/$id
 #
 # what am I here for?
 #
-seq=\`basename \$0\`
-seqres=\$RESULT_DIR/\$seq
-echo "QA output created by \$seq"
+. ./common/test_names
+_set_seq_and_groups other
 
-here=\`pwd\`
-tmp=/tmp/\$\$
-status=1	# failure is the default!
 trap "_cleanup; exit \\\$status" 0 1 2 3 15
 
 _cleanup()

