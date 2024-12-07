Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1732A28DD0
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529802; cv=none; b=P1bTl+D0qSE/yirDszBTLvCZTnF8evsU2MwvzIJ2XNC73sGf8FYfgFZk+p7lJbMBz1YFvREYNZEn+d73jPOQFjXpalwYX4gKDPRPkRE1ykNVL83Dxi6DtSN5xKOiI3XQbtiUhLVMQOhaysiSsJGK/aKWf9T0Mi+FChkzpNDU9l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529802; c=relaxed/simple;
	bh=Al1C3n9eUFPpXmKLwAWud2MM7kC5kQ0AD6XqINV8d4k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fNrVaw1SXbaetkvl0sMtY8Ih9REEHgMELbwCp+nXxtA/Ia0HrIhoPsuzM+gZIulpk8k/dFSM+tF9Rb7k9+wb2oleaEecezm+HrX8J7Amm/r295aCTtBii7adBnSqFRlvrkXAG9CbmKeqrLL3o9SDkJfWvXTZ+4asebNCvCu8wLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y1g4hT4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y1g4hT4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3841C4CED1;
	Sat,  7 Dec 2024 00:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529802;
	bh=Al1C3n9eUFPpXmKLwAWud2MM7kC5kQ0AD6XqINV8d4k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y1g4hT4deWmSLOqmOWasPUa1rTUW4rWzfgpNOI9M0QNVrfSAQJcIrPVrHkQZEEUFi
	 4oF99cYhL9s6Z0z2BfDyvXKq7t2vB2sC43QONYUqEQdMN5hLIMENhQDppWxleaXLLQ
	 zVx721pRQPAe1GNKJIh/+WqsOetjs6Eh5kCef+xX0F1prCkwOKVDSTJlX397A/hQWN
	 dPYfnpGCghGH4WPYC5AywuKF9/XhDF4jACTCKBxFT9ptp1R4TWqGcMCSdId1Caea/9
	 WYbcyz5jv1xvLwzXF14FVhXyvbo6g4HMZo+eLY23tlBE0zKOiwy/el0kFEXsF+ZzTS
	 TiwoFMhWUhOoQ==
Date: Fri, 06 Dec 2024 16:03:21 -0800
Subject: [PATCH 46/46] xfs: switch to multigrain timestamps
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: josef@toxicpanda.com, rdunlap@infradead.org, jlayton@kernel.org,
 brauner@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750698.124560.10567756358629530953.stgit@frogsfrogsfrogs>
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

From: Jeff Layton <jlayton@kernel.org>

Source kernel commit: 1cf7e834a6fb84de9d1e038d6cf4c5bd0d202ffa

Enable multigrain timestamps, which should ensure that there is an
apparent change to the timestamp whenever it has been written after
being actively observed via getattr.

Also, anytime the mtime changes, the ctime must also change, and those
are now the only two options for xfs_trans_ichgtime. Have that function
unconditionally bump the ctime, and ASSERT that XFS_ICHGTIME_CHG is
always set.

Finally, stop setting STATX_CHANGE_COOKIE in getattr, since the ctime
should give us better semantics now.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org> # documentation bits
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20241002-mgtime-v10-9-d1c4717f5284@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 libxfs/xfs_trans_inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index 45b513bc5ceb40..90eec4d3592dea 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -59,12 +59,12 @@ xfs_trans_ichgtime(
 	ASSERT(tp);
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 
-	tv = current_time(inode);
+	/* If the mtime changes, then ctime must also change */
+	ASSERT(flags & XFS_ICHGTIME_CHG);
 
+	tv = inode_set_ctime_current(inode);
 	if (flags & XFS_ICHGTIME_MOD)
 		inode_set_mtime_to_ts(inode, tv);
-	if (flags & XFS_ICHGTIME_CHG)
-		inode_set_ctime_to_ts(inode, tv);
 	if (flags & XFS_ICHGTIME_ACCESS)
 		inode_set_atime_to_ts(inode, tv);
 	if (flags & XFS_ICHGTIME_CREATE)

