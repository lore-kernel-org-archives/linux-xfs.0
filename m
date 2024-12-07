Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3894256D
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530271; cv=none; b=Xijxat4QlHzF4SOh/7vjc6bItvUUeJRZVAtZy4oMccuJGHYuVDS1lxQhTYwFsyQDvzHoCs3KsvQxZhhu/VTknw1yA3eWb2Oxh5VWUP9PGZokXJIWGTu8/6wvxaMF9JIs0LMPV1dRrKccbugqHO3oudTC2/RoVEdOm577o80/dU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530271; c=relaxed/simple;
	bh=1dG0gB+ZjIOPsU6W+JVmpvGDYx7ElnpZVloDp0HtARk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZZa5au7LEku8rPYTNuDQ4SFUSq6Qodkp63Cmffi/bM9VZ5dZm4Po6PojsqL3F4odPSvefaTYNljMwG7zTx9niMmRpOsqHXa4K8SgeZJoyg3RgEPGjuWD65e6Xn13zsJqjfNxcU0ACuRTq49wMUttr9nhmadamMUSF70Pgh2vVU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e5axUeft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e5axUeft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F638C4CED1;
	Sat,  7 Dec 2024 00:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530271;
	bh=1dG0gB+ZjIOPsU6W+JVmpvGDYx7ElnpZVloDp0HtARk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e5axUeft7U7F1B2TL2WoFhMfa8ulObjjn9BvFCkaUKCNEBk8qwQ6UEGxM3goR3NQZ
	 O6GAtGDa1kkN9+V4enB8IiGp2d9d7PVninFMkQTcUfSpmYF4Fu7v60bvLh2q5Oz9Cw
	 T5apJFfONveVY0BwXV5FCgtVF70xbXQi7ds7SRwhfmm43rrRzdbkJh/Nu5sil8aKn5
	 CT5ABXHBdugrPUn2i9QJhM0z5Qg4NiBZSCi4cMevWrG5hCQqns8uoImnr4Nyb0ucX5
	 aqSGJr/KlBxMm00g33ZFMA35xSJ4Me4GhdS1sk77ST3KtKY1SZxR7wC6DQEkg49CRW
	 fC9Ek35QR9dfQ==
Date: Fri, 06 Dec 2024 16:11:11 -0800
Subject: [PATCH 24/50] xfs_repair: stop tracking duplicate RT extents with
 rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752311.126362.6980632236757578255.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Nothing ever looks them up, so don't bother with tracking them by
overloading the AG numbers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/incore_ext.c |    5 ++---
 repair/phase4.c     |    8 ++++++--
 2 files changed, 8 insertions(+), 5 deletions(-)


diff --git a/repair/incore_ext.c b/repair/incore_ext.c
index a31ef066ef356c..892f9d25588c11 100644
--- a/repair/incore_ext.c
+++ b/repair/incore_ext.c
@@ -725,7 +725,7 @@ static avl64ops_t avl64_extent_tree_ops = {
 void
 incore_ext_init(xfs_mount_t *mp)
 {
-	xfs_agnumber_t agcount = mp->m_sb.sb_agcount + mp->m_sb.sb_rgcount;
+	xfs_agnumber_t agcount = mp->m_sb.sb_agcount;
 	int i;
 
 	pthread_mutex_init(&rt_ext_tree_lock, NULL);
@@ -778,10 +778,9 @@ incore_ext_init(xfs_mount_t *mp)
 void
 incore_ext_teardown(xfs_mount_t *mp)
 {
-	xfs_agnumber_t agcount = mp->m_sb.sb_agcount + mp->m_sb.sb_rgcount;
 	xfs_agnumber_t i;
 
-	for (i = 0; i < agcount; i++)  {
+	for (i = 0; i < mp->m_sb.sb_agcount; i++)  {
 		btree_destroy(dup_extent_trees[i]);
 		free(extent_bno_ptrs[i]);
 		free(extent_bcnt_ptrs[i]);
diff --git a/repair/phase4.c b/repair/phase4.c
index 3a627d8aeea85a..f43f8ecd84e25b 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -322,8 +322,12 @@ _("free space (%u,%u-%u) only seen by one free space btree\n"),
 		case XR_E_FS_MAP:
 			break;
 		case XR_E_MULT:
-			add_dup_extent(agno + isrt ? mp->m_sb.sb_agcount : 0,
-					agbno, blen);
+			/*
+			 * Nothing is searching for duplicate RT extents, so
+			 * don't bother tracking them.
+			 */
+			if (!isrt)
+				add_dup_extent(agno, agbno, blen);
 			break;
 		case XR_E_BAD_STATE:
 		default:

