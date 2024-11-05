Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AAC18E023
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846044; cv=none; b=Eirru9OHsU94ExHKadAVo8sdQTRc2VxT6gTfm1DAiwuzp8F0EBLKdpv7ifT93o9aVN7f/iI0AT9kNxh/1sJO/X2az2lXPaoKhR8xFT6MMiTUaBqjwuuI0VEeBz7JbX0+ebiduxXm/pEl3IE9TyL/CerydcJnxA930fFevOaU8iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846044; c=relaxed/simple;
	bh=Za3v3pLFNPzikohDMoRNxTbEbPa1EDoBZ9x8YuG9t+0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u8zWesTpQE3PrbznBR87fVRfF4jo+y8pcmzae59+BBVLTGr8codeT2xGrfUGvq63jDCfQY79ShfLL0Zxg35nt9sBckieo+2rytIxUiiBOPZby2f3HTsTywvpfrAcwlwPWr0mINt9NJlXumCG6i6qsVm5MglZC7WR6/oRMfVHNmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VL4+QEeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VL4+QEeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C93C4CECF;
	Tue,  5 Nov 2024 22:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846044;
	bh=Za3v3pLFNPzikohDMoRNxTbEbPa1EDoBZ9x8YuG9t+0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VL4+QEeE9DRxYDvPwTiYTq19Gko5mFaL4Q3+JY3DhTFVPFAMSAIYc9OzA7jEw8sjR
	 J9eluHqNREfJ7N9f11zzK6KY1lO2LgKySNblprdeHLAlLam4Ub/tiixnCye5h5xrcN
	 wf19F5VTEbSqRbmZx6XIlF99co4j4SkvbZp2O8l8I0G2ctea0X01UueaGPfv1t7hbQ
	 QAhpVauRBOlR1nksblIaMF94FFJl6EmP+SxUHgYO2hslsLS2ipFIEg1nOtTatK5j9j
	 eadJnDEKrOYZNwgRyt3Mb+39BzOK/NCRlFgo89+9Z/r6An46FGUDuhJgO/97PhjsOb
	 ByXcNXes/60HQ==
Date: Tue, 05 Nov 2024 14:34:04 -0800
Subject: [PATCH 16/34] xfs: force swapext to a realtime file to use the file
 content exchange ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398457.1871887.15566338923238425406.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

xfs_swap_extent_rmap does not use log items to track the overall
progress of an attempt to swap the extent mappings between two files.
If the system crashes in the middle of swapping a partially written
realtime extent, the mapping will be left in an inconsistent state
wherein a file can point to multiple extents on the rt volume.

The new file range exchange functionality handles this correctly, so all
callers must upgrade to that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 1ac0b0facb7fd3..bc53f5c7357c7a 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1532,6 +1532,18 @@ xfs_swap_extents(
 		goto out_unlock;
 	}
 
+	/*
+	 * The rmapbt implementation is unable to resume a swapext operation
+	 * after a crash if the allocation unit size is larger than a block.
+	 * This (deprecated) interface will not be upgraded to handle this
+	 * situation.  Defragmentation must be performed with the commit range
+	 * ioctl.
+	 */
+	if (XFS_IS_REALTIME_INODE(ip) && xfs_has_rtgroups(ip->i_mount)) {
+		error = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	error = xfs_qm_dqattach(ip);
 	if (error)
 		goto out_unlock;

