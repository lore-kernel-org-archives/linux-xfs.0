Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66FD8C3F6B0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 19:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239803AbiGZTta (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 15:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239623AbiGZTt3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 15:49:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1247357E4;
        Tue, 26 Jul 2022 12:49:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AC14B81A0C;
        Tue, 26 Jul 2022 19:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBFCC433C1;
        Tue, 26 Jul 2022 19:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658864966;
        bh=kGOZC86XoZIhEkIl9Rg3eU70eX/lOCt+6PenAyb4Ih8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VY+wxoe/a5jBDEh6Lxzt0+XdkA/ZHvB9hMSSpey0roy0PcndXg8kS2DzFJ/vv+WF0
         Y07+y7txkJOxH6wdmGSui9DUR+aruufVoqG7NLcuIwYr8/V/gUu24JZM7onyOPn+Po
         7WShlm5UZREWwK1tk5PKfGQmNmZ3rTYvpHofy32Qzvdx8M7NxMtND7vQJ175nSxL0i
         tLW8NOIaWtqoE2R9E8XjEt7ai8R+hNqawUpdyDfiMzaKCdiOaZ7jzF6po82L3jawqd
         H0gCDVfB8rtBOOCvuekxUCrYLrFQk8Ctkw8mlueitpFtMMq8qACWojrRfk4YXOu7jb
         472/EJ6QZaA9g==
Subject: [PATCH 3/3] common: filter internal errors during io error testing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 26 Jul 2022 12:49:25 -0700
Message-ID: <165886496575.1585306.16047150077901464823.stgit@magnolia>
In-Reply-To: <165886494905.1585306.15343417924888857310.stgit@magnolia>
References: <165886494905.1585306.15343417924888857310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The goal of an EIO shutdown test is to examine the shutdown and recovery
behavior if we make the underlying storage device return EIO.  On XFS,
it's possible that the shutdown will come from a thread that cancels a
dirty transaction due to the EIO.  This is expected behavior, but
_check_dmesg will flag it as a test failure.

Make it so that we can add simple regexps to the default check_dmesg
filter function, then add the "Internal error" string to filter function
when we invoke an EIO test.  This fixes periodic regressions in
generic/019 and generic/475.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 check      |    1 +
 common/rc  |   19 ++++++++++++++++++-
 common/xfs |    7 +++++++
 3 files changed, 26 insertions(+), 1 deletion(-)


diff --git a/check b/check
index 0b2f10ed..000e31cb 100755
--- a/check
+++ b/check
@@ -896,6 +896,7 @@ function run_section()
 			echo "run fstests $seqnum at $date_time" > /dev/kmsg
 			# _check_dmesg depends on this log in dmesg
 			touch ${RESULT_DIR}/check_dmesg
+			rm -f ${RESULT_DIR}/dmesg_filter
 		fi
 		_try_wipe_scratch_devs > /dev/null 2>&1
 
diff --git a/common/rc b/common/rc
index 317049bc..12964ae2 100644
--- a/common/rc
+++ b/common/rc
@@ -4331,8 +4331,25 @@ _check_dmesg_for()
 # lockdep.
 _check_dmesg_filter()
 {
+	local extra_filter=
+	local filter_file="${RESULT_DIR}/dmesg_filter"
+
+	test -e "$filter_file" && extra_filter="-f $filter_file"
+
 	egrep -v -e "BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low" \
-		-e "BUG: MAX_STACK_TRACE_ENTRIES too low"
+		-e "BUG: MAX_STACK_TRACE_ENTRIES too low" \
+		$extra_filter
+}
+
+# Add a simple expression to the default dmesg filter
+_add_dmesg_filter()
+{
+	local regexp="$1"
+	local filter_file="${RESULT_DIR}/dmesg_filter"
+
+	if [ ! -e "$filter_file" ] || ! grep -q "$regexp" "$filter_file"; then
+		echo "$regexp" >> "${RESULT_DIR}/dmesg_filter"
+	fi
 }
 
 # check dmesg log for WARNING/Oops/etc.
diff --git a/common/xfs b/common/xfs
index a7bc661e..8c52f0bb 100644
--- a/common/xfs
+++ b/common/xfs
@@ -818,6 +818,13 @@ _xfs_prepare_for_eio_shutdown()
 	local dev="$1"
 	local ctlfile="error/fail_at_unmount"
 
+	# Once we enable IO errors, it's possible that a writer thread will
+	# trip over EIO, cancel the transaction, and shut down the system.
+	# This is expected behavior, so we need to remove the "Internal error"
+	# message from the list of things that can cause the test to be marked
+	# as failed.
+	_add_dmesg_filter "Internal error"
+
 	# Don't retry any writes during the (presumably) post-shutdown unmount
 	_has_fs_sysfs "$ctlfile" && _set_fs_sysfs_attr $dev "$ctlfile" 1
 

