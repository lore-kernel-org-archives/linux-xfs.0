Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E413228628D;
	Wed, 19 Feb 2025 01:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927223; cv=none; b=gSmmRuokm4Sp2GfpRNhjUFfKRlfFt4QTFydrL5gifIx72ZChPoz6uCi0hweKlgxBL4iAsC5wD3uz/vKxP7V9DGibDHUKcxNwK0zYWKdY2/3GdYF2YlN7w8u6ZYS6P3etKtUZuarnvKXnuxffrC1Nt5bOhCbXu73/fsSmqACp5Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927223; c=relaxed/simple;
	bh=x4O8hj36ddzwoViWvcwqNTDa9dfOzV9ZP5ld/BkZOyY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mfdzkDtDEo2DLxD2VN6l4+pz8TpCoWpzFT6FFEPto61yCGPfDpLwMQQmNJhAVHTA8931H1yASQVKmLKbtuiZKudH3ABM6Bwda7Gj6/jaJqvV0JwGjZPpNDExPdR4Ejf0DDFkpMofkWqm35zerZmkR4xO57PZmxOgXyeZqMwb1h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TGPIv0Lr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TGPIv0Lr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7D2C4CEE2;
	Wed, 19 Feb 2025 01:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927222;
	bh=x4O8hj36ddzwoViWvcwqNTDa9dfOzV9ZP5ld/BkZOyY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TGPIv0LrLaXqBiPIwYl0Lq3fmEQS+uZ0T841eceKVj2GcRq8nN7C8IcoLCKRXH2jo
	 UJ/n3FVy7+Arz3BU8UnB0Jg9ZjmM51kCY4oWLobZtIT+Y5BSsuEYHoNxEuqMSvW+Cd
	 pFQx76Nq7/QxiHg1XOauxjVPRkCavUyoGgrCGXPjTMHqVspanIEBzOuFbaS3mAuviH
	 unoLo6w/KJniJFNqoxYCLzQDV0zEg8KMbFDFz/tjWfWnSn9h7DxBG+CG/azLeyoCK9
	 LaNtVP2qGgWd3jir26Nc0+rwjKO36FClIqt04IOyDzxcfEjtJ4KxopbB/mfctZTvzZ
	 wkUseFdpUEWgg==
Date: Tue, 18 Feb 2025 17:07:02 -0800
Subject: [PATCH 13/13] fuzzy: create missing fuzz tests for rt rmap btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591349.4080556.636964987283271719.stgit@frogsfrogsfrogs>
In-Reply-To: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Back when I first created the fuzz tests for the realtime rmap btree, I
forgot a couple of things.  Add tests to fuzz rtrmap btree leaf records,
and node keys.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1528     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1528.out |    4 ++++
 tests/xfs/1529     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1529.out |    4 ++++
 tests/xfs/407      |    2 +-
 5 files changed, 84 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/1528
 create mode 100644 tests/xfs/1528.out
 create mode 100755 tests/xfs/1529
 create mode 100644 tests/xfs/1529.out


diff --git a/tests/xfs/1528 b/tests/xfs/1528
new file mode 100755
index 00000000000000..15420555ed89ac
--- /dev/null
+++ b/tests/xfs/1528
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1528
+#
+# Populate a XFS filesystem and fuzz every rtrmapbt record field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+_require_realtime
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rtrmapbt"
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "path -m $path")
+
+echo "Fuzz rtrmapbt recs"
+_scratch_xfs_fuzz_metadata '' 'both' "path -m $path" "addr u${inode_ver}.rtrmapbt.ptrs[1]" >> $seqres.full
+echo "Done fuzzing rtrmapbt recs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1528.out b/tests/xfs/1528.out
new file mode 100644
index 00000000000000..b51b640c40a268
--- /dev/null
+++ b/tests/xfs/1528.out
@@ -0,0 +1,4 @@
+QA output created by 1528
+Format and populate
+Fuzz rtrmapbt recs
+Done fuzzing rtrmapbt recs
diff --git a/tests/xfs/1529 b/tests/xfs/1529
new file mode 100755
index 00000000000000..0a9cce43d831bc
--- /dev/null
+++ b/tests/xfs/1529
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1529
+#
+# Populate a XFS filesystem and fuzz every rtrmapbt keyptr field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+_require_realtime
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rtrmapbt"
+
+echo "Fuzz rtrmapbt keyptrs"
+_scratch_xfs_fuzz_metadata '(rtrmapbt)' 'offline' "path -m $path" >> $seqres.full
+echo "Done fuzzing rtrmapbt keyptrs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1529.out b/tests/xfs/1529.out
new file mode 100644
index 00000000000000..808fcc957f91e0
--- /dev/null
+++ b/tests/xfs/1529.out
@@ -0,0 +1,4 @@
+QA output created by 1529
+Format and populate
+Fuzz rtrmapbt keyptrs
+Done fuzzing rtrmapbt keyptrs
diff --git a/tests/xfs/407 b/tests/xfs/407
index 1eff49218a86bf..a46ecb0cd5eb93 100755
--- a/tests/xfs/407
+++ b/tests/xfs/407
@@ -24,7 +24,7 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
-path="$(_scratch_xfs_find_rgbtree_height 'rmap' 1)" || \
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 2)" || \
 	_fail "could not find two-level rtrmapbt"
 inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "path -m $path")
 

