Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8EEDDA6;
	Tue, 18 Jun 2024 00:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671950; cv=none; b=faGWEpaq6CYZfJKGq1BNB/9X7CU7UVdC4DFtlMKsPGZi/mK8sJuyAptK7/ARrabb6/COiS19CM8Pizgv6I1t7H/k6W2d5zPhbNT1PHmafbfZJWCUvz/WnSxAjohA0qKrLlElZF6hwy0QyKkibVNjLDTwHVZa49kB5Fvmyj9YlWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671950; c=relaxed/simple;
	bh=im8zc6XeXwkN1EF4G/Qjmvbip51EkovsRT71tZmHj+A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BtipCECgayA2fb7e8P1qPI5hvvAC1JU6xxM+paFqJ9N39nZk07WqFUWrqZ3s2m4EzjvQh+2LLY/dHRhMDPz6F7rzolHTHLDDRR3G0E1kFJH5ruNxFM0yMKRNER/XAMgVnkPt/Kd7gX0tlkiaHyo92N+TnrmZazZxwzujm2FgGzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wb/wkVIg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wb/wkVIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7E1C4AF1A;
	Tue, 18 Jun 2024 00:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671950;
	bh=im8zc6XeXwkN1EF4G/Qjmvbip51EkovsRT71tZmHj+A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Wb/wkVIgAWg20AZim42woKJRPfsmvBkbuVPtTad5pJJCrnqsTF6vX/m9r6LNDWg7C
	 rhWXV8yf3TOG/8WXXQFZ0FKxb3Ad74aldZ60rn6t5pzAHitQ6cODG0sTNGm88OX82Z
	 nDk5CO5O4mp4NnPYgPrUr1/4AA6Y5L2nFEyQZ9W0gqMMY0nJoUxeoc72dToUY1crlL
	 CLcCB9v34w/GUgmei29R9meK/PerBm9cSs/jePC4ChQx4s3yVkMG1j8/adLsIL9a2N
	 B4AZbz3lB+eVTXGzblOZsSre8GRhS8HnErwXWaQcKzx/th7zRTTDxK+hc1zsPfNsJG
	 U36HTjEa/oQTA==
Date: Mon, 17 Jun 2024 17:52:29 -0700
Subject: [PATCH 1/2] common/fuzzy: stress directory tree modifications with
 the dirtree tester
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Message-ID: <171867146331.794337.1922848493796719618.stgit@frogsfrogsfrogs>
In-Reply-To: <171867146313.794337.2022231429195368114.stgit@frogsfrogsfrogs>
References: <171867146313.794337.2022231429195368114.stgit@frogsfrogsfrogs>
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

Stress test the directory tree corruption detector by racing it with
fsstress.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1864     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1864.out |    2 ++
 tests/xfs/1865     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1865.out |    2 ++
 4 files changed, 80 insertions(+)
 create mode 100755 tests/xfs/1864
 create mode 100644 tests/xfs/1864.out
 create mode 100755 tests/xfs/1865
 create mode 100644 tests/xfs/1865.out


diff --git a/tests/xfs/1864 b/tests/xfs/1864
new file mode 100755
index 0000000000..d00bcb28b4
--- /dev/null
+++ b/tests/xfs/1864
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1864
+#
+# Race fsstress and directory tree structure corruption detector for a while to
+# see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest scrub dangerous_fsstress_scrub
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_scrub -x 'dir' -s "scrub dirtree" -t "%dir%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1864.out b/tests/xfs/1864.out
new file mode 100644
index 0000000000..472f56323a
--- /dev/null
+++ b/tests/xfs/1864.out
@@ -0,0 +1,2 @@
+QA output created by 1864
+Silence is golden
diff --git a/tests/xfs/1865 b/tests/xfs/1865
new file mode 100755
index 0000000000..098891536c
--- /dev/null
+++ b/tests/xfs/1865
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1865
+#
+# Race fsstress and directory tree structure repair for a while to see if we
+# crash or livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_online_repair -x 'dir' -s "repair dirtree" -t "%dir%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1865.out b/tests/xfs/1865.out
new file mode 100644
index 0000000000..9f2fecad3f
--- /dev/null
+++ b/tests/xfs/1865.out
@@ -0,0 +1,2 @@
+QA output created by 1865
+Silence is golden

