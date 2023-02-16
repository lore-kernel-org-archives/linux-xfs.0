Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 082B9C636D6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjBPVO6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjBPVO4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:14:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE2148E22;
        Thu, 16 Feb 2023 13:14:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94CE1B82760;
        Thu, 16 Feb 2023 21:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A8BC433D2;
        Thu, 16 Feb 2023 21:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676582093;
        bh=jcMPAitEdlmtQO6luu6/YtNbQLTOBOSD+2V5MPg8xLk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=tOQHNSuG3WoQS+ZdwmCXJWDLqjzmNywPFTyCs4mUosPlt7u9ygTaV4M2xhx/AGcFk
         6GpuX3LTkWFDTRNaG/hmr5P0Qim+yCIHJRUEkz/50EfRG6ourJdBBIb38DbY6tKLyr
         FIjE6Uiv2MY52hWdHNwIZ+eCDjy2kYzngtpLvuTWcjvFTLvE53UjpfGAKRbmaDv5pr
         zgVUWuk38aFRMT982CB2QLVZ3+v0hO0sByGxSkhrOzTHsTqVPe4V3rU3bTAcB6HJVS
         RyWISlOYQGuKExvz2TZ+QYFJh39zOll/Yuzmqfvp1bhVFlEVgHzFA7qzZUhFS0aJ/O
         CZ3wkvO9O1ePw==
Date:   Thu, 16 Feb 2023 13:14:52 -0800
Subject: [PATCH 05/14] xfs/018: disable parent pointers for this test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657884552.3481377.4320827336847794985.stgit@magnolia>
In-Reply-To: <167657884480.3481377.14824439551809919632.stgit@magnolia>
References: <167657884480.3481377.14824439551809919632.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test depends heavily on the xattr formats created for new files.
Parent pointers break those assumptions, so force parent pointers off.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/018 |    7 ++++++-
 tests/xfs/191 |    7 ++++++-
 tests/xfs/288 |    7 ++++++-
 3 files changed, 18 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/018 b/tests/xfs/018
index 1ef51a2e61..34b6e91579 100755
--- a/tests/xfs/018
+++ b/tests/xfs/018
@@ -100,7 +100,12 @@ attr32l="X$attr32k"
 attr64k="$attr32k$attr32k"
 
 echo "*** mkfs"
-_scratch_mkfs >/dev/null
+
+# Parent pointers change the xattr formats sufficiently to break this test.
+# Disable parent pointers if mkfs supports it.
+mkfs_args=()
+$MKFS_XFS_PROG 2>&1 | grep -q parent=0 && mkfs_args+=(-n parent=0)
+_scratch_mkfs "${mkfs_args[@]}" >/dev/null
 
 blk_sz=$(_scratch_xfs_get_sb_field blocksize)
 err_inj_attr_sz=$(( blk_sz / 3 - 50 ))
diff --git a/tests/xfs/191 b/tests/xfs/191
index 7a02f1be21..0a6c20dad7 100755
--- a/tests/xfs/191
+++ b/tests/xfs/191
@@ -33,7 +33,12 @@ _fixed_by_kernel_commit 7be3bd8856fb "xfs: empty xattr leaf header blocks are no
 _fixed_by_kernel_commit e87021a2bc10 "xfs: use larger in-core attr firstused field and detect overflow"
 _fixed_by_git_commit xfsprogs f50d3462c654 "xfs_repair: ignore empty xattr leaf blocks"
 
-_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
+# Parent pointers change the xattr formats sufficiently to break this test.
+# Disable parent pointers if mkfs supports it.
+mkfs_args=()
+$MKFS_XFS_PROG 2>&1 | grep -q parent=0 && mkfs_args+=(-n parent=0)
+
+_scratch_mkfs_xfs "${mkfs_args[@]}" | _filter_mkfs >$seqres.full 2>$tmp.mkfs
 cat $tmp.mkfs >> $seqres.full
 source $tmp.mkfs
 _scratch_mount
diff --git a/tests/xfs/288 b/tests/xfs/288
index aa664a266e..6bfc9ac0c8 100755
--- a/tests/xfs/288
+++ b/tests/xfs/288
@@ -19,8 +19,13 @@ _supported_fs xfs
 _require_scratch
 _require_attrs
 
+# Parent pointers change the xattr formats sufficiently to break this test.
+# Disable parent pointers if mkfs supports it.
+mkfs_args=()
+$MKFS_XFS_PROG 2>&1 | grep -q parent=0 && mkfs_args+=(-n parent=0)
+
 # get block size ($dbsize) from the mkfs output
-_scratch_mkfs_xfs 2>/dev/null | _filter_mkfs 2>$tmp.mkfs >/dev/null
+_scratch_mkfs_xfs "${mkfs_args[@]}" 2>/dev/null | _filter_mkfs 2>$tmp.mkfs >/dev/null
 . $tmp.mkfs
 
 _scratch_mount

