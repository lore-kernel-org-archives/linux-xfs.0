Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FB0D517
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609219; cv=none; b=ZowHzI3nqN1zyph8hqvoIHemKbfwpYXp71zEL/XjhmEO9iulT22BeAMGxzc2DhokA9+0aMQ1ApPaKmO7Wa1nBUk1yRw+iutlHW0yA/1CgnaJz5VjhOLSB46S+Jbp+Sc6rb7yWNi/Y9LtH4jWCVGjBepst4sNa9a3PklOa4hFZCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609219; c=relaxed/simple;
	bh=RSEgZllS8Kc7t1XKjvSwgZULRMe44/zp2kQfyXHDxoY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bg8HB18jIVLRoMIcT2Otf3ItZUg//MFzfRPymIHWEgwessUq5xOTkLR1xFUJg7wnmpf3dqgCka3dW0QKsadKHdGpZ5Yu503eOy8NjHQdox/ishUsA0v1GGCmyZQ2urgDHqmJyhhCqHeOuLNEd+61qC3zR9Ieih9xAZKHv+C8DZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oN+pLkFA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oN+pLkFA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B99C4CEC5;
	Fri, 11 Oct 2024 01:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609219;
	bh=RSEgZllS8Kc7t1XKjvSwgZULRMe44/zp2kQfyXHDxoY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oN+pLkFADkH3M5zoK1PZYTVOXhmlAxQrAUo6C+n/yEpnZAs00e1ZEpVD7RC71JJ1N
	 JiKOFkP6LlMMyE763VCfvRIVbyTu4sdMidxXnQjffWd0RubY3ppNT6k9/Jn4WCRUzT
	 VwAFGX+usqGRmh4LKvYfFOEBZ3iNZ4WWM4xo00t5MmU+EBhCmf/vJ8l0VeNdTgcwUQ
	 RLgnyxhd05+yuOdIYkoAAeuiQgq/sL/OAIXsbBA5kJS5UgZX+XKvLlzDLXIF3D/u0p
	 osMyCkV2L5Mknk1EpJ4wAIeOp97y+kDf7e1I4px3lgKFt6/qhx/dEfplI8pxzteeVq
	 CjYg4fOH/6Hlw==
Date: Thu, 10 Oct 2024 18:13:39 -0700
Subject: [PATCH 6/6] xfs: enable realtime quota again
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860645780.4180109.10859688721403091860.stgit@frogsfrogsfrogs>
In-Reply-To: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
References: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
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

Enable quotas for the realtime device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c      |   10 +++++++---
 fs/xfs/xfs_rtalloc.c |    4 +++-
 2 files changed, 10 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 90d45aae5cb891..e18784804fcb03 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1663,14 +1663,18 @@ xfs_qm_mount_quotas(
 	uint			sbf;
 
 	/*
-	 * If quotas on realtime volumes is not supported, we disable
-	 * quotas immediately.
+	 * If quotas on realtime volumes is not supported, disable quotas
+	 * immediately.  We only support rtquota if rtgroups are enabled to
+	 * avoid problems with older kernels.
 	 */
-	if (mp->m_sb.sb_rextents) {
+	if (mp->m_sb.sb_rextents && !xfs_has_rtgroups(mp)) {
 		xfs_notice(mp, "Cannot turn on quotas for realtime filesystem");
 		mp->m_qflags = 0;
 		goto write_changes;
 	}
+	if (mp->m_sb.sb_rextents)
+		xfs_warn(mp,
+ "EXPERIMENTAL realtime quota feature in use. Use at your own risk!");
 
 	ASSERT(XFS_IS_QUOTA_ON(mp));
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 0575b9553f40a9..7b98597c801f99 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1265,7 +1265,9 @@ xfs_growfs_rt(
 
 	/* Unsupported realtime features. */
 	error = -EOPNOTSUPP;
-	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp) || xfs_has_quota(mp))
+	if (xfs_has_quota(mp) && !xfs_has_rtgroups(mp))
+		goto out_unlock;
+	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp))
 		goto out_unlock;
 
 	error = xfs_sb_validate_fsb_count(&mp->m_sb, in->newblocks);

