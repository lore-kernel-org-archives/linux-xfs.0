Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D1F128381
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423924; cv=none; b=b3eWWwxYVv7H5VyHjHMMpmqt4X6l/m+CS/rxOIYI0a6IMG7VqSJmTeGYXl5z95te9J/Muq9AtJwqJIlPu5Fv4vcdS3x7XTlHf0lrXJxqpwuldHDHo6/5ZRlH7zMBw5HGEPIF5CGAnnrIkkMfb1SbRMtIuuOg22Ii+y5olJYK1EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423924; c=relaxed/simple;
	bh=GI/xOk5H1D7E+55CfeGa9WXQJBmjwEF/UsvvQXpQ3LY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mavvrQr+bWxWWB9zu6Osag+HRJ1ZYo3y87KkT3Z9e5uSB6yn/JdT4Zhtxi54AqsNGNF/t41vkYclTA2Y+xppF3Yj65AqDToPtKGSGnGQmsi7SV59nMD/RzWs2dlO6yiNmxJue9y0baTPEyTAzsLvAUFoTNB47g3HQmy5d+EB3ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sdyvuENj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sdyvuENj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135EAC433F1;
	Tue, 26 Mar 2024 03:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423924;
	bh=GI/xOk5H1D7E+55CfeGa9WXQJBmjwEF/UsvvQXpQ3LY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sdyvuENjXV34gjk3MnMFQiVVNdx6QiVjfDPlg7Mq6hn3ABNGoaGQVHpYpgEqaL+xg
	 iQuU6E6JhRbM7dcypZBseVncc5yJ5M+20UtyGGB1N/B8AuI4jJZAFemLA13JiDCQxb
	 Y1IMZ2P+FY5LlWOEh5VZr8h7ELynGIWCbJij7LCNd6nGfhzOaRYJ9BIpCO95V8l+DS
	 GzPh8I8hrG1R4U9CYks2qviaWSHoTSQc1UYCVivdDuv5hyoQqEgzjENBC9Hyw7u1ox
	 1wIFIe+FzFL1VtxifLdnJCYSO+CP+TFDkzAWY/I/0fbqrikvJagoIOAA2Yxot6WacO
	 tUphT8XFfT2jg==
Date: Mon, 25 Mar 2024 20:32:03 -0700
Subject: [PATCH 014/110] xfs: report health of inode link counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131587.2215168.6349840306510538212.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 93687ee2e3748a4a6b541ff0d83d1480815b00a9

Report on the health of the inode link counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h     |    1 +
 libxfs/xfs_health.h |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 07acbed9235c..f10d0aa0e337 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -196,6 +196,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_RT_BITMAP	(1 << 4)  /* realtime bitmap */
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
 #define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
+#define XFS_FSOP_GEOM_SICK_NLINKS	(1 << 7)  /* inode link counts */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 5626e53b3f0f..2bfe2dc404a1 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
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

