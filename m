Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C116A12CDA5;
	Tue,  3 Mar 2026 00:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498530; cv=none; b=FwXZXony80oB/RbpC1leA8DwNPlGYR60xymntnUrKYT6oqJszER+j4Q1zWqyN4dT0YuN2zwtTHx5Nk2jbmX12lz0R/gCLBzGTISg2uM7ByYPTDy8sfIVmHV0o4c03c0CTSvg2PRdFk2cITjAlj1IjRh1orSAdfBy+AIuXTFFIhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498530; c=relaxed/simple;
	bh=SNJ8TbUBDlqhiVK7+LmOUpbQNbGe9ck+HXXL/yDd4IM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FgNI7OPT9BwYUAuTANGdJDsWQZtQv4LrthIOPvxGHH5zbYct34wNrOZVsOc1V84PSeCApbEtlixWJfo8yB7MmM341eb0vw96v58Hr2iluouBfGugLB1QKiVgPN9A6u9yGTQfPP7iqLPfOGOGk8QP100OzojzaDtIZ7cmLlI0F5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T5wWpb+A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T5wWpb+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2BAC19423;
	Tue,  3 Mar 2026 00:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498530;
	bh=SNJ8TbUBDlqhiVK7+LmOUpbQNbGe9ck+HXXL/yDd4IM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T5wWpb+APE97bfzs9vERkkcOKIo1WWI7E0aLAjRKpVPCeUV9JGgH4B7yF+6c+/6fy
	 r/cogOH9Q2gOd/i17bBMmdXoPl0jxwwUfM31ZppEt4b50Np6Jt7NZroYcR7tpIhMgK
	 3fjizhMgG8g/7rFodKEg33aZB+DbRFoKKR3ixTTd/QDXzZenxvpmzNSwuA5NPRvJwy
	 ue87/jLOH3Zn5E7BbBaoYppIKeCVLstPwuLT8P6InB53Fo0gAeQVmN6fDlCyhhBNLu
	 bXaDuFfie5glvFB0XeTr8szDqp63tnEFAvZ48Q09nI4e6+0uFbIgzM9FO6XE188AkI
	 yJ3Hs2yJbLd3g==
Date: Mon, 02 Mar 2026 16:42:10 -0800
Subject: [PATCH 05/13] xfs: test xfs_healer's event handling
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177249785861.483507.5063706976168327778.stgit@frogsfrogsfrogs>
In-Reply-To: <177249785709.483507.8373602184765043420.stgit@frogsfrogsfrogs>
References: <177249785709.483507.8373602184765043420.stgit@frogsfrogsfrogs>
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

