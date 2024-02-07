Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61138FBEB;
	Wed,  7 Feb 2024 02:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707272360; cv=none; b=VR0yG8UCZ5VFcK2qlSA4upWjDHVSRc0mU1pr5dvpvCl90nykhDDbs29OXGkfbNxYLrIykkggTTXJbKMpguYtAAhAzmhzXe5kHuohCEuSLTPxfx/oDnYytKunc5CqFlpz+GFAFJvxScuSxztQImUp3GRs4E9VgKuRLEtGcPDRDvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707272360; c=relaxed/simple;
	bh=Qmkuef+jv6iUjSWKplTunZ9HuLxmGKijMrmARJaVADE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=es5yXz7GhawCjCxTsq77tQa5FIvl3qRwC4lAIfq/Rev4FN6RPuX9upi284KPCh9ma5vSMwymhNycBpxR8/Xednwvj8/qn5P2XEXBSjbtSmtWdv+ynCNqKE/Mkx8/yvTpKgNoBoO/9nQuVNoCvHlfvm7knHXZXydYv8CpcSwK6o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UAjA+R6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UAjA+R6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF479C433F1;
	Wed,  7 Feb 2024 02:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707272359;
	bh=Qmkuef+jv6iUjSWKplTunZ9HuLxmGKijMrmARJaVADE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=UAjA+R6fJoqroDB8G75A05o7fXv3IpZru6US/hCUNLsdW+NYtOAH07onkkRGbucF7
	 kxf6YGDU5D++tkON5I+neV4w3KgNWXJFrhGC5rVAgZPeTmF6jrma4yckhniP5HJ43V
	 OtRO+KPbZ8Qv+COAxY90UJXpU0LhJeu1qtAnu///lGP0TRgyLMVcWu6DpaSybInHne
	 Px9kF1baVDEyTNKFTmbQ2blike6REreRhlbxxoZGQxm+M6efHsT1cnVajV3i4ErC7O
	 bWHGe4ne060UEQwmvftiCxP5CQDuLGLnjdHBfPsOYB68KRdp9LdzixGRVrlDnVg1wR
	 19Qm/2Ash5ARw==
Subject: [PATCH 08/10] xfs/503: split copy and metadump into two tests
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
 linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date: Tue, 06 Feb 2024 18:19:19 -0800
Message-ID: <170727235942.3726171.4745513175828645904.stgit@frogsfrogsfrogs>
In-Reply-To: <170727231361.3726171.14834727104549554832.stgit@frogsfrogsfrogs>
References: <170727231361.3726171.14834727104549554832.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This test examines the behavior of xfs_copy and xfs_metadump.  Metadump
now supports capturing external log contents, but copy does not.  Split
the test into two to improve coverage on multidevice filesystems.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 tests/xfs/503     |   17 +++--------------
 tests/xfs/503.out |    2 --
 tests/xfs/601     |   54 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/601.out |    4 ++++
 4 files changed, 61 insertions(+), 16 deletions(-)
 create mode 100755 tests/xfs/601
 create mode 100755 tests/xfs/601.out


diff --git a/tests/xfs/503 b/tests/xfs/503
index 07d243bc06..01cff7b08d 100755
--- a/tests/xfs/503
+++ b/tests/xfs/503
@@ -4,11 +4,11 @@
 #
 # FS QA Test No. 503
 #
-# Populate a XFS filesystem and ensure that metadump, mdrestore, and copy
-# all work properly.
+# Populate a XFS filesystem and ensure that metadump and mdrestore all work
+# properly.
 #
 . ./common/preamble
-_begin_fstest auto copy metadump
+_begin_fstest auto metadump
 
 _register_cleanup "_cleanup" BUS
 
@@ -32,7 +32,6 @@ _supported_fs xfs
 
 _require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
 _require_loop
-_require_xfs_copy
 _require_scratch_nocheck
 _require_populate_commands
 _xfs_skip_online_rebuild
@@ -58,16 +57,6 @@ _xfs_verify_metadumps '-o'
 echo "metadump ao and mdrestore"
 _xfs_verify_metadumps '-a -o'
 
-echo copy
-$XFS_COPY_PROG $SCRATCH_DEV $copy_file >> $seqres.full
-_check_scratch_fs $copy_file
-
-echo recopy
-$XFS_COPY_PROG $copy_file $SCRATCH_DEV >> $seqres.full
-_scratch_mount
-_check_scratch_fs
-_scratch_unmount
-
 # success, all done
 status=0
 exit
diff --git a/tests/xfs/503.out b/tests/xfs/503.out
index 5e7488456d..7f3d3a5f24 100644
--- a/tests/xfs/503.out
+++ b/tests/xfs/503.out
@@ -4,5 +4,3 @@ metadump and mdrestore
 metadump a and mdrestore
 metadump o and mdrestore
 metadump ao and mdrestore
-copy
-recopy
diff --git a/tests/xfs/601 b/tests/xfs/601
new file mode 100755
index 0000000000..e1e94ca8ff
--- /dev/null
+++ b/tests/xfs/601
@@ -0,0 +1,54 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 601
+#
+# Populate a XFS filesystem and ensure that xfs_copy works properly.
+#
+. ./common/preamble
+_begin_fstest auto copy
+
+_register_cleanup "_cleanup" BUS
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.* $testdir
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+
+testdir=$TEST_DIR/test-$seq
+
+# real QA test starts here
+_supported_fs xfs
+
+_require_xfs_copy
+_require_scratch_nocheck
+_require_populate_commands
+_xfs_skip_online_rebuild
+_xfs_skip_offline_rebuild
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+mkdir -p $testdir
+copy_file=$testdir/copy.img
+
+echo copy
+$XFS_COPY_PROG $SCRATCH_DEV $copy_file >> $seqres.full
+_check_scratch_fs $copy_file
+
+echo recopy
+$XFS_COPY_PROG $copy_file $SCRATCH_DEV >> $seqres.full
+_scratch_mount
+_check_scratch_fs
+_scratch_unmount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/601.out b/tests/xfs/601.out
new file mode 100755
index 0000000000..0cbe0c0d09
--- /dev/null
+++ b/tests/xfs/601.out
@@ -0,0 +1,4 @@
+QA output created by 601
+Format and populate
+copy
+recopy

