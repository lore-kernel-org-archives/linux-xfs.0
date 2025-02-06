Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29AF23AE90
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882154; cv=none; b=r9BqX3XU10oSwMiCTPMJfXtTZNo1CvngfptjNr3//Zx2s895Fwd/SdOTms8NKg34VEzgUTA5POetn3rSmLroVbLloRLAG+G+/SaElhM84+Ga1RLvUXUxOuQjNhbTdpnbfyrEpb85KDHnT7QFmOVo74UIXluOj7iPN42GPdXi9KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882154; c=relaxed/simple;
	bh=PA7tOg/RHQO4svBcFa2YhefHC3fbKNGND21vlhj1ZnM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CErRWkjYPQ2MxzPmap5K/2TBJBet7M2vXPku0xTdR2uUlAG90zBt8CkNt0qI5Z2Y8OsfZLZneNxChOhIcQ/gJ2vIgjVvhCdWdUYPI/AfwPC3Hpgtj5f8hCMVwxOWdtjaXBFIqepUlmfXKYCS25bUj1kKmodTv8GXtWWMGY6e6Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DP6vGJh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DP6vGJh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55316C4CEDD;
	Thu,  6 Feb 2025 22:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882153;
	bh=PA7tOg/RHQO4svBcFa2YhefHC3fbKNGND21vlhj1ZnM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DP6vGJh5+ebjI/u0U7fAuzFA31USn3PbkEwD6CLn9nJOBdEFsqWnu8PmDk3db5tYH
	 EVboB2xrxirgt0WOuToQ+IguVAEqfrurN9qGLrZdONucHU2g6JgINdU64LQ0kXGDQO
	 /TFPab+yNqZOaro3bqeqdOi7PqL2/mqpVHU6swMeNNPSS3Nrm/OSUYBpW6xX6U1F66
	 IevyEZpF044Pdfo5K8cG1i2Q2F8JxzMv1/GwjTi4M0kLQCp8v1QFdyrrq49FHeJThq
	 dtWaAz07YfbpOogBN+sI4hpdOanrhCjYHwBmIzbJmBPqxH0a7JpKcidC3e5bm9nBD/
	 hWemOy3naClpg==
Date: Thu, 06 Feb 2025 14:49:12 -0800
Subject: [PATCH 54/56] xfs: remove XFS_ILOG_NONCORE
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087620.2739176.15928074738306981453.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 415dee1e06da431f3d314641ceecb9018bb6fa53

XFS_ILOG_NONCORE is not used in the kernel code or xfsprogs, remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_log_format.h |    6 ------
 1 file changed, 6 deletions(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index ec7157eaba5f68..a472ac2e45d0d8 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -359,12 +359,6 @@ struct xfs_inode_log_format_32 {
  */
 #define XFS_ILOG_IVERSION	0x8000
 
-#define	XFS_ILOG_NONCORE	(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
-				 XFS_ILOG_DBROOT | XFS_ILOG_DEV | \
-				 XFS_ILOG_ADATA | XFS_ILOG_AEXT | \
-				 XFS_ILOG_ABROOT | XFS_ILOG_DOWNER | \
-				 XFS_ILOG_AOWNER)
-
 #define	XFS_ILOG_DFORK		(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
 				 XFS_ILOG_DBROOT)
 

