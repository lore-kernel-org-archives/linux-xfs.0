Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A819C04A68
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 19:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239779AbiGZTtZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 15:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239654AbiGZTtY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 15:49:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35567357E5;
        Tue, 26 Jul 2022 12:49:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6DDEB80919;
        Tue, 26 Jul 2022 19:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92318C433C1;
        Tue, 26 Jul 2022 19:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658864960;
        bh=ehxNhR8SMV5Z67mOm4YqokKlpX6kINV6GrgKDo46cZ0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pCyivbnCLzKXaRUk+mpJd1atRc9of+6IBC04nWhQclwAQxKeioERQCe8xn8b6x6Hs
         PX7f8AXUV+4SN9wA+ImDhOPs717eEbNENxTI0bRcEdtCD5XgSeQqs+nhMyMBdDL0Ui
         QMDrFxu8r/fx8pl3ebPpq2S1Jtgu1ki4VXixlqZfkBYrJbmBsRK/PszPUjTzCNy/yJ
         gIPJem2GJgGCBt5ufDzGeVQvlTKcW/qwfk9t/qzBM6ZFnnES2urKh/F645k+vVz7mh
         zcOXrCUUCFJDHn83IZx+n57sRSmnpVNcQGAcGaZf6RASYn6iAFg16VDwKQZsOe72EO
         uL7eVtXGsfIsg==
Subject: [PATCH 2/3] common: disable infinite IO error retry for EIO shutdown
 tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 26 Jul 2022 12:49:20 -0700
Message-ID: <165886496017.1585306.14180522898371330403.stgit@magnolia>
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

This patch fixes a rather hard to hit livelock in the tests that test
how xfs handles shutdown behavior when the device suddenly dies and
starts returing EIO all the time.  The livelock happens if the AIL is
stuck retrying failed metadata updates forever, the log itself is not
being written, and there is no more log grant space, which prevents the
frontend from shutting down the log due to EIO errors during
transactions.

While most users probably want the default retry-forever behavior
because EIO can be transient, the circumstances are different here.  The
tests are designed to flip the device back to working status only after
the unmount succeeds, so we know there's no point in the filesystem
retrying writes until after the unmount.

This fixes some of the periodic hangs in generic/019 and generic/475.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/dmerror           |    4 ++++
 common/fail_make_request |    1 +
 common/rc                |   31 +++++++++++++++++++++++++++----
 common/xfs               |   29 +++++++++++++++++++++++++++++
 4 files changed, 61 insertions(+), 4 deletions(-)


diff --git a/common/dmerror b/common/dmerror
index 85ef9a16..ed5afaa4 100644
--- a/common/dmerror
+++ b/common/dmerror
@@ -138,6 +138,10 @@ _dmerror_load_error_table()
 		suspend_opt="$*"
 	fi
 
+	# If the full environment is set up, configure ourselves for shutdown
+	type _prepare_for_eio_shutdown &>/dev/null && \
+		_prepare_for_eio_shutdown $DMERROR_DEV
+
 	# Suspend the scratch device before the log and realtime devices so
 	# that the kernel can freeze and flush the filesystem if the caller
 	# wanted a freeze.
diff --git a/common/fail_make_request b/common/fail_make_request
index 9f8ea500..b5370ba6 100644
--- a/common/fail_make_request
+++ b/common/fail_make_request
@@ -44,6 +44,7 @@ _start_fail_scratch_dev()
 {
     echo "Force SCRATCH_DEV device failure"
 
+    _prepare_for_eio_shutdown $SCRATCH_DEV
     _bdev_fail_make_request $SCRATCH_DEV 1
     [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
         _bdev_fail_make_request $SCRATCH_LOGDEV 1
diff --git a/common/rc b/common/rc
index 09c81be6..317049bc 100644
--- a/common/rc
+++ b/common/rc
@@ -4372,6 +4372,20 @@ _check_dmesg()
 	fi
 }
 
+# Make whatever configuration changes we need ahead of testing fs shutdowns due
+# to unexpected IO errors while updating metadata.  The sole parameter should
+# be the fs device, e.g.  $SCRATCH_DEV.
+_prepare_for_eio_shutdown()
+{
+	local dev="$1"
+
+	case "$FSTYP" in
+	"xfs")
+		_xfs_prepare_for_eio_shutdown "$dev"
+		;;
+	esac
+}
+
 # capture the kmemleak report
 _capture_kmemleak()
 {
@@ -4634,7 +4648,7 @@ run_fsx()
 #
 # Usage example:
 #   _require_fs_sysfs error/fail_at_unmount
-_require_fs_sysfs()
+_has_fs_sysfs()
 {
 	local attr=$1
 	local dname
@@ -4650,9 +4664,18 @@ _require_fs_sysfs()
 		_fail "Usage: _require_fs_sysfs <sysfs_attr_path>"
 	fi
 
-	if [ ! -e /sys/fs/${FSTYP}/${dname}/${attr} ];then
-		_notrun "This test requires /sys/fs/${FSTYP}/${dname}/${attr}"
-	fi
+	test -e /sys/fs/${FSTYP}/${dname}/${attr}
+}
+
+# Require the existence of a sysfs entry at /sys/fs/$FSTYP/DEV/$ATTR
+_require_fs_sysfs()
+{
+	_has_fs_sysfs "$@" && return
+
+	local attr=$1
+	local dname=$(_short_dev $TEST_DEV)
+
+	_notrun "This test requires /sys/fs/${FSTYP}/${dname}/${attr}"
 }
 
 _require_statx()
diff --git a/common/xfs b/common/xfs
index ba72027c..a7bc661e 100644
--- a/common/xfs
+++ b/common/xfs
@@ -800,6 +800,35 @@ _scratch_xfs_unmount_dirty()
 	_scratch_unmount
 }
 
+# Prepare a mounted filesystem for an IO error shutdown test by disabling retry
+# for metadata writes.  This prevents a (rare) log livelock when:
+#
+# - The log has given out all available grant space, preventing any new
+#   writers from tripping over IO errors (and shutting down the fs/log),
+# - All log buffers were written to disk, and
+# - The log tail is pinned because the AIL keeps hitting EIO trying to write
+#   committed changes back into the filesystem.
+#
+# Real users might want the default behavior of the AIL retrying writes forever
+# but for testing purposes we don't want to wait.
+#
+# The sole parameter should be the filesystem data device, e.g. $SCRATCH_DEV.
+_xfs_prepare_for_eio_shutdown()
+{
+	local dev="$1"
+	local ctlfile="error/fail_at_unmount"
+
+	# Don't retry any writes during the (presumably) post-shutdown unmount
+	_has_fs_sysfs "$ctlfile" && _set_fs_sysfs_attr $dev "$ctlfile" 1
+
+	# Disable retry of metadata writes that fail with EIO
+	for ctl in max_retries retry_timeout_seconds; do
+		ctlfile="error/metadata/EIO/$ctl"
+
+		_has_fs_sysfs "$ctlfile" && _set_fs_sysfs_attr $dev "$ctlfile" 0
+	done
+}
+
 # Skip if we are running an older binary without the stricter input checks.
 # Make multiple checks to be sure that there is no regression on the one
 # selected feature check, which would skew the result.

