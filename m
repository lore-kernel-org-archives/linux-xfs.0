Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45EA0C761A6
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Mar 2023 16:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbjC3Qqo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Mar 2023 12:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbjC3Qq0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Mar 2023 12:46:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E03D31C;
        Thu, 30 Mar 2023 09:46:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14C1761E46;
        Thu, 30 Mar 2023 16:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712EDC433EF;
        Thu, 30 Mar 2023 16:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680194778;
        bh=taJXt1do04/FAanLh1/8aDNmkbur9J3EiXhH8X2GuU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a8EWo+onGa++zbvmvNmbZLF0lSssJSRObWQjvX6d0w6V2HUuzyVrYxljWikjhwjLp
         dlqiLdYIoU8IYJOLNCE6Pz49cg1GhHuRmfAJW9nhR2eXStx4qGijNAvvr9A/PiLHD9
         NwZ/Ey3umU5ezSaod6EUQsLt7fFllr1wB22SDhIervQBAX+K4v4NpMX3mY2Xo0lOcU
         dGrLLIbC1EoWwOdGYmA+2qXXDG7P1WupgoEVoYWQAANn9eeDGZCOHOHgjfF4FbYn9I
         beqF259z7CH9xHIF2+H7z61U70L7iXGKKB6b5MGazYOXGDte3hPPj1TFrYfa+yrJiy
         VwdKlSGVQ/Tng==
Date:   Thu, 30 Mar 2023 09:46:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH v1.1 1/3] generic/{251,260}: compute maximum fitrim offset
Message-ID: <20230330164617.GD16170@frogsfrogsfrogs>
References: <168005148468.4147931.1986862498548445502.stgit@frogsfrogsfrogs>
 <168005149047.4147931.2729971759269213680.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168005149047.4147931.2729971759269213680.stgit@frogsfrogsfrogs>
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
Reviewed-by: David Disseldorp <ddiss@suse.de>
---
v1.1: tighten up the awk usage
---
 common/rc         |   15 +++++++++++++++
 common/xfs        |    8 ++++++++
 tests/generic/251 |    2 +-
 tests/generic/260 |    2 +-
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index 90749343f3..563d2978a7 100644
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
+		$DF_PROG -k | awk -v dev="$2" -v mnt="$1" '$1 == dev && $7 == mnt { print $3 }'
+		;;
+	esac
+}
+
 _require_dumpe2fs()
 {
 	if [ -z "$DUMPE2FS_PROG" ]; then
diff --git a/common/xfs b/common/xfs
index e8e4832cea..c558e940cd 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1783,3 +1783,11 @@ _require_xfs_scratch_atomicswap()
 		_notrun "atomicswap dependencies not supported by scratch filesystem type: $FSTYP"
 	_scratch_unmount
 }
+
+# Return the maximum start offset that the FITRIM command will accept, in units
+# of 1024 byte blocks.
+_xfs_discard_max_offset_kb()
+{
+	$XFS_IO_PROG -c 'statfs' "$1" | \
+		awk '{g[$1] = $3} END {print (g["geom.bsize"] * g["geom.datablocks"] / 1024)}'
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
