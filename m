Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF46E1DFCB
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529771; cv=none; b=AJjkDco9IUCu+a7Wmj6tXLvEwaRXQXa5gNSFptv55ZRNykh9HGoMszLOAkSftLHXxyzqZI743M4uy9cRur5PfRR9uvouH95gmJIOh19ySsyXIHJXz1/VDSzp8wMGPkvGFX0DxhmIl9/zJ4azOf7Z1XouPTm5e5/28xuOaRBoYBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529771; c=relaxed/simple;
	bh=E0K+vFrbHB77I+hRarADE82t76FSKrrtTJ9fYu93Kvg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W/VSByLsVjy5qE7GPSteP9zrsrqw4yCMMAYtw9iO8zhwfVDwtNusJ1LkIKZsgV6Zq+cuBxzQ4DESkZdr+LoQ+2F1Dh7rHA1Q3qHfLv6e4U2eRLBZme7MgeAPD3f5SwqYJIadj4jv0UEVrWydnh+leG97ApwZpEkK2/5md38ncmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0ie6bUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0ie6bUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7286C4CED1;
	Sat,  7 Dec 2024 00:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529770;
	bh=E0K+vFrbHB77I+hRarADE82t76FSKrrtTJ9fYu93Kvg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V0ie6bUNjUDSu6njTFB6iUkcgLwEeO0o5C9LG592WVvqRFZEl+CnZ9jh1uvTf0Wv6
	 p6tcriCXCmWaD/cyqoBuq44ftfDw+KEL0alOrsUT9YGEAwd64zSAeXdk16vPY5cEHi
	 xROjj45U2R6MCOvZi6/cnaPBQMvw+hfNkiNOmREHvYN61/HD8MQyGt6ZEPzwHaVh7Z
	 Dz00HR2Rdyf6ExZvGBxtN+JB7p6X+Zby6WcaafMfj92gQ944FHIew4fNMQpSbujd2R
	 wN/6xkEAwDSU6pFHZEyKEi1gSyqgKfGKnfvO6SWi/ZoIkZw8HgDqgsayQhlQTsUaJh
	 JJnpajjfUQLuQ==
Date: Fri, 06 Dec 2024 16:02:50 -0800
Subject: [PATCH 44/46] xfs: remove unknown compat feature check in superblock
 write validation
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: leo.lilong@huawei.com, hch@lst.de,
 cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750667.124560.260733898261342072.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
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

