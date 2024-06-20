Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8576BB58;
	Thu, 20 Jun 2024 20:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718917111; cv=none; b=lOW3X7Od0eBFKSQCPSpgk6d1vaqHemM+5rM3EH5LXcYR+xXpGMsvhXakEUZFJDjr2cc7vLeiFvcnbOF684uCEh7M4Vxd0zd3+bo/tZpHhnOtX+Z5c81CvO4VuZZDiinWw3n+T+oqORJShlOCqPTDCLI9HwK4xWc/AjBaPQEjqek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718917111; c=relaxed/simple;
	bh=LvMjZvXlMf4yFgltuVMIZShvUZGVUFeDJWOYYx0xlwg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H2Pmi7KJ5oZ3jXJJQoaqrgtT10lvR0cjWc7La+imPtc3MWJajvY4W7cUv2IPu0INuBPR0IHyW4CUOfvsvbcXYPcjJj86dEm8Z3j48la/OLXU1wsgkLWQxy1hONkwJxPMWFugwxnlTRHX2GPIATLtwxUQNu6at4l9qhHZjkZp0Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kZt+uUYB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kZt+uUYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208D7C32781;
	Thu, 20 Jun 2024 20:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718917110;
	bh=LvMjZvXlMf4yFgltuVMIZShvUZGVUFeDJWOYYx0xlwg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kZt+uUYB40ZzFMVBrcfkV7gL5P6pIsVpAoDMiqQVt+DFZqN4CmTMVYfE1kecBEvjK
	 SldQ49QAsrvRO4f9L1R7YyLLGRJpHnr+WdHYxMPiwCpYQ+giXWoG24Wpjp5cLcACR+
	 nWKEW0flUJ9ZIYybEzf9Yf7TcbkUiTW8QHqRh4SQoyH4Bw1nyoOTr4RgzUprXKkz51
	 9u2tLxaa7qHys/JIKXv/u89x2YWr6LzZ5Cn+f4o4JgAj3nYe02oYax4uSILBbWEmsN
	 zUnsM4vxEpW2Tj2qFLzNB3xlZE6g4R/TSmCY/91kRt6khf8Zu+2vIYzIzd29hbxUCL
	 ebTz4xSjDduBQ==
Date: Thu, 20 Jun 2024 13:58:29 -0700
Subject: [PATCH 06/11] xfs/{018,191,288}: disable parent pointers for these
 tests
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171891669731.3035255.3411599744154340279.stgit@frogsfrogsfrogs>
In-Reply-To: <171891669626.3035255.15795876594098866722.stgit@frogsfrogsfrogs>
References: <171891669626.3035255.15795876594098866722.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 common/xfs    |   16 ++++++++++++++++
 tests/xfs/018 |    4 ++++
 tests/xfs/191 |    3 +++
 tests/xfs/288 |    4 ++++
 4 files changed, 27 insertions(+)


diff --git a/common/xfs b/common/xfs
index 0b0863f1dc..b392237575 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1847,3 +1847,19 @@ _require_xfs_nocrc()
 		_notrun "v4 file systems not supported"
 	_scratch_unmount
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
+		MKFS_OPTIONS="$(echo "$MKFS_OPTIONS" | \
+				sed -e 's/parent=[01]/parent=0/g')"
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

