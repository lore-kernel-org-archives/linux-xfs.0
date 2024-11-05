Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44A920D51E
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846481; cv=none; b=qhcAPMEHDh+IUVB9D57s/ITudjl1/il+OjgftmjQsRGRJfE2TxMI8Jwrol6Pb4C7r7+nEymW8LLwm8mofBDL9k4yI4c4npDAoG0gznpmu58YwEQvOmmZluT8S6fGGuIMYuYGF3o5AxlEd5CiIdgtwU7hGLWZ9Q3X01g6T7Hg1eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846481; c=relaxed/simple;
	bh=Y75ctLb6UH431sT2pn2oip6YtVvXhcwrRAD7PhAI1fU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q6TY2+WBj9OfmaTT1B8crUjPcalOVfrtJ3kYVMUmpauPC/KPlp8rgldoarPruO5JS8dMiecpWQw83PeJ/iTSylBbAlFswHA91mALzjjtzPBIP9Giwq9j2W234X540OLAT2D4FhFY3s4Adk/TLXTWrTVaBahotE4hLAfwM6Wh5l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TTF/lCmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TTF/lCmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF0BC4CECF;
	Tue,  5 Nov 2024 22:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846481;
	bh=Y75ctLb6UH431sT2pn2oip6YtVvXhcwrRAD7PhAI1fU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TTF/lCmWFF/L4BGRNrKkOCBVbkOm3Rpw2zWqKofUL13oBTegkpUZ3NUZee6hF8VQt
	 2YD4HyPeci+N5AQ9s4gWbkd8A/P7XVsHNRPHhxAvb8/OE+0gDh94+aPFQqI2ckZfxb
	 O6FOXbqjSlKSA47f+nAMJm3Ybj99R5ujeeSoXZ1I2ysgZEmZzAXT3dHEcvcMIt2ATh
	 2pqLpD3i4ev6DuzBHaNo61yJAF9nVrbfiV3aovhVGvd0+eQegUe4s48ZzZH9rw1gIE
	 cKDtLViytL+jOL/K8RG1ZBVXHGyhqUrukB3+uIhZWzpiER2Hx64C6afjuMHFTxcmB2
	 4d394AJstxLgA==
Date: Tue, 05 Nov 2024 14:41:21 -0800
Subject: [PATCH 6/6] xfs: enable realtime quota again
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084399664.1873230.9165782253353224379.stgit@frogsfrogsfrogs>
In-Reply-To: <173084399548.1873230.14221538780736772304.stgit@frogsfrogsfrogs>
References: <173084399548.1873230.14221538780736772304.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.c      |    7 ++++---
 fs/xfs/xfs_rtalloc.c |    4 +++-
 2 files changed, 7 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 90d45aae5cb891..b928b036990bc3 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1663,10 +1663,11 @@ xfs_qm_mount_quotas(
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
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 7ecea7623a151a..0cb534d71119a5 100644
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

