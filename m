Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3488183A
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mKqmB+1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3663C433C7;
	Wed, 13 Dec 2023 22:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702508058;
	bh=sKsdJU42lY76RCCOG1sMgg5FMg8w9Ht6efo0j4od2Q4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mKqmB+1rCNgpuJbB0s4yNaNLvN4bAsLP3iBXDY43yCYcaNugx2rHmo6YwYNDod7L0
	 qC3R5mMGQ4JOS36uS6w1WNPYYY/hXejJraxs/DLQ5RFjkvF2eBdrz+8B+xRmEDcxlv
	 MX5m+p8uX17g+Brkl+3AIvTdjNrRglY7xfIpaDNy5o+Xm+i1Cg7rU+/ER5LjR4q3lJ
	 1+ivWDpRS/nMhHDtgxyKfpQdFZYAVNBpS7vaG68U8Q4JjXvvzwx7WrP4ehVJhLnTzK
	 xRDzq8srhHtfOkdWUtgRjK8Zww+Bztgh3BydTsQOtq0QJPUwA/Ql2ZqLjEkemdzGet
	 akKzwsQYxzEAA==
Date: Wed, 13 Dec 2023 14:54:18 -0800
Subject: [PATCH 4/9] xfs: dont cast to char * for XFS_DFORK_*PTR macros
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170250783531.1399182.12180413015033895645.stgit@frogsfrogsfrogs>
In-Reply-To: <170250783447.1399182.12936206088783796234.stgit@frogsfrogsfrogs>
References: <170250783447.1399182.12936206088783796234.stgit@frogsfrogsfrogs>
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

Code in the next patch will assign the return value of XFS_DFORK_*PTR
macros to a struct pointer.  gcc complains about casting char* strings
to struct pointers, so let's fix the macro's cast to void* to shut up
the warnings.

While we're at it, fix one of the scrub tests that uses PTR to use BOFF
instead for a simpler integer comparison, since other linters whine
about char* and void* comparisons.

Can't satisfy all these dman bots.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |    2 +-
 fs/xfs/scrub/inode.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 9a88aba1589f..f16974126ff9 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1008,7 +1008,7 @@ enum xfs_dinode_fmt {
  * Return pointers to the data or attribute forks.
  */
 #define XFS_DFORK_DPTR(dip) \
-	((char *)dip + xfs_dinode_size(dip->di_version))
+	((void *)dip + xfs_dinode_size(dip->di_version))
 #define XFS_DFORK_APTR(dip)	\
 	(XFS_DFORK_DPTR(dip) + XFS_DFORK_BOFF(dip))
 #define XFS_DFORK_PTR(dip,w)	\
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 6c40f3e020ea..a81f070b0cd2 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -556,7 +556,7 @@ xchk_dinode(
 	}
 
 	/* di_forkoff */
-	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
+	if (XFS_DFORK_BOFF(dip) >= mp->m_sb.sb_inodesize)
 		xchk_ino_set_corrupt(sc, ino);
 	if (naextents != 0 && dip->di_forkoff == 0)
 		xchk_ino_set_corrupt(sc, ino);

