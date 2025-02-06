Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED8323AE70
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882107; cv=none; b=l0h0/jdqwqEz+lKzTyh+uSeomYW1V2NEwBXDdABLQNSsQBA79tlW2QkxW2eK8aE/tmiGxLy/NJewrpRGzYlXNoHfQE5K2TBKBKtYv1acABPy7llp7bXLtvIbNaNdUb7tPMZzvnnWwGBeBxh4Kw94/HqXzc6ltjazaeaYxeuAlA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882107; c=relaxed/simple;
	bh=dZ3w/zAaKoj97J0qQJMoi7eIh4ue9hy/tytvX3RFdtI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LEjkIocIgjuzCv7wTqVpiBpMMlNLf3e94UWF3llY0EjOmlG/ZoiaHQwvIDPzXpzJw3s1kGTVoD4fapfyxwuzv1YTprwWwIUn3BsVTLN1Yr6l4c+7Y0nO29l5oOcQv0bUaaHIb1KbmDuHTMkzlQLNUwa3IWyrxPqK5NrrCengWc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n1fNdgfU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n1fNdgfU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36013C4CEEB;
	Thu,  6 Feb 2025 22:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882106;
	bh=dZ3w/zAaKoj97J0qQJMoi7eIh4ue9hy/tytvX3RFdtI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n1fNdgfUYWcHGyql6fEu1GvnBNboFSx/42vzEFgvHVqGW02F3Kn9BcpDuceTqHq/L
	 9v0aw13GjG7MpDqmAe/fVjWF5Do4QT0xHj0xoQPhcvH4fZ3kqlIs7P2V2eHuutYdJ5
	 3ASLvJ/VwW3/Rp9aTcP6AW+uP0SDtfssUxrpmNtLzafFovCuYFC92U9wfny6fBlG6E
	 xiXd5ZXWkgQqDu3cPmm6O4k9lyoAqNnQvOHP18CZK/CAbE7Dy+ZdAEbUgZnHDzAl8F
	 CG2QFGoRe6rh7/8mlWS/xqmBLy29lOe6KzsGUvCT3jaYztqXfEGUY4HAn/se+2OaSQ
	 djixqP9Xe1tsA==
Date: Thu, 06 Feb 2025 14:48:25 -0800
Subject: [PATCH 51/56] xfs: scrub the metadir path of rt refcount btree files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087574.2739176.1403943867809149942.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: ca757af07fccf527f91ad49f3b6648e6783b0bc8

Add a new XFS_SCRUB_METAPATH subtype so that we can scrub the metadata
directory tree path to the refcount btree file for each rt group.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index a4bd6a39c6ba71..2c3171262b445b 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -832,9 +832,10 @@ struct xfs_scrub_vec_head {
 #define XFS_SCRUB_METAPATH_GRPQUOTA	(6)  /* group quota */
 #define XFS_SCRUB_METAPATH_PRJQUOTA	(7)  /* project quota */
 #define XFS_SCRUB_METAPATH_RTRMAPBT	(8)  /* realtime reverse mapping */
+#define XFS_SCRUB_METAPATH_RTREFCOUNTBT	(9)  /* realtime refcount */
 
 /* Number of metapath sm_ino values */
-#define XFS_SCRUB_METAPATH_NR		(9)
+#define XFS_SCRUB_METAPATH_NR		(10)
 
 /*
  * ioctl limits

