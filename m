Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F362EC4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236286AbiLaDHD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236314AbiLaDGy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:06:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B029B1117D;
        Fri, 30 Dec 2022 19:06:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FB5A61D33;
        Sat, 31 Dec 2022 03:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A7BC433D2;
        Sat, 31 Dec 2022 03:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456012;
        bh=u3Pwql2JKSIQphxgfnnWr1hwq2Yfhh1lv9cIDyF5ASA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LNdBU7d1pgJRlnOTOz5MpSiHfaF3q2RJnKg1pMad5jQAfdZr1dWQys2ATn/3Qn7hf
         VECtJh0YWe4TKYOKnWWRQjUrwhugDS7X3Wfhxlw5FN/hXJNyRIFlbRPnWSIdjMY17o
         jBz0CEZZpxQ5POULTjddrHaxdxMwXtFJkLBcK7dALdtgAGYha5qWWPOhUv0EVnAGyr
         5h6Di2Mu/NgGGQviYKJ/cCZH6/EZAizig0w6fVw2YwqS+uzkgqbVBSOOPsZfEEca6I
         QehZBwbLMf4crAdFkC2TN2+d00vkMUz8dcm7AGx0vR45tVhxvT4wO7z4n2uSBZudCc
         kmzTYHbrjx5qA==
Subject: [PATCH 3/9] xfs/{030,033,178}: forcibly disable metadata directory
 trees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:32 -0800
Message-ID: <167243883283.736753.490441868180062329.stgit@magnolia>
In-Reply-To: <167243883244.736753.17143383151073497149.stgit@magnolia>
References: <167243883244.736753.17143383151073497149.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The golden output for thests tests encode the xfs_repair output when we
fuzz various parts of the filesystem.  With metadata directory trees
enabled, however, the golden output changes dramatically to reflect
reconstruction of the metadata directory tree.

To avoid regressions, add a helper to force metadata directories off via
MKFS_OPTIONS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs    |   13 +++++++++++++
 tests/xfs/030 |    1 +
 tests/xfs/033 |    1 +
 tests/xfs/178 |    1 +
 4 files changed, 16 insertions(+)


diff --git a/common/xfs b/common/xfs
index dafbd1b874..0f69d3eb18 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1770,3 +1770,16 @@ _scratch_xfs_find_metafile()
 	echo "${selector}"
 	return 0
 }
+
+# Force metadata directories off.
+_scratch_xfs_force_no_metadir()
+{
+	if echo "$MKFS_OPTIONS" | grep -q 'metadir='; then
+		MKFS_OPTIONS="$(echo "$MKFS_OPTIONS" | sed -e 's/metadir=\([01]\)/metadir=0/g')"
+		return
+	fi
+
+	if grep -q 'metadir=' $MKFS_XFS_PROG; then
+		MKFS_OPTIONS="-m metadir=0 $MKFS_OPTIONS"
+	fi
+}
diff --git a/tests/xfs/030 b/tests/xfs/030
index 201a901579..a62ea4fab3 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -50,6 +50,7 @@ _supported_fs xfs
 
 _require_scratch
 _require_no_large_scratch_dev
+_scratch_xfs_force_no_metadir
 
 DSIZE="-dsize=100m,agcount=6"
 
diff --git a/tests/xfs/033 b/tests/xfs/033
index ef5dc4fa36..e886c15082 100755
--- a/tests/xfs/033
+++ b/tests/xfs/033
@@ -53,6 +53,7 @@ _supported_fs xfs
 
 _require_scratch
 _require_no_large_scratch_dev
+_scratch_xfs_force_no_metadir
 
 # devzero blows away 512byte blocks, so make 512byte inodes (at least)
 _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
diff --git a/tests/xfs/178 b/tests/xfs/178
index a65197cde3..72b4d347fd 100755
--- a/tests/xfs/178
+++ b/tests/xfs/178
@@ -45,6 +45,7 @@ _supported_fs xfs
 #             fix filesystem, new mkfs.xfs will be fine.
 
 _require_scratch
+_scratch_xfs_force_no_metadir
 _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
 test "${PIPESTATUS[0]}" -eq 0 || _fail "mkfs failed!"
 

