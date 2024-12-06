Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08F61F3D3D
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528942; cv=none; b=Mxk0oZc5cUO0+Tp2edyE4JjaBGcNTunJjePqTN0y5MVuu7fxW0uFACDFxVKzIWs3EyFaO5ZY59el/mh1MHFeGMIj5njlROjXD56dveX4XfS0tAf142yl6GOCTCSBRMHcLU9KvqqlgQhG7euUcnOtgIKUDdxTVeWocdP5iDBEeks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528942; c=relaxed/simple;
	bh=O2S1O8gO8ZH6KMu2IbA9sI1zdwZ9FXkMuP0oezHdUR0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CMyXAKGvBQBNZTMeBoqGLoA8mLXi9KZbDcDU53JIJtFEcqThYpTarzp52nwDV9nP/GMl+IeKONQ1tLvg7poKo5wDzBDU1f2UXOxBaKn/8HP9dx+a+xC3JTDIVJqU9mOsnGbN1rsgrjzd6qYdqqI/+95EnqKTVWrVogiRD/iJROk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QAZxxLe7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QAZxxLe7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FCCC4CED1;
	Fri,  6 Dec 2024 23:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528942;
	bh=O2S1O8gO8ZH6KMu2IbA9sI1zdwZ9FXkMuP0oezHdUR0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QAZxxLe71OQVJf9mbyoTfuhTuEdKNUBXo0L3TqNo5PC+gb5HspuE6lepyA7P4cL48
	 0oZ27m8rMBRUsw4ukKNkGrgoLHFOrvyZN68IEUk9Tlc4kA3S2zLXXMzs6d5Sd89jvu
	 CfPs32ap8auZ9xirE4MRFRUAGVOsSicyZfpc5IT9RoqLYuOLOHHGxuRhGD0+CBan0D
	 aS6kCxP+lEsA1WIyJoAXO7UoFcb1wYaKHf+aZ0q1JhPDsNb46vS+/dCt6EuAN+ae+o
	 /4SmJ/NK82CQfedlNas5DJHc3zJ2vnQetEdDtW1GM+LLquDYZ7DINypKqstlcvp9P3
	 gPgq+grMVg0XQ==
Date: Fri, 06 Dec 2024 15:49:01 -0800
Subject: [PATCH 36/41] xfs_repair: drop all the metadata directory files
 during pass 4
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748786.122992.11426516667642776775.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
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
---
 repair/dinode.c |   14 +++++++++++++-
 repair/scan.c   |    2 +-
 2 files changed, 14 insertions(+), 2 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 4eea8a1fa74ea3..9fea0cedd71cfe 100644
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

