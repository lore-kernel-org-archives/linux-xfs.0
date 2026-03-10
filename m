Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBC92C11E8;
	Tue, 10 Mar 2026 03:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114687; cv=none; b=rpJ+p4Tgki+CrusCLb4bteErnUESUvR5SDK0P0xKX71HOvQcuaVxAnRkDPkpbXJJLNkVnYFswHA+b3bLWx+xl/YcfU39M0V9VvBSPa+9CVWK7z9AayiIxvZH77z8Q9mr8gyAj0fEHL28JzOfN6GNYUr94WyWEELTu5WhrogHJqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114687; c=relaxed/simple;
	bh=SNJ8TbUBDlqhiVK7+LmOUpbQNbGe9ck+HXXL/yDd4IM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JouejBm/BXB5wo9MIWTzX2/OhN71YKBrjvb8GCUdYZltKxvdvJinMf5hBj3GWbyaxV9RAaS4J8V9ltAKvp5QIu9ILWRtEmGRew+SsT0coZprq2Z3+teTKm46Q/8fnnCePPTSXlhMdxD9umHgZFfi2p5T0eBEbgxOhUIW0rHXb0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E/i6BEl1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E/i6BEl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0079C19423;
	Tue, 10 Mar 2026 03:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114686;
	bh=SNJ8TbUBDlqhiVK7+LmOUpbQNbGe9ck+HXXL/yDd4IM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E/i6BEl1N05yS2tT5Moo6U2n18qDRRTYuRL0qxzTKTCjOXD6PjJiD2dFV+xh2U6x4
	 UzGU8BKdvw/nlhdrQEeb+cprAwdgjokv/0xuJHqHxQ98tyT+sehlwTN3X4zg6wkE/G
	 N3HxjHppryB2BIjIfRUErnAXISqMPQC3qKpbhrPIv72hQRKx3lX7iOcpqbOWNFCBb4
	 +UTJ9KDcSis6X9PgiQS5VkBt0ZPcUkUIT+/iRuK6j146oi7gP3C2PkPBpM2rgJ8WP8
	 c49WjbLEF7VFnMS/7vuCrHku5vSM+Z8D3Uj3Qigw84TP6rbQvnFdx+o5brqzTJuGbz
	 E/WG9Ka91s3Vg==
Date: Mon, 09 Mar 2026 20:51:26 -0700
Subject: [PATCH 05/14] xfs: test xfs_healer's event handling
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177311403867.1186408.18154501598966372334.stgit@frogsfrogsfrogs>
In-Reply-To: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
References: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make sure that xfs_healer can handle every type of event that the kernel
can throw at it by initiating a full scrub of a test filesystem.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1882     |   44 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1882.out |    2 ++
 2 files changed, 46 insertions(+)
 create mode 100755 tests/xfs/1882
 create mode 100644 tests/xfs/1882.out


diff --git a/tests/xfs/1882 b/tests/xfs/1882
new file mode 100755
index 00000000000000..2fb4589418401e
--- /dev/null
+++ b/tests/xfs/1882
@@ -0,0 +1,44 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1882
+#
+# Make sure that xfs_healer correctly handles all the reports that it gets
+# from the kernel.  We simulate this by using the --everything mode so we get
+# all the events, not just the sickness reports.
+#
+. ./common/preamble
+_begin_fstest auto selfhealing
+
+. ./common/filter
+. ./common/fuzzy
+. ./common/systemd
+. ./common/populate
+
+_require_scrub
+_require_xfs_io_command "scrub"		# online check support
+_require_command "$XFS_HEALER_PROG" "xfs_healer"
+_require_scratch
+
+# Does this fs support health monitoring?
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+_require_xfs_healer $SCRATCH_MNT
+_scratch_unmount
+
+# Create a sample fs with all the goodies
+_scratch_populate_cached nofill &>> $seqres.full
+_scratch_mount
+
+_scratch_invoke_xfs_healer "$tmp.healer" --everything
+
+# Run scrub to make some noise
+_scratch_scrub -b -n >> $seqres.full
+
+_scratch_kill_xfs_healer
+cat $tmp.healer >> $seqres.full
+
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1882.out b/tests/xfs/1882.out
new file mode 100644
index 00000000000000..9b31ccb735cabd
--- /dev/null
+++ b/tests/xfs/1882.out
@@ -0,0 +1,2 @@
+QA output created by 1882
+Silence is golden

