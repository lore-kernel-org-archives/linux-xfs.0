Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3B5C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kk0s1JVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A704C433C8;
	Sun, 31 Dec 2023 23:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066736;
	bh=Mgis5ApiN8H7LDZ6HRfTiG1Rzg8ApbIgI7jAqMvWGaE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Kk0s1JVaE7tZaCvO2YnXrjT5n50IskWo3lnVwW3R8RBHFBWaoB2Ch5gON5dMuzK9X
	 78l3c3o8MngyntKx0NVEcWX3yyeW3zXE53jBQ9V39as/oNAcMe7S7OJ136Qtyb2gmy
	 SOgLuFi22j35BTtIN9YWVI+3+damKIEwn1qS8ymW4im2uJUbNMScwUsFy5y/DDZWl4
	 t/fQcwcH9UMGkADuslWdpL98Yl6Sttzrw/FBs4TEeF8YgV14vDFhesCQyA4nj4Bj+A
	 YX8En3MfhFgycniiaQfAmo8PbgxZ+R9veiW6GRUWusTOHHN0aFnh2ekOjWE4Rg5aXH
	 fdkQU3GpLzAUA==
Date: Sun, 31 Dec 2023 15:52:15 -0800
Subject: [PATCH 18/52] xfs: use an incore rtgroup rotor for rtpick
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012409.1811243.7956219219085956379.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

During the 6.7 merge window, Linus noticed that the realtime allocator
was doing some sketchy things trying to encode a u64 sequence counter
into the rtbitmap file's atime.  The sketchy casting of a struct pointer
to a u64 pointer has subtly broken several times over the past decade as
the codebase has transitioned to using the VFS i_atime field and that
field has changed in size and layout over time.

Since the goal of the rtpick code is to _suggest_ a starting place for
new rt file allocations, the repeated breakage has not resulted in
inconsistent metadata.  IOWs, it's a hint.

For rtgroups, we don't need this complex code to cut the rtextents space
into fractions.  Add an rtgroup rotor and use that for rtpick, similar
to AG rotoring on the data device.  The new rotor does not persist,
which reduces the logging overhead slightly.

Link: https://lore.kernel.org/linux-xfs/CAHk-=wj3oM3d-Hw2vvxys3KCZ9De+gBN7Gxr2jf96OTisL9udw@mail.gmail.com/
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h   |    1 +
 libxfs/xfs_rtbitmap.c |   12 ++++++++----
 mkfs/proto.c          |    3 ++-
 3 files changed, 11 insertions(+), 5 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index ecee4ccc0b7..a2fdd7c2f14 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -52,6 +52,7 @@ typedef struct xfs_mount {
 	char			*m_fsname;	/* filesystem name */
 	int			m_bsize;	/* fs logical block size */
 	spinlock_t		m_agirotor_lock;
+	xfs_rgnumber_t		m_rtgrotor;	/* last rtgroup rtpicked */
 	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
 	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
 	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 7be1c0bdbea..7d29a72be6b 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1060,10 +1060,14 @@ xfs_rtfree_extent(
 		if (!(mp->m_rbmip->i_diflags & XFS_DIFLAG_NEWRTBM))
 			mp->m_rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;
 
-		atime = inode_get_atime(VFS_I(mp->m_rbmip));
-		atime.tv_sec = 0;
-		inode_set_atime_to_ts(VFS_I(mp->m_rbmip), atime);
-		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
+		if (xfs_has_rtgroups(mp)) {
+			mp->m_rtgrotor = 0;
+		} else {
+			atime = inode_get_atime(VFS_I(mp->m_rbmip));
+			atime.tv_sec = 0;
+			inode_set_atime_to_ts(VFS_I(mp->m_rbmip), atime);
+			xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
+		}
 	}
 	error = 0;
 out:
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 33d454cffb2..36df148018f 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -810,7 +810,8 @@ rtbitmap_create(
 
 	rbmip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
 	rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;
-	inode_set_atime(VFS_I(rbmip), 0, 0);
+	if (!xfs_has_rtgroups(mp))
+		inode_set_atime(VFS_I(rbmip), 0, 0);
 	libxfs_trans_log_inode(upd.tp, rbmip, XFS_ILOG_CORE);
 
 	error = -libxfs_imeta_commit_update(&upd);

