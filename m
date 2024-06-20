Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A021D757EE;
	Thu, 20 Jun 2024 21:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718917204; cv=none; b=bzgesI69MsF4eNljANo62qVLXgE1Rq0UKowu+RcewUAlEDCsbw4zgiaXdkvM2oxFNg7NbKuNAdWCIxGNlVUVFj65gFrSA2uzYKDkCCDlmAwb1EC7Ro1s44cKXME0q41GgK2sWJqoWMIjGVSRjKdeS2jmRD+nYShESer9IWmds3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718917204; c=relaxed/simple;
	bh=hjBiPuHxOmQiXUcJu2uPy6VcZD7wpq87L5C2k5yjNjE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=meTDb2O3p4+pxjXwduK3GBAhwNct1an0wL9pIPuyUlkb/g7+crED6CkN3JrHnbgpiDC7UItkXhG5Tnl96wbYfalnl1schR6mRu0ilk8xTAPYzK1PtODkcCOncvYgoqlpTr6mgUwpd7WVE9Zx8wnoUhHwbGAdV80AE2xnatRTHSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7dCvfsE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7dCvfsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3627AC2BD10;
	Thu, 20 Jun 2024 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718917204;
	bh=hjBiPuHxOmQiXUcJu2uPy6VcZD7wpq87L5C2k5yjNjE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V7dCvfsE3XYicJBqJhs+2vVmixWn0PsBluDVPpwPJxjLZif0f0jrqiSRs25HN2pIk
	 eiOnT+0ozugh9ZrnzPGmnCp4iIIFddHu0r2QX+emJG0AZnEW509qJabW5GReRGvFfh
	 /auQj8fO8ibGpLDX+XQonrM/aFCaGFBCUUAEWp73sZPBevYsxJoZku2iTtQ9ifBrq4
	 g932oJx41b7SmpMEOsYRW04XlnqbkvdXy+hK30r+1mHzZHOcYkBXvRevayqgOqm5OG
	 5M04p4WKTL83vbmfgBDgELF5Fh7k6VTyRygbESzD1LKCMyGklUNCbJnWAEkLX5xpbG
	 V8G2pTawuKe0w==
Date: Thu, 20 Jun 2024 14:00:03 -0700
Subject: [PATCH 1/2] common/fuzzy: stress directory tree modifications with
 the dirtree tester
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <171891670166.3035670.9262848217494592378.stgit@frogsfrogsfrogs>
In-Reply-To: <171891670149.3035670.17847103061665110343.stgit@frogsfrogsfrogs>
References: <171891670149.3035670.17847103061665110343.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

