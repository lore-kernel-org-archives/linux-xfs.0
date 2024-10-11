Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326D98F5B
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609750; cv=none; b=Pm0slCWvpEli2/K9CSbeRiApZXlm4UUlru4T0+GP5Cy/W2942sfXOf/YYp6x44ckRcj0H5+POMquf7CmMaVXnXMQ6k9GZn47oSbgTwpEnxec8TOMARHh5I1cbnP06WNBwH8O0+6czq3msy0OkRNUp3FkbV4j7hh+hB64yBcFrfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609750; c=relaxed/simple;
	bh=sHG4UJNomzhpeEaSl/uEssJkvHYlmQ/JjgSTusLiZCU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rfj6iqVZ1youRtBquQGI4BeIwpsSMcKpeNNBDHaVJasB9F6k/ztQPQoE7CdDSc6jFnLVk/EmUseBD6EqRPTwEiwgX3b2AZAga719xmCIJ1oDA7mJd2EnYZKWJaK1/7Wlb5w8oGHPWSeEOXIdwtFNbIiTKulGcLqqGa/oE7XIG6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iqtfY2aX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iqtfY2aX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5EDC4CEC5;
	Fri, 11 Oct 2024 01:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609750;
	bh=sHG4UJNomzhpeEaSl/uEssJkvHYlmQ/JjgSTusLiZCU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iqtfY2aXZ+7z0+nnD0fAJ9BUmXXEXjK1JOjiXQ5HanDmRUb4ih14NGH9Uc7H8GjEy
	 ywcDhgLed7Mh+TMaON96B3noQRZ/Mrnd3bn2eUN96OpgGezFAQ7MfoFGA4IUM0gj8I
	 FgBmW3xlGluaVQXWbPBnDbp5tzq2L9iflAl3DLcnO+fh2JokVYMY3F3J+onkJVAmm7
	 pvBt/jMSAjY5VF3iU8w7MHOzu+C5vnBEMn2Q0DrohC8f0jQpEb9B5NuLNWGrKgRRmg
	 C+1Azhs/66y8dLpCCaRbwtrO0hXYstkJgAgsiYat1lXOSc8xYycjzy712x3TP6YKbr
	 Cabz/Z/69+6eQ==
Date: Thu, 10 Oct 2024 18:22:29 -0700
Subject: [PATCH 32/38] xfs_repair: drop all the metadata directory files
 during pass 4
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654468.4183231.18372098805615461877.stgit@frogsfrogsfrogs>
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

Drop the entire metadata directory tree during pass 4 so that we can
reinitialize the entire tree in phase 6.  The existing metadata files
(rtbitmap, rtsummary, quotas) will be reattached to the newly rebuilt
directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |   14 +++++++++++++-
 repair/scan.c   |    2 +-
 2 files changed, 14 insertions(+), 2 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 9d8a027610c601..fb234e259afd83 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -656,7 +656,7 @@ _("illegal state %d in block map %" PRIu64 "\n"),
 				break;
 			}
 		}
-		if (collect_rmaps) /* && !check_dups */
+		if (collect_rmaps && !zap_metadata) /* && !check_dups */
 			rmap_add_rec(mp, ino, whichfork, &irec);
 		*tot += irec.br_blockcount;
 	}
@@ -3123,6 +3123,18 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 	 */
 	*dirty += process_check_inode_nlink_version(dino, lino);
 
+	/*
+	 * The entire metadata directory tree will be rebuilt during phase 6.
+	 * Therefore, if we're at the end of phase 4 and this is a metadata
+	 * file, zero the ondisk inode and the incore state.
+	 */
+	if (check_dups && zap_metadata && !no_modify) {
+		clear_dinode(mp, dino, lino);
+		*dirty += 1;
+		*used = is_free;
+		*isa_dir = 0;
+	}
+
 	return retval;
 
 clear_bad_out:
diff --git a/repair/scan.c b/repair/scan.c
index 0fec7c222ff156..ed73de4b2477bf 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -418,7 +418,7 @@ _("bad state %d, inode %" PRIu64 " bmap block 0x%" PRIx64 "\n"),
 	numrecs = be16_to_cpu(block->bb_numrecs);
 
 	/* Record BMBT blocks in the reverse-mapping data. */
-	if (check_dups && collect_rmaps) {
+	if (check_dups && collect_rmaps && !zap_metadata) {
 		agno = XFS_FSB_TO_AGNO(mp, bno);
 		pthread_mutex_lock(&ag_locks[agno].lock);
 		rmap_add_bmbt_rec(mp, ino, whichfork, bno);

