Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6A7C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D03B56140B
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbhD1EJw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 00:09:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234587AbhD1EJv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 00:09:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7179460720;
        Wed, 28 Apr 2021 04:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619582947;
        bh=xNhvbDzwY83lOSf4Cd6ynyV6nL64Z+F28X0La4D2f5U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bwFB6JT2HrwoPip55zHAngxRAyLuJwxngB+L4WO9IivbS2uGWSMVRHvvvxkJq7QFY
         RFoG9ZiVcy397HcGG0sJcJ9Eh04weY0iupxYBjwGGPQkRj+E/mvf1F4mwA8KQC6Ivi
         EZPbGuqwgwAjutH2+G6ICHxBs48JjS47gWKoe1bJFq5WxerVm4dVsGKLS9Ger/othx
         TqIpwg3z5W/PZe7DOfnFt+eqhZ243piVZzcIMzjdwLkzJCwDSpUvwYNPuJxqf9zRsE
         R9ewF0oS+NhMOSpC1GqAMm7fiTjWXFn512xEn7c1UO0KsTiGpp89D5e2A5ALlkN9ep
         c4veQb0wVrHwA==
Subject: [PATCH 2/5] generic/{094,225}: fix argument to
 _require_file_block_size_equals_fs_block_size
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Apr 2021 21:09:06 -0700
Message-ID: <161958294676.3452351.8192861960078318002.stgit@magnolia>
In-Reply-To: <161958293466.3452351.14394620932744162301.stgit@magnolia>
References: <161958293466.3452351.14394620932744162301.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix the incorrect parameter being passed to this new predicate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc         |    3 ++-
 tests/generic/094 |    2 +-
 tests/generic/225 |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)


diff --git a/common/rc b/common/rc
index 2cf550ec..6752c92d 100644
--- a/common/rc
+++ b/common/rc
@@ -4174,7 +4174,8 @@ _get_block_size()
 }
 
 # Require that the fundamental allocation unit of a file is the same as the
-# filesystem block size.
+# filesystem block size.  The sole parameter must be the root dir of a
+# filesystem.
 _require_file_block_size_equals_fs_block_size()
 {
 	local file_alloc_unit="$(_get_file_block_size $1)"
diff --git a/tests/generic/094 b/tests/generic/094
index 8c292473..20ef158e 100755
--- a/tests/generic/094
+++ b/tests/generic/094
@@ -43,7 +43,7 @@ _require_test_program "fiemap-tester"
 # FIEMAP test doesn't like finding unwritten blocks after it punches out
 # a partial rt extent.
 test "$FSTYP" = "xfs" && \
-	_require_file_block_size_equals_fs_block_size $fiemapfile
+	_require_file_block_size_equals_fs_block_size $SCRATCH_MNT
 
 seed=`date +%s`
 
diff --git a/tests/generic/225 b/tests/generic/225
index fac688df..1a7963e8 100755
--- a/tests/generic/225
+++ b/tests/generic/225
@@ -43,7 +43,7 @@ _require_test_program "fiemap-tester"
 # FIEMAP test doesn't like finding unwritten blocks after it punches out
 # a partial rt extent.
 test "$FSTYP" = "xfs" && \
-	_require_file_block_size_equals_fs_block_size $fiemapfile
+	_require_file_block_size_equals_fs_block_size $SCRATCH_MNT
 
 seed=`date +%s`
 

