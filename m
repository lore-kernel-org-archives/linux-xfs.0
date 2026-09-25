Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1471922FD;
	Fri, 25 Sep 2026 04:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790309447; cv=none; b=kKC1ORgVNRe8vZ11C98EShv1qgrThHjF43LiHXcIAu84cjHJhoBVUClN7mWh60yL+Np/A827BO5fEN+M89eLhXc/huZGLSRtIF9sAP8oGI8ExwmNdkEpbEUC25aXNRrXkZnZBk8JGsLlZ9z9OSC407s1Mfczs6NUHWVqlfNQvy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790309447; c=relaxed/simple;
	bh=IO8nHUSCrv9pmk3oeaKfuw41L21V94bwcW68gT/BxWw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cr84fLORpc8a2p1AaIhwHtJ443q6NhkMVvcSu1bvFLEGPCYO0Qkr/sBeKL0JydkYm2s/PUe4GBiJybMI5gEIyuOshds01mQqxBPYwNF9UoI8yz34R7mCbaa3BU2QuOx/dKEzGvG5TwyINRiMfbszkjEuYjj1plJ5AJqy3HWILCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mozo48MQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mozo48MQ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 49B6B1F000FF;
	Fri, 25 Sep 2026 04:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790309446;
	bh=ZQfR0KMxnqyC1Dl54hyKYbajgKGmQE+VLDLLr/Codks=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=mozo48MQJMQ7kvOPQ1ll29+0D0xTNdUdaGngz3f1vRh0bATufC6dzo7SixNqSL9ZH
	 kI4yQRhA3fVwMU4MQEA07q0/HwzpLuEpzcJDsnFsXmKIxTJLYehIIy4+XIvf8/TT/U
	 wzjfP7AEiMQ/8Kgj4b8Lu5Ao/+lK/PlvmKwzq+mCOaOOQZ7V+8NF/wM/aoiDmszazy
	 2mSQjb433FHyRN7/Pj7iOmAc+n6HsUN+pKJwDrnbc22meVItGhV1j6fVhT2tWIhDuO
	 XVCFwGd9wkZQ+NyhkcIHjjw0uauuva0Qw0Mi4rTef8cPz5TKIm24VABZlcDquQnO0C
	 InNxUWDfjM/DA==
Date: Thu, 24 Sep 2026 21:10:45 -0700
Subject: [PATCH 01/12] xfs: adjust checks for cross-AG reaping issues
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179030932071.3344850.13288640767644794186.stgit@frogsfrogsfrogs>
In-Reply-To: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

While analyzing the reaping code for the previous patch, I studied the
xfs_fsblock_t code to reconstruct how this code works.  AGs have a
superblock at the start of each AG which means that regions in the
xfsb_bitmap (aka xfs_fsblock_t bitmap) cannot cross an AG boundary, so
we don't need a loop here like we do for xfs_rtblock_t bitmaps.

However, the checks here are not quite right -- there can be quite a lot
of reserved space in COW forks, which means that the bitmap extent
actually can exceed XFS_MAX_BMBT_EXTLEN.  We also don't have an explicit
debugging check that we never cross AGs, so add that here.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 66da11280f7ecd ("xfs: reintroduce reaping of file metadata blocks to xrep_reap_extents")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/reap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 1980baa6e5eed7..2cb626afa0099e 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -796,9 +796,9 @@ xreap_fsmeta_extent(
 	xfs_agblock_t		agbno_next = agbno + len;
 	int			error = 0;
 
-	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
 	ASSERT(sc->ip != NULL);
 	ASSERT(!sc->sa.pag);
+	ASSERT(agno == XFS_FSB_TO_AGNO(sc->mp, fsbno + len - 1));
 
 	/*
 	 * We're reaping blocks after repairing file metadata, which means that

