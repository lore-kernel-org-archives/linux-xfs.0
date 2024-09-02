Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E0819CC04
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301748; cv=none; b=YqEWp5QfnQnxZS+kPBy2kn1IQEB0DYEZB+ty02hkvMKXCw866rMik1a/qU8WNp6qhq0f40HEB7cMA31XMkkjz5qs3xqJZTVVeD4mW4dGG9p7Y7tQnDpYa+WZrESB8coyMHKfhP//jCv1iLlJgvElbvby2L+se/ofe2zvUamavbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301748; c=relaxed/simple;
	bh=3sIdlBYkG592+tuhX8+J4D0TGI3nZiv6KsmPJX8bEa0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A9CRu2V4cX6f4PhvTY3bjr0MklrcAeKk4sGBu2DOF35EcQSfCpROt1HEavci+colIUfK7PEkHZJ5US1370c0dE4QQ+TRoxNODHerqNvbs1SmX33H9zXkV/SaII9oyBaKf6CY30BmOaZCLjaMl9zI6I5/EobS1PHpx85bsh3D7HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dz7OdJh+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dz7OdJh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D119AC4CEC2;
	Mon,  2 Sep 2024 18:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301747;
	bh=3sIdlBYkG592+tuhX8+J4D0TGI3nZiv6KsmPJX8bEa0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Dz7OdJh+wtPqAySWE3FEhS0FAkBxrp2vKXfnzB8k/d9GnkanLCQTev+w5o01+lJyj
	 5Ncp3VPjAS5+7NjmsvixaUHRPgdlhyw2jNxGSVuiO5+a8mC1Ep+L6VGJYtQoAK4IX/
	 caE389wqQujtVweHyZgg3g5QWjxQSB/yAmd8lY6D+GGI4LS4DYn8xce5J72ok05K0v
	 ELsTpdJ9Hj9aQmBl8sswAyP/W0QYAPPwBDFoxlJIa47+r3qldHqW0Wn+9zhaKdZFca
	 NRvhbysfydVnS+YxwZgLgDVF2w+jHs+/imY5+M4toOWiVNffSvEuofU/KPyX5xcZjT
	 eS++FhOZH50kA==
Date: Mon, 02 Sep 2024 11:29:07 -0700
Subject: [PATCH 08/10] xfs: fix broken variable-sized allocation detection in
 xfs_rtallocate_extent_block
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530106389.3325667.16691450577382253644.stgit@frogsfrogsfrogs>
In-Reply-To: <172530106239.3325667.7882117478756551258.stgit@frogsfrogsfrogs>
References: <172530106239.3325667.7882117478756551258.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index d27bfec08ef8..72123e2337d8 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -244,6 +244,7 @@ xfs_rtallocate_extent_block(
 	xfs_rtxnum_t		end;	/* last rtext in chunk */
 	xfs_rtxnum_t		i;	/* current rtext trying */
 	xfs_rtxnum_t		next;	/* next rtext to try */
+	xfs_rtxlen_t		scanlen; /* number of free rtx to look for */
 	xfs_rtxlen_t		bestlen = 0; /* best length found so far */
 	int			stat;	/* status from internal calls */
 	int			error;
@@ -255,20 +256,22 @@ xfs_rtallocate_extent_block(
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
@@ -299,7 +302,7 @@ xfs_rtallocate_extent_block(
 	}
 
 	/* Searched the whole thing & didn't find a maxlen free extent. */
-	if (minlen > maxlen || besti == -1)
+	if (besti == -1)
 		goto nospace;
 
 	/*

