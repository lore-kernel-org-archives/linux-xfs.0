Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B09D5C6FD18
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Mar 2023 00:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjC2A6N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Mar 2023 20:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjC2A6M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Mar 2023 20:58:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B751FE2;
        Tue, 28 Mar 2023 17:58:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D86361A15;
        Wed, 29 Mar 2023 00:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4D2C433EF;
        Wed, 29 Mar 2023 00:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680051490;
        bh=7X4wCnYJn7Rq6nGNOHZh/8BiePB5G0VwBfETuwqyVSw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SlLgb+tHU9w6x5nOa79rae0fkF4t7ZY1T7JXvKkP7WYp7QiyjWcEzlmI5ayzJkVmE
         8sn09pzKWH/i/ltNdTvwAIZWQc/614EV/yOPhsbiSPnGQQwB2QyvDtJp0ilnJzr+CW
         l6ictsfoExpgcsodm0NJC50ZIqeSEmnhT/3uioCDPOi7j3iAepDG4JWDLiAk+tq8a2
         0zx/5Vw6gIbPiMEChxwHczkbl2D2X/L5vI5ezNqJeOsZR1/i8x3tpAEMhDfCSb/5nJ
         4X8f+La+B5ZwEo52NMPQp/S0YBzTw3xom5OHFfjO3Cb+Z3bNMs3EtPieDJ2FUJJs9E
         +yUrF16ZNpsQw==
Subject: [PATCH 1/3] generic/{251,260}: compute maximum fitrim offset
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 28 Mar 2023 17:58:10 -0700
Message-ID: <168005149047.4147931.2729971759269213680.stgit@frogsfrogsfrogs>
In-Reply-To: <168005148468.4147931.1986862498548445502.stgit@frogsfrogsfrogs>
References: <168005148468.4147931.1986862498548445502.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

FITRIM is a bizarre ioctl.  Callers are allowed to pass in "start" and
"length" parameters, which are clearly some kind of range argument.  No
means is provided to discover the minimum or maximum range.  Although
regular userspace programs default to (start=0, length=-1ULL), this test
tries to exercise different parameters.

However, the test assumes that the "size" column returned by the df
command is the maximum value supported by the FITRIM command, and is
surprised if the number of bytes trimmed by (start=0, length=-1ULL) is
larger than this size quantity.

This is completely wrong on XFS with realtime volumes, because the
statfs output (which is what df reports) will reflect the realtime
volume if the directory argument is a realtime file or a directory
flagged with rtinherit.  This is trivially reproducible by configuring a
rt volume that is much larger than the data volume, setting rtinherit on
the root dir at mkfs time, and running either of these tests.

Refactor the open-coded df logic so that we can determine the value
programmatically for XFS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc         |   15 +++++++++++++++
 common/xfs        |   11 +++++++++++
 tests/generic/251 |    2 +-
 tests/generic/260 |    2 +-
 4 files changed, 28 insertions(+), 2 deletions(-)


diff --git a/common/rc b/common/rc
index 90749343f3..228982fa4d 100644
--- a/common/rc
+++ b/common/rc
@@ -3927,6 +3927,21 @@ _require_batched_discard()
 	fi
 }
 
+# Given a mountpoint and the device associated with that mountpoint, return the
+# maximum start offset that the FITRIM command will accept, in units of 1024
+# byte blocks.
+_discard_max_offset_kb()
+{
+	case "$FSTYP" in
+	xfs)
+		_xfs_discard_max_offset_kb "$1"
+		;;
+	*)
+		$DF_PROG -k | grep "$1" | grep "$2" | awk '{print $3}'
+		;;
+	esac
+}
+
 _require_dumpe2fs()
 {
 	if [ -z "$DUMPE2FS_PROG" ]; then
diff --git a/common/xfs b/common/xfs
index e8e4832cea..a6c82fc6c7 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1783,3 +1783,14 @@ _require_xfs_scratch_atomicswap()
 		_notrun "atomicswap dependencies not supported by scratch filesystem type: $FSTYP"
 	_scratch_unmount
 }
+
+# Return the maximum start offset that the FITRIM command will accept, in units
+# of 1024 byte blocks.
+_xfs_discard_max_offset_kb()
+{
+	local path="$1"
+	local blksz="$($XFS_IO_PROG -c 'statfs' "$path" | grep "geom.bsize" | cut -d ' ' -f 3)"
+	local dblks="$($XFS_IO_PROG -c 'statfs' "$path" | grep "geom.datablocks" | cut -d ' ' -f 3)"
+
+	echo "$((dblks * blksz / 1024))"
+}
diff --git a/tests/generic/251 b/tests/generic/251
index 2a271cd126..8ee74980cc 100755
--- a/tests/generic/251
+++ b/tests/generic/251
@@ -71,7 +71,7 @@ _guess_max_minlen()
 fstrim_loop()
 {
 	trap "_destroy_fstrim; exit \$status" 2 15
-	fsize=$($DF_PROG | grep $SCRATCH_MNT | grep $SCRATCH_DEV  | awk '{print $3}')
+	fsize=$(_discard_max_offset_kb "$SCRATCH_MNT" "$SCRATCH_DEV")
 	mmlen=$(_guess_max_minlen)
 
 	while true ; do
diff --git a/tests/generic/260 b/tests/generic/260
index 2f653b4af2..08fde46873 100755
--- a/tests/generic/260
+++ b/tests/generic/260
@@ -27,7 +27,7 @@ _scratch_mount
 
 _require_batched_discard $SCRATCH_MNT
 
-fssize=$($DF_PROG -k | grep "$SCRATCH_MNT" | grep "$SCRATCH_DEV"  | awk '{print $3}')
+fssize=$(_discard_max_offset_kb "$SCRATCH_MNT" "$SCRATCH_DEV")
 
 beyond_eofs=$(_math "$fssize*2048")
 max_64bit=$(_math "2^64 - 1")

