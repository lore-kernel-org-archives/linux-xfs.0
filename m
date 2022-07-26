Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8CDC04A68
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 19:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239710AbiGZTsy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 15:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiGZTsx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 15:48:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DA533400;
        Tue, 26 Jul 2022 12:48:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6106761513;
        Tue, 26 Jul 2022 19:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD700C433D6;
        Tue, 26 Jul 2022 19:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658864931;
        bh=6sPnFU/Jy3QJp15gmqOMMIjHLbuQqvXAA0PHYaigEp4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SY5LodYVBnwZpusX2ftWLJehn33Wqv4uBT9m8tNGU+27P/vo1H8mZNVf7pOYX26kk
         JU9fE9ANoR8XQFAPC42kvFWERIqdIPlHAAC7JfjHdl5ize9tb6KEhZs2oAO6uTCK4L
         MRxio1exo0YQ3SJp1mlppY0ssHEKVmOGb9t+K1EUR3IGBRLHnSrJlVkPL7KIuzd8kh
         Dm2Hq6XTry8hiNnhUGaZjtpOtv5wk4dTBwPAlWQ1B977+j3zhxSaDNczGK9/B7JP2Q
         wBJlX1CnSI3y1qobO1d7ochS9DWyMqthbCkOWOf5kKD+RSw0DAD1kmFfkmdOjozgz0
         iMdS7iG2q6glQ==
Subject: [PATCH 1/1] dmlogwrites: skip generic tests when external logdev in
 use
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 26 Jul 2022 12:48:51 -0700
Message-ID: <165886493136.1585149.12462469554668740768.stgit@magnolia>
In-Reply-To: <165886492580.1585149.760428651537119015.stgit@magnolia>
References: <165886492580.1585149.760428651537119015.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, dm-logwrites and common/dmlogwrites don't seem to have any
means to coordinate the event numbers across multiple devices, and the
fstests setup code is sufficiently intense that it doesn't seem like
there's support for multi-disk filesystems.  For now, we'll _notrun the
tests when we have external log devices, even though that seems like
something we'd _really_ want to test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc         |    8 ++++++++
 tests/generic/455 |    1 +
 tests/generic/457 |    1 +
 tests/generic/470 |    1 +
 tests/generic/482 |    1 +
 5 files changed, 12 insertions(+)


diff --git a/common/rc b/common/rc
index 60a9bacd..197c9415 100644
--- a/common/rc
+++ b/common/rc
@@ -2002,6 +2002,14 @@ _require_logdev()
     $UMOUNT_PROG $SCRATCH_LOGDEV 2>/dev/null
 }
 
+# This test requires that an external log device is not in use
+#
+_require_no_logdev()
+{
+	[ "$USE_EXTERNAL" = "yes" ] && [ -n "$SCRATCH_LOGDEV" ] && \
+		_notrun "Test not compatible with external logs, skipped this test"
+}
+
 # this test requires loopback device support
 #
 _require_loop()
diff --git a/tests/generic/455 b/tests/generic/455
index 13d326e7..649b5410 100755
--- a/tests/generic/455
+++ b/tests/generic/455
@@ -25,6 +25,7 @@ _cleanup()
 _supported_fs generic
 _require_test
 _require_scratch_nocheck
+_require_no_logdev
 _require_log_writes
 _require_dm_target thin-pool
 
diff --git a/tests/generic/457 b/tests/generic/457
index 7e0a3157..da75798f 100755
--- a/tests/generic/457
+++ b/tests/generic/457
@@ -26,6 +26,7 @@ _cleanup()
 _supported_fs generic
 _require_test
 _require_scratch_reflink
+_require_no_logdev
 _require_cp_reflink
 _require_log_writes
 _require_dm_target thin-pool
diff --git a/tests/generic/470 b/tests/generic/470
index dd8525d7..f3407511 100755
--- a/tests/generic/470
+++ b/tests/generic/470
@@ -27,6 +27,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _require_scratch_nocheck
+_require_no_logdev
 _require_log_writes_dax_mountopt "dax"
 _require_dm_target thin-pool
 _require_xfs_io_command "mmap" "-S"
diff --git a/tests/generic/482 b/tests/generic/482
index c7e034d0..28c83a23 100755
--- a/tests/generic/482
+++ b/tests/generic/482
@@ -49,6 +49,7 @@ _cleanup()
 # Modify as appropriate.
 _supported_fs generic
 
+_require_no_logdev
 _require_command "$KILLALL_PROG" killall
 # Use thin device as replay device, which requires $SCRATCH_DEV
 _require_scratch_nocheck

