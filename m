Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2ED019D8A7;
	Wed, 19 Feb 2025 00:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926439; cv=none; b=FHDW/e/2EYCyttXGF29cQtvSw9JcqGH24OVnGDSnNj4YxTw8rGVCtWgCEmHWgNfwMfx3CW9Qzw3ftTI79JSXelOZaVz4VWAUbNbJbAkxOrxg7Mrmruyph27HbDN6dTCaBhePVaSghLP5ctA1rWtkZ9ipCceA7nR8XD5tNUeFxNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926439; c=relaxed/simple;
	bh=YrhNwxGuK96Y9/n5sgdzifTcaMto7KGJD6ganjgPFXU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rGVYRgfb1d8glHPv8e1SWGyq8UT320YRZeaqobI7qEU+veUC7903wwqZTCPAo8HXuqTwjFWvTad47yvGqj9pro5oJKLTlydmYo2HW59nPImUTE1C3xoXczEXdP6dhYMbBiC/eJy9Pr0e57vPZaIbdTnuJirs/tSdx1VAllFMWJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZW9++Y9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZW9++Y9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148C7C4CEE2;
	Wed, 19 Feb 2025 00:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926439;
	bh=YrhNwxGuK96Y9/n5sgdzifTcaMto7KGJD6ganjgPFXU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZW9++Y9h1jjoMuxDE9pClOVIzyM4xdgKno+6D4s0NAwAgwK2H2SHFBWqrzX7OZyNS
	 KBFtxxsnkBtlowsE+BtfNaGmp6TQsv+wmQCfH+F4VwRHl3GPwKMVpg2RE836l145ji
	 cvix48z+zgfJVpn86Yb4eqUone/A1dN01Wg5KziGkdzFfQJMR9rvnvWnpNuiA3rCUc
	 7qxSO2wJEy126AxU4P6HQrEd8CyYBwoY1p1ag9WaDriDrm5o7BeHxCCmsxzTi86X6a
	 hbZlk0oImEsaFzBMgedoH5mdG0mITJUGjG/wB6AaLL84EPldkww9X1n7YZeGnRvxc3
	 fOG0VQENtipeA==
Date: Tue, 18 Feb 2025 16:53:58 -0800
Subject: [PATCH 02/12] xfs/{030,033,178}: forcibly disable metadata directory
 trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992588098.4078751.13636667598878254024.stgit@frogsfrogsfrogs>
In-Reply-To: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The golden output for thests tests encode the xfs_repair output when we
fuzz various parts of the filesystem.  With metadata directory trees
enabled, however, the golden output changes dramatically to reflect
reconstruction of the metadata directory tree.

To avoid regressions, add a helper to force metadata directories off via
MKFS_OPTIONS.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs    |   25 +++++++++++++++++++++++++
 tests/xfs/030 |    1 +
 tests/xfs/033 |    1 +
 tests/xfs/178 |    1 +
 4 files changed, 28 insertions(+)


diff --git a/common/xfs b/common/xfs
index 02f569c971a194..85cd9a1348e385 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1902,3 +1902,28 @@ _scratch_xfs_find_metafile()
 	echo "inode $sb_field"
 	return 0
 }
+
+# Force metadata directories off.
+_scratch_xfs_force_no_metadir()
+{
+	# Remove any mkfs-time quota options because those are only supported
+	# with metadir=1
+	for opt in uquota gquota pquota; do
+		echo "$MKFS_OPTIONS" | grep -q -w "$opt" || continue
+
+		MKFS_OPTIONS="$(echo "$MKFS_OPTIONS" | sed -e "s/,$opt//g" -e "s/ $opt/ /g")"
+		MOUNT_OPTIONS="$MOUNT_OPTIONS -o $opt"
+	done
+
+	# Replace any explicit metadir option with metadir=0
+	if echo "$MKFS_OPTIONS" | grep -q 'metadir='; then
+		MKFS_OPTIONS="$(echo "$MKFS_OPTIONS" | sed -e 's/metadir=[0-9]*/metadir=0/g' -e 's/metadir\([, ]\)/metadir=0\1/g')"
+		return
+	fi
+
+	# Inject metadir=0 if there isn't one in MKFS_OPTIONS and mkfs supports
+	# that option.
+	if grep -q 'metadir=' $MKFS_XFS_PROG; then
+		MKFS_OPTIONS="-m metadir=0 $MKFS_OPTIONS"
+	fi
+}
diff --git a/tests/xfs/030 b/tests/xfs/030
index 7ce5ffce38693c..22fbdb2fdbc999 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -48,6 +48,7 @@ _check_ag()
 
 _require_scratch
 _require_no_large_scratch_dev
+_scratch_xfs_force_no_metadir
 
 DSIZE="-dsize=100m,agcount=6"
 
diff --git a/tests/xfs/033 b/tests/xfs/033
index d7b02a9c51b3f0..e0b0dd58212d61 100755
--- a/tests/xfs/033
+++ b/tests/xfs/033
@@ -51,6 +51,7 @@ _filter_bad_ids()
 
 _require_scratch
 _require_no_large_scratch_dev
+_scratch_xfs_force_no_metadir
 
 # devzero blows away 512byte blocks, so make 512byte inodes (at least)
 _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
diff --git a/tests/xfs/178 b/tests/xfs/178
index a22e626706ec49..0cc0e3f5bb88b4 100755
--- a/tests/xfs/178
+++ b/tests/xfs/178
@@ -50,6 +50,7 @@ _dd_repair_check()
 #             fix filesystem, new mkfs.xfs will be fine.
 
 _require_scratch
+_scratch_xfs_force_no_metadir
 _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
 
 # By executing the followint tmp file, will get on the mkfs options stored in

