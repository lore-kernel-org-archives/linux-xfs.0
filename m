Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BFD1E2609
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416763; cv=none; b=Z4aKJV0SPbM86MjDPgnx6TojfbjSairc/wvbj6KBR5KlQTkIvwKIAPcNhJVnUYmizbrUmbQAEz5fUXuOAE6Sm5m//JPT0Erg9ZQrdHI9JXobJzIkbAsum7WSmiSRw7hLtzqOAI3Qhi439JW9xhQ7xQ6NVcfD8cgjUZXZi2qEucc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416763; c=relaxed/simple;
	bh=88T5JNLfeHZi+5wRLkmnq5IGQELdjVRGa8xlsIk32K4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pnvZfxZE54Wwu5M0poBuk/H1NWEIOL4RHZS4OCnUWJHNdJarYAuhX7KNKz87YG8ws3HZ4ytMbb0F9wxr8txKaN+q7NAfvm5yEKP4kwfekFqnWMNYz/5oOQ2rEVgALlDXAMJE00PfeyUrKr4JVFavh0EmqV1OXhNLKn5WQHcMU/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DCjessrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DCjessrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EDAC4CEC3;
	Thu, 31 Oct 2024 23:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416763;
	bh=88T5JNLfeHZi+5wRLkmnq5IGQELdjVRGa8xlsIk32K4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DCjessrLnvFNd0/oV3JWY7YlxvIpGsyWHZA35KByyxY8QOxEX8b5AyOgqXAFu4iw/
	 WNFa4NoFr8Yzvk8l5ZGG/jOEtv7QWMaduHAvD9lHaR4vpGF2HzGSfaDafYoI1A0BWI
	 HOcjK5/i0m1OeJ+/dMP6Fucwfo5Jp6MpOKKRoWXi3YVtWN1S2Pr6QC8utu1Qyaw5Hi
	 UxdL5jAZNSjzwi+P0/1oSIhmMdxDnjVjm3y7QRzrdKUKBuxDFWvwcxUeYOOxuqs0Kk
	 smu5d4EzcOk7kp0vSO7QPGpgmnqkqpKZiJIfBCCRWe2CSJHWMNsvTX+nondFWwBqSf
	 8iEB5Xa7ZSm3g==
Date: Thu, 31 Oct 2024 16:19:22 -0700
Subject: [PATCH 41/41] xfs: update the pag for the last AG at recovery time
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566543.962545.13384145870546499319.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 4a201dcfa1ff0dcfe4348c40f3ad8bd68b97eb6c

Currently log recovery never updates the in-core perag values for the
last allocation group when they were grown by growfs.  This leads to
btree record validation failures for the alloc, ialloc or finotbt
trees if a transaction references this new space.

Found by Brian's new growfs recovery stress test.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ag.c |   17 +++++++++++++++++
 libxfs/xfs_ag.h |    1 +
 2 files changed, 18 insertions(+)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index a22c2be153a50c..79ee483b42695a 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -271,6 +271,23 @@ xfs_agino_range(
 	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
 }
 
+int
+xfs_update_last_ag_size(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		prev_agcount)
+{
+	struct xfs_perag	*pag = xfs_perag_grab(mp, prev_agcount - 1);
+
+	if (!pag)
+		return -EFSCORRUPTED;
+	pag->block_count = __xfs_ag_block_count(mp, prev_agcount - 1,
+			mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks);
+	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
+			&pag->agino_max);
+	xfs_perag_rele(pag);
+	return 0;
+}
+
 int
 xfs_initialize_perag(
 	struct xfs_mount	*mp,
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 6e68d6a3161a0f..9edfe0e9643964 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -150,6 +150,7 @@ int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t old_agcount,
 void xfs_free_perag_range(struct xfs_mount *mp, xfs_agnumber_t first_agno,
 		xfs_agnumber_t end_agno);
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
+int xfs_update_last_ag_size(struct xfs_mount *mp, xfs_agnumber_t prev_agcount);
 
 /* Passive AG references */
 struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);

