Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E29C5479D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbiLaDQ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236343AbiLaDQa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:16:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F8B1021;
        Fri, 30 Dec 2022 19:16:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA95E61D1B;
        Sat, 31 Dec 2022 03:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3DDC433EF;
        Sat, 31 Dec 2022 03:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456588;
        bh=izVADCf/hidd/o5zezb8nuGI3fq6pIxTPRhQEPPYpyM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uBIiRmggO01QeXenNINf7z8RGWI3AkhzaoEfZ17GDmDcuo6JdgP4EWBsm34JUyZbh
         0ddkTzgJnmNt8zCGXuKiq9DX9GiqFw+fvmd+JQMRuaHZu1YPUxrFi/vUDjpxUv2TKK
         9ZOPgOqTHebNdm98xMJ4or6daU8P6SWrHB0lVOfEZPtbFEbbmeTxEg33E8uYWekZSO
         38IVsP03iLaYEFuFPamYlPt/fc1WsAODEwcL3fxdSLaW0JPnB4zbqN6t2a3yJWLDfU
         fcPSYncit8Sdo/J5l9Pj/gH6G/oe8Vsvu6OIH0dDfXSWw0u8pKUVThqeX5XLv1dFFu
         fzyLOSupaZsOQ==
Subject: [PATCH 02/10] common/populate: create realtime refcount btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:48 -0800
Message-ID: <167243884879.740253.13552800092754454785.stgit@magnolia>
In-Reply-To: <167243884850.740253.18400210873595872110.stgit@magnolia>
References: <167243884850.740253.18400210873595872110.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Populate a realtime refcount btree when we're creating a sample fs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)


diff --git a/common/populate b/common/populate
index 6a05177e6d..734e31345f 100644
--- a/common/populate
+++ b/common/populate
@@ -367,16 +367,30 @@ _scratch_xfs_populate() {
 		rm -f "${dir}/${f}"
 	done
 
-	# Reverse-mapping btree
+	is_rt="$(_xfs_get_rtextents "$SCRATCH_MNT")"
 	is_rmapbt="$(_xfs_has_feature "$SCRATCH_MNT" rmapbt -v)"
+	is_reflink="$(_xfs_has_feature "$SCRATCH_MNT" reflink -v)"
+
+	# Reverse-mapping btree
 	if [ $is_rmapbt -gt 0 ]; then
 		echo "+ rmapbt btree"
 		nr="$((blksz * 2 / 24))"
 		__populate_create_file $((blksz * nr)) "${SCRATCH_MNT}/RMAPBT"
 	fi
 
+	# Realtime Reference-count btree comes before the rtrmapbt so that
+	# the refcount entries are created in rtgroup 0.
+	if [ $is_reflink -gt 0 ] && [ $is_rt -gt 0 ]; then
+		echo "+ rtreflink btree"
+		rt_blksz=$(_xfs_get_rtextsize "$SCRATCH_MNT")
+		nr="$((rt_blksz * 2 / 12))"
+		$XFS_IO_PROG -R -f -c 'truncate 0' "${SCRATCH_MNT}/RTREFCOUNTBT"
+		__populate_create_file $((blksz * nr)) "${SCRATCH_MNT}/RTREFCOUNTBT"
+		$XFS_IO_PROG -R -f -c 'truncate 0' "${SCRATCH_MNT}/RTREFCOUNTBT2"
+		cp --reflink=always "${SCRATCH_MNT}/RTREFCOUNTBT" "${SCRATCH_MNT}/RTREFCOUNTBT2"
+	fi
+
 	# Realtime Reverse-mapping btree
-	is_rt="$(_xfs_get_rtextents "$SCRATCH_MNT")"
 	if [ $is_rmapbt -gt 0 ] && [ $is_rt -gt 0 ]; then
 		echo "+ rtrmapbt btree"
 		nr="$((blksz * 2 / 24))"
@@ -385,7 +399,6 @@ _scratch_xfs_populate() {
 	fi
 
 	# Reference-count btree
-	is_reflink="$(_xfs_has_feature "$SCRATCH_MNT" reflink -v)"
 	if [ $is_reflink -gt 0 ]; then
 		echo "+ reflink btree"
 		nr="$((blksz * 2 / 12))"
@@ -403,6 +416,7 @@ _scratch_xfs_populate() {
 	__populate_fragment_file "${SCRATCH_MNT}/RMAPBT"
 	__populate_fragment_file "${SCRATCH_MNT}/RTRMAPBT"
 	__populate_fragment_file "${SCRATCH_MNT}/REFCOUNTBT"
+	__populate_fragment_file "${SCRATCH_MNT}/RTREFCOUNTBT"
 
 	umount "${SCRATCH_MNT}"
 }
@@ -644,6 +658,10 @@ __populate_check_xfs_rgbtree_height() {
 		path_format="/realtime/%u.rmap"
 		bt_prefix="u3.rtrmapbt"
 		;;
+	"refcnt")
+		path_format="/realtime/%u.refcount"
+		bt_prefix="u3.rtrefcbt"
+		;;
 	*)
 		_fail "Don't know about rt btree ${bt_type}"
 		;;
@@ -718,6 +736,8 @@ _scratch_xfs_populate_check() {
 	test $is_reflink -ne 0 && __populate_check_xfs_agbtree_height "refcnt"
 	test $is_rmapbt -ne 0 && test $is_rt -gt 0 && \
 		__populate_check_xfs_rgbtree_height "rmap"
+	test $is_reflink -ne 0 && test $is_rt -gt 0 && \
+		__populate_check_xfs_rgbtree_height "refcnt"
 }
 
 # Check data fork format of ext4 file

