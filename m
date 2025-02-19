Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5FC3596B;
	Wed, 19 Feb 2025 00:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926689; cv=none; b=pEq6kSGPdj3TFGdJ1MA72rm/FNqTdTpmO9RNCZRff+zdkHLBIPnImV3g7a0CXxBrZSDFE1qTTuMOGtjwhOzTJo/GWkFEk9ZZ4qzamJziAvRX19bL2P+fUJaIfRHydr1y0x2TUdvnjf3UzrSEP5JyC2eDOC5Nf1xpMPXWsgCQAzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926689; c=relaxed/simple;
	bh=o3VUUXGYQa5mzmJ/im4aC1NvxgbM8eoTLmzt9FY8a38=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xg7oC8oSh0aKoGFOFvqQcEVjKUsm21ntNnMb0OxxT8K3mO5K5/Ke6+eexXb2olHObDgntP1egKYTgj2kJiZsw6A58y8+ltXeoj6pJB9sIAMlFfnpsjT2WO5M2e/r9w9XckVUA4HbKZbUNRucIX3JyBJKtRguMXjyh2z1Tdb4adA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XF6pBq7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XF6pBq7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372F3C4CEE2;
	Wed, 19 Feb 2025 00:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926689;
	bh=o3VUUXGYQa5mzmJ/im4aC1NvxgbM8eoTLmzt9FY8a38=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XF6pBq7dtibGN8YyGqU80fquTczU4Rti0ziD2r9d9wdLzO3hxka7EWN+iOWdaLmiY
	 WcvirqgoC2Bn8f2zxPBUoSSB1sxnQWXHmTk5sY1KT6GDGaYP88oW6OM/tsa7aIWAr7
	 oLUZf7T0/H3Ii4L8y18Mp8EPm60jbAo2FnOUIUVlCNbYz12bFR3JhhsRoyn89mYdF0
	 x5cIv0vZZlOBKhs+4g/m4bvMt+ir5RBomXN4KZUPmBdLGEBuPIRXtltH5Qr8JN9ac2
	 SYqi2hgZkNL9MvPym6eveFWzdgTxgrtD8A5gxiNfoGpYVFoORXzkUlA1bMgefLk7+T
	 s0w2GP4/SIpOA==
Date: Tue, 18 Feb 2025 16:58:08 -0800
Subject: [PATCH 02/15] common/{fuzzy,populate}: use _scratch_xfs_mdrestore
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589216.4079457.5690934779911954776.stgit@frogsfrogsfrogs>
In-Reply-To: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Port the fuzzing and populated filesystem cache code to use this helper
to pick up external log devices for the scratch filesystem.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/fuzzy    |    2 +-
 common/populate |   15 ++-------------
 2 files changed, 3 insertions(+), 14 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 702ebc4b9aed84..ee9fe75609e603 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -306,7 +306,7 @@ __scratch_xfs_fuzz_unmount()
 __scratch_xfs_fuzz_mdrestore()
 {
 	__scratch_xfs_fuzz_unmount
-	_xfs_mdrestore "${POPULATE_METADUMP}" "${SCRATCH_DEV}" || \
+	_scratch_xfs_mdrestore "${POPULATE_METADUMP}" || \
 		_fail "${POPULATE_METADUMP}: Could not find metadump to restore?"
 }
 
diff --git a/common/populate b/common/populate
index 627e8ca49694e7..e6804cbc6114ba 100644
--- a/common/populate
+++ b/common/populate
@@ -1030,19 +1030,8 @@ _scratch_populate_restore_cached() {
 
 	case "${FSTYP}" in
 	"xfs")
-		_xfs_mdrestore "${metadump}" "${SCRATCH_DEV}"
-		res=$?
-		test $res -ne 0 && return $res
-
-		# Cached images should have been unmounted cleanly, so if
-		# there's an external log we need to wipe it and run repair to
-		# format it to match this filesystem.
-		if [ -n "${SCRATCH_LOGDEV}" ]; then
-			$WIPEFS_PROG -a "${SCRATCH_LOGDEV}"
-			_scratch_xfs_repair
-			res=$?
-		fi
-		return $res
+		_scratch_xfs_mdrestore "${metadump}"
+		return $?
 		;;
 	"ext2"|"ext3"|"ext4")
 		_ext4_mdrestore "${metadump}" "${SCRATCH_DEV}"

