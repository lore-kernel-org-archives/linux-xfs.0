Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D5F190682
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 18:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724437403; cv=none; b=miKBuEYsK0s9mfzNkCOUFX27R0x7xBHVoX7BvywH6Nj8CJJH/4/sKkm2Cojs5hCVaeQ8Tgkx/eEKZ+iNa/N5biU4df2yZQndwnvoMoS95KOZZbGXp4y+6/ygMiEKrVeTekzfGc5Q8iAR59UjuQ0jhL9hyouvRXEzX2zoytElXiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724437403; c=relaxed/simple;
	bh=OXudku/sQ/Gbf4tVEw/0JI1TSgDFZeqwrty4yAVQ7Lk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T5C8e4WmSo078yPLoXj29SlyCve+kLHBrN2uiQVTHEbqtTW9ikeS/jo5zWvuMY3/+d/IE87yJSr2iShvgwVbxDNtg4WZpdOOpo0NNqjQCsQD/PGZF5Inwi5vLPHV39Fk4FicS97BJbd16m/3RpiLSIBBq8lurGurnYwm+bZLGh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P7a2z7jL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P7a2z7jL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E44C32786;
	Fri, 23 Aug 2024 18:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724437403;
	bh=OXudku/sQ/Gbf4tVEw/0JI1TSgDFZeqwrty4yAVQ7Lk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P7a2z7jLymTJdj9d0X2x4JnRGcFVErU+tPpaFT6XpcjWNruiII3gO24wtmDgY2jtO
	 bUi/GaY14x1a9KkFUehHW9cMn2uoAYTPltB1cE39+C0RSwIOFx/r0WrJEOoWBEULTZ
	 7hTyXKjoBkgrkGnumD9h+0i2pkF+2IqYY5Gc4flgdXTEaKQhOFTdkH92fG0eXxRnJb
	 eZrFKT+JvCdcVMp3qKK8/dTmxICUFNGkfROeAyKGg+bvQpZ6SGuAQcIaJWT6qf5Som
	 q95urJRELl5aR68v8pwVItpIpPCG7k6FLoZME9d+w1VWCf/EZyYI3QdoKHCS6Me4ZP
	 Xga5papYb/6kQ==
Date: Fri, 23 Aug 2024 11:23:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: persist quota flags with metadir
Message-ID: <20240823182322.GQ865349@frogsfrogsfrogs>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
 <172437089432.61495.8117184114353548540.stgit@frogsfrogsfrogs>
 <ZsgkKwHoeFii_c8J@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsgkKwHoeFii_c8J@infradead.org>

On Thu, Aug 22, 2024 at 10:54:51PM -0700, Christoph Hellwig wrote:
> On Thu, Aug 22, 2024 at 05:28:59PM -0700, Darrick J. Wong wrote:
> > Starting with metadir, let's change the behavior so that if the user
> > does not specify any quota-related mount options at all, the ondisk
> > quota flags will be used to bring up quota.  In other words, the
> > filesystem will mount in the same state and with the same functionality
> > as it had during the last mount.
> 
> Finally!
> 
> Are you going to send some tests that test this behavior?
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Yes.

--D

xfs: test persistent quota flags

Test the persistent quota flags that come with the metadir feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1891     |  128 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1891.out |  147 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 282 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/1891
 create mode 100644 tests/xfs/1891.out

diff --git a/tests/xfs/1891 b/tests/xfs/1891
new file mode 100755
index 0000000000..53009571a9
--- /dev/null
+++ b/tests/xfs/1891
@@ -0,0 +1,128 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1891
+#
+# Functionality test for persistent quota accounting and enforcement flags in
+# XFS when metadata directories are enabled.
+#
+. ./common/preamble
+_begin_fstest auto quick quota
+
+. ./common/filter
+. ./common/quota
+
+$MKFS_XFS_PROG 2>&1 | grep -q 'uquota' || \
+	_notrun "mkfs does not support uquota option"
+
+_require_scratch
+_require_xfs_quota
+
+filter_quota_state() {
+	sed -e 's/Inode: #[0-9]\+/Inode #XXX/g' \
+	    -e '/max warnings:/d' \
+	    -e '/Blocks grace time:/d' \
+	    -e '/Inodes grace time:/d' \
+		| _filter_scratch
+}
+
+qerase_mkfs_options() {
+	echo "$MKFS_OPTIONS" | sed \
+		-e 's/uquota//g' \
+		-e 's/gquota//g' \
+		-e 's/pquota//g' \
+		-e 's/uqnoenforce//g' \
+		-e 's/gqnoenforce//g' \
+		-e 's/pqnoenforce//g' \
+		-e 's/,,*/,/g'
+}
+
+confirm() {
+	echo "$MOUNT_OPTIONS" | grep -E -q '(qnoenforce|quota)' && \
+		echo "saw quota mount options"
+	_scratch_mount
+	$XFS_QUOTA_PROG -x -c "state -ugp" $SCRATCH_MNT | filter_quota_state
+	_check_xfs_scratch_fs
+	_scratch_unmount
+}
+
+ORIG_MOUNT_OPTIONS="$MOUNT_OPTIONS"
+MKFS_OPTIONS="$(qerase_mkfs_options)"
+
+echo "Test 0: formatting a subset"
+_scratch_mkfs -m uquota,gqnoenforce &>> $seqres.full
+MOUNT_OPTIONS="$ORIG_MOUNT_OPTIONS"
+_qmount_option	# blank out quota options
+confirm
+
+echo "Test 1: formatting"
+_scratch_mkfs -m uquota,gquota,pquota &>> $seqres.full
+MOUNT_OPTIONS="$ORIG_MOUNT_OPTIONS"
+_qmount_option	# blank out quota options
+confirm
+
+echo "Test 2: only grpquota"
+MOUNT_OPTIONS="$ORIG_MOUNT_OPTIONS"
+_qmount_option grpquota
+confirm
+
+echo "Test 3: repair"
+_scratch_xfs_repair &>> $seqres.full || echo "repair failed?"
+MOUNT_OPTIONS="$ORIG_MOUNT_OPTIONS"
+_qmount_option	# blank out quota options
+confirm
+
+echo "Test 4: weird options"
+MOUNT_OPTIONS="$ORIG_MOUNT_OPTIONS"
+_qmount_option pqnoenforce,uquota
+confirm
+
+echo "Test 5: simple recovery"
+_scratch_mkfs -m uquota,gquota,pquota &>> $seqres.full
+MOUNT_OPTIONS="$ORIG_MOUNT_OPTIONS"
+_qmount_option	# blank out quota options
+echo "$MOUNT_OPTIONS" | grep -E -q '(qnoenforce|quota)' && \
+	echo "saw quota mount options"
+_scratch_mount
+$XFS_QUOTA_PROG -x -c "state -ugp" $SCRATCH_MNT | filter_quota_state
+touch $SCRATCH_MNT/a
+_scratch_shutdown -v -f >> $seqres.full
+echo shutdown
+_scratch_unmount
+confirm
+
+echo "Test 6: simple recovery with mount options"
+_scratch_mkfs -m uquota,gquota,pquota &>> $seqres.full
+MOUNT_OPTIONS="$ORIG_MOUNT_OPTIONS"
+_qmount_option	# blank out quota options
+echo "$MOUNT_OPTIONS" | grep -E -q '(qnoenforce|quota)' && \
+	echo "saw quota mount options"
+_scratch_mount
+$XFS_QUOTA_PROG -x -c "state -ugp" $SCRATCH_MNT | filter_quota_state
+touch $SCRATCH_MNT/a
+_scratch_shutdown -v -f >> $seqres.full
+echo shutdown
+_scratch_unmount
+MOUNT_OPTIONS="$ORIG_MOUNT_OPTIONS"
+_qmount_option gqnoenforce
+confirm
+
+echo "Test 7: user quotaoff recovery"
+_scratch_mkfs -m uquota,gquota,pquota &>> $seqres.full
+MOUNT_OPTIONS="$ORIG_MOUNT_OPTIONS"
+_qmount_option	# blank out quota options
+echo "$MOUNT_OPTIONS" | grep -E -q '(qnoenforce|quota)' && \
+	echo "saw quota mount options"
+_scratch_mount
+$XFS_QUOTA_PROG -x -c "state -ugp" $SCRATCH_MNT | filter_quota_state
+touch $SCRATCH_MNT/a
+$XFS_QUOTA_PROG -x -c 'off -u' $SCRATCH_MNT
+_scratch_shutdown -v -f >> $seqres.full
+echo shutdown
+_scratch_unmount
+confirm
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1891.out b/tests/xfs/1891.out
new file mode 100644
index 0000000000..7e88940880
--- /dev/null
+++ b/tests/xfs/1891.out
@@ -0,0 +1,147 @@
+QA output created by 1891
+Test 0: formatting a subset
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode: N/A
+Test 1: formatting
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Test 2: only grpquota
+saw quota mount options
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Test 3: repair
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Test 4: weird options
+saw quota mount options
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Test 5: simple recovery
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+shutdown
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Test 6: simple recovery with mount options
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+shutdown
+saw quota mount options
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Test 7: user quotaoff recovery
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+shutdown
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
