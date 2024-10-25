Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C2E1CF96
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838010; cv=none; b=W/VnJ3cbKmCbKAPuCtxjvpsmX8IRLOnIzQdww24dx/yRLLRTIx8pLfOlqkXLwUz4ik9aWoGB/jKTFfqUaz6GJU0RGFepJM0+NRPSfIcFqmKwfy+dnvpOjtXHLLWCCKfGNuw2BverLuHrzxz2GHsdi+6OV7EdHy6UDV5HjNaEBmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838010; c=relaxed/simple;
	bh=KWJkctQUa0j6Xx07tu6NhDAg+q+dMKXu7XWIh1DO1io=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J4aRaKdAD8Y0NGQLgEyvf6DHwpSy4MZhT0CvhoDKvmG26Z50VGrJWar9RzvA27wsOKHofAx8ifXvz4ctzRsDCMtIanhf1Sdd9zrX4f+E/NoYftTe67QWemol/GhxgVCZikAuUlCpu84fiotXFZU7jTkquIEncyte4nZ7y6MHFjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p0zeh77J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p0zeh77J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56194C4CEC3;
	Fri, 25 Oct 2024 06:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729838010;
	bh=KWJkctQUa0j6Xx07tu6NhDAg+q+dMKXu7XWIh1DO1io=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p0zeh77JJ/Gq6ga0X33YsVqfyd5XMtrtfc2XJg5g7FEQsNBkiuKjUROpZkhLobIDH
	 BCJNA26U7H6Cu8aNlL7XTjz2KdRgggQsORtAJ/RUUiRmKbL/lsdeZG2mf2M7mgzcBd
	 mAr//z6fgVv7+EIOJscFFRK5u05TRNgr9oIyPfofSUisSqVg7bn4YJ4ybxID/hnu59
	 e/15JRKLyes5BpGPE7pClCZdYa3+PQ3NVMHSgNXNMuPurvIQlKJYafTUcQ2qPJMRXG
	 Dqaoh9tvbfoxpF0tdk6pijbNSphTESEthpUm7aJy/BiX2S/5VG4POF7asuzEzdR1J1
	 TA17likkdnpyw==
Date: Thu, 24 Oct 2024 23:33:29 -0700
Subject: [PATCH 4/7] libxfs: validate inumber in xfs_iget
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983773390.3040944.4686468112875777629.stgit@frogsfrogsfrogs>
In-Reply-To: <172983773323.3040944.5615240418900510348.stgit@frogsfrogsfrogs>
References: <172983773323.3040944.5615240418900510348.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Actually use the inumber validator to check the argument passed in here,
just like we now do in the kernel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index 2062ecf54486cf..9230ad24a5cb6c 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -143,7 +143,7 @@ libxfs_iget(
 	int			error = 0;
 
 	/* reject inode numbers outside existing AGs */
-	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
+	if (!xfs_verify_ino(mp, ino))
 		return -EINVAL;
 
 	ip = kmem_cache_zalloc(xfs_inode_cache, 0);

