Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE371F93E
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504605; cv=none; b=bktJLWx2j5ChrrhdIRcnfnHHKoG5XywfxAk4C5EhWQFuCOA/1YvzcHY6n4hRPed4W3KCoaF8m9BXtKk7bz/81rSpcwzZPireS/S+zj+I2VYwSnWswCibKZdkh/sxinYbA1FJhjuj0ruWTSUXb73GrE8y0hN49WPYhl/eevn62W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504605; c=relaxed/simple;
	bh=XF0+li0F9HMsX2i2D7o4wMkgoesOL6yjPc2F5Ji3HAA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pIQXdiwojoEYceWYtNWKaHkLo2+8AXtPB59YvyLLDo4p23mB5oB9KIEqZ6kQqT6RVE/EvpNrybQTbky2PMgbNhLUb29N0dtK/hbUkykW9DLUiRrPtCOq2dwfxOoB18eGa/0yp67EoU/blHxP+z68AifYv1T+Zm3ngIL56S69IRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dnz5CU9Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dnz5CU9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69586C433C7;
	Wed, 27 Mar 2024 01:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504605;
	bh=XF0+li0F9HMsX2i2D7o4wMkgoesOL6yjPc2F5Ji3HAA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Dnz5CU9ZBW1Oieuy9AQFssda2WS0ykGDEK8iGu5EZqvQIJ2bzWKaaM1KRH3G3KwMZ
	 tla8wBc5r48WrTMCNZ3g6sEovqBPTKM2QMrCtoJiyn2u4swTTH+jNwhv3jiW3yzeAe
	 5QzV2ksb6/0CKxdwJnRFotO02QrCkGQzARX+daJS3dhqvOWgWDhdIPszQz3es1efxF
	 f4xzI9SwM24CpZDItYB0q9E0pVWRShgKdyEe1MZvCqeyCuu3JcIUEl5mFxXhz8q2Va
	 TPAYRahS1nBmODe15/a6YZFHwT88r0NPvIhmBQDd2L9TUVMoOqIaEq473ylHsjpTVZ
	 lKKdAcHxE+P7A==
Date: Tue, 26 Mar 2024 18:56:44 -0700
Subject: [PATCH 15/15] xfs: enable logged file mapping exchange feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150380915.3216674.10597980562141537325.stgit@frogsfrogsfrogs>
In-Reply-To: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
References: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
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

Add the XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS feature to the set of features
that we will permit when mounting a filesystem.  This turns on support
for the file range exchange feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 753adde56a2d0..aa2ad7e04202b 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -398,7 +398,8 @@ xfs_sb_has_incompat_feature(
  */
 #define XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS (1 << 1)
 #define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
-	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
+		(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS | \
+		 XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS)
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
 static inline bool
 xfs_sb_has_incompat_log_feature(

