Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC15C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOFtR38s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E76DC433C7;
	Sun, 31 Dec 2023 22:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060232;
	bh=Ccs95rvslNdNhuX7mbI+FeVNZNnDY9AG9AjAjpIyhe4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KOFtR38sf9qR8xSZjSVETgokcuf8+fEboewUcJ91dXP83idB3kYmIXEFrZDVXKMvS
	 zU42j849LkkOLkw1+KabnkDy/WWcRHVcGSxEb9neDjnwsclMa/DwfXZ0CEBS2eZaRL
	 5PhSE7IApVJeIuAM0Jg547COuxk8NJX/8SIdERxNp5XIevDHnyBhhW5i0Kf3D7MGCs
	 5wOESd0AXIJBmhikra85Iu31ttmWi9IhNoRzIfEY0rCWlRpAKK8kC+6YfKer6uI4eP
	 3E8TFZjJd0qFAcAHYSEMtNnOwcbDf05BlavNdJ9kDx26V2YwHYEMxxfzyHB/Px0pdz
	 KmL4mcXRY+moA==
Date: Sun, 31 Dec 2023 14:03:51 -0800
Subject: [PATCH 4/4] xfs: enable file data force-align feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Message-ID: <170404855961.1770028.12314794235344049296.stgit@frogsfrogsfrogs>
In-Reply-To: <170404855884.1770028.10371509002317647981.stgit@frogsfrogsfrogs>
References: <170404855884.1770028.10371509002317647981.stgit@frogsfrogsfrogs>
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

Enable this feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index a0f5bae450135..c9af0025c26a7 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -398,7 +398,8 @@ xfs_sb_has_compat_feature(
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
 		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
-		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
+		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT | \
+		 XFS_SB_FEAT_RO_COMPAT_FORCEALIGN)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(

