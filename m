Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D536AC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 01:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B333E613C5
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 01:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbhD2Bck (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 21:32:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231874AbhD2Bck (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 21:32:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 682A560234;
        Thu, 29 Apr 2021 01:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619659914;
        bh=QK2oBbTwoY0ZKX9PsJ9f8Wpkm8wQWezdl0b03CT5SEk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XX8fI3dLKFXMXzbfZZAbl9+66/FvK6uSnfyufGXJ7KMUMPeSFlovqQ1AwqxvHDnc6
         o3HCfr+mq+jf9jToaYd0xXOog0tp/WYIhioQFSfeeWYqWdwHfNBSxJPF41tAAgUZJn
         tQiMh/UkNG9Nsp+M+1pvullqI0mYvRlSGxGj3yum3EXErPCASifp5lL9DlW5yy6Lsu
         4Kfu3thsAsq8R5gUv9uD6/gklSupsIWUmL93KyXzOa7Y6qUJe3yk8PureFnHoDjakV
         0iOz8d4Gbe+kaA+1OmMJhkRtWFgBEI8TTGct4eR586wdUVKdjKZRiAS3oeLNYLWW9N
         uRsVEdHPNuwbA==
Date:   Wed, 28 Apr 2021 18:31:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v1.2 5/5] xfs/49[12]: skip pre-lazysbcount filesystems
Message-ID: <20210429013154.GL3122235@magnolia>
References: <161958293466.3452351.14394620932744162301.stgit@magnolia>
 <161958296475.3452351.7075798777673076839.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161958296475.3452351.7075798777673076839.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Prior to lazysbcount, the xfs mount code blindly trusted the value of
the fdblocks counter in the primary super, which means that the kernel
doesn't detect the fuzzed fdblocks value at all.  V4 is deprecated and
pre-lazysbcount V4 hasn't been the default for ~14 years, so we'll just
skip these two tests on those old filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v1.2: factor the feature checking into a separate helper
---
 common/xfs    |   12 ++++++++++++
 tests/xfs/491 |    4 ++++
 tests/xfs/492 |    4 ++++
 3 files changed, 20 insertions(+)

diff --git a/common/xfs b/common/xfs
index 8501b084..92383061 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1129,6 +1129,18 @@ _check_scratch_xfs_features()
 	test "${found}" -eq "$#"
 }
 
+# Skip a test if any of the given fs features aren't present on the scratch
+# filesystem.  The scratch fs must have been formatted already.
+_require_scratch_xfs_features()
+{
+	local features="$(_scratch_xfs_db -c 'version' 2>/dev/null)"
+
+	for feature in "$@"; do
+		echo "${features}" | grep -q -w "${feature}" ||
+			_notrun "Missing scratch feature: ${feature}"
+	done
+}
+
 # Decide if xfs_repair knows how to set (or clear) a filesystem feature.
 _require_xfs_repair_upgrade()
 {
diff --git a/tests/xfs/491 b/tests/xfs/491
index 6420202b..7d447ccf 100755
--- a/tests/xfs/491
+++ b/tests/xfs/491
@@ -36,6 +36,10 @@ _require_scratch
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
+
+# pre-lazysbcount filesystems blindly trust the primary sb fdblocks
+_require_scratch_xfs_features LAZYSBCOUNT
+
 _scratch_mount >> $seqres.full 2>&1
 echo "test file" > $SCRATCH_MNT/testfile
 
diff --git a/tests/xfs/492 b/tests/xfs/492
index 522def47..21c6872f 100755
--- a/tests/xfs/492
+++ b/tests/xfs/492
@@ -36,6 +36,10 @@ _require_scratch
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
+
+# pre-lazysbcount filesystems blindly trust the primary sb fdblocks
+_require_scratch_xfs_features LAZYSBCOUNT
+
 _scratch_mount >> $seqres.full 2>&1
 echo "test file" > $SCRATCH_MNT/testfile
 
