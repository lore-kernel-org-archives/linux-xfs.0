Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E972153BE4
	for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 23:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731971275; cv=none; b=opyQ0pIzdgsmxsXykxcIG0HNcbXLFHI2km9H16gCiPcsOHwKbBVuzBVJIYjeD4qrNoLkNzInf4Z098UkZdZc5nN05pfUPDot6avzyFF2xUdnXCTruj2C/oJsl1bxQhTQGdLl97hwce/v7MUBRyurZJnCvSNv2MYzGSSKSCEijhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731971275; c=relaxed/simple;
	bh=Afnw0Dozkp6dkJ3i6nWk+EhzbwSUGGsj3wrCcnCBLyg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DdarO9+6TrjdOADcbYNK68B35CqTCAcVec3C1ecwTYWdwpo28f+PDLqeTfgrMyryfRUH1E9CfNvjyI7R+2vb292HQ4T92XxkLf81iqrQoLH7i73cb4opmpycy36eEHD74+vGTLnAPzWAESfGR6u+j7BM8h/P92DFINqkJBZ7nuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IgGHLAMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IgGHLAMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC741C4CECC;
	Mon, 18 Nov 2024 23:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731971274;
	bh=Afnw0Dozkp6dkJ3i6nWk+EhzbwSUGGsj3wrCcnCBLyg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IgGHLAMXap3VsHvQYB3G6UKjCOUFgA9HZ0orClt1g9f6qFgmoWHjS+CPHdSSt8AJg
	 cyhN+XAdajWi8xowvcqkBkzHwP9OC0RfBTIPhk6Dw4oOidgg5xCUXcJPvtmkNTal21
	 IYkGBPg9uVLjAWihcrrDTQNY/jUMNTL3loQUcUDHpquu/YWkznO/Edbbf0A4LArxVX
	 UPPIWp1tuelcK/AYUjf+iZR3Su//imEdzfucEwx826C7MEAzqkzpOTf4duriJUVaHy
	 XmryrPOnfbJrLQBQU7IoEpXA5a84+nUJa+uGx+dQNoOpnWxFr+4XiDidgzAnnUfEOQ
	 RUwxL1MoOGG7A==
Date: Mon, 18 Nov 2024 15:07:54 -0800
Subject: [PATCH 2/2] xfs_repair: synthesize incore inode tree records when
 required
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173197107039.920975.2579223976323116080.stgit@frogsfrogsfrogs>
In-Reply-To: <173197107006.920975.13789855653344370340.stgit@frogsfrogsfrogs>
References: <173197107006.920975.13789855653344370340.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

On a filesystem with 64k fsblock size, xfs/093 fails with the following:

Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
found inodes not in the inode allocation tree
found inodes not in the inode allocation tree
        - process known inodes and perform inode discovery...
        - agno = 0
xfs_repair: dino_chunks.c:1166: process_aginodes: Assertion `num_inos == igeo->ialloc_inos' failed.
./common/xfs: line 392: 361225 Aborted                 (core dumped) $XFS_REPAIR_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV

In this situation, the inode size is 512b, which means that two inobt
records map to a single fs block.  However, the inobt walk didn't find
the second record, so it didn't create a second incore ino_tree_node_t
object.  The assertion trips, and we fail to repair the filesystem.

To fix this, synthesize incore inode records when we know that they must
exist.  Mark the inodes as in use so that they will not be purged from
parent directories or moved to lost+found if the directory tree is also
compromised.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dino_chunks.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 1953613345190d..86e29dd9ae05eb 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -1050,6 +1050,8 @@ process_aginodes(
 	first_ino_rec = ino_rec = findfirst_inode_rec(agno);
 
 	while (ino_rec != NULL)  {
+		xfs_agino_t	synth_agino;
+
 		/*
 		 * paranoia - step through inode records until we step
 		 * through a full allocation of inodes.  this could
@@ -1068,6 +1070,32 @@ process_aginodes(
 				num_inos += XFS_INODES_PER_CHUNK;
 		}
 
+		/*
+		 * We didn't find all the inobt records for this block, so the
+		 * incore tree is missing a few records.  This implies that the
+		 * inobt is heavily damaged, so synthesize the incore records.
+		 * Mark all the inodes in use to minimize data loss.
+		 */
+		for (synth_agino = first_ino_rec->ino_startnum + num_inos;
+		     num_inos < igeo->ialloc_inos;
+		     synth_agino += XFS_INODES_PER_CHUNK,
+		     num_inos += XFS_INODES_PER_CHUNK) {
+			int		i;
+
+			ino_rec = find_inode_rec(mp, agno, synth_agino);
+			if (ino_rec)
+				continue;
+
+			ino_rec = set_inode_free_alloc(mp, agno, synth_agino);
+			do_warn(
+ _("found inobt record for inode %" PRIu64 " but not inode %" PRIu64 ", pretending that we did\n"),
+					XFS_AGINO_TO_INO(mp, agno,
+						first_ino_rec->ino_startnum),
+					XFS_AGINO_TO_INO(mp, agno,
+						synth_agino));
+			for (i = 0; i < XFS_INODES_PER_CHUNK; i++)
+				set_inode_used(ino_rec, i);
+		}
 		ASSERT(num_inos == igeo->ialloc_inos);
 
 		if (pf_args) {

