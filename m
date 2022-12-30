Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE52C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbiLaDPq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236337AbiLaDPo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:15:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4E5257;
        Fri, 30 Dec 2022 19:15:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF0FAB81E61;
        Sat, 31 Dec 2022 03:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890FCC433EF;
        Sat, 31 Dec 2022 03:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456541;
        bh=aTkm8z/589qdaL7VLGasCqnTpNpfp9e+HuWHLLuLrY4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=B3QVcuQ7CqHHl1+xYAjFGZhfUXAq0kw+t7vAMUzHlyKGKlyP4Q1g1tYYON7n1QuUs
         T333sD83tDx28C1oHu3WCDJCcPqcfYKtmvD7D2yOITUKggX6lq2GzsxWAsMcxZrepF
         RDakXaP6vUZyUE+H4IhF/7Mn69p/SJHRxO+oua73PxVsCWhc0mQ5IEG9I2VXF7mi3P
         SJ9LdmAnLulG4Sjdf0CFs0Jd/QzrEFlpywJ5WAkKY1j8TNlcahuDbY37OB128wqI7m
         xqPIlalHNTC0lw6T0JUI0oCUwfzqQkVw/mCXTZrzL/E9Z8Xu073Wdcj5rdKju3zQNy
         kcUO1MyCntcNg==
Subject: [PATCH 12/13] populate: check that we created a realtime rmap btree
 of the given height
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:45 -0800
Message-ID: <167243884551.739669.9596459322408561738.stgit@magnolia>
In-Reply-To: <167243884390.739669.13524725872131241203.stgit@magnolia>
References: <167243884390.739669.13524725872131241203.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that we actually create an rt rmap btree of the desired height
somewhere in the filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)


diff --git a/common/populate b/common/populate
index 7d57cd1287..6a05177e6d 100644
--- a/common/populate
+++ b/common/populate
@@ -631,6 +631,37 @@ __populate_check_xfs_agbtree_height() {
 	return 1
 }
 
+# Check that there's at least one rt btree with multiple levels
+__populate_check_xfs_rgbtree_height() {
+	local bt_type="$1"
+	local rgcount=$(_scratch_xfs_db -c 'sb 0' -c 'p rgcount' | awk '{print $3}')
+	local path
+	local path_format
+	local bt_prefix
+
+	case "${bt_type}" in
+	"rmap")
+		path_format="/realtime/%u.rmap"
+		bt_prefix="u3.rtrmapbt"
+		;;
+	*)
+		_fail "Don't know about rt btree ${bt_type}"
+		;;
+	esac
+
+	for ((rgno = 0; rgno < rgcount; rgno++)); do
+		path="$(printf "${path_format}" "${rgno}")"
+		bt_level=$(_scratch_xfs_db -c "path -m ${path}" -c "p ${bt_prefix}.level" | awk '{print $3}')
+		# "level" is the actual level within the btree
+		if [ "${bt_level}" -gt 0 ]; then
+			return 0
+		fi
+	done
+
+	__populate_fail "Failed to create rt ${bt_type} of sufficient height!"
+	return 1
+}
+
 # Check that populate created all the types of files we wanted
 _scratch_xfs_populate_check() {
 	_scratch_mount
@@ -654,6 +685,7 @@ _scratch_xfs_populate_check() {
 	is_finobt=$(_xfs_has_feature "$SCRATCH_MNT" finobt -v)
 	is_rmapbt=$(_xfs_has_feature "$SCRATCH_MNT" rmapbt -v)
 	is_reflink=$(_xfs_has_feature "$SCRATCH_MNT" reflink -v)
+	is_rt="$(_xfs_get_rtextents "$SCRATCH_MNT")"
 
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
@@ -684,6 +716,8 @@ _scratch_xfs_populate_check() {
 	test $is_finobt -ne 0 && __populate_check_xfs_agbtree_height "fino"
 	test $is_rmapbt -ne 0 && __populate_check_xfs_agbtree_height "rmap"
 	test $is_reflink -ne 0 && __populate_check_xfs_agbtree_height "refcnt"
+	test $is_rmapbt -ne 0 && test $is_rt -gt 0 && \
+		__populate_check_xfs_rgbtree_height "rmap"
 }
 
 # Check data fork format of ext4 file

