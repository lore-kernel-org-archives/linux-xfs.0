Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A189C8C7
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609001; cv=none; b=XLXg1gnHZJu7H6bwJNAKRSLAEOrqGmBqpRmu9FRWrKTLC4hZUnU98+HQkSTQOcFHVbfzWd/ilPxSuOJmA3E4RirfnTBawRuQ8tekLxKCinTMWRW1yy/FCwcFJzrYhhK51fj2r7UMRsqd5a978MBS0r8c9iSPz8HoFBIYp7DKVeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609001; c=relaxed/simple;
	bh=KU9BwRVkpPhG+2ZG+zbojsZrsJs+sQug+KoB0CuyfJ0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e9nULPCMGCNQEkWzcmILshFBXLXSg+Vn5tPbeuVA2i9rscFLcjd5sKbQBiJRFcuyr4j86YEA2qPdbd/4hETwrImENvCXml65tSySMBrv5dhoz9R15RqA4wHPaXbiIgKKkg/yH3reaxhkolQM4f1lVn5qA7okE/GPF2o9hhxdnW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VoeoFbip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VoeoFbip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEC4C4CEC5;
	Fri, 11 Oct 2024 01:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609001;
	bh=KU9BwRVkpPhG+2ZG+zbojsZrsJs+sQug+KoB0CuyfJ0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VoeoFbip1GGijVThAwdP1nNbXIs1671O1jekAUX9eadvvQ3RjOXt8vwpaS8HIFT2W
	 mRQJy/Wnp1In0+1q1zhVvHLfXS7O6ZnE86R/iI8iri8EOknjpCDepBX8u0YM8dqn2u
	 I7HUawKEdU3HsOA+YzOryCqTJQBbFD3w8bFA/UiSpJxXRJl9xQpljUD3VPe6dw47Bk
	 MQKVVh3iFs7WwjNekjlAZ7D8leboaejgG5RDLJqBJJeWdW9XZHJotuKzCt6N1SO59/
	 Rmo6qaHgYWrOZUEk843cE3IwGfPBciX4tryBtGW17gRRlQA4A5SJp0aPoijwIZfNMW
	 UhZH/4m/qZnOA==
Date: Thu, 10 Oct 2024 18:10:00 -0700
Subject: [PATCH 32/36] xfs: fix minor bug in xfs_verify_agbno
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644795.4178701.7276354025328848629.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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

There's a minor bug in xfs_verify_agbno -- min_block ought to be the
first agblock number in the AG that can be used by non-static metadata.
Unfortunately, we set it to the last agblock of the static metadata.
Fortunately this works due to the <= check, but this isn't technically
correct.

Instead, change the check to < and set it to the next agblock past the
static metadata.  This hasn't been an issue up to now, but we're going
to move these things into the generic group struct, and this will cause
problems with rtgroups, where min_block can be zero for an rtgroup.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |    2 +-
 fs/xfs/libxfs/xfs_ag.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index a0b2b54309522f..ebf645a3dd8963 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -221,7 +221,7 @@ xfs_perag_alloc(
 	 * Pre-calculated geometry
 	 */
 	pag->block_count = __xfs_ag_block_count(mp, index, agcount, dblocks);
-	pag->min_block = XFS_AGFL_BLOCK(mp);
+	pag->min_block = XFS_AGFL_BLOCK(mp) + 1;
 	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
 			&pag->agino_max);
 
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 242346872351c1..1671cd5ce3020a 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -216,7 +216,7 @@ xfs_verify_agbno(struct xfs_perag *pag, xfs_agblock_t agbno)
 {
 	if (agbno >= pag->block_count)
 		return false;
-	if (agbno <= pag->min_block)
+	if (agbno < pag->min_block)
 		return false;
 	return true;
 }

