Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FB0BA32;
	Mon,  1 Jan 2024 00:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N769XBKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F65DC433C7;
	Mon,  1 Jan 2024 00:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070069;
	bh=1Ikcs1j5LbhYZsuA+H3sbgF6TnvrMuvLRAfHAuXXzNs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N769XBKLk9WLPRDqHZZN/hLo+Q9vAY1qTB8xbohMI916HGx4HLE676vdJZDPDuUED
	 ngeVXzAS96sp4coJVKqBh3QbFrWJGB7ER25wFtB5ZOBUXxkAtiIn8rkKkgJRbfgavI
	 vMcEw0s33i+WMIML6tBwk8uiHB3msOmIRAaqvNrOr3+piQMeEr+t8w0nvSPDPWYAjR
	 xEc1/Oq/iwYXpWlo38d0nKHkpVp46Wwhnn9mJVCd1Gv6hxuB921p0X1xwXRMmAmaEj
	 tRSRxvY03ZejQk30Rw/7kv7RBJUFakejfReuc3Ih3Uev+An9GVDKiJndpx8vgK13IC
	 GxSfltsiJ5tKQ==
Date: Sun, 31 Dec 2023 16:47:48 +9900
Subject: [PATCH 06/11] xfs/{018,191,288}: disable parent pointers for this
 test
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, guan@eryu.me, linux-xfs@vger.kernel.org
Message-ID: <170405028507.1824869.10522647392997122541.stgit@frogsfrogsfrogs>
In-Reply-To: <170405028421.1824869.17871351204326094851.stgit@frogsfrogsfrogs>
References: <170405028421.1824869.17871351204326094851.stgit@frogsfrogsfrogs>
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

These tests depend heavily on the xattr formats created for new files.
Parent pointers break those assumptions, so force parent pointers off.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs    |   15 +++++++++++++++
 tests/xfs/018 |    4 ++++
 tests/xfs/191 |    3 +++
 tests/xfs/288 |    4 ++++
 4 files changed, 26 insertions(+)


diff --git a/common/xfs b/common/xfs
index f53b33fc54..88fa6fb55a 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1816,3 +1816,18 @@ _xfs_discard_max_offset_kb()
 	$XFS_IO_PROG -c 'statfs' "$1" | \
 		awk '{g[$1] = $3} END {print (g["geom.bsize"] * g["geom.datablocks"] / 1024)}'
 }
+
+# Adjust MKFS_OPTIONS as necessary to avoid having parent pointers formatted
+# onto the filesystem
+_xfs_force_no_pptrs()
+{
+	# Nothing to do if parent pointers aren't supported by mkfs
+	$MKFS_XFS_PROG 2>&1 | grep -q parent=0 || return
+
+	if echo "$MKFS_OPTIONS" | grep -q 'parent='; then
+		MKFS_OPTIONS="$(echo "$MKFS_OPTIONS" | sed -e 's/parent=[01]/parent=0/g')"
+		return
+	fi
+
+	MKFS_OPTIONS="$MKFS_OPTIONS -n parent=0"
+}
diff --git a/tests/xfs/018 b/tests/xfs/018
index 73040edc92..7d1b861d1c 100755
--- a/tests/xfs/018
+++ b/tests/xfs/018
@@ -111,6 +111,10 @@ attr32l="X$attr32k"
 attr64k="$attr32k$attr32k"
 
 echo "*** mkfs"
+
+# Parent pointers change the xattr formats sufficiently to break this test.
+# Disable parent pointers if mkfs supports it.
+_xfs_force_no_pptrs
 _scratch_mkfs >/dev/null
 
 blk_sz=$(_scratch_xfs_get_sb_field blocksize)
diff --git a/tests/xfs/191 b/tests/xfs/191
index 7a02f1be21..e2150bf797 100755
--- a/tests/xfs/191
+++ b/tests/xfs/191
@@ -33,6 +33,9 @@ _fixed_by_kernel_commit 7be3bd8856fb "xfs: empty xattr leaf header blocks are no
 _fixed_by_kernel_commit e87021a2bc10 "xfs: use larger in-core attr firstused field and detect overflow"
 _fixed_by_git_commit xfsprogs f50d3462c654 "xfs_repair: ignore empty xattr leaf blocks"
 
+# Parent pointers change the xattr formats sufficiently to break this test.
+# Disable parent pointers if mkfs supports it.
+_xfs_force_no_pptrs
 _scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
 cat $tmp.mkfs >> $seqres.full
 source $tmp.mkfs
diff --git a/tests/xfs/288 b/tests/xfs/288
index aa664a266e..60fb9360f4 100755
--- a/tests/xfs/288
+++ b/tests/xfs/288
@@ -19,6 +19,10 @@ _supported_fs xfs
 _require_scratch
 _require_attrs
 
+# Parent pointers change the xattr formats sufficiently to break this test.
+# Disable parent pointers if mkfs supports it.
+_xfs_force_no_pptrs
+
 # get block size ($dbsize) from the mkfs output
 _scratch_mkfs_xfs 2>/dev/null | _filter_mkfs 2>$tmp.mkfs >/dev/null
 . $tmp.mkfs

