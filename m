Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78B6376EA
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591307; cv=none; b=XHhZA78hOSIyLjC50KylKrwYltacuYMq7TWfJp+la5Hyh6a9PID+0JRsywBDgzuJC/X1NhRQRmwTybVPXyGw7dO4f4n99bI+xW6jn+GgXLNtMVgpifh8i/1fMBZyvve5YkCPmoZbkKUWsx4EpbrT/Pvh9K9TdsyPm0XXduFK9CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591307; c=relaxed/simple;
	bh=9SYpj2UBd49qqEfnubR8U/0Q1nspr8jJxh5bCNr8BSI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p0wYHMi2cQr2lvxFpIFRPwOutvtJF/lM7j/euncUXJL3pLi8s10qu0MUvjDXosiRRMsQq2KY88HKxrmeH1QDDCvTmqHdFCtPj4O+eUwgTKYWVyA9rwvKjKDgx92WgNv4le9Fh8yvXprc6z/t6/iFmBF/GOTPq2PrTKR4YWRIU9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uH5IVfok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uH5IVfok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433F6C43390;
	Tue, 30 Jan 2024 05:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591307;
	bh=9SYpj2UBd49qqEfnubR8U/0Q1nspr8jJxh5bCNr8BSI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uH5IVfoknJ25KUMl7guizk9BmZa+Y/9bTtPQswPqPO8+IxeqpyeUplifhJBfJLQrL
	 dgzo0GWQ79yabFwgaeXQmgO8dd2rxxepvtX6dcWQzjyAcOF37IZeSugAZfbF42H5sD
	 1Tac8/0HJh8vt4r/qpkFOCcsZCF/wR0y9FqNhP+hVLy7BwXWBF2NLvvbr7affWkUHV
	 aCHksoIFOjs50fS2Z0Ynb11MCK8UaSrYCRVewbSAEuG0+2922/wvbDPhfpuQznD9za
	 5X441ivxZ//s3mCxQUarz4E+3zZtwmlZJXTDU4t1tYSORDkSJUEbgxrrSnE0YvorAG
	 DsSq0UEWv5+Hg==
Date: Mon, 29 Jan 2024 21:08:26 -0800
Subject: [PATCH 1/4] xfs: report health of inode link counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659063274.3353617.17308240464450341520.stgit@frogsfrogsfrogs>
In-Reply-To: <170659063247.3353617.664642117268018311.stgit@frogsfrogsfrogs>
References: <170659063247.3353617.664642117268018311.stgit@frogsfrogsfrogs>
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

Report on the health of the inode link counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h     |    1 +
 fs/xfs/libxfs/xfs_health.h |    4 +++-
 fs/xfs/xfs_health.c        |    1 +
 3 files changed, 5 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 07acbed9235c5..f10d0aa0e337f 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -196,6 +196,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_RT_BITMAP	(1 << 4)  /* realtime bitmap */
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
 #define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
+#define XFS_FSOP_GEOM_SICK_NLINKS	(1 << 7)  /* inode link counts */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 5626e53b3f0fe..2bfe2dc404a19 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -42,6 +42,7 @@ struct xfs_fsop_geom;
 #define XFS_SICK_FS_GQUOTA	(1 << 2)  /* group quota */
 #define XFS_SICK_FS_PQUOTA	(1 << 3)  /* project quota */
 #define XFS_SICK_FS_QUOTACHECK	(1 << 4)  /* quota counts */
+#define XFS_SICK_FS_NLINKS	(1 << 5)  /* inode link counts */
 
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
@@ -79,7 +80,8 @@ struct xfs_fsop_geom;
 				 XFS_SICK_FS_UQUOTA | \
 				 XFS_SICK_FS_GQUOTA | \
 				 XFS_SICK_FS_PQUOTA | \
-				 XFS_SICK_FS_QUOTACHECK)
+				 XFS_SICK_FS_QUOTACHECK | \
+				 XFS_SICK_FS_NLINKS)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY)
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index ef07af9f753d3..111c27a6b1079 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -281,6 +281,7 @@ static const struct ioctl_sick_map fs_map[] = {
 	{ XFS_SICK_FS_GQUOTA,	XFS_FSOP_GEOM_SICK_GQUOTA },
 	{ XFS_SICK_FS_PQUOTA,	XFS_FSOP_GEOM_SICK_PQUOTA },
 	{ XFS_SICK_FS_QUOTACHECK, XFS_FSOP_GEOM_SICK_QUOTACHECK },
+	{ XFS_SICK_FS_NLINKS,	XFS_FSOP_GEOM_SICK_NLINKS },
 	{ 0, 0 },
 };
 

