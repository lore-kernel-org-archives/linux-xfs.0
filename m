Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793C01E0DE9
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548312; cv=none; b=si9Wzx7CBqk45jkmM1P9AuSv4ByeHDHWTAmmnoRboCt2l49QK9d0eU+7OHP4bK6BClTNgEf/O2dcLToyt6TXtNNcUVEzI8wjyNXSL8sdH7P+0Ctdg0Y/8e0033uVcagO6McKb5/PjmUcSGkdlEy7Gk3Qmk+c987fGDk0CkF+P60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548312; c=relaxed/simple;
	bh=17HU7dAC0sPq6dTovl+2c7ds9+4XBTYKqbTpAuKBSuI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Evs7gWwnm2oS54Evxf95FSLp+DujDQqfyWQr8B9rHTAndwl3O9ICGgPF//Ky2fY/DXKe1Y7MGlSlgFeoPyb7+CL+u996i7gnYh190FDyYRGdrci/TZHWVAzf7peWixh/PiX1FMlwutIh565POzBT7Z8fa2wpNoaOvVqU+UXLXK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OIn+qiIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OIn+qiIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54B9C4CEC3;
	Mon, 21 Oct 2024 22:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548312;
	bh=17HU7dAC0sPq6dTovl+2c7ds9+4XBTYKqbTpAuKBSuI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OIn+qiIs4C2pVsjlH9UImpT/7g4LLIFexUV993aZloC3mMyxS6dz7xV324MyWr5o1
	 OO9AKvF96sjJGiJa7+O8jbo+pcL3e6ni6zoKDFhFsFpnMFD4ns978vHNroFKqw/RQk
	 PXKjHx0y9UeMemdE4sVhdsjvoNSgdcZeEoepTJK/QfOWdinAedd13NC0yrnaaEdCuS
	 Uul9Vc+ZpoxjsbUWRrxsXzdiHELqbzUxciCHW00PLf9wmOjyTJPGI+ZtnerX8U1o+Z
	 LBbzNJ288okFOKE83VlXWknATG/LR2xOd2JTkZ2anpFEoeGP4/wHFikt3KeWmJ/7sK
	 iO/TslCIF0v4g==
Date: Mon, 21 Oct 2024 15:05:11 -0700
Subject: [PATCH 24/37] xfs: remove unnecessary check
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783834.34558.7499025596498842496.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dan Carpenter <dan.carpenter@linaro.org>

Source kernel commit: fb8b941c75bd70ddfb0a8a3bb9bb770ed1d648f8

We checked that "pip" is non-NULL at the start of the if else statement
so there is no need to check again here.  Delete the check.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_inode_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 74d2b5960bf0f2..92bfdf0715f02e 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -305,7 +305,7 @@ xfs_inode_init(
 		    !vfsgid_in_group_p(i_gid_into_vfsgid(args->idmap, inode)))
 			inode->i_mode &= ~S_ISGID;
 
-		ip->i_projid = pip ? xfs_get_initial_prid(pip) : 0;
+		ip->i_projid = xfs_get_initial_prid(pip);
 	}
 
 	ip->i_disk_size = 0;

