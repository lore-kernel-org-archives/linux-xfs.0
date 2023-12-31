Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3283C2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ilzUiF37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C928C433C7;
	Sun, 31 Dec 2023 23:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066173;
	bh=l7L2i5yKDV8jNMpvQyjAJ2/HuE75/90s4dlK+3uuvG4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ilzUiF37UFTeCtGeCKePLQLFfZd7WHiVHWXR51AffroWs3Wz9ok/31OM1cb3StuYo
	 7eZ7HMJqEZpeBNGTq1KTOD0AeHjPiX2ZzkvEyEev0wfIBIoO35UHcYwa+t1ZvY5a4y
	 RZO/0GUvWH47lQJrK1a2ryHZLkwKQE10h6t88OOK1hFfjYiqIviUd2djQhprp5eBNn
	 nVmWS6x97PadFOq5uSk+2t5TQb40bIKFiBA8dlvysMUkWOX7I3XQAJtGW8dEJMsOEG
	 MHi5/AWI0PXveAqhJsigPqGyPGOU/lKQglze0NFrR4cGfei4EuGsHZi02EqcwfibN6
	 8kUmZRno8C3og==
Date: Sun, 31 Dec 2023 15:42:53 -0800
Subject: [PATCH 51/58] xfs_repair: metadata dirs are never plausible root dirs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010627.1809361.195606095171584318.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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

Metadata directories are never candidates to be the root of the
user-accessible directory tree.  Update has_plausible_rootdir to ignore
them all, as well as detecting the case where the superblock incorrectly
thinks both trees have the same root.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/xfs_repair.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index d881d5ec4ac..fe24f66ab98 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -541,9 +541,15 @@ has_plausible_rootdir(
 	int			error;
 	bool			ret = false;
 
+	if (xfs_has_metadir(mp) &&
+	    mp->m_sb.sb_rootino == mp->m_sb.sb_metadirino)
+		goto out;
+
 	error = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &ip);
 	if (error)
 		goto out;
+	if (xfs_is_metadir_inode(ip))
+		goto out_rele;
 	if (!S_ISDIR(VFS_I(ip)->i_mode))
 		goto out_rele;
 

