Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141E613FEE;
	Mon, 23 Dec 2024 22:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991782; cv=none; b=Nux6+BV2wi04SFFsyndd7NHZB6QDhQ9/cknE7q4Se+aNfeOeliGhDEg8CKOl9ReT2Ap2B0J44a7q/s0bpDPpZWAvv7wttdOrpBlDvTpoWe8UXbYjnD9EX4giS4MCU8WYRT/zvJAUa7yRDwAiCWnhTWH+CUNJdLZqar56mcCDC50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991782; c=relaxed/simple;
	bh=E0K+vFrbHB77I+hRarADE82t76FSKrrtTJ9fYu93Kvg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jh9aG9acWeGjK0Y4NJ6JdXKdnvlbN2cQyRZx1zzq1w97u3lendefZ7l5LXOoR9vFoni1Y6PRejlwm+eoI1TmIM9bd8vV8IQPSwJa3/yvPppQEzy4CmB2RQuz1tiR8c2eXWvthWakUGcKCNF6zOXdX7O5/+8tlWg2WZdeYp1FZbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DkDZEwbs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DkDZEwbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76D1C4CED3;
	Mon, 23 Dec 2024 22:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991781;
	bh=E0K+vFrbHB77I+hRarADE82t76FSKrrtTJ9fYu93Kvg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DkDZEwbsWZUCkMDaBksZ2OzJAjv+kEGjb1QcHZrz0QAqbPH/8FpyDb0oTx2S3D2Pl
	 XuqYGhirAFF2P7DP9Gl88ufgvrLd01PcOKIcCXoR/2huidUB0F+8RB9geKGpuUGCwC
	 KG9Ynh724mg57XEwHLCdBjgZVXZxZxYn6/WrMV3N8fRNp4sE9Ymy/i9z5N8TYzVDwB
	 ogBEx3IMQKPdQGCcJpqmzYCrR1ZsYQNtyi/p4YnHT8H1qfhtLSi7Xn1nkZf+DLYLeY
	 bURoXNtkzWQ7lF37B7bD/Ew6b4J92zrasNxDa9SP+urHpo3OrHV/8Wh027LGRM0xIF
	 6ri1E1OD3oqKg==
Date: Mon, 23 Dec 2024 14:09:41 -0800
Subject: [PATCH 44/52] xfs: remove unknown compat feature check in superblock
 write validation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: stable@vger.kernel.org, leo.lilong@huawei.com, hch@lst.de, cem@kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <173498943164.2295836.3577687751669301178.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Long Li <leo.lilong@huawei.com>

Source kernel commit: 652f03db897ba24f9c4b269e254ccc6cc01ff1b7

Compat features are new features that older kernels can safely ignore,
allowing read-write mounts without issues. The current sb write validation
implementation returns -EFSCORRUPTED for unknown compat features,
preventing filesystem write operations and contradicting the feature's
definition.

Additionally, if the mounted image is unclean, the log recovery may need
to write to the superblock. Returning an error for unknown compat features
during sb write validation can cause mount failures.

Although XFS currently does not use compat feature flags, this issue
affects current kernels' ability to mount images that may use compat
feature flags in the future.

Since superblock read validation already warns about unknown compat
features, it's unnecessary to repeat this warning during write validation.
Therefore, the relevant code in write validation is being removed.

Fixes: 9e037cb7972f ("xfs: check for unknown v5 feature bits in superblock write verifier")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_sb.c |    7 -------
 1 file changed, 7 deletions(-)


diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 375324b99261af..87f740e6c75dce 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -323,13 +323,6 @@ xfs_validate_sb_write(
 	 * the kernel cannot support since we checked for unsupported bits in
 	 * the read verifier, which means that memory is corrupt.
 	 */
-	if (xfs_sb_has_compat_feature(sbp, XFS_SB_FEAT_COMPAT_UNKNOWN)) {
-		xfs_warn(mp,
-"Corruption detected in superblock compatible features (0x%x)!",
-			(sbp->sb_features_compat & XFS_SB_FEAT_COMPAT_UNKNOWN));
-		return -EFSCORRUPTED;
-	}
-
 	if (!xfs_is_readonly(mp) &&
 	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
 		xfs_alert(mp,

