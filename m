Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0EDBA39
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710296190; cv=none; b=fjmU5XVCLaI8+vLmCW7ZmGeBKAYNniYyjsHSvt6lnbullZMOc37ap8Vk4RimpGGdL8nEqBRwM2l7tpGIMd3aawjZ1/1bnlWFVYfaDHN2DTLlRQCGE1EYmbSx5TepSAiT+/NyNW1gXSe0wLnd5lOsVdPZ+N+8M/zPL/q3U876a1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710296190; c=relaxed/simple;
	bh=cZSQZHTmg5gCKF1rmcvSgu+zjTn48l2ja2nWMx8zWlU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cqRpmgCh9/ltdN/0mzXHchuvppBUC16H4P4GTmQ0OZ1+PUrZCH2URrg2qcwLdPMukY7jh28AGvBLe3RoEPPf1k5RXf4S+pSlAl6u+VrskKHTV7y39z9sJt6evHWL46PLlDDwtNJGEv4KfPhLMaWmypudw9gBzuK+KxFY1qQNDXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cOamjq6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cOamjq6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226C3C433F1;
	Wed, 13 Mar 2024 02:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710296190;
	bh=cZSQZHTmg5gCKF1rmcvSgu+zjTn48l2ja2nWMx8zWlU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cOamjq6f9Yq/aHQIXaJmrOnrTWrE1++Om9ZrUrOPK1xcIJRVCn+RbdQS1k+PE3m6D
	 cKZlrPNNxEc+k2+SW0RqDDGT9ybCbuHcQaYIWzhYtMwQ3YbnKgLhknlwfAbqMCXq/4
	 64QXRy0x8EKAjAMes17LkxJ8RBWdrhSNsBFyzRHpp2CxjygCGzqwdab6EZvqQAmWF0
	 k+VZXpJKmDoWKgpitA7hbh2RnYfluuXQToJ8k5/lNBBkJLeIW2iKxC3i+miKxKobjA
	 wmvkQj34fCPvwHZzN9LbUePARkHh6NCMydY1vGpy/Bm/ePLrb6GO00PtX3ThSyCrti
	 JbiLuItiU4qmw==
Date: Tue, 12 Mar 2024 19:16:29 -0700
Subject: [PATCH 7/8] xfs_repair: don't create block maps for data files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029434829.2065824.5706231368777334384.stgit@frogsfrogsfrogs>
In-Reply-To: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
References: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
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

Repair only queries inode block maps for inode forks that map filesystem
metadata.  IOWs, it only uses it for directories, quota files, symlinks,
and extended attributes.  It doesn't use it for regular files or
realtime files, so exclude its use for these files to reduce processing
times for heavily fragmented regular files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index bf93a5790877..9938bad1570b 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1930,8 +1930,8 @@ process_inode_data_fork(
 	if (*nextents > be64_to_cpu(dino->di_nblocks))
 		*nextents = 1;
 
-
-	if (dino->di_format != XFS_DINODE_FMT_LOCAL && type != XR_INO_RTDATA)
+	if (dino->di_format != XFS_DINODE_FMT_LOCAL &&
+	    (type != XR_INO_RTDATA && type != XR_INO_DATA))
 		*dblkmap = blkmap_alloc(*nextents, XFS_DATA_FORK);
 	*nextents = 0;
 

