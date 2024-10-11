Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EEF5227
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609563; cv=none; b=AMv0Owv/a+lloznQWKVAnK+BPZ5YJyJc7earWpdw5aTIwsB3cw76EINTuCFvuAT1U1vhCdptysVUEzyqnymM0D1+0swoHIv+wb8cXeKW2hUJpn6YQaFtU7HYAQpPEjt8A1I8Xc+KpeLgKrmJIz5r+dB1/pYneNJl5oLrF8YQpfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609563; c=relaxed/simple;
	bh=UYDBF/PO8rIIFEygyTn376bsoWQrEvmjwIAWMzA/pWE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RrXvkyk7rTQW8ivNjzhFONc8jKewBCSOl+3h2tfrxDOMkdqDsFiiRUHKY6ClLickAa+pOgl9XVak5UET4CUn9rESdsWORBbJ0Z9K6zhObE5spN12dv6gu6ZwmuRPXg/GnQ4EvsuSMMejXhMBVidZxwSouf4cLrGbLQ7WM78yIDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GvjEefZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GvjEefZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEEBC4CEC5;
	Fri, 11 Oct 2024 01:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609562;
	bh=UYDBF/PO8rIIFEygyTn376bsoWQrEvmjwIAWMzA/pWE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GvjEefZioIDlwQcy4cPZTdY5Oq/whCLfZ4zet4npKVTWckWq9oLUSvRYUGFhLr5hK
	 Z+CaIKHZJvWEL3lEb7Fq5vmGsYQTU+vzPJyz/JZo2UrN2hNjQY9dvYxWdDz4S99Rlh
	 LFsWEycGDRu3S/Di/wwYCoqFaTy75t0GJWVRkrKwWb06TnaGPLOaMsz5AU1LK8b5Un
	 zVgy0zAvNufFgU6eNhWw8dvVZNQAsfiirS55DYee05/etcmdKcafzyljQNyl355vER
	 PMCZ8h1gc9qxefWflv9X4SiwBduFDFvU9iJ+0iAduUPrlCZFfZlHKcFP4kM2TwzjBE
	 XRSVq6rZBTGbg==
Date: Thu, 10 Oct 2024 18:19:22 -0700
Subject: [PATCH 20/38] xfs_repair: refactor marking of metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654282.4183231.13044241893441384330.stgit@frogsfrogsfrogs>
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

Refactor the mechanics of marking a metadata inode into a helper
function so that we don't have to open-code that for every single
metadata inode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   76 ++++++++++++++++++++-----------------------------------
 1 file changed, 28 insertions(+), 48 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 0f13d996fe726a..0c80c4aa36af4a 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2891,6 +2891,22 @@ _("error %d fixing shortform directory %llu\n"),
 	libxfs_irele(ip);
 }
 
+static void
+mark_inode(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	struct ino_tree_node	*irec;
+	int			offset;
+
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
+			XFS_INO_TO_AGINO(mp, ino));
+
+	offset = XFS_INO_TO_AGINO(mp, ino) - irec->ino_startnum;
+
+	add_inode_reached(irec, offset);
+}
+
 /*
  * mark realtime bitmap and summary inodes as reached.
  * quota inode will be marked here as well
@@ -2898,54 +2914,18 @@ _("error %d fixing shortform directory %llu\n"),
 static void
 mark_standalone_inodes(xfs_mount_t *mp)
 {
-	ino_tree_node_t		*irec;
-	int			offset;
-
-	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rbmino),
-			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rbmino));
-
-	offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rbmino) -
-			irec->ino_startnum;
-
-	add_inode_reached(irec, offset);
-
-	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rsumino),
-			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rsumino));
-
-	offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rsumino) -
-			irec->ino_startnum;
-
-	add_inode_reached(irec, offset);
-
-	if (fs_quotas)  {
-		if (mp->m_sb.sb_uquotino
-				&& mp->m_sb.sb_uquotino != NULLFSINO)  {
-			irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp,
-						mp->m_sb.sb_uquotino),
-				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_uquotino));
-			offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_uquotino)
-					- irec->ino_startnum;
-			add_inode_reached(irec, offset);
-		}
-		if (mp->m_sb.sb_gquotino
-				&& mp->m_sb.sb_gquotino != NULLFSINO)  {
-			irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp,
-						mp->m_sb.sb_gquotino),
-				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_gquotino));
-			offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_gquotino)
-					- irec->ino_startnum;
-			add_inode_reached(irec, offset);
-		}
-		if (mp->m_sb.sb_pquotino
-				&& mp->m_sb.sb_pquotino != NULLFSINO)  {
-			irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp,
-						mp->m_sb.sb_pquotino),
-				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_pquotino));
-			offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_pquotino)
-					- irec->ino_startnum;
-			add_inode_reached(irec, offset);
-		}
-	}
+	mark_inode(mp, mp->m_sb.sb_rbmino);
+	mark_inode(mp, mp->m_sb.sb_rsumino);
+
+	if (!fs_quotas)
+		return;
+
+	if (mp->m_sb.sb_uquotino && mp->m_sb.sb_uquotino != NULLFSINO)
+		mark_inode(mp, mp->m_sb.sb_uquotino);
+	if (mp->m_sb.sb_gquotino && mp->m_sb.sb_gquotino != NULLFSINO)
+		mark_inode(mp, mp->m_sb.sb_gquotino);
+	if (mp->m_sb.sb_pquotino && mp->m_sb.sb_pquotino != NULLFSINO)
+		mark_inode(mp, mp->m_sb.sb_pquotino);
 }
 
 static void

