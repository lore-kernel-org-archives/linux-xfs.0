Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D827EC140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nyy4EZBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A1BC433C8;
	Sun, 31 Dec 2023 23:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064000;
	bh=9eL7XeYB9EP5CDIDx8VdAXpj6a90rLRSXvxKmQ0tQn4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Nyy4EZBi4Cclka1Sb2OMSRtN+hbcx903zTLdHNcUc7v0FShY3Q0m/781UA/DyyKpT
	 DtcNzyDmlhduPE5H3eHzlI0+0VD7FmJPzfFVNbAOD9dVpKKdqIaTljIZ7urrktArxd
	 LP4a8qX2e9rMKL++Hkxe13NEBMyZK4DVaTXO7NGRFp/bzJja0I+xKP9sLoEjo5PmDW
	 xwLbPYPxbuoZUCz6HuHVpO1TBaWs1KUN+buIaN255e6ln5acEHzq7k3yU2orR3Y4dZ
	 NKw9MYT9xuog62nH6367EgPU7xUMS5CHhi+1gyMRfCvvy/fZj91PnN0xxYgGqGpWp9
	 6cw6DqR3yLzNQ==
Date: Sun, 31 Dec 2023 15:06:40 -0800
Subject: [PATCH 06/32] xfs: add parent attributes to link
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Message-ID: <170405006183.1804688.237715546796664157.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
References: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_link to add a parent pointer to the inode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: minor rebase fixes]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_trans_space.c |   14 ++++++++++++++
 libxfs/xfs_trans_space.h |    3 +--
 2 files changed, 15 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_trans_space.c b/libxfs/xfs_trans_space.c
index 3408e700f01..039bbd91e87 100644
--- a/libxfs/xfs_trans_space.c
+++ b/libxfs/xfs_trans_space.c
@@ -50,3 +50,17 @@ xfs_mkdir_space_res(
 {
 	return xfs_create_space_res(mp, namelen);
 }
+
+unsigned int
+xfs_link_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret;
+
+	ret = XFS_DIRENTER_SPACE_RES(mp, namelen);
+	if (xfs_has_parent(mp))
+		ret += xfs_parent_calc_space_res(mp, namelen);
+
+	return ret;
+}
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 6cda87153b3..5539634009f 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
@@ -86,8 +86,6 @@
 	(2 * (mp)->m_alloc_maxlevels)
 #define	XFS_GROWFSRT_SPACE_RES(mp,b)	\
 	((b) + XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK))
-#define	XFS_LINK_SPACE_RES(mp,nl)	\
-	XFS_DIRENTER_SPACE_RES(mp,nl)
 #define	XFS_QM_DQALLOC_SPACE_RES(mp)	\
 	(XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK) + \
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
@@ -107,5 +105,6 @@ unsigned int xfs_parent_calc_space_res(struct xfs_mount *mp,
 
 unsigned int xfs_create_space_res(struct xfs_mount *mp, unsigned int namelen);
 unsigned int xfs_mkdir_space_res(struct xfs_mount *mp, unsigned int namelen);
+unsigned int xfs_link_space_res(struct xfs_mount *mp, unsigned int namelen);
 
 #endif	/* __XFS_TRANS_SPACE_H__ */

