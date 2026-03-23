Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42F9320A24
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291701; cv=none; b=m8MF8oZ+8BsWbCOL9va5sSd68X8h+yDZgpyKkNB1GhvhRkoiqSCy2xjYIzzvWCkQOVUJMnuhlKFdHPoC7yueX3lCAtxej4KJW9xFo7uOnn7++3nYb/3ZkhcrsBoDRhr7kNt377dzyTpEulJ8ZfrQWgHnLQWWXbQoO9W8bLln3jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291701; c=relaxed/simple;
	bh=YENs4bmcsgJKw/hm0cfjktZQ50SonArZ/+CrwE3/pcA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RYPTqGj6CdEDE84ayseV6OsJ3T55yV44FsalWoJV17H5W7ED7BZ80X5YOtiUjQ7l97oHSo30x2rrQU7V9WFeO6BRyKaIbzsqfnNPNqM7sVpx0oG1I9lTK3iiygtdzaxhIhetL1oFPK2o32T9XU3lvGXFsAY5b46MRjwVm/Ii9AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eyXOGW+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eyXOGW+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E8BC2BCB0;
	Mon, 23 Mar 2026 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291701;
	bh=YENs4bmcsgJKw/hm0cfjktZQ50SonArZ/+CrwE3/pcA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eyXOGW+ua80wxyennW3AmKqrmO0CgUTx8h1JJZSe0lW8yR0cPwgzmi3HB2ZF1EZya
	 uhtL4HbEusP6dzh8KTgvbpwJQizozUU/nE9Ghi99sEVol5VbAtsZfJhsEg17DwfeNa
	 P4JFlCoDqX83dOfG1jgU/pvI4qPq6bp4j1er1TLr8+IAVOGLKeNF5QcTi3sd5u2Eyw
	 w4ShRhOB8o4EegQ4WraBgwK8oId8mXajUdw8N0bunnSU/6AxU9PQEZsX5SxHZ4FzZj
	 LWr8K2nSelNtpIo6vBGFE/Jl3lP1iY5A2akdJv9NFgfwKv1rRCS1hISy4VBm67yUnV
	 5yWQtxYOJQJQg==
Date: Mon, 23 Mar 2026 11:48:20 -0700
Subject: [PATCH 27/40] xfs: fix spacing style issues in xfs_alloc.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, shinsj4653@gmail.com, linux-xfs@vger.kernel.org
Message-ID: <177429121236.2266274.13542319239358959127.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
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
 

