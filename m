Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F33C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiLaAkg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbiLaAke (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:40:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35E31E3FE;
        Fri, 30 Dec 2022 16:40:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95E51B81E34;
        Sat, 31 Dec 2022 00:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6C3C433EF;
        Sat, 31 Dec 2022 00:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447230;
        bh=NEJVxybmGz9m2WGi9E8ExY9mgy9FwwtkPSjtg8F/6jk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ev7FsCMOx+N2jixBGo2ZjEmLH3S+1DlVRCsw5c8bgYkuJmbhb21EZ8tJnVxaqlVe8
         eSRcjoZ9NqCKfDZSXALnT7/HrrwNynBb7wCB7AeDWLp2HPri+M0xXLuyJREc3HzHW9
         eYBA0zUjA84N/1yLq5hOwhyOpJjCTHmgIfbbrk9xrq3n/6LuCGXIQdXSjwOrINlo7z
         DOSm1quCS1EwxuEe0rBD6T8FcmGs1ia+9qCWz2yWaVmpMk24PukWHmi1haSl/x7+Ux
         FIxAtSbqNZltwD7/YM+4/OH1dFKZC04uVPtT6X8PcIZG6ZZ28Y5P1PwOR8GIk9MTOT
         6c5k8TXihsYig==
Subject: [PATCH 1/2] xfs: test rebuilding the entire filesystem with online
 fsck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:12 -0800
Message-ID: <167243875254.723308.5964105615767086182.stgit@magnolia>
In-Reply-To: <167243875241.723308.1395808663517469875.stgit@magnolia>
References: <167243875241.723308.1395808663517469875.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a new knob, TEST_XFS_SCRUB_REBUILD, that makes it so that we use
xfs_scrub to rebuild the ondisk metadata after every test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 README       |    3 ++
 common/fuzzy |    1 +
 common/rc    |    2 +-
 common/xfs   |   77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 82 insertions(+), 1 deletion(-)


diff --git a/README b/README
index 4c4f22f853..744317625f 100644
--- a/README
+++ b/README
@@ -191,6 +191,9 @@ Extra XFS specification:
    to check the filesystem. As of August 2021, xfs_repair finds all
    filesystem corruptions found by xfs_check, and more, which means that
    xfs_check is no longer run by default.
+ - Set TEST_XFS_SCRUB_REBUILD=1 to have _check_xfs_filesystem run xfs_scrub in
+   "force_repair" mode to rebuild the filesystem; and xfs_repair -n to check
+   the results of the rebuilding.
  - xfs_scrub, if present, will always check the test and scratch
    filesystems if they are still online at the end of the test. It is no
    longer necessary to set TEST_XFS_SCRUB.
diff --git a/common/fuzzy b/common/fuzzy
index 14f7fdf03c..d8de55250d 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -975,6 +975,7 @@ __scratch_xfs_stress_setup_force_rebuild() {
 # and wait for 30*TIME_FACTOR seconds to see if the filesystem goes down.
 # Same requirements and arguments as _scratch_xfs_stress_scrub.
 _scratch_xfs_stress_online_repair() {
+	touch "$RESULT_DIR/.skip_orebuild"	# no need to test online rebuild
 	__scratch_xfs_stress_setup_force_rebuild
 	XFS_SCRUB_FORCE_REPAIR=1 _scratch_xfs_stress_scrub "$@"
 }
diff --git a/common/rc b/common/rc
index 23530413ec..a1b65f0a7f 100644
--- a/common/rc
+++ b/common/rc
@@ -1685,7 +1685,7 @@ _require_scratch_nocheck()
             exit 1
         fi
     fi
-    rm -f ${RESULT_DIR}/require_scratch
+    rm -f ${RESULT_DIR}/require_scratch "$RESULT_DIR/.skip_orebuild"
 }
 
 # we need the scratch device and it needs to not be an lvm device
diff --git a/common/xfs b/common/xfs
index 436569ba28..804047557b 100644
--- a/common/xfs
+++ b/common/xfs
@@ -692,6 +692,8 @@ _scratch_xfs_mdrestore()
 # run xfs_check and friends on a FS.
 _check_xfs_filesystem()
 {
+	local can_scrub=
+
 	if [ $# -ne 3 ]; then
 		echo "Usage: _check_xfs_filesystem device <logdev>|none <rtdev>|none" 1>&2
 		exit 1
@@ -726,6 +728,8 @@ _check_xfs_filesystem()
 	# Run online scrub if we can.
 	mntpt="$(_is_dev_mounted $device)"
 	if [ -n "$mntpt" ] && _supports_xfs_scrub "$mntpt" "$device"; then
+		can_scrub=1
+
 		# Tests can create a scenario in which a call to syncfs() issued
 		# at the end of the execution of the test script would return an
 		# error code. xfs_scrub internally calls syncfs() before
@@ -842,6 +846,79 @@ _check_xfs_filesystem()
 		_mount_or_remount_rw "$extra_mount_options" $device $mountpoint
 	fi
 
+	# If desired, test the online metadata rebuilding behavior if the
+	# filesystem was mounted when this function was called.
+	if [ -n "$TEST_XFS_SCRUB_REBUILD" ] && [ -n "$can_scrub" ] && [ ! -e "$RESULT_DIR/.skip_orebuild" ]; then
+		orebuild_ok=1
+
+		# Walk the entire directory tree to load directory blocks into
+		# memory and populate the dentry cache, which can speed up the
+		# repairs considerably when the directory tree is very large.
+		find $mntpt &>/dev/null &
+
+		XFS_SCRUB_FORCE_REPAIR=1 "$XFS_SCRUB_PROG" -v -d $mntpt > $tmp.scrub 2>&1
+		if [ $? -ne 0 ]; then
+			if grep -q 'No space left on device' $tmp.scrub; then
+				# It's not an error if the fs does not have
+				# enough space to complete a repair.  We will
+				# check everything, though.
+				echo "*** XFS_SCRUB_FORCE_REPAIR=1 xfs_scrub -v -d ran out of space ***" >> $seqres.full
+				cat $tmp.scrub >> $seqres.full
+				echo "*** end xfs_scrub output" >> $seqres.full
+			else
+				_log_err "_check_xfs_filesystem: filesystem on $device failed scrub orebuild"
+				echo "*** XFS_SCRUB_FORCE_REPAIR=1 xfs_scrub -v -d output ***" >> $seqres.full
+				cat $tmp.scrub >> $seqres.full
+				echo "*** end xfs_scrub output" >> $seqres.full
+				ok=0
+				orebuild_ok=0
+			fi
+		fi
+		rm -f $tmp.scrub
+
+		# Clear force_repair because xfs_scrub could have set it
+		$XFS_IO_PROG -x -c 'inject noerror' "$mntpt" >> $seqres.full
+
+		"$XFS_SCRUB_PROG" -v -d -n $mntpt > $tmp.scrub 2>&1
+		if [ $? -ne 0 ]; then
+			_log_err "_check_xfs_filesystem: filesystem on $device failed scrub orebuild recheck"
+			echo "*** xfs_scrub -v -d -n output ***" >> $seqres.full
+			cat $tmp.scrub >> $seqres.full
+			echo "*** end xfs_scrub output" >> $seqres.full
+			ok=0
+			orebuild_ok=0
+		fi
+		rm -f $tmp.scrub
+
+		mountpoint=`_umount_or_remount_ro $device`
+
+		$XFS_REPAIR_PROG -n $extra_options $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
+		if [ $? -ne 0 ]; then
+			_log_err "_check_xfs_filesystem: filesystem on $device is inconsistent (orebuild-reverify)"
+			echo "*** xfs_repair -n output ***"	>>$seqres.full
+			cat $tmp.repair				>>$seqres.full
+			echo "*** end xfs_repair output"	>>$seqres.full
+
+			ok=0
+			orebuild_ok=0
+		fi
+		rm -f $tmp.repair
+
+		if [ $ok -eq 0 ]; then
+			echo "*** mount output ***"		>>$seqres.full
+			_mount					>>$seqres.full
+			echo "*** end mount output"		>>$seqres.full
+		elif [ "$type" = "xfs" ]; then
+			_mount_or_remount_rw "$extra_mount_options" $device $mountpoint
+		fi
+
+		if [ "$orebuild_ok" -ne 1 ] && [ "$DUMP_CORRUPT_FS" = "1" ]; then
+			local flatdev="$(basename "$device")"
+			_xfs_metadump "$seqres.$flatdev.orebuild.md" "$device" \
+				"$logdev" compress >> $seqres.full
+		fi
+	fi
+
 	if [ $ok -eq 0 ]; then
 		status=1
 		if [ "$iam" != "check" ]; then

