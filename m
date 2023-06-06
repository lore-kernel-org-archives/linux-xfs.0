Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DAA4C7EE43
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 22:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239868AbjFFW3d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 18:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239862AbjFFW3a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 18:29:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD7E1717;
        Tue,  6 Jun 2023 15:29:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8871562D9A;
        Tue,  6 Jun 2023 22:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AA9C433D2;
        Tue,  6 Jun 2023 22:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686090569;
        bh=0eqc4eS96XfhmaM65cuwLkQ+u2jlhnVKaAqHvfso1I8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t4QLybElDJjKdLnQqGRX3KjzdWFtcrXCkDUvITSM07B8LNBxVL2CvYkXZtpVBe2eh
         8Y+OrnSY4MEZIlQQQfYC6Cwtl7K+7Sb3XuNyIbxVibX6rlBpYaxxBU46As6768JCvY
         ZK7yMyD1mvYW9RieDNWGqbiDtyiOrOYHDPnqcDlQg+yzlnVt2ui3SC5wJRuAFzFsz1
         M40mAhcVCUqnIKTaEDgY4CfmgnB6pW2Saq07QXlk+IqdcznWiy4k1boxkies82KDJA
         x35T0tpg5juIgrI0khwb4MmIONw7KuhOw2vqNMKMLAC24iUqhTlBCC7vRo/huDZ8Ew
         +r/4PkQ6KCNjw==
Subject: [PATCH 1/3] fuzzy: disallow post-test online rebuilds when testing
 online fsck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 06 Jun 2023 15:29:28 -0700
Message-ID: <168609056848.2592490.8544982472802991550.stgit@frogsfrogsfrogs>
In-Reply-To: <168609056295.2592490.1272515528324889317.stgit@frogsfrogsfrogs>
References: <168609056295.2592490.1272515528324889317.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we're testing the online fsck code or running fuzz tests of the
filesystem, don't let the post-test checks rebuild the filesystem
metadata, because this is redundant with the test and will disturb
the metadata if the tools fail.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |    7 ++++++-
 common/rc    |    2 +-
 common/xfs   |   12 +++++++++++-
 3 files changed, 18 insertions(+), 3 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index a78a354142..7228158034 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -721,6 +721,9 @@ _scratch_xfs_fuzz_metadata() {
 	# Always capture full core dumps from crashing tools
 	ulimit -c unlimited
 
+	_xfs_skip_online_rebuild
+	_xfs_skip_offline_rebuild
+
 	echo "${fields}" | while read field; do
 		echo "${verbs}" | while read fuzzverb; do
 			__scratch_xfs_fuzz_mdrestore
@@ -1356,6 +1359,9 @@ _scratch_xfs_stress_scrub() {
 		rm -f "$tmp.scrub"
 	fi
 
+	_xfs_skip_online_rebuild
+	_xfs_skip_offline_rebuild
+
 	local start="$(date +%s)"
 	local end
 	if [ -n "$SOAK_DURATION" ]; then
@@ -1429,7 +1435,6 @@ __scratch_xfs_stress_setup_force_rebuild() {
 # and wait for 30*TIME_FACTOR seconds to see if the filesystem goes down.
 # Same requirements and arguments as _scratch_xfs_stress_scrub.
 _scratch_xfs_stress_online_repair() {
-	touch "$RESULT_DIR/.skip_orebuild"	# no need to test online rebuild
 	__scratch_xfs_stress_setup_force_rebuild
 	XFS_SCRUB_FORCE_REPAIR=1 _scratch_xfs_stress_scrub "$@"
 }
diff --git a/common/rc b/common/rc
index 37074371d7..c2ed40d768 100644
--- a/common/rc
+++ b/common/rc
@@ -1749,7 +1749,7 @@ _require_scratch_nocheck()
             exit 1
         fi
     fi
-    rm -f ${RESULT_DIR}/require_scratch "$RESULT_DIR/.skip_orebuild"
+    rm -f ${RESULT_DIR}/require_scratch "$RESULT_DIR/.skip_orebuild" "$RESULT_DIR/.skip_rebuild"
 }
 
 # we need the scratch device and it needs to not be an lvm device
diff --git a/common/xfs b/common/xfs
index 137ac9dbbe..d85acd9572 100644
--- a/common/xfs
+++ b/common/xfs
@@ -721,6 +721,16 @@ _scratch_xfs_mdrestore()
 	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$@"
 }
 
+# Do not use xfs_repair (offline fsck) to rebuild the filesystem
+_xfs_skip_offline_rebuild() {
+	touch "$RESULT_DIR/.skip_rebuild"
+}
+
+# Do not use xfs_scrub (online fsck) to rebuild the filesystem
+_xfs_skip_online_rebuild() {
+	touch "$RESULT_DIR/.skip_orebuild"
+}
+
 # run xfs_check and friends on a FS.
 _check_xfs_filesystem()
 {
@@ -849,7 +859,7 @@ _check_xfs_filesystem()
 	fi
 
 	# Optionally test the index rebuilding behavior.
-	if [ -n "$TEST_XFS_REPAIR_REBUILD" ]; then
+	if [ -n "$TEST_XFS_REPAIR_REBUILD" ] && [ ! -e "$RESULT_DIR/.skip_rebuild" ]; then
 		rebuild_ok=1
 		$XFS_REPAIR_PROG $extra_options $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
 		if [ $? -ne 0 ]; then

