Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A25C2DA
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FmGYZW0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D49C433C7;
	Sun, 31 Dec 2023 23:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066110;
	bh=1V1z9cunnmGzE/mIfdxsuNHXZFcCVu5bM5t2SpghaYo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FmGYZW0fs+ylaKJ/gKkMnFco09H24cfRWX4jRwU7HMzp+z9NrPPLpNwFhIjuankef
	 kbc4UcqGW+5eNTTV5EHkzqKnDSEtx+VzHT6RchDBVlMA6BIIfN1UtRUfFg81GRNMmS
	 lTO5s/hQ2qjrAPNvKxeTqCog0aC1gcSeUJVUYbQWgXNIKm+S4CHqA14+O1dtix4B7S
	 t5SHWXN0rMNF6nrFBzBtPSO4wYW3VSrvdHSDyrDieK4BhpKXdI+vP3ZkwO5bV0SzJ9
	 gYvO5OIQV/P37lWjRKMyJ75gXR9r6xmKneFp1seG5BrilSWs62cBbW7T/NZ3ukQhY1
	 VDox+ang+2wMw==
Date: Sun, 31 Dec 2023 15:41:50 -0800
Subject: [PATCH 47/58] xfs_repair: update incore metadata state whenever we
 create new files
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010574.1809361.14769763572771262563.stgit@frogsfrogsfrogs>
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

Make sure that we update our incore metadata inode bookkeepping whenever
we create new metadata files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)


diff --git a/repair/phase6.c b/repair/phase6.c
index 21bd2b75050..9ad586602cb 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -516,6 +516,24 @@ mark_ino_inuse(
 		set_inode_isadir(irec, ino_offset);
 }
 
+/*
+ * Mark a newly allocated inode as metadata in the incore bitmap.  Callers
+ * must have already called mark_ino_inuse to ensure there is an incore record.
+ */
+static void
+mark_ino_metadata(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	struct ino_tree_node	*irec;
+	int			ino_offset;
+
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
+			XFS_INO_TO_AGINO(mp, ino));
+	ino_offset = get_inode_offset(mp, ino, irec);
+	set_inode_is_meta(irec, ino_offset);
+}
+
 /* Make sure this metadata directory path exists. */
 static int
 ensure_imeta_dirpath(
@@ -557,6 +575,7 @@ ensure_imeta_dirpath(
 		}
 
 		mark_ino_inuse(mp, ino, S_IFDIR, parent);
+		mark_ino_metadata(mp, ino);
 		parent = ino;
 	}
 
@@ -664,6 +683,7 @@ ensure_rtino_metadir(
 
 		mark_ino_inuse(mp, upd->ip->i_ino, S_IFREG,
 				lookup_imeta_path_dirname(mp, path));
+		mark_ino_metadata(mp, upd->ip->i_ino);
 		return;
 	}
 
@@ -1108,6 +1128,7 @@ mk_metadir(
 
 	libxfs_trans_ijoin(tp, mp->m_metadirip, 0);
 	libxfs_imeta_set_iflag(tp, mp->m_metadirip);
+	mark_ino_metadata(mp, mp->m_metadirip->i_ino);
 
 	error = -libxfs_trans_commit(tp);
 	if (error)

