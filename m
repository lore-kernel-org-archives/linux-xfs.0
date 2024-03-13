Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212BBC13D
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710296159; cv=none; b=VBTPGF+RVIQDU1A4y9gzZnoc8gLDrZhdxx35SZfLxJkkK6h0s5pbDi20kkjbazn6qfpkwMkR9EMzPKkg9WAmThQ+Drzbq2I9C1equEHm+U9Mh410X9jvm7TUI/fni9gp3PorbLPGCMXcbACuQ/0DVHv0MVozDQJtoSdgehKo1tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710296159; c=relaxed/simple;
	bh=ZnsI6GWbGchmRhLy6XBqBWnnFaLLHJfDgWNZErryit0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UhVGda/58XEpOeWMep18iWbZY5vSI578n6r0I03Yxuvn6KA9tCM0rDK0gXKeo3/pI3LAKRx1uFsRvev5faS3TxsGoacRASsaa+1+aSAsOKbm8N97GrT0A4oFN2gC35CVxt7y0w1oE+qf9gfsbq9etU9tRcW13xfTkteaKlRUKjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cbh0TU18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cbh0TU18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE805C433F1;
	Wed, 13 Mar 2024 02:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710296159;
	bh=ZnsI6GWbGchmRhLy6XBqBWnnFaLLHJfDgWNZErryit0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Cbh0TU18FPsYt2ZYm964wrYjbZ4vk4QJXxYEW1wEeYtXcoOlpa16OWoIsxABwaaDp
	 6kNDWpsf3rKbGaInVG/FQlKwgZdYCRVu4PFP9zPO3gERUBiyc9sTUVT/lzSASIzfW1
	 6ax0ADOb9jpU5x6zer82X6BNQWKaMn2GcjwhPT0jsbIT3dcTsnd1Ou1Qdxf8afOAk5
	 S8fqhFLoKz6qRfpBV/jUttQpdMZEmPdgjEic/oKFRQ8jBoPr692A1sLjtoXO51/udC
	 fmWg61cmCZv8hvo0+YM8KThuyVPtuCpXrMLtUr3FjDhUAj7s6w/Sbnqs/YcGrxYqsa
	 hhQNYrl2HPKcA==
Date: Tue, 12 Mar 2024 19:15:58 -0700
Subject: [PATCH 5/8] xfs_repair: clean up lock resources
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: "Darrick J. Wong" <djwong@djwong.org>, linux-xfs@vger.kernel.org
Message-ID: <171029434801.2065824.8093618587875439562.stgit@frogsfrogsfrogs>
In-Reply-To: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
References: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@djwong.org>

When we free all the incore block mapping data, be sure to free the
locks too.

Signed-off-by: Darrick J. Wong <djwong@djwong.org>
---
 repair/incore.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/repair/incore.c b/repair/incore.c
index 2ed37a105ca7..06edaf0d6052 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -301,8 +301,17 @@ free_bmaps(xfs_mount_t *mp)
 {
 	xfs_agnumber_t i;
 
+	pthread_mutex_destroy(&rt_lock.lock);
+
+	for (i = 0; i < mp->m_sb.sb_agcount; i++)
+		pthread_mutex_destroy(&ag_locks[i].lock);
+
+	free(ag_locks);
+	ag_locks = NULL;
+
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		btree_destroy(ag_bmap[i]);
+
 	free(ag_bmap);
 	ag_bmap = NULL;
 

