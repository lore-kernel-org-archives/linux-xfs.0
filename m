Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E338A1F3FD7;
	Thu, 16 Jan 2025 23:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070537; cv=none; b=RNcNG2qyHwaBMbLOFrV7LGr+m+J5cypGApc5NWvEbYGPzOtfufMh5wFlHcjyuCBz9XddK2EMW5eQXJQOsmrympJJGr99Xr/5t4nZWBNdTVy9XKjcE+Vzldag4BR/uJdHWQcNmvbssaipL7xtPONRbkQKWVX23hMvUyLJ3Hvo03o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070537; c=relaxed/simple;
	bh=rhltLT/ppZYKCi5Ez89cB7XeFHOQYBDN55ZjeImE8j8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M4YrAnVr6Y3z0RB2ebqkCeHWfGpBieNGaMqFPyd60ZuTPdbAYGIebYEXYR+6N/eQgzeEnyc9rhM8ng248WhLQ17dzZUnH5Es7SPwT6N2XmAA0fHIQ37ur0g0m7oiqRLdSQO+2+xWXfpsZDTUTofc6wrxj6maDD6a/AR/fadhKZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l82z7khT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l82z7khT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF93C4CEDD;
	Thu, 16 Jan 2025 23:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070536;
	bh=rhltLT/ppZYKCi5Ez89cB7XeFHOQYBDN55ZjeImE8j8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l82z7khThBqvUjb8BCyD6Ckdpns3ZksM7p7CEmtNdjCoeQQobIJVZ5aRnPQOJFgnr
	 EA6A/dsvyoYHQbpME3K3lAU5ppGt3NBq+Gu0cA1brdXsdsEkMNydK06r3SLVyf/9Ek
	 +zT6FqWf/LV0S1bF/GaTcB8TRiWDD4dkDm0Fty9c3TOooJSIjqv445vget2R4R1iKf
	 ww3obuMgK436FdwE1e543vLCOjD0rp1OLCflPhvLNIbj/baQ4S3uHi4IpoRnscaSIa
	 kKUfNcBu4wDG0FHx97pwS/MlkrMNtEZtbLqBH0NUIRswzLYD1ny15nj6PyPB1X6ABV
	 wpag8e2IsK3Sg==
Date: Thu, 16 Jan 2025 15:35:36 -0800
Subject: [PATCH 02/14] common/{fuzzy,populate}: use _scratch_xfs_mdrestore
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706976093.1928798.18219737153083282251.stgit@frogsfrogsfrogs>
In-Reply-To: <173706976044.1928798.958381010294853384.stgit@frogsfrogsfrogs>
References: <173706976044.1928798.958381010294853384.stgit@frogsfrogsfrogs>
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
index 331bf5ad7bbafa..9fcaf9b6ee55a9 100644
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
index 4cc4415697ac78..814f28a41c9bea 100644
--- a/common/populate
+++ b/common/populate
@@ -1017,19 +1017,8 @@ _scratch_populate_restore_cached() {
 
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

