Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC460C5479D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236216AbiLaDIH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiLaDHn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:07:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADE71054D;
        Fri, 30 Dec 2022 19:07:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9A27B81EAB;
        Sat, 31 Dec 2022 03:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79EA2C433D2;
        Sat, 31 Dec 2022 03:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456059;
        bh=Ja2rsjmpbCQZlvCHfjK9BjCD4ORiClJi7K/yA4HQy+s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nqYHnsOv+dHq4rbBCPUWkcYHm3Qxg3KyE3f8zs0mZOtCr+dcWQ7ncGRdVgGXb6nIp
         uYtPjBVHm2VQRIAROLYts3xrNOXt4GbNw4LEkt6NbJUuvngjFkwzE8ClJOkqvp9XUD
         GNzYFV01TfOqPqkrbCqh04qjZtY3HUylyl8lzmDHpm8HJk4deAFNPWT60lrgITgqzk
         l8PINx1g6tKNxB53wEx1cTQArFkFdKQXn06qj82ji+kkFqPTuTJZ5KH5x/qRuSDXmB
         O1RcgkYvfMrQGvcMIbPC6v71Xokm40fKHNFEjmVWChBfKA700C3LBSRwJf4W/H+sQi
         9bBQ4tCLiBnSQ==
Subject: [PATCH 6/9] xfs/{050,144,153,299,330}: update quota reports to leave
 out metadir files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:33 -0800
Message-ID: <167243883317.736753.15243001924230247968.stgit@magnolia>
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

Remove the metadata directory tree directories from the quota reporting
in these tests so that we don't regress the golden output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/filter |    7 +++++--
 common/xfs    |   23 +++++++++++++++++++++++
 tests/xfs/050 |    1 +
 tests/xfs/153 |    1 +
 tests/xfs/299 |    1 +
 tests/xfs/330 |    6 +++++-
 6 files changed, 36 insertions(+), 3 deletions(-)


diff --git a/common/filter b/common/filter
index 3e3fea7ea0..49c6859992 100644
--- a/common/filter
+++ b/common/filter
@@ -618,11 +618,14 @@ _filter_getcap()
 
 # Filter user/group/project id numbers out of quota reports, and standardize
 # the block counts to use filesystem block size.  Callers must set the id and
-# bsize variables before calling this function.
+# bsize variables before calling this function.  The qhidden_rootfiles variable
+# (by default zero) is the number of root files to filter out of the inode
+# count part of the quota report.
 _filter_quota_report()
 {
 	test -n "$id" || echo "id must be set"
 	test -n "$bsize" || echo "block size must be set"
+	test -n "$qhidden_rootfiles" || qhidden_rootfiles=0
 
 	tr -s '[:space:]' | \
 	perl -npe '
@@ -630,7 +633,7 @@ _filter_quota_report()
 		s/^\#0 \d+ /[ROOT] 0 /g;
 		s/6 days/7 days/g' |
 	perl -npe '
-		$val = 0;
+		$val = '"$qhidden_rootfiles"';
 		if ($ENV{'LARGE_SCRATCH_DEV'}) {
 			$val = $ENV{'NUM_SPACE_FILES'};
 		}
diff --git a/common/xfs b/common/xfs
index 0f69d3eb18..99e377631b 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1783,3 +1783,26 @@ _scratch_xfs_force_no_metadir()
 		MKFS_OPTIONS="-m metadir=0 $MKFS_OPTIONS"
 	fi
 }
+
+# Decide if a mount filesystem has metadata directory trees.
+_xfs_mount_has_metadir() {
+	local mount="$1"
+
+	# spaceman (and its info command) predate metadir
+	test ! -e "$XFS_SPACEMAN_PROG" && return 1
+	$XFS_SPACEMAN_PROG -c "info" "$mount" | grep -q 'metadir=1'
+}
+
+# Compute the number of files in the metadata directory tree.
+_xfs_calc_metadir_files() {
+	local mount="$1"
+
+	if ! _xfs_mount_has_metadir "$mount"; then
+		echo 0
+		return
+	fi
+
+	local regfiles="$($XFS_IO_PROG -c 'bulkstat' "$mount" | grep '^bs_ino' | wc -l)"
+	local metafiles="$($XFS_IO_PROG -c 'bulkstat -m' "$mount" 2>&1 | grep '^bs_ino' | wc -l)"
+	echo $((metafiles - regfiles))
+}
diff --git a/tests/xfs/050 b/tests/xfs/050
index 2220e47016..64fbaf687d 100755
--- a/tests/xfs/050
+++ b/tests/xfs/050
@@ -34,6 +34,7 @@ _require_xfs_quota
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 bsize=$(_get_file_block_size $SCRATCH_MNT)
+qhidden_rootfiles=$(_xfs_calc_metadir_files $SCRATCH_MNT)
 _scratch_unmount
 
 bsoft=$(( 200 * $bsize ))
diff --git a/tests/xfs/153 b/tests/xfs/153
index dbe26b6803..fc64bf734a 100755
--- a/tests/xfs/153
+++ b/tests/xfs/153
@@ -39,6 +39,7 @@ _require_test_program "vfs/mount-idmapped"
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 bsize=$(_get_file_block_size $SCRATCH_MNT)
+qhidden_rootfiles=$(_xfs_calc_metadir_files $SCRATCH_MNT)
 _scratch_unmount
 
 bsoft=$(( 200 * $bsize ))
diff --git a/tests/xfs/299 b/tests/xfs/299
index 4b9df3c6aa..2167c492c4 100755
--- a/tests/xfs/299
+++ b/tests/xfs/299
@@ -159,6 +159,7 @@ _qmount_option "uquota,gquota,pquota"
 _qmount
 
 bsize=$(_get_file_block_size $SCRATCH_MNT)
+qhidden_rootfiles=$(_xfs_calc_metadir_files $SCRATCH_MNT)
 
 bsoft=$(( 100 * $bsize ))
 bhard=$(( 500 * $bsize ))
diff --git a/tests/xfs/330 b/tests/xfs/330
index c6e74e67e8..e919ccc1ca 100755
--- a/tests/xfs/330
+++ b/tests/xfs/330
@@ -26,7 +26,10 @@ _require_nobody
 
 do_repquota()
 {
-	repquota $SCRATCH_MNT | grep -E '^(fsgqa|root|nobody)' | sort -r
+	repquota $SCRATCH_MNT | grep -E '^(fsgqa|root|nobody)' | sort -r | \
+	perl -npe '
+		$val = '"$qhidden_rootfiles"';
+		s/(^root\s+--\s+\S+\s+\S+\s+\S+\s+)(\S+)/$1@{[$2 - $val]}/g'
 }
 
 rm -f "$seqres.full"
@@ -35,6 +38,7 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
 _scratch_mount >> "$seqres.full" 2>&1
+qhidden_rootfiles=$(_xfs_calc_metadir_files $SCRATCH_MNT)
 quotacheck -u -g $SCRATCH_MNT 2> /dev/null
 quotaon $SCRATCH_MNT 2> /dev/null
 

