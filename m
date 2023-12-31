Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E961BE5F
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZI/7ZC7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FCBC433C7;
	Sun, 31 Dec 2023 22:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060592;
	bh=tD0sG2KYm7uv4UDdRdJpaT7xWFrVIFNTXubIGC3zHAo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZI/7ZC7C7cS9XUy+ANBp5iNCIz9j8QtFF573NDkilUpem1hkJaW7BRjmoZn/FkFaw
	 OBIfGS+v3aFZx+9gHLggOqRQJl/aJKS01v7jN8MVkUR/JYqfWnX2KSNF0ifUOBzZax
	 b/1mBBmKYPX/sKbygEWISAnLYtRR/BTyeoFUEhm2HwUVxVLqno6eAA1L9qjdEsJbU4
	 g2ltlYSlEf+vWXy+PQKO7PV1zI8JzzLrLvpaCojj70+SNEzg16sffVR3vQE8W++dQO
	 r+0rk1A9TBunwvMgz1mlbQFjVSIzUO/pSEdfFcTzs653sw2DLqz5EYZRD+VOmgJkLR
	 0PMwAUF44d9/A==
Date: Sun, 31 Dec 2023 14:09:51 -0800
Subject: [PATCH 6/8] xfs_repair: constrain attr fork extent count
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404991217.1793698.17159020331919803285.stgit@frogsfrogsfrogs>
In-Reply-To: <170404991133.1793698.11944872908755383201.stgit@frogsfrogsfrogs>
References: <170404991133.1793698.11944872908755383201.stgit@frogsfrogsfrogs>
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

Don't let the attr fork extent count exceed the maximum possible value.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index bd91ce14a36..a6a44b85424 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2049,6 +2049,7 @@ process_inode_attr_fork(
 	xfs_ino_t		lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	struct xfs_dinode	*dino = *dinop;
 	struct blkmap		*ablkmap = NULL;
+	xfs_extnum_t		max_nex;
 	int			repair = 0;
 	int			err;
 	int			try_rebuild = -1; /* don't know yet */
@@ -2070,6 +2071,11 @@ process_inode_attr_fork(
 	}
 
 	*anextents = xfs_dfork_attr_extents(dino);
+	max_nex = xfs_iext_max_nextents(
+			xfs_dinode_has_large_extent_counts(dino),
+			XFS_ATTR_FORK);
+	if (*anextents > max_nex)
+		*anextents = 1;
 	if (*anextents > be64_to_cpu(dino->di_nblocks))
 		*anextents = 1;
 

