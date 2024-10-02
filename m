Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D16D6FB0
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831474; cv=none; b=HkgbX83cecqKQHzMAkccjN0E28FkESCN/DTdz/C5xA5D4z+dCUBr8SKjcW1nVaNm9KObZVFYCBudrSCKUnunx7a47JYJqvf9F3JMOAckYi6KuTGiaW2mkbhqxzm88ik1t0ZgOXkxD6Cx4NBGQysTF9yqB4P8kPXWjn+XpIrjLio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831474; c=relaxed/simple;
	bh=7Rtv2aOlmsM+Xkx391mVSbmJMa/z2v+V7GayPgjZlNI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZrYz9q5VjUnnyaANNxUfnCTVbzaOQaBTFUqoPkXjINJDcIE10r4S3nCF6ZYcPsD90kiZU948tpD0tsR7ShlRnfaJN7rVXYRgxJBN/k8pGMZ7J1UVtuYVXyLYwoXNawF1SGaMdMLBqyxsGbdpo6W5Hu7zpETc8vLe4aqbKea0E9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fZ4N/FRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fZ4N/FRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A465C4CEC6;
	Wed,  2 Oct 2024 01:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831474;
	bh=7Rtv2aOlmsM+Xkx391mVSbmJMa/z2v+V7GayPgjZlNI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fZ4N/FRCo3fu+RidkEBanYbwOQpilEJh4x+9/5n/eYfMYItYIQGFmZZHYmi9mxjMx
	 w1E544KQ6T2uhdZ6Q1fwWlGx6Bc97o4p5h3oF5RNODGt2fT/+xyjP2Ei2pjZ0WcrIC
	 5PTJJm2CRiS++2NLAwrg2MnkfiGZl+laseGN0PzA5WMiaWROaQyU4EZ7VEgHBhluoc
	 TUixWuZtygJ7JxvagePaYKaINN73+J3SbDAD+llgm1qI05oY4u1FhfTsB6sV9jQYMV
	 qZ3cR8F7fepU6AfP82MgIUz65IEr7zw3aWQONexaPYss8POb2EZ7kGsGXEE3mMJQoI
	 HuHFFMtxf5GBQ==
Date: Tue, 01 Oct 2024 18:11:13 -0700
Subject: [PATCH 13/64] libxfs: set access time when creating files
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783101977.4036371.15734675602815750733.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Set the access time on files that we're creating, to match the behavior
of the kernel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index b302bbbfd..132cf990d 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -94,7 +94,8 @@ libxfs_icreate(
 	struct inode		*inode;
 	struct xfs_inode	*ip;
 	unsigned int		flags;
-	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG |
+					XFS_ICHGTIME_ACCESS;
 	int			error;
 
 	error = libxfs_iget(mp, tp, ino, XFS_IGET_CREATE, &ip);

