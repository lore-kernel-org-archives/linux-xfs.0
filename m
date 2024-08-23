Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC8615BB
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372048; cv=none; b=kld6xHjpV6dPGTmuPMCJu6fwiVt/bBDo6F+zlTpNVqtQso37MB0HQojFBkbfGJ+b0zViJ7FHJegmk3iigB7jY6tUnugBQAbb4kMUGV8wTsMWEU6hdrY2tlLyFDs4htgmnrqgDsTsxGzFIsRO9dHUKr0YMOzlwAVNLiYhSAjCHZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372048; c=relaxed/simple;
	bh=+x4z1G+4tOi+7Abo/E4zpmt+4FM/QmLqipzg1qO00Z8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tDyZAl21xNCgBj8BGPNhSJIMsEykIbfu9+Hjr9kTpKHFbgN9BLeOl9Sn0TDB7Oo6Lw1O17kG3tarfoL2MHco5eEOWe8U4P7dVIcP/e964J23Xvjh4O/cIr74DY3SAp794OFcG7AlHjIcyT3yH8Z4XJLs+XI2Q5MaZ+CG0RjuZzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aMTf3Iy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aMTf3Iy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FDDC4AF09;
	Fri, 23 Aug 2024 00:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372048;
	bh=+x4z1G+4tOi+7Abo/E4zpmt+4FM/QmLqipzg1qO00Z8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aMTf3Iy8F1wBiNQTbk/igmlSDdi4HDL12U7ZjCNu+ZZx4LSDbosq3RIV9vuvtNtEZ
	 EQBSIgLJvmsO0xviwf61NoaieKBqGs1kH7utG7n8Ts8HRLyc7VuBZ9h0lZxLf3VF+2
	 fenxt+FOB9EeWOljCtJDE6DN6VRnR5lBOwgGUvxGvkJHwNmLc4YmG5tYFb7wPLOHS7
	 jAJDUgwKpQOAuIRLQ0rf42EsQdyXRPUwjEyAR1c6OZkWPPz0qHGB47ffHvgxPpktdE
	 STKBJIND8haN9+0tjrQetuuOuhObT4g36hoFeYmFQBi7ovLF8UUH0Aoc6jik2za8tW
	 w00oToldqRq+w==
Date: Thu, 22 Aug 2024 17:14:08 -0700
Subject: [PATCH 08/10] xfs: fix broken variable-sized allocation detection in
 xfs_rtallocate_extent_block
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086754.59070.15167835843175811059.stgit@frogsfrogsfrogs>
In-Reply-To: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
References: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
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

This function tries to find a suitable free space extent starting from
a particular rtbitmap block.  Some time ago, I added a clamping function
to prevent the free space scans from running off the end of the bitmap,
but I didn't quite get the logic right.

Let's say there's an allocation request with a minlen of 5 and a maxlen
of 32 and we're scanning the last rtbitmap block.  If we come within 4
rtx of the end of the rt volume, maxlen will get clamped to 4.  If the
next 3 rtx are free, we could have satisfied the allocation, but the
code setting partial besti/bestlen for "minlen < maxlen" will think that
we're doing a non-variable allocation and ignore it.

The root of this problem is overwriting maxlen; I should have stuffed
the results in a different variable, which would not have introduced
this bug.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 3dafe37f01f64..4e7db8d4c0827 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -246,6 +246,7 @@ xfs_rtallocate_extent_block(
 	xfs_rtxnum_t		end;	/* last rtext in chunk */
 	xfs_rtxnum_t		i;	/* current rtext trying */
 	xfs_rtxnum_t		next;	/* next rtext to try */
+	xfs_rtxlen_t		scanlen; /* number of free rtx to look for */
 	xfs_rtxlen_t		bestlen = 0; /* best length found so far */
 	int			stat;	/* status from internal calls */
 	int			error;
@@ -257,20 +258,22 @@ xfs_rtallocate_extent_block(
 	end = min(mp->m_sb.sb_rextents, xfs_rbmblock_to_rtx(mp, bbno + 1)) - 1;
 	for (i = xfs_rbmblock_to_rtx(mp, bbno); i <= end; i++) {
 		/* Make sure we don't scan off the end of the rt volume. */
-		maxlen = xfs_rtallocate_clamp_len(mp, i, maxlen, prod);
+		scanlen = xfs_rtallocate_clamp_len(mp, i, maxlen, prod);
+		if (scanlen < minlen)
+			break;
 
 		/*
-		 * See if there's a free extent of maxlen starting at i.
+		 * See if there's a free extent of scanlen starting at i.
 		 * If it's not so then next will contain the first non-free.
 		 */
-		error = xfs_rtcheck_range(args, i, maxlen, 1, &next, &stat);
+		error = xfs_rtcheck_range(args, i, scanlen, 1, &next, &stat);
 		if (error)
 			return error;
 		if (stat) {
 			/*
-			 * i for maxlen is all free, allocate and return that.
+			 * i to scanlen is all free, allocate and return that.
 			 */
-			*len = maxlen;
+			*len = scanlen;
 			*rtx = i;
 			return 0;
 		}
@@ -301,7 +304,7 @@ xfs_rtallocate_extent_block(
 	}
 
 	/* Searched the whole thing & didn't find a maxlen free extent. */
-	if (minlen > maxlen || besti == -1)
+	if (besti == -1)
 		goto nospace;
 
 	/*

