Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D6DCC6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjCPTeU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjCPTeS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:34:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DC01C7E0;
        Thu, 16 Mar 2023 12:34:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 963FDCE1E65;
        Thu, 16 Mar 2023 19:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A058C433D2;
        Thu, 16 Mar 2023 19:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678995254;
        bh=jcMPAitEdlmtQO6luu6/YtNbQLTOBOSD+2V5MPg8xLk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=g4rLsAQBaPnKRl+G2x5vdPTUaqZFchYF1wp27RwIrlJbdKQvKmGHmr+xjmj2HL+w6
         qeyyVtAWOGWR/e1k6gT/NTLQs/UuPqN4W0GXnpN1wCS4Y5qbtGeR6TonqxPgfJ73Nr
         fEw+hSrjlPTaRLlwH7sPWlyholf4/j+p0dosEeX5Ts+CIm9PceKvkn9/wRdRQHG+BJ
         gKsSOSaNsam+jGAxJ4lHw8fiCDhp6yu8Yu9mK8fRaku0HNO3KcvKux3S/3fd8sxh+o
         vgrO1G61t8fpvwUnPuzvqMN8WmnF++2JcksRtjgNTaauxIrVochh7IYX/d7gESRBAD
         EnN7mkCLIFxsw==
Date:   Thu, 16 Mar 2023 12:34:13 -0700
Subject: [PATCH 05/14] xfs/018: disable parent pointers for this test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167899417721.17926.3530090921775489965.stgit@frogsfrogsfrogs>
In-Reply-To: <167899417650.17926.7405859750613330339.stgit@frogsfrogsfrogs>
References: <167899417650.17926.7405859750613330339.stgit@frogsfrogsfrogs>
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

