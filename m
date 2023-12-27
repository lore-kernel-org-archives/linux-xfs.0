Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C517EE;
	Mon,  1 Jan 2024 01:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aJA6QKAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C07BC433C7;
	Mon,  1 Jan 2024 01:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070977;
	bh=ryjV8Jrw4OGG3FzNh3otD97RHKFVzbHCCZkGrrqFVx8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aJA6QKAy3u/A5G+DAS6srTTWvlONw3wvF69oDqTM2/+fayYiSBKqL0yDszIWI4+U+
	 4ID2Ei/TZf8Y8Uo8DrUuGHSE0AN1nSrqUPsjuZCXGkDwDopu3GV0/9YJd/phCgMZyk
	 6QX0xMqZhcRv7DCzf2XfUzEdwnKMrpQ5Yv0OvmCMPTWpw1NZbWWf1vO0XBEc6O4YHb
	 r/t7/mS1ORtp85bdjhk9SR7qk+igBJDKpWGxOWvr4d62MBc6/HmB7nltOkloIe0TCm
	 ZgYrLh29zV+ehM3eunrgXCjEuRz/59zg+MTo3b/UAxgUiU5x12gSylIeS1tmTnCZqc
	 pUR5iY/TQCIBg==
Date: Sun, 31 Dec 2023 17:02:56 +9900
Subject: [PATCH 6/9] xfs: remove xfs/131 now that we allow reflink on realtime
 volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405032095.1827358.13900239085409160451.stgit@frogsfrogsfrogs>
In-Reply-To: <170405032011.1827358.11723561661069109569.stgit@frogsfrogsfrogs>
References: <170405032011.1827358.11723561661069109569.stgit@frogsfrogsfrogs>
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

Remove this test, since we now support reflink on the rt volume.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/131     |   48 ------------------------------------------------
 tests/xfs/131.out |    5 -----
 2 files changed, 53 deletions(-)
 delete mode 100755 tests/xfs/131
 delete mode 100644 tests/xfs/131.out


diff --git a/tests/xfs/131 b/tests/xfs/131
deleted file mode 100755
index 879e2dc6e8..0000000000
--- a/tests/xfs/131
+++ /dev/null
@@ -1,48 +0,0 @@
-#! /bin/bash
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
-#
-# FS QA Test No. 131
-#
-# Ensure that we can't reflink realtime files.
-#
-. ./common/preamble
-_begin_fstest auto quick clone realtime
-
-# Override the default cleanup function.
-_cleanup()
-{
-    cd /
-    umount $SCRATCH_MNT > /dev/null 2>&1
-    rm -rf $tmp.* $testdir $metadump_file
-}
-
-# Import common functions.
-. ./common/filter
-. ./common/reflink
-
-# real QA test starts here
-_supported_fs xfs
-_require_realtime
-_require_scratch_reflink
-_require_cp_reflink
-
-echo "Format and mount scratch device"
-_scratch_mkfs >> $seqres.full
-_scratch_mount
-
-testdir=$SCRATCH_MNT/test-$seq
-mkdir $testdir
-
-echo "Create the original file blocks"
-blksz=65536
-$XFS_IO_PROG -R -f -c "truncate $blksz" $testdir/file1
-
-echo "Reflink every block"
-_cp_reflink $testdir/file1 $testdir/file2 2>&1 | _filter_scratch
-
-test -s $testdir/file2 && _fail "Should not be able to reflink a realtime file."
-
-# success, all done
-status=0
-exit
diff --git a/tests/xfs/131.out b/tests/xfs/131.out
deleted file mode 100644
index 3c0186f0c7..0000000000
--- a/tests/xfs/131.out
+++ /dev/null
@@ -1,5 +0,0 @@
-QA output created by 131
-Format and mount scratch device
-Create the original file blocks
-Reflink every block
-cp: failed to clone 'SCRATCH_MNT/test-131/file2' from 'SCRATCH_MNT/test-131/file1': Invalid argument

