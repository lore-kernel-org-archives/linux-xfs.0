Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC48A21B45F
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192298; cv=none; b=LHLtExrqXFRIeaExS4+P1QxEwQfIYDWI3dz5E9jUQL7gAnBdalW3jOWvDfwFKWCURII/tjQ/rffrGUtIYvx7pT6HiRkEuDT3mR1R6ub8m4Qv0om2L5kowdmFJ1ZxfUYJ9aU64kyerR2YVzpm+AHV09F7bNfe+PBO2KoDgKPT774=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192298; c=relaxed/simple;
	bh=UMdToS5oT8aELM+6cb9lj5eIzs+DwrmvIY32iezD7CU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T5OgjHxN1P1f58012xtHv2ULTfuyjBLJA0FDiPRWaOhr/Qwsso/bYgT5sgt1O2/GRTvfxTUD5ZQ31wGTShKhNKlVMAYQR7i++8GFNxq8IT1onr4rWUGPFfnkL06VOvzfViOUXHLo3I69EysfQ4gzJZ+NNPzUzis+MoZgOS5VEXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rwKHog+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rwKHog+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7816AC4CEC3;
	Thu, 17 Oct 2024 19:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192298;
	bh=UMdToS5oT8aELM+6cb9lj5eIzs+DwrmvIY32iezD7CU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rwKHog+PCDJAjy81dGsosgRbX7veweFOyh2jTKlvWrXrBRVl95vBigUYqOySEtXnk
	 A+sylPNkR+uyNZLqHPI8yYhIEgzj+6wHUCyYS8cIcXSy8dV9VNytHAHB+XmlgO2WxB
	 HmFzH9mOu6fbZDFOQfQhZ542w5oeB0eGjtTa5uC4MAuO97L40utU5UAPoULLC8ByPm
	 nJMBWs2JsbwwRFFNQv4J8tO9KBxnbNLMsjwoLNFK+361Gs/D29tO1wFGHHV2/swFto
	 ykaXmwzcJ1ins8eQ9FW+X/X+N9jcBd/1Lxz2+1JV4t24FicYDvoQx+URxqjDV9gITt
	 4oMi1nS9P+pIQ==
Date: Thu, 17 Oct 2024 12:11:38 -0700
Subject: [PATCH 6/6] xfs: enable realtime quota again
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919073181.3456016.10141558876859300958.stgit@frogsfrogsfrogs>
In-Reply-To: <172919073062.3456016.13160926749424883839.stgit@frogsfrogsfrogs>
References: <172919073062.3456016.13160926749424883839.stgit@frogsfrogsfrogs>
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
index 8a8210d45f4f03..845c1264456f77 100644
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

