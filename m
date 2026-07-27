Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C570233723;
	Mon, 27 Jul 2026 05:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129797; cv=none; b=hR09wYP0oP/ItAr2aHG0c2askMK0XZk025RoXtaT5fNRs4fIiCXhA41J0rnYpRAzYY3OKAgeHiesmLT61h/UHbggTSBIb3ahkq7L5Bj4UwF1C/BZAlLUKvrsoItje9V0yIsHoUdrGJq7okqZmlvGZriIk+qbokps10m4g45k27c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129797; c=relaxed/simple;
	bh=0s6yICiEJXjDZf8dfdga4FqtFljpGTVywY8SqVjgVR8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MAMZC+R+DVG35ljkhtvVGgGbsmnLFZcrWux3hIgpyzFCiFAolJZGx/b+eEHn6XbqOVG2QPIk2uk+NGJXxz02HLKtN3GyP982C8Bsgp1nfQd1bO5P96Yadak6QUmKqTXnt1UdkrL/5pI93d+sRPnAoKvFRPisIa57a65yrEGK/HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MPpTXedk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MPpTXedk"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E23861F000E9;
	Mon, 27 Jul 2026 05:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785129796;
	bh=ocJCKG8l3OaFXT+E8pLXMdsuCVkSuYD9vYhEeSH2z3s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=MPpTXedk2xGI2+e60gx1ee05kgEMTj3X6v8LE5O1RV2IbKUfeCjlQ4blD9A8HoD2S
	 MPS10vRuD9SpPHiNyMdcxoQ0wtHRf7cVMdczFByugAU+ZnQubv9+9S93oHPDXCdhzq
	 JetkG+2NrZyKkEuSolVcdmrpuGHCzLxaH2DQ3Jg5lFTc+0KMzVa+zgEjCEhhFqUy0b
	 CEH1IEFGz6qLTxNEOTHTGdKDVoIqBlrcvsquI8ydRajAELov2DHp5eKapGErCaWcgu
	 /9YNv7Cn62T5Zzt4uE2xuH8ZgmNZX0zjP7wFqRgFes4pdUAs8UD3nEAdKXjnpE9lSs
	 +H460i+qUjFrQ==
Date: Sun, 26 Jul 2026 22:23:15 -0700
Subject: [PATCH 2/6] xfs: don't double-lock when deleting a self-referential
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178512389209.1494795.13770437422433825910.stgit@frogsfrogsfrogs>
In-Reply-To: <178512389129.1494795.16117444961252720216.stgit@frogsfrogsfrogs>
References: <178512389129.1494795.16117444961252720216.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM notices that the dirtree scrubber can detect a directory that
refers to itself.  In this case, it's not correct for the directory tree
repair code to try to iolock/ilock both sc->ip and dp, because they're
the same inode.  Fix this by detecting that corner case and handling it
appropriately.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dirtree_repair.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/dirtree_repair.c b/fs/xfs/scrub/dirtree_repair.c
index 1c0d7ea4a5be6a..bbf6acf6fd400c 100644
--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -349,6 +349,8 @@ xrep_dirtree_unlink_iolock(
 
 	ASSERT(sc->ilock_flags & XFS_IOLOCK_EXCL);
 
+	if (sc->ip == dp)
+		return 0;
 	if (xfs_ilock_nowait(dp, XFS_IOLOCK_EXCL))
 		return 0;
 
@@ -400,8 +402,18 @@ xrep_dirtree_unlink(
 	 * directory code can handle a reservationless update.
 	 */
 	resblks = xfs_remove_space_res(mp, step->name_len);
-	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, sc->ip,
-			&resblks, &sc->tp, &dontcare);
+	if (sc->ip == dp) {
+again:
+		error = xfs_trans_alloc_inode(dp, &M_RES(mp)->tr_remove,
+				resblks, 0, false, &sc->tp);
+		if ((error == -ENOSPC || error == -EDQUOT) && resblks > 0) {
+			resblks = 0;
+			goto again;
+		}
+	} else {
+		error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, sc->ip,
+				&resblks, &sc->tp, &dontcare);
+	}
 	if (error)
 		goto out_iolock;
 
@@ -489,9 +501,11 @@ xrep_dirtree_unlink(
 	xchk_trans_cancel(sc);
 out_ilock:
 	xfs_iunlock(sc->ip, XFS_ILOCK_EXCL);
-	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (dp != sc->ip)
+		xfs_iunlock(dp, XFS_ILOCK_EXCL);
 out_iolock:
-	xfs_iunlock(dp, XFS_IOLOCK_EXCL);
+	if (dp != sc->ip)
+		xfs_iunlock(dp, XFS_IOLOCK_EXCL);
 	return error;
 }
 

