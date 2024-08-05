Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916501D540
	for <linux-xfs@vger.kernel.org>; Mon,  5 Aug 2024 18:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722883606; cv=none; b=OK4h0MQeDCv86J3+Eyv0hSr/8WFsByRIffmG1cjxOJ1dKyzW96KuJKjYrJvVr6GRiec8/A6QttsKnikYI877sbAc07KCDRKvXvlLVEseZTbD/EeRt9FijnSHluQk+ss2DU/sFbXqW2grE2cPNypHmN7ybwBx3jxrv0biUj7R1f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722883606; c=relaxed/simple;
	bh=FVHLKuOOECjxnkB8B0ixqd2Tvc768BUqG49bWyW/wcY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QcfsZdcS1q/NNpIP+nJr4eE56oFdC+zLts/L5mtCBgjtXk5CtUzLIzG6bAh6ufVRyAnC6royzYrS+NTtK6hZyDLuOE9E8nFqa/fbjJsAiil3ErEncgBWd4t/0m28xl18oeT2NBVnnp/mFFMCitIPnFpHjIlwzm8auPrWkoLNWNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JLw6DEu2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JLw6DEu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C14C32782;
	Mon,  5 Aug 2024 18:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722883606;
	bh=FVHLKuOOECjxnkB8B0ixqd2Tvc768BUqG49bWyW/wcY=;
	h=Date:From:To:Cc:Subject:From;
	b=JLw6DEu21HW1t5rw38qzy6jV1rddRz6Uqc1jZEukRijOypWp17P7ATQbVw2TgnZFq
	 Ekl7PU3MRb6OhpXx431wSpaEmJkCayymbJH/dfbX4d4aU7Kq0qDZYuitJQ3lR02T/J
	 K3+bhd86qKTTkkPKu8cyGMGYTLKLFw3NdOkn/pZ/Qw6k4m+GrdAWODP58f2mOvQ7Ea
	 ZsbQUsHnGRmI73CYae7EFqJbOhnMvEMzujsXxuWJXgohUx8k7fA54t1EqP6OaRxBdf
	 qEPp9Vk8LFFyfItIpoJEwFzmiZx8RF9a1KUwWntmxVUuEnCg5Q49BiWJ8luFxATzsj
	 PH61TbK1qnRpQ==
Date: Mon, 5 Aug 2024 11:46:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: conditionally allow FS_XFLAG_REALTIME changes if S_DAX
 is set
Message-ID: <20240805184645.GC623936@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

If a file has the S_DAX flag (aka fsdax access mode) set, we cannot
allow users to change the realtime flag unless the datadev and rtdev
both support fsdax access modes.  Even if there are no extents allocated
to the file, the setattr thread could be racing with another thread
that has already started down the write code paths.

Fixes: ba23cba9b3bdc ("fs: allow per-device dax status checking for filesystems")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 4e933db75b12..6b13666d4e96 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -483,6 +483,17 @@ xfs_ioctl_setattr_xflags(
 		/* Can't change realtime flag if any extents are allocated. */
 		if (ip->i_df.if_nextents || ip->i_delayed_blks)
 			return -EINVAL;
+
+		/*
+		 * If S_DAX is enabled on this file, we can only switch the
+		 * device if both support fsdax.  We can't update S_DAX because
+		 * there might be other threads walking down the access paths.
+		 */
+		if (IS_DAX(VFS_I(ip)) &&
+		    (mp->m_ddev_targp->bt_daxdev == NULL ||
+		     (mp->m_rtdev_targp &&
+		      mp->m_rtdev_targp->bt_daxdev == NULL)))
+			return -EINVAL;
 	}
 
 	if (rtflag) {
