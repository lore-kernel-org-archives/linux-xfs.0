Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35FA29B0
	for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 00:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732147774; cv=none; b=kUcbeEglQqdUKQgmqR5h3u2LXNrjCNv6qxnBkgEc06ZcDNt0SlQqjAkKrxSw4IW8mjejzQdyHAeD+x4BP8F4WG12IObIrZ958B1tTS0VKC/P75ycpTOIbtSISuSjUfvpOC1wUwUzkmvmnV7PUrWHG9lecAC+IfoZjjAaIyKnkvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732147774; c=relaxed/simple;
	bh=ixMdGknki2mXLtQRo5rQKCiJblO627x+/Bxn+Q/+G3o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oMF+1OfFyN90Yxk71nCe4IH+/L6lFrxLJiv2BUXBmAm5CR4OjQNHr3TPq/wQ9bgEfcnhQ7CDcdQ+rsXViDVZW6dLhsBjHpScOvpGVROS1k8sG9g0wQwEyTZKRJnifJysoAdAEbsKavRZeUsftQrC+1JS5Er1Zn0wwLyva7FnU3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Of5vu465; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Of5vu465"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29871C4CECD;
	Thu, 21 Nov 2024 00:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732147774;
	bh=ixMdGknki2mXLtQRo5rQKCiJblO627x+/Bxn+Q/+G3o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Of5vu465NAHdjGRjCS9oWjmIXsL1w0CQR0upNalP9nMjQZHi8ymXaOqm0M1hnVb0P
	 AxfGLrLLwsuO1W9B0YOKiRbqVCpSknMExadXfe1rkwHTF47p36XBkfKMqb10yNmRrd
	 cx127qOjSXqo73rU1q3gLQuT+rW2dFFkJQ/FymZvTJKfhzHYBpOnTjqFonyhar3bxn
	 e3KM2A482Es0x3RRu7JkptsmQs/X6xR+NsXOIxb2PIPtvLV5DPx2eg2fcXfdR8oNfC
	 fNNAcxy712FneoUj44nLSD2/5tuf9/VBUuu5SykhSp4zgojEyX9u107ld8WKlLEejP
	 TehKIHJsn5p5A==
Date: Wed, 20 Nov 2024 16:09:33 -0800
Subject: [PATCH 2/2] xfs_repair: synthesize incore inode tree records when
 required
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173214768860.2957531.16129692070811504220.stgit@frogsfrogsfrogs>
In-Reply-To: <173214768829.2957531.4071177223892485486.stgit@frogsfrogsfrogs>
References: <173214768829.2957531.4071177223892485486.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

