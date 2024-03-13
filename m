Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F188BE0
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295846; cv=none; b=uKwRKH25gLxRy1nf8m0qI5L+/NqIQQs/87rmNlbOTILnVOpZ2vTllyNGiWdcwFnhN2XmMsK+vZMNpZEnOvONrJ56x9sz3wLAdW5mww9ps6fudY7SNdgk/OC4zK0qQhb1gwukqPnOgEHbYc38RNT2k4NwMe+Lo8kOkMXDKuZ8GKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295846; c=relaxed/simple;
	bh=OdIy7L+j69FjI8DILFBcjLuf9qIuHa8ZnYxTvRUnJQI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pvxxSegfhMeZEulDrhC7BDL3YOFjC48YSQmWvR0JfyA5j3r5zXiEyGv72GiNcYh6ZwG+0OOmzARtJyh7Ra55BenGPcWBdSyheEwnC4syVAoJ4Y8mcU4Tj9A2MBNVYvQ5PDJRBZY32b+NYKUwYAor+W/0DOHVHV+fw629cGgf4iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hGD99oRg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hGD99oRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E760C433C7;
	Wed, 13 Mar 2024 02:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295846;
	bh=OdIy7L+j69FjI8DILFBcjLuf9qIuHa8ZnYxTvRUnJQI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hGD99oRgeqO71gR34hKnU1KO2Jld4lSySPvLpMgFm2B3KJ6PlVRPPvsA7vjCVZ5cB
	 g+GNO0Ny3H0QK6WltdAUIvQ1+xZwDvb2Bm9iC53ML1zt3coKIrYtnpgp2XvNnIQCPt
	 6Rdp8VpuRvhpo1qmaKr7I8nQt00dJkULFo911bKASL3JmNmrSMHeFM60VaFnGrO3iS
	 sXkfmPbEBVjj2y/KIHJYdTNi71f5MIawNBGxGscIwRLIbItZ+4n6b4qhCF5N0xNbYW
	 uemBH/cBMUVFS6mMFh8SWQGYj1slbH0mww1WAu8UiFw8NUTOkZqYAo9TBBwn4YMMi5
	 FTuuA2NUP04NQ==
Date: Tue, 12 Mar 2024 19:10:45 -0700
Subject: [PATCH 1/2] xfs_repair: adjust btree bulkloading slack computations
 to match online repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029432516.2063452.11265636611489161443.stgit@frogsfrogsfrogs>
In-Reply-To: <171029432500.2063452.8809888062166577820.stgit@frogsfrogsfrogs>
References: <171029432500.2063452.8809888062166577820.stgit@frogsfrogsfrogs>
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

Adjust the lowspace threshold in the new btree block slack computation
code to match online repair, which uses a straight 10% instead of magic
shifting to approximate that without division.  Repairs aren't that
frequent in the kernel; and userspace can always do u64 division.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/bulkload.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)


diff --git a/repair/bulkload.c b/repair/bulkload.c
index 8dd0a0c3908b..0117f69416cf 100644
--- a/repair/bulkload.c
+++ b/repair/bulkload.c
@@ -106,9 +106,10 @@ bulkload_claim_block(
  * exceptions to this rule:
  *
  * (1) If someone turned one of the debug knobs.
- * (2) The AG has less than ~9% space free.
+ * (2) The AG has less than ~10% space free.
  *
- * Note that we actually use 3/32 for the comparison to avoid division.
+ * In the latter case, format the new btree blocks almost completely full to
+ * minimize space usage.
  */
 void
 bulkload_estimate_ag_slack(
@@ -124,8 +125,8 @@ bulkload_estimate_ag_slack(
 	bload->leaf_slack = bload_leaf_slack;
 	bload->node_slack = bload_node_slack;
 
-	/* No further changes if there's more than 3/32ths space left. */
-	if (free >= ((sc->mp->m_sb.sb_agblocks * 3) >> 5))
+	/* No further changes if there's more than 10% space left. */
+	if (free >= sc->mp->m_sb.sb_agblocks / 10)
 		return;
 
 	/*

