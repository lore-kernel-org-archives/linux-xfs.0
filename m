Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6421422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990968; cv=none; b=tvax5Nl+Drmu20+jEXKECZRO1z3QOK8v9bPSOuh81wRbkKaIZqZO4M9hQj8hqg+jAw8yLwgdNdGKWlIJ7G6pWYMBc58ass8bOYfys9HPDpM/8TeB7Y4NqUWNlwJjAWjtNq0SvsDJ7JWRTobnLBwAGA5c3Qt9joL2o3MF1zdW9yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990968; c=relaxed/simple;
	bh=tt5/BQJPtCEDRDcdBCtrjDfKHB55GPnka1Fc6Tgydm0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gQLiBMv6JEgCnYL5etkjQqhbwEs+LJpjXQDOSD6ajnCSvBnLpu1gsYMQqgcb2ql58fFBWX0zPdLZwe1p0N8dh4MWlOObXid63Jd5OZDut6N9Gr9cKoMLg2VR4fQwiAYfLqXhyw6Mm4rPAxlPNoAYXgjnkNtMmTFzX3S0NZ+juQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=osLY4jg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="osLY4jg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E753C4CED3;
	Mon, 23 Dec 2024 21:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990968;
	bh=tt5/BQJPtCEDRDcdBCtrjDfKHB55GPnka1Fc6Tgydm0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=osLY4jg62wAVyZ8x9shsXs3tpgvupE0g83iTEtrmdTvX86DKpa79oA/Mt5pPKFshD
	 GW7hPKWomwu3TnnrsiGouSjzNkZJioTlA4wlWA/UKNasX2L0mLXbzE0IdXzOKaB8im
	 DdOpasbB2SRWLq0QrUZACc6blOdDvvsHw5jgOz+bXjAfBeEu8UK1+BUm3kG+pEiVRi
	 B8Wesg1rvaWvNCmlQFfFHqs0yzPfQ05IJRfmQzLKii1UTmJ10MOhUun/RvSbUsE05D
	 eA8eKdODmXbi06ayv1ZiDxoYziCo3yhWBnr+gKGgtGYNkQItWuV/qsrxa8Fcnoyp4h
	 NlVGClLw8vXmw==
Date: Mon, 23 Dec 2024 13:56:08 -0800
Subject: [PATCH 37/41] xfs_repair: drop all the metadata directory files
 during pass 4
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941535.2294268.3801251769353928342.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c |   14 +++++++++++++-
 repair/scan.c   |    2 +-
 2 files changed, 14 insertions(+), 2 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 8148cdbc4f10ad..2185214ac41bdf 100644
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

