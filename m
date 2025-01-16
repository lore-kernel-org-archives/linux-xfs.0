Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30941CEAD3;
	Thu, 16 Jan 2025 23:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070348; cv=none; b=nl3unaptolmf0LmAwAbbKtv43wrko4LUJqz+mD/NSOof/E4Ilvzq1UQZ0+tnULHeEr3Cj/td/lpMISOvfW34ICShYvpWoZV4s82IL7ZXeLm9ntuR+nL7vKo9oOWhcVpWTtoAEviGGwX2BPL0oi6wxp9l9SP2JY2B1UHh4WJSoKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070348; c=relaxed/simple;
	bh=HRHVDg5464kdEFenLG+y7WCFPUqFPxgG3cEfwnqHrZ0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t9FE/TeBIu7ATkX257HECo/RzDAG8a/1R02f1PCIMNWV1o+R5Bqm3JtZJVNF/KN2fWr7C6tDscVYOQVLFjWPhErjI275RuHBExSRfbp+9BmB3lwzgXhXL1SfzaR498LxMGMgOi6jDqALuZGxhenawenN86t46MdungAavQmONp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y31lauu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y31lauu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D43BC4CED6;
	Thu, 16 Jan 2025 23:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070348;
	bh=HRHVDg5464kdEFenLG+y7WCFPUqFPxgG3cEfwnqHrZ0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y31lauu85AdWnMV9ALDHSl9kj9WdB90nH9kxSyZ+42yhMmfzWU2JwyFs5y+jzoX37
	 GMtXIQChMcBUryH4loVrIu+xNVT7SEVEQp2U2o1icV1xD6SOeBEwLxQbaJtxcbp4I0
	 bmfZQ+RJEmEIoTmjWHrzinkDTlMyPR4Fw6rHUPRAQ2bKdbw6BINnqDdZ//GWY3h9qg
	 C152OwQxvniJLWayk/MraRKIkbB2gyUbY350ArtllnyaMkrvStgUaPk37faEN8XrrO
	 ATFjOc1/z9N5eXRsAHncFKSUvIpjt2HGQNYqOxkgWi3WAXffLdDZgDqPCxurL8fWN0
	 mo+Q/F/Z/40Qg==
Date: Thu, 16 Jan 2025 15:32:28 -0800
Subject: [PATCH 02/11] xfs/{030,033,178}: forcibly disable metadata directory
 trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706975196.1928284.971193659670502234.stgit@frogsfrogsfrogs>
In-Reply-To: <173706975151.1928284.10657631623674241763.stgit@frogsfrogsfrogs>
References: <173706975151.1928284.10657631623674241763.stgit@frogsfrogsfrogs>
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
index 092b3dc6f3bdc5..ee7fe7b92a4950 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1908,3 +1908,28 @@ _scratch_xfs_find_metafile()
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

