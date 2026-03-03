Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5060C1DEFE8
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497122; cv=none; b=aF7gyCoMOMan1j196umsbUQfEQFUfDkpUgDibDQIPJ6O9IVTM0MOL/fP9Egyo0I85KLbU8ULRrR5efAOGPM0kNp5U4VwNO6xj/c5E3QOxP2owQowcUgXkF1KV1Ton4ngRXZp/6Tejfz2e7idP9ZtINLSRzXvqWGySfdu6c9gSPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497122; c=relaxed/simple;
	bh=YENs4bmcsgJKw/hm0cfjktZQ50SonArZ/+CrwE3/pcA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OI3q2w0UMHmPW3oW+b11FDVfuH3r+fSqGZRG08Y5wdmpdt8aKywnSerwInA0gX4Wcw4atoixs2fOnjEMM+N6z4Q6IKyt/rM12Kf0QSb6Lr5/0QSWpoPYH9R0xF9qy/bunKZooDP2PoZYq3BbDeNBdSDqksb0WqePenot1pcyrLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q0B9Inhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0B9Inhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB857C19423;
	Tue,  3 Mar 2026 00:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497122;
	bh=YENs4bmcsgJKw/hm0cfjktZQ50SonArZ/+CrwE3/pcA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q0B9Inhvdzj06j4RM8MpsTEkc3bW882JZtVuGrVrWz6/4b1sH4YhqKxCmEzoBKw4C
	 Nk0GDOWSv35oCM9urOxZdpfvSC9tEDYKCv/X+iWAz9w4eUrX+bjZI19gsmoJsS3qex
	 8w1RhuBndB08i1hNLswxI4LS/BDwLSFbUYODmCjfoA3DDBRqfG+aRmY8EEKREXKFAo
	 7nw/iuhQaDTjcGLoTB647JEEPZkO1HtbtfnqPYzY5j7Wv14cQcgSaYDI9ppMpVG5AY
	 wYjC3pjONWposvZMw+aAMfOCP2bMgySeJlLj6HCNrk+NJxsALY5cFAOpfogW3Kj+lX
	 Vxt7M+BirS+zA==
Date: Mon, 02 Mar 2026 16:18:41 -0800
Subject: [PATCH 25/36] xfs: fix spacing style issues in xfs_alloc.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, shinsj4653@gmail.com, linux-xfs@vger.kernel.org
Message-ID: <177249638238.457970.10333179272852692004.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Shin Seong-jun <shinsj4653@gmail.com>

Source kernel commit: 0ead3b72469e52ca02946b2e5b35fff38bfa061f

Fix checkpatch.pl errors regarding missing spaces around assignment
operators in xfs_alloc_compute_diff() and xfs_alloc_fixup_trees().

Adhere to the Linux kernel coding style by ensuring spaces are placed
around the assignment operator '='.

Signed-off-by: Shin Seong-jun <shinsj4653@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 9f92bd77fad76c..695ed830d139fe 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -372,8 +372,8 @@ xfs_alloc_compute_diff(
 	xfs_agblock_t	freeend;	/* end of freespace extent */
 	xfs_agblock_t	newbno1;	/* return block number */
 	xfs_agblock_t	newbno2;	/* other new block number */
-	xfs_extlen_t	newlen1=0;	/* length with newbno1 */
-	xfs_extlen_t	newlen2=0;	/* length with newbno2 */
+	xfs_extlen_t	newlen1 = 0;	/* length with newbno1 */
+	xfs_extlen_t	newlen2 = 0;	/* length with newbno2 */
 	xfs_agblock_t	wantend;	/* end of target extent */
 	bool		userdata = datatype & XFS_ALLOC_USERDATA;
 
@@ -573,8 +573,8 @@ xfs_alloc_fixup_trees(
 	int		i;		/* operation results */
 	xfs_agblock_t	nfbno1;		/* first new free startblock */
 	xfs_agblock_t	nfbno2;		/* second new free startblock */
-	xfs_extlen_t	nflen1=0;	/* first new free length */
-	xfs_extlen_t	nflen2=0;	/* second new free length */
+	xfs_extlen_t	nflen1 = 0;	/* first new free length */
+	xfs_extlen_t	nflen2 = 0;	/* second new free length */
 	struct xfs_mount *mp;
 	bool		fixup_longest = false;
 

