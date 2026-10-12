Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9CA39DBCC;
	Mon, 12 Oct 2026 05:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784749; cv=none; b=n7bu9qtn9QuP11ZXuG2nG+C29U9apczxIjZcZiZZ5GuNPLaO1js/PqVZ36Gdl52A9ZYxT5SJEaJeqLOWB4JyX81x5Do7HnBBz8QRQ7i33JwLm563hbN6eEukGPI4pWnaNiQOlz8ROj1nJXtBk5rGKJJg2TioswwSefbjeeUorYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784749; c=relaxed/simple;
	bh=JTWwyJ+GuW+Y2L/OsOcWbzaLugnT5i80fGhjTP6Nwbw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AFFjZKcCF5RuFGg0NaM0cQupbk9Xfn7IVJ9qZ0D8HEC8tjma5gyzKk7rA7BJY9DbaaJAajY4sfW7WW4pYwN7t9FKeMSbuU2zCo1ioiM43dqIj+P8L7PCLJN3VFYj+H4nt4VJmxQxqRfJ+bol3gP46N4RMFQy72WBg9nRjgZynIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IKt+LZ/l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IKt+LZ/l"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D66451F0089B;
	Mon, 12 Oct 2026 05:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784747;
	bh=60hQEpUfdJ4E0yyTd54LasBfrJ6VLUlt8mYTuf07WI0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=IKt+LZ/lV0XzP96AmAr+PhAQMQ20mYZiP25m/7cI2MMrGIzja8l2Dj3xGQYWPsxo2
	 lGCxS11pj9TJ1vM0psjiaJghRbhkfyPfs5f+4ciQoflRBOfOjQG97NrQh6YRY8RjNT
	 rD8qhsW0Piu+G/i64TYYYYIdCDJnN/mDYbxlcWvXucUKLNXiewm81H22XRMCwiAS4E
	 5ScdNTwVc9grdEaFc+UAip6hlsBVPPKs4ptxCefAB1yXDj4nEGc+6+0lppiS2kIJjM
	 qJc5V8GObhNNeSjBanD39HibK5KhnnXPvixZWKUptaVi287YgnDVIrnR1DOLuW56Hd
	 UMQBNST+XMP4A==
Date: Sun, 11 Oct 2026 22:59:07 -0700
Subject: [PATCH 01/12] xfs: don't set a metadata directory's parent to
 sb_rootino
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179178065816.1058822.16755886855029594169.stgit@frogsfrogsfrogs>
In-Reply-To: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that it's weird to set a metadata directory's parent
inumber to the regular directory tree root.  Fix this even if nobody's
ever going to notice this because metadata path lookups don't access
dotdot.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: 4f3d4dd1b04b2b ("xfs: define the on-disk format for the metadir feature")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dir_repair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 4a0b912b657696..bb3f2f462bde56 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1674,7 +1674,10 @@ xrep_dir_swap(
 	ASSERT(sc->ilock_flags & XFS_ILOCK_EXCL);
 	if (rd->pscan.parent_ino == NULLFSINO) {
 		rd->needs_adoption = true;
-		rd->pscan.parent_ino = rd->sc->mp->m_sb.sb_rootino;
+		if (xfs_is_metadir_inode(rd->sc->ip))
+			rd->pscan.parent_ino = rd->sc->mp->m_sb.sb_metadirino;
+		else
+			rd->pscan.parent_ino = rd->sc->mp->m_sb.sb_rootino;
 	}
 
 	/*

