Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887DA8494;
	Sat, 26 Oct 2024 20:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729973558; cv=none; b=LHeEZQW5zMVuaXXh5evrg0BSlJE2wqd4iFKebawk9UTP42V+QPaaB8gp5edC1NRNuHNmQAHp/LsDvaV8hjw1vl1/NlKUOkC/MjEOrrPcOgpPHPhwBTG2hto4tUAfGotiN62n9heFOwH/PJA4vvrgNex+jLke1gLGbsfNtCpDqlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729973558; c=relaxed/simple;
	bh=8JJ3WuQ7zBqgQWERCkgZi39Z7iknVCN5isYAoyhvvMk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fc+LfiQ7/75Y7C2hCQxwEs9V4i9Shx2Rrl49UHG5edsScbGZcawoMRVUsonSVPRm/8Rfk9D5hnkkdWMvPwYJSXCgMRIPqva8rJrOcv8Os5EXUpagyOxlzyIytDk8krrQJtyRWTHV2FV7N+F9InhMM2BC1bRy3vJeZONVlg5ya90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=msfV8YoF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="msfV8YoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B85AC4CEC6;
	Sat, 26 Oct 2024 20:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729973558;
	bh=8JJ3WuQ7zBqgQWERCkgZi39Z7iknVCN5isYAoyhvvMk=;
	h=From:To:Cc:Subject:Date:From;
	b=msfV8YoFaUlWjOTsVvKkQ0Nwk1XW5q0oRc5L1hohU7VDoEiSjmX0JztldAWDwgDHI
	 sOUZzXV9gq2Mx7XBc8uf7twIllYqyB8YiRib1tnqjbnFRx07CauTI+4OtOD1cBbbJ5
	 S0C+1R+1C6nmhx5IC+YX5gA8/a86XWx4l+cJwwYW9eg3UJXrGPHXQ3//cq9XsveH/V
	 VDEtV4VC16FBuWt/57qZU4SfQPOPszU7AcxzyeRKx1SKyAQj+SA7DfJ9ESe4ZVeDbM
	 Vt0elri0fOeVd9l5dp/e0uquN8NQe0p+dPaKsatflCJ3ZOWGVmKD8kGuGT+bbihAIv
	 3ec4CPKtCs8mQ==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: notrun if kernel xfs not supports ascii-ci feature
Date: Sun, 27 Oct 2024 04:12:34 +0800
Message-ID: <20241026201234.77387-1-zlang@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As the ascii-ci feature is deprecated, if linux build without the
CONFIG_XFS_SUPPORT_ASCII_CI, mount xfs with "-n version=ci" will
get EINVAL. So let's notrun if it's not supported by kernel.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 common/xfs    | 10 ++++++++++
 tests/xfs/188 |  1 +
 tests/xfs/597 |  1 +
 tests/xfs/598 |  1 +
 4 files changed, 13 insertions(+)

diff --git a/common/xfs b/common/xfs
index 62e3100ee..cbcf4ee0b 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1181,6 +1181,16 @@ _require_xfs_mkfs_ciname()
 		|| _notrun "need case-insensitive naming support in mkfs.xfs"
 }
 
+# this test requires the xfs kernel support ascii-ci feature
+#
+_require_xfs_ciname()
+{
+	_try_scratch_mkfs_xfs -n version=ci >/dev/null 2>&1
+	_try_scratch_mount >/dev/null 2>&1 \
+		|| _notrun "XFS doesn't support ascii-ci feature"
+	_scratch_unmount
+}
+
 # this test requires mkfs.xfs have configuration file support
 _require_xfs_mkfs_cfgfile()
 {
diff --git a/tests/xfs/188 b/tests/xfs/188
index a72bf15d6..98cdfd501 100755
--- a/tests/xfs/188
+++ b/tests/xfs/188
@@ -31,6 +31,7 @@ _cleanup()
 
 _require_scratch
 _require_xfs_mkfs_ciname
+_require_xfs_ciname
 
 _scratch_mkfs -n version=ci >/dev/null 2>&1
 _scratch_mount
diff --git a/tests/xfs/597 b/tests/xfs/597
index d3bf91a99..2bf361080 100755
--- a/tests/xfs/597
+++ b/tests/xfs/597
@@ -20,6 +20,7 @@ _fixed_by_kernel_commit 9dceccc5822f \
 
 _require_scratch
 _require_xfs_mkfs_ciname
+_require_xfs_ciname
 
 _scratch_mkfs -n version=ci > $seqres.full
 _scratch_mount
diff --git a/tests/xfs/598 b/tests/xfs/598
index 54f50cd60..20a80fcb6 100755
--- a/tests/xfs/598
+++ b/tests/xfs/598
@@ -27,6 +27,7 @@ _fixed_by_kernel_commit 9dceccc5822f \
 _require_test
 _require_scratch
 _require_xfs_mkfs_ciname
+_require_xfs_ciname
 
 _scratch_mkfs -n version=ci > $seqres.full
 _scratch_mount
-- 
2.45.2

