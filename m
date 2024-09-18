Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9344B45027;
	Wed, 18 Sep 2024 20:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726693040; cv=none; b=EwUZ9ckpUsP5+BeYLN0dTJ9E0t/vKFq6FynVevRtkyRN3orA0aUaypkAcekSA1gBEifQob6xGAqkazOCTfTAm9tMLgAXgLHQ9vqvFObep1GOh1HdZZuRRC8p+xgw9w/ygPAXpDhHgZmW7fKdBQAJWKJwdC7wZvmGq74h7ogpAdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726693040; c=relaxed/simple;
	bh=+jtfLx5CASsB1oasfUD/3tSbPDkEKiLPc2Vsn1y+BZE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P/Wsv0KTDmRirgwoPHX7jTFuRW+9B5Ihl50haa+/C7e1SzlFFJQSaPUQgIaSWkpKikAhaGW0GhKhitpO3RFHsidh+ntJzumJ0b5KG1y3TWmof7uFfXb5oad0IVXFDxKJlL4Ym2pxG81TM6/BMCODDIOW41682niCKOkNbqtixKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=saer3NS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="saer3NS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17195C4CEC2;
	Wed, 18 Sep 2024 20:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726693040;
	bh=+jtfLx5CASsB1oasfUD/3tSbPDkEKiLPc2Vsn1y+BZE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=saer3NS6vTIf3hU4dgKfc+MI2K1SRItc7T6gg6G9p03v/A04OFBTmKGM+oOkq/Bp6
	 8KFcW7md3HJZ0+WYxZ225RGxWXj63RfpbUR4RZhySZ7cQG92f66xtyWmee9+HlpHf5
	 RGqfgc2b/bKR+gYcZGU1O9R86YuNHpwXC2K9VeDq2d2YqCgr3JJVejtxpzTVj0dGoH
	 BLPFC9gA942M2A88L1PKAq+/LzxcS2tE0C7Hu7v7dSYikKDUKrCY7X+61GsROf+1Ss
	 2IhOvQA/PnM9DFPUPQLMEn/pXuW8OVLG1MzdGnXdFi1x0GAGFR8nMrgtrFzpCFkKLZ
	 q826ihIG5Ny5A==
Date: Wed, 18 Sep 2024 13:57:19 -0700
Subject: [PATCH 1/1] generic: add a regression test for sub-block fsmap
 queries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <172669301299.3083764.15063882630075709199.stgit@frogsfrogsfrogs>
In-Reply-To: <172669301283.3083764.4996516594612212560.stgit@frogsfrogsfrogs>
References: <172669301283.3083764.4996516594612212560.stgit@frogsfrogsfrogs>
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

Zizhi Wo found some bugs in the GETFSMAP implementation if it is fed
sub-fsblock ranges.  Add a regression test for this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/1954     |   79 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1954.out |   15 +++++++++
 2 files changed, 94 insertions(+)
 create mode 100755 tests/generic/1954
 create mode 100644 tests/generic/1954.out


diff --git a/tests/generic/1954 b/tests/generic/1954
new file mode 100755
index 0000000000..cfdfaf15e2
--- /dev/null
+++ b/tests/generic/1954
@@ -0,0 +1,79 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1954
+#
+# Regression test for sub-fsblock key handling errors in GETFSMAP.
+#
+. ./common/preamble
+_begin_fstest auto rmap fsmap
+
+_fixed_by_kernel_commit XXXXXXXXXXXX \
+	"xfs: Fix the owner setting issue for rmap query in xfs fsmap"
+_fixed_by_kernel_commit XXXXXXXXXXXX \
+	"xfs: Fix missing interval for missing_owner in xfs fsmap"
+
+. ./common/filter
+
+_require_xfs_io_command "fsmap"
+_require_scratch
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+blksz=$(_get_block_size "$SCRATCH_MNT")
+if ((blksz < 2048)); then
+	_notrun "test requires at least 4 bblocks per fsblock"
+fi
+
+$XFS_IO_PROG -c 'fsmap' $SCRATCH_MNT >> $seqres.full
+
+find_freesp() {
+	$XFS_IO_PROG -c 'fsmap -d' $SCRATCH_MNT | tr '.[]:' '    ' | \
+		grep 'free space' | awk '{printf("%s:%s\n", $4, $5);}' | \
+		head -n 1
+}
+
+filter_fsmap() {
+	_filter_xfs_io_numbers | sed \
+		-e 's/inode XXXX data XXXX..XXXX/inode data/g' \
+		-e 's/inode XXXX attr XXXX..XXXX/inode attr/g' \
+		-e 's/: free space XXXX/: FREE XXXX/g' \
+		-e 's/: [a-z].*XXXX/: USED XXXX/g'
+}
+
+$XFS_IO_PROG -c 'fsmap -d' $SCRATCH_MNT | filter_fsmap >> $seqres.full
+
+freesp="$(find_freesp)"
+
+freesp_start="$(echo "$freesp" | cut -d ':' -f 1)"
+freesp_end="$(echo "$freesp" | cut -d ':' -f 2)"
+echo "$freesp:$freesp_start:$freesp_end" >> $seqres.full
+
+echo "test incorrect setting of high key"
+$XFS_IO_PROG -c 'fsmap -d 0 3' $SCRATCH_MNT | filter_fsmap
+
+echo "test missing free space extent"
+$XFS_IO_PROG -c "fsmap -d $((freesp_start + 1)) $((freesp_start + 2))" $SCRATCH_MNT | \
+	filter_fsmap
+
+echo "test whatever came before freesp"
+$XFS_IO_PROG -c "fsmap -d $((freesp_start - 3)) $((freesp_start - 2))" $SCRATCH_MNT | \
+	filter_fsmap
+
+echo "test whatever came after freesp"
+$XFS_IO_PROG -c "fsmap -d $((freesp_end + 2)) $((freesp_end + 3))" $SCRATCH_MNT | \
+	filter_fsmap
+
+echo "test crossing start of freesp"
+$XFS_IO_PROG -c "fsmap -d $((freesp_start - 2)) $((freesp_start + 1))" $SCRATCH_MNT | \
+	filter_fsmap
+
+echo "test crossing end of freesp"
+$XFS_IO_PROG -c "fsmap -d $((freesp_end - 1)) $((freesp_end + 2))" $SCRATCH_MNT | \
+	filter_fsmap
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1954.out b/tests/generic/1954.out
new file mode 100644
index 0000000000..6baec43511
--- /dev/null
+++ b/tests/generic/1954.out
@@ -0,0 +1,15 @@
+QA output created by 1954
+test incorrect setting of high key
+	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
+test missing free space extent
+	XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
+test whatever came before freesp
+	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
+test whatever came after freesp
+	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
+test crossing start of freesp
+	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
+	XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
+test crossing end of freesp
+	XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
+	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX

