Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8A74A2D
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609719; cv=none; b=psVHaGgN2MCpKbTizpdZHvBczBGOzApGV9zejLb5YuMRrghJ7o06DahXUaddEPnEqSGf0u9BbWGpciws4WfGQupDrsaGajXDp8vhFVoCW/aToFl/tTe5DkrlaQj+qNg77hnkzbvlcvoId6NCM/qK5Fy4hXvwP1akfpt+oUG/QmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609719; c=relaxed/simple;
	bh=PV/bUSbFeBwhbkpbhC8nesg0kVxi6pKZOzCZFcWzCN4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tHQrifyhoKYk/grn0r8ySiau81qRj7QVg8ITAONEeMGvmzFdiieGm1jHQ26h3z71hPWbyZ7g/sOO7jS5FsezKcvTt6nQzie3gdDKHYMgmQH43eqvWo+iXPdrJ3kjK7PWprnyCTBJXCVNDfPLhpJCRmXQAJBIoPotbmVjQziubyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pLbio+rx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pLbio+rx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC47C4CEC5;
	Fri, 11 Oct 2024 01:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609718;
	bh=PV/bUSbFeBwhbkpbhC8nesg0kVxi6pKZOzCZFcWzCN4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pLbio+rxlkRdawyZpHKwwMv8QznV5bzQ+9+LpvOFSDZ+QM3HfIcj9wseXMmWu0buY
	 sSAz95qmtTJWHHnxVgRb5LQtQNCZjpGJsJA6AC5fCLD6OmSSCt0Pu6iwnHdKqb8mwr
	 65CgAUkYXnQ78vNJplHIyT4QAWndn3ST3OCYF0XUPXiAxRh9E2DCydsmaeqyd/qdNQ
	 xbSnuMwwYN0l5m1Eif+Pmn7M8CMqhduiOY1AG6/1HjuNvsgzJDiVbfS1zFDFMN+GQI
	 PHUnMLT8OGlPCYgsa4ZN/0EfpoLjeFlvn1LwXyskSSBlf5uTDS/SMn0IQH2jzUchXi
	 uoMbX2i9IcmMw==
Date: Thu, 10 Oct 2024 18:21:58 -0700
Subject: [PATCH 30/38] xfs_repair: adjust keep_fsinos to handle metadata
 directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654437.4183231.2986701133772942310.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

In keep_fsinos, mark the root of the metadata directory tree as inuse.
The realtime bitmap and summary files still come after the root
directories, so this is a fairly simple change to the loop test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase5.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 86b1f681a72bb8..a5e19998b97061 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -419,13 +419,18 @@ static void
 keep_fsinos(xfs_mount_t *mp)
 {
 	ino_tree_node_t		*irec;
-	int			i;
+	unsigned int		inuse = xfs_rootrec_inodes_inuse(mp), i;
 
 	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
 			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
 
-	for (i = 0; i < 3; i++)
+	for (i = 0; i < inuse; i++) {
 		set_inode_used(irec, i);
+
+		/* Everything after the root dir is metadata */
+		if (i)
+			set_inode_is_meta(irec, i);
+	}
 }
 
 static void

