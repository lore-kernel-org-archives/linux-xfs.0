Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB8328628D;
	Wed, 19 Feb 2025 01:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927301; cv=none; b=AR8Knl8lyfzIDsdUZHoG1mN5EpKTNUIG5JqRhL6aap1+kJGF2d3VV4nOdChZn+rwdw75saBzQVBYsGnU7khOmTHYQfNuRpXd41iUVz9lN0CxDL33pk5CLEsLJYzjn79KlbUmCf9AKr0z3+cnKYGuBDeUAmJjT5w19C/cDLP/vms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927301; c=relaxed/simple;
	bh=jcu0vp7+GpoT2FpVp0ffYgbEDoEA3PiLe79XPGq3og0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gYbAlvztPx3you3OuTs0ioHyFYcOK7UAHs00HQLrtnIiUO05vTXhH/GKqfuQZf0YxxIYJ41C4iVTwFt6cWe8/53gcxU5Zfd5GRpK12EtFSYfnTiRaSl4+F4IzuwVTkhna1+Xl/bMLrILEObTioHJXTr7UHeTm5Qf84DAUQoGxXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s8kiNH8v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s8kiNH8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B3FC4CEE2;
	Wed, 19 Feb 2025 01:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927300;
	bh=jcu0vp7+GpoT2FpVp0ffYgbEDoEA3PiLe79XPGq3og0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s8kiNH8v6CHIIXZoapALvyo2iRZuITAVx3zfSQAbb6Zvl1zzvz4TLzOQp/pdu81Jw
	 u1tgFPV/k5EefV1+Ydmh/Dqldj4RG4dUdLulXlEXrXCOl1INsplcmrJmUBxHD3jbcE
	 dEsXuktPSwqkEzDvWjxIYMM33jaAHeCnbwdPQTZe5nPuV8TgLygnfyuQEfNy9Wkxsd
	 vHVJmrfkAQ2/lramLK3v7J7n0QlaRs/TFzmgZPcHMzss/RYBSAhUJnBkQjVp3Q58qK
	 BNjatejHMs2ugW+GLYahQZLxtEQU/Mv/0ncWJ0XFcbbIj/tY8BQUX0vBNl9R/bXypn
	 aQShFicKRBV6w==
Date: Tue, 18 Feb 2025 17:08:20 -0800
Subject: [PATCH 5/7] xfs: remove xfs/131 now that we allow reflink on realtime
 volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591845.4081089.4278978282673903512.stgit@frogsfrogsfrogs>
In-Reply-To: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
References: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/131     |   46 ----------------------------------------------
 tests/xfs/131.out |    5 -----
 2 files changed, 51 deletions(-)
 delete mode 100755 tests/xfs/131
 delete mode 100644 tests/xfs/131.out


diff --git a/tests/xfs/131 b/tests/xfs/131
deleted file mode 100755
index c83a1d6eab9ef7..00000000000000
--- a/tests/xfs/131
+++ /dev/null
@@ -1,46 +0,0 @@
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
index 3c0186f0c7e9da..00000000000000
--- a/tests/xfs/131.out
+++ /dev/null
@@ -1,5 +0,0 @@
-QA output created by 131
-Format and mount scratch device
-Create the original file blocks
-Reflink every block
-cp: failed to clone 'SCRATCH_MNT/test-131/file2' from 'SCRATCH_MNT/test-131/file1': Invalid argument

