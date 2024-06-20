Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8AB58AA7;
	Thu, 20 Jun 2024 20:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718916891; cv=none; b=qRBPHJ/tA4fCfoCYKS9u773vcV1nlJQUR7hR5bE8vKYe+YcNGOPIP4ErQlNFzDtkBEJTJilxfOr1hcxNseForvC2J58gMaDsfvSRhQQX82hkro8nwQE5pxnbISPpdHvK3H9uQONWGYngigv231MZWN/LqA7omXUvF+aip5kNNg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718916891; c=relaxed/simple;
	bh=rOygqbToq+vFobGhkyww7kzoiDA1swL6P0+ly6lBLB8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ks7duMR967tCPp9VG96YGWXD9FrsrboM+BaOtSIT+ILqvUYvXIsEZgXRiaMdCsoRQBjU2jUig+RYl9wGRFd+sH/8acPBhW2ZCBo0jsLAnCSURQ1Xhh11n+YZcZHx4s2CQMCBY0iwUJADVHPQ6EXLYEobCeLpp4vemu898GTmCEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QCJtLezg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QCJtLezg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093A6C2BD10;
	Thu, 20 Jun 2024 20:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718916891;
	bh=rOygqbToq+vFobGhkyww7kzoiDA1swL6P0+ly6lBLB8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QCJtLezgXdH2/9D/9C6JCaROqNNZpW+hIZuOJV2Ljgx3pgZiniR2dl2QQRKofE4MM
	 YRHldWiSlMgphoJbOMcrlWkfLXKP+ivmriXTbIvbN91PbsDUQHgc/3yBU7vAhVoiB4
	 6lcBWBPr8c19x32YhAAGZiOmY3U+1RigOC9HGcbmtJsDLjt3XDCeHMzQ5tOxWUChMQ
	 DMBd+Y5ngiMsD/G6qpfsoBwbNKDYVsYhZHhcmE6+qYaW65rJODjSLNJqEQ/lwbzl7M
	 NIGjztoTU/GBqCnpK5P/hlZNvBx18W+w11WAUn6BfQJUxawGOfiXVhGeSFbgncgA/s
	 Z+0A+tofWDrZA==
Date: Thu, 20 Jun 2024 13:54:50 -0700
Subject: [PATCH 03/11] generic/709,710: rework these for exchangerange vs.
 quota testing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <171891669159.3034840.3701471459033486232.stgit@frogsfrogsfrogs>
In-Reply-To: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
References: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
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

The exchange-range implementation is now completely separate from the
old swapext ioctl, so let's migrate these quota tests to exchangerange.

There's no point in maintaining these tests for the legacy swapext code
because it returns EINVAL if any quota is enabled and the two files have
different user/group/project ids.  Originally I had forward ported the
old swapext ioctl to use commitrange as its backend, but that will be
dropped in favor of porting xfs_fsr to use commitrange directly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/709     |   12 ++++++------
 tests/generic/710     |   14 +++++++-------
 tests/generic/710.out |    2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)


diff --git a/tests/generic/709 b/tests/generic/709
index 4fc938bb6a..f3b827cb04 100755
--- a/tests/generic/709
+++ b/tests/generic/709
@@ -4,17 +4,17 @@
 #
 # FS QA Test No. 709
 #
-# Can we use swapext to make the quota accounting incorrect?
+# Can we use exchangerange to make the quota accounting incorrect?
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext quota
+_begin_fstest auto quick fiexchange quota
 
 # Import common functions.
 . ./common/filter
 . ./common/quota
 
 # real QA test starts here
-_require_xfs_io_command swapext
+_require_xfs_io_command exchangerange
 _require_user
 _require_nobody
 _require_quota
@@ -32,7 +32,7 @@ chown $qa_user $SCRATCH_MNT/a
 $XFS_IO_PROG -f -c 'pwrite -S 0x59 0 64k -b 64k' -c 'truncate 256k' $SCRATCH_MNT/b >> $seqres.full
 chown nobody $SCRATCH_MNT/b
 
-echo before swapext >> $seqres.full
+echo before exchangerange >> $seqres.full
 $XFS_QUOTA_PROG -x -c 'report -a' $SCRATCH_MNT >> $seqres.full
 stat $SCRATCH_MNT/* >> $seqres.full
 
@@ -40,11 +40,11 @@ stat $SCRATCH_MNT/* >> $seqres.full
 # fail with -EINVAL (since that's what the first kernel fix does) or succeed
 # (because subsequent rewrites can handle quota).  Whatever the outcome, the
 # quota usage check at the end should never show a discrepancy.
-$XFS_IO_PROG -c "swapext $SCRATCH_MNT/b" $SCRATCH_MNT/a &> $tmp.swap
+$XFS_IO_PROG -c "exchangerange $SCRATCH_MNT/b" $SCRATCH_MNT/a &> $tmp.swap
 cat $tmp.swap >> $seqres.full
 grep -v 'Invalid argument' $tmp.swap
 
-echo after swapext >> $seqres.full
+echo after exchangerange >> $seqres.full
 $XFS_QUOTA_PROG -x -c 'report -a' $SCRATCH_MNT >> $seqres.full
 stat $SCRATCH_MNT/* >> $seqres.full
 
diff --git a/tests/generic/710 b/tests/generic/710
index 6c6aa08f63..c344bd898b 100755
--- a/tests/generic/710
+++ b/tests/generic/710
@@ -4,17 +4,17 @@
 #
 # FS QA Test No. 710
 #
-# Can we use swapext to exceed the quota enforcement?
+# Can we use exchangerange to exceed the quota enforcement?
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext quota
+_begin_fstest auto quick fiexchange quota
 
 # Import common functions.
 . ./common/filter
 . ./common/quota
 
 # real QA test starts here
-_require_xfs_io_command swapext
+_require_xfs_io_command exchangerange
 _require_user
 _require_nobody
 _require_quota
@@ -35,14 +35,14 @@ chown nobody $SCRATCH_MNT/b
 # Set up a quota limit
 $XFS_QUOTA_PROG -x -c "limit -u bhard=70k nobody" $SCRATCH_MNT
 
-echo before swapext >> $seqres.full
+echo before exchangerange >> $seqres.full
 $XFS_QUOTA_PROG -x -c 'report -a' $SCRATCH_MNT >> $seqres.full
 stat $SCRATCH_MNT/* >> $seqres.full
 
-# Now try to swapext
-$XFS_IO_PROG -c "swapext $SCRATCH_MNT/b" $SCRATCH_MNT/a
+# Now try to exchangerange
+$XFS_IO_PROG -c "exchangerange $SCRATCH_MNT/b" $SCRATCH_MNT/a
 
-echo after swapext >> $seqres.full
+echo after exchangerange >> $seqres.full
 $XFS_QUOTA_PROG -x -c 'report -a' $SCRATCH_MNT >> $seqres.full
 stat $SCRATCH_MNT/* >> $seqres.full
 
diff --git a/tests/generic/710.out b/tests/generic/710.out
index a2aa981919..fcc006c279 100644
--- a/tests/generic/710.out
+++ b/tests/generic/710.out
@@ -1,4 +1,4 @@
 QA output created by 710
-swapext: Disk quota exceeded
+exchangerange: Disk quota exceeded
 Comparing user usage
 Comparing group usage

