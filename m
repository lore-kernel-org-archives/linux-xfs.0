Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0757CF9E9
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440818; cv=none; b=IM9Xd23cNEYgi9KXnglrDzeYh5WBpbzmWFs+uiL21Z+nB8jteT+r6ByQ9VkuJDCs1cLtmDV+vcAUagoADKxEdnaC+5URXlaq3mYnIZHdA/pFsKY0TFTLnk05rmcYYdsAsbXrP82BLN49G+I/8Q8nhMjpVwI5IDh6c160CrbdaTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440818; c=relaxed/simple;
	bh=PzOhQabSw8em7t9ztyUjOYGyND7JLF5zubrkS/6tZVg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X7FhFjKB4jHjzJw7vmi4uG2NTXLScY9/qIIRGeSpsjrxOh+YEvOGw6udsRaEtP6/dl3GrMxFr4GTqUuj4rjIVrQ18A8/iUBqEqAbKz0HyG6a1MfaFb4A5ydwQVU4gpobamT7iKZmQqYBC/12Vruhu1qX6NwhqVu4N8ykMd9Db1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LOuegTPp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LOuegTPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED18C2BD10;
	Mon,  3 Jun 2024 18:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440817;
	bh=PzOhQabSw8em7t9ztyUjOYGyND7JLF5zubrkS/6tZVg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LOuegTPpZG/DpYeIRI1BduHF2tQuxU7NXMaW1No3/HEwyJv2cGxL2M8YyAO9E5eum
	 zQZNQwcPcKGWNB8pvHpmVkP2E3aoeLhD32Fq8bd44MiDRapw+/E9tyKwKSfjICvvyk
	 3xGzBYkosB94uZJJPk4cxebEOstk1T9eU5wtv1EdIg9PZRrDusSGGoiKLmei6GcD29
	 IwXwUEz2spfLUzpzzJu629Q94/PBHfYloW/GiMkEZi0OQ+I0JmVZBMk6KyOATvgLor
	 EXocURkVV+DxrhOxj0CMhqCQd+W84FB7YW+pX/c6H7V2sop5NPC/WrXEeScCiaHpXV
	 ReVMJDB65DFSA==
Date: Mon, 03 Jun 2024 11:53:37 -0700
Subject: [PATCH 006/111] xfs: clean up remaining GFP_NOFS users
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171744039456.1443973.1453404677962488039.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 204fae32d5f7b9ac673d3d4f636dcef8697db2f0

These few remaining GFP_NOFS callers do not need to use GFP_NOFS at
all. They are only called from a non-transactional context or cannot
be accessed from memory reclaim due to other constraints. Hence they
can just use GFP_KERNEL.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_btree_staging.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 0828cc7e3..45ef6aba8 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -139,7 +139,7 @@ xfs_btree_stage_afakeroot(
 	ASSERT(!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE));
 	ASSERT(cur->bc_tp == NULL);
 
-	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_NOFS | __GFP_NOFAIL);
+	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_KERNEL | __GFP_NOFAIL);
 	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
 	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
 	nops->free_block = xfs_btree_fakeroot_free_block;
@@ -220,7 +220,7 @@ xfs_btree_stage_ifakeroot(
 	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
 	ASSERT(cur->bc_tp == NULL);
 
-	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_NOFS | __GFP_NOFAIL);
+	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_KERNEL | __GFP_NOFAIL);
 	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
 	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
 	nops->free_block = xfs_btree_fakeroot_free_block;

