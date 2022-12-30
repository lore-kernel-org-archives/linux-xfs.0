Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A337C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235896AbiLaAsy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235953AbiLaAsv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:48:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40A81C921;
        Fri, 30 Dec 2022 16:48:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82741B81DAF;
        Sat, 31 Dec 2022 00:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DCBC433D2;
        Sat, 31 Dec 2022 00:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447728;
        bh=4BHdVO5u7Fx1QSmqvqHGoDSx/S5p/HWHJwtW3AVZlI8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kk0TMerfFYOGVX1O4122V9vuevnw82+jYMrJkcA0uGriUiK+y6stU96GYoLEUqJOb
         Idarhk7M5e3UfdwoNrppLmTtgVYskVT5+kYS6fnnwRD0HyoeG4LC/Mi84j4u1ySInx
         c8e+HEBjCUrTLew/W9yNjcnpXGly3BJHKruk9oyBKuBWzYQzz2CHt7FH2wMa7VFBld
         p4F/mo9hFjxYtohNOQ90/SHuPnQ6uHW33KEOgzxO0cY2hh6HH5CvsYmeoxeZo590Nd
         s5A93rNhRiKIhzrnFvVU4LkH1nOKQYtZEsunh1odSGzyJUvGw7W44mUU25e7h0gjnR
         WX80urSe3HI1Q==
Subject: [PATCH 18/24] common: check xfs health after doing an online scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:41 -0800
Message-ID: <167243878140.730387.8820397468231187961.stgit@magnolia>
In-Reply-To: <167243877899.730387.9276624623424433346.stgit@magnolia>
References: <167243877899.730387.9276624623424433346.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

After we've run xfs_scrub -n to perform a check of a mounted
filesystem's metadata, we should check the health reporting system to
make sure that the results got recorded.  Also wire this up to the xfs
fuzz testing helpers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   27 +++++++++++++++++++++++++++
 common/xfs   |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)


diff --git a/common/fuzzy b/common/fuzzy
index cf085f8b28..d841d435eb 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -216,6 +216,15 @@ __scratch_xfs_fuzz_field_online() {
 	test $res -eq 0 && \
 		(>&2 echo "${fuzz_action}: online scrub didn't fail.")
 
+	# Does the health status report reflect the corruption?
+	if [ $res -ne 0 ]; then
+		__fuzz_notify "++ Detect fuzzed field ill-health report"
+		_check_xfs_health $SCRATCH_MNT 2>&1
+		res=$?
+		test $res -ne 1 && \
+			(>&2 echo "${fuzz_action}: online health check failed ($res).")
+	fi
+
 	# Try fixing the filesystem online
 	__fuzz_notify "++ Try to repair filesystem (online)"
 	_scratch_scrub 2>&1
@@ -308,6 +317,15 @@ __scratch_xfs_fuzz_field_norepair() {
 	test $res -eq 0 && \
 		(>&2 echo "${fuzz_action}: online scrub didn't fail.")
 
+	# Does the health status report reflect the corruption?
+	if [ $res -ne 0 ]; then
+		__fuzz_notify "++ Detect fuzzed field ill-health report"
+		_check_xfs_health $SCRATCH_MNT 2>&1
+		res=$?
+		test $res -ne 1 && \
+			(>&2 echo "${fuzz_action}: online health check failed ($res).")
+	fi
+
 	__scratch_xfs_fuzz_unmount
 
 	return 0
@@ -338,6 +356,15 @@ __scratch_xfs_fuzz_field_both() {
 		test $res -eq 0 && \
 			(>&2 echo "${fuzz_action}: online scrub didn't fail.")
 
+		# Does the health status report reflect the corruption?
+		if [ $res -ne 0 ]; then
+			__fuzz_notify "++ Detect fuzzed field ill-health report"
+			_check_xfs_health $SCRATCH_MNT 2>&1
+			res=$?
+			test $res -ne 1 && \
+				(>&2 echo "${fuzz_action}: online health check failed ($res).")
+		fi
+
 		# Try fixing the filesystem online
 		__fuzz_notify "++ Try to repair filesystem (online)"
 		_scratch_scrub 2>&1
diff --git a/common/xfs b/common/xfs
index 804047557b..371618dc7b 100644
--- a/common/xfs
+++ b/common/xfs
@@ -599,6 +599,37 @@ _require_xfs_db_command()
 		_notrun "xfs_db $command support is missing"
 }
 
+# Check the health of a mounted XFS filesystem.  Callers probably want to
+# ensure that xfs_scrub has been run first.  Returns 1 if unhealthy metadata
+# are found or 0 otherwise.
+_check_xfs_health() {
+	local mntpt="$1"
+	local ret=0
+	local t="$tmp.health_helper"
+
+	test -x "$XFS_SPACEMAN_PROG" || return 0
+
+	$XFS_SPACEMAN_PROG -c 'health -c -q' $mntpt > $t.out 2> $t.err
+	test $? -ne 0 && ret=1
+
+	# Don't return error if userspace or kernel don't support health
+	# reporting.
+	grep -q 'command.*health.*not found' $t.err && return 0
+	grep -q 'Inappropriate ioctl for device' $t.err && return 0
+
+	# Filter out the "please run scrub" message if nothing's been checked.
+	sed -e '/Health status has not been/d' -e '/Please run xfs_scrub/d' -i \
+			$t.err
+
+	grep -q unhealthy $t.out && ret=1
+	test $(wc -l < $t.err) -gt 0 && ret=1
+	cat $t.out
+	cat $t.err 1>&2
+	rm -f $t.out $t.err
+
+	return $ret
+}
+
 # Does the filesystem mounted from a particular device support scrub?
 _supports_xfs_scrub()
 {
@@ -750,6 +781,18 @@ _check_xfs_filesystem()
 			ok=0
 		fi
 		rm -f $tmp.scrub
+
+		# Does the health reporting notice anything?
+		_check_xfs_health $mntpt > $tmp.health 2>&1
+		res=$?
+		if [ $((res ^ ok)) -eq 0 ]; then
+			_log_err "_check_xfs_filesystem: filesystem on $device failed health check"
+			echo "*** xfs_spaceman -c 'health -c -q' output ***" >> $seqres.full
+			cat $tmp.health >> $seqres.full
+			echo "*** end xfs_spaceman output" >> $seqres.full
+			ok=0
+		fi
+		rm -f $tmp.health
 	fi
 
 	if [ "$type" = "xfs" ]; then

