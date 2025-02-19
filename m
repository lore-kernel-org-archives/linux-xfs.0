Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6CE286292;
	Wed, 19 Feb 2025 01:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927082; cv=none; b=LZ4pZ2QeyszVfeHqM8HR2LAITTRY2/V2ChQd3i34O5P21VrbTKZ8I+1X16Z+pA2RtnTW+kjAo0YF5IqTNXRHGh/t7vf52kQyFwCa4OH+qAWUGJ93vGaNQcaziQRcf7YdHVPvo3TIwKOwnouk6eJmlgAYY5FqVBPh8zfKLH4zhsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927082; c=relaxed/simple;
	bh=Yk3T6iB+jUswyvSovc+Vb8HrmLsT2R0Gr/UMpW3hEwU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kHGPAvEEu4H/NIdpNH7PMmqi9bLFNFmvTWsnwb5fuVSr//BLRr8dIyDaOxDNdt8IcM38de6lk6adJSticilY4oCDPM2d8kQFSO0Xm37CDQzHIMi/fph4Nz4DqXGb/VjUMDTnSHAqN23y5JIsDaOsRSui4SavEht0SONvO8r8eDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hb/S+9g/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hb/S+9g/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECDFC4CEE2;
	Wed, 19 Feb 2025 01:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927082;
	bh=Yk3T6iB+jUswyvSovc+Vb8HrmLsT2R0Gr/UMpW3hEwU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hb/S+9g/WqePClQ2Qg9ASQY16V02oVt5n2AMdEAL1zlQFBpNyc7UI3y8wTgGel4Oi
	 HmHVtXuCfkhiKO7pes6vSq0ZQJAHz9AxVtWxjK2NO9MxsZhjlDiwvBp6C1seyI3AUo
	 WAc4A37EY5rqJfxaPNpCQt0PxYnEOH753CmGYJ6LjjMvGy1D4bcMn/vA8Giy15Arva
	 UD72jlT/v+yeB6uXuSi8TZBLYqsj0+0pfLMFFpvS1lZPMYjgmnb/QYMzLns3gHve/O
	 26m+umUgqa1S78R8GgT3yBAN8hYkFtlhRmQGCRzHEpis8isrHJWkje8h8PUOhbdM9o
	 JhuJeCZSUeehQ==
Date: Tue, 18 Feb 2025 17:04:41 -0800
Subject: [PATCH 04/13] xfs: race fsstress with realtime rmap btree scrub and
 repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591186.4080556.3392046573752829715.stgit@frogsfrogsfrogs>
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

Race checking and rebuilding realtime rmap btrees with fsstress.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1817     |   39 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/1817.out |    2 ++
 tests/xfs/1821     |   45 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1821.out |    2 ++
 tests/xfs/1857     |   39 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/1857.out |    2 ++
 tests/xfs/1893     |    2 +-
 7 files changed, 130 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/1817
 create mode 100644 tests/xfs/1817.out
 create mode 100755 tests/xfs/1821
 create mode 100644 tests/xfs/1821.out
 create mode 100755 tests/xfs/1857
 create mode 100644 tests/xfs/1857.out


diff --git a/tests/xfs/1817 b/tests/xfs/1817
new file mode 100755
index 00000000000000..501aa2c8611196
--- /dev/null
+++ b/tests/xfs/1817
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1817
+#
+# Race fsstress and rtrmapbt scrub for a while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest scrub fsstress_scrub
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+_require_realtime
+_require_scratch
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_require_xfs_has_feature "$SCRATCH_MNT" realtime
+_require_xfs_has_feature "$SCRATCH_MNT" rmapbt
+_xfs_force_bdev realtime $SCRATCH_MNT
+
+_scratch_xfs_stress_scrub -s "scrub rtrmapbt %rgno%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1817.out b/tests/xfs/1817.out
new file mode 100644
index 00000000000000..525ec14ed0f057
--- /dev/null
+++ b/tests/xfs/1817.out
@@ -0,0 +1,2 @@
+QA output created by 1817
+Silence is golden
diff --git a/tests/xfs/1821 b/tests/xfs/1821
new file mode 100755
index 00000000000000..3104dc7d9e5f37
--- /dev/null
+++ b/tests/xfs/1821
@@ -0,0 +1,45 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1821
+#
+# Race fsstress and realtime bitmap repair for a while to see if we crash or
+# livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair fsstress_online_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+_require_realtime
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_require_xfs_has_feature "$SCRATCH_MNT" realtime
+_xfs_force_bdev realtime $SCRATCH_MNT
+
+if _xfs_has_feature "$SCRATCH_MNT" rtgroups; then
+	_scratch_xfs_stress_online_repair -s "repair rtbitmap %rgno%"
+elif xfs_io -c 'help scrub' | grep -q rgsuper; then
+	_scratch_xfs_stress_online_repair -s "repair rtbitmap 0"
+else
+	_scratch_xfs_stress_online_repair -s "repair rtbitmap"
+fi
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1821.out b/tests/xfs/1821.out
new file mode 100644
index 00000000000000..0f18ad5d88ca70
--- /dev/null
+++ b/tests/xfs/1821.out
@@ -0,0 +1,2 @@
+QA output created by 1821
+Silence is golden
diff --git a/tests/xfs/1857 b/tests/xfs/1857
new file mode 100755
index 00000000000000..d07559f3974062
--- /dev/null
+++ b/tests/xfs/1857
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1857
+#
+# Race fsstress and rtrmapbt repair for a while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair fsstress_online_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+_require_realtime
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_require_xfs_has_feature "$SCRATCH_MNT" realtime
+_require_xfs_has_feature "$SCRATCH_MNT" rmapbt
+_xfs_force_bdev realtime $SCRATCH_MNT
+
+_scratch_xfs_stress_online_repair -s "repair rtrmapbt %rgno%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1857.out b/tests/xfs/1857.out
new file mode 100644
index 00000000000000..b51ffd3f6cdd53
--- /dev/null
+++ b/tests/xfs/1857.out
@@ -0,0 +1,2 @@
+QA output created by 1857
+Silence is golden
diff --git a/tests/xfs/1893 b/tests/xfs/1893
index d06687fa2a1087..1f04da0028a12a 100755
--- a/tests/xfs/1893
+++ b/tests/xfs/1893
@@ -46,7 +46,7 @@ done
 
 # Metapath verbs that take a rt group number
 for ((rgno = 0; rgno < rgcount; rgno++)); do
-	for v in rtbitmap rtsummary; do
+	for v in rtbitmap rtsummary rtrmapbt; do
 		testio=$(try_verb "$v" "$rgno")
 		test -z "$testio" && verbs+=("$v $rgno")
 	done

