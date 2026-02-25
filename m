Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7033A1E5B63
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 22:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772059923; cv=none; b=ASmh5Bi13wA6AJ++Ppct7g1DkXIWUluNpfNJwr51OkTe2gqPm8Bq+sB0a6Yfv3oKBOx9ee3O/7s3TvlIzIKHl8y3VKH3h5qHgXR57dUUQpYY8BzlIeteKRntjh5PVioaSQN3kkltOWrIK4z7wDod09T7fRyloCoIGnt3CzQGvIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772059923; c=relaxed/simple;
	bh=kOBvUrZskBebD2BO+DyiLdRhKidjAj4UFUN0Ea6rVkQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=MQMR1qIFJQUcXSXkCuMy4kjzwR/njWQM354c5V7f+4HL5t9EyBHiqDoVS8iLdDLnXSzys6IAg+3Y2uUzcElxEgVO0F7D8XiLEvgQYDD7jjafL2ZNxtAOd4XFJIWWTLYGIiAdz53TDd87xm/Eseah/N1i+XtOy3QwrHy9IG3LZRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DTDYkwOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DTDYkwOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56C6C116D0;
	Wed, 25 Feb 2026 22:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772059923;
	bh=kOBvUrZskBebD2BO+DyiLdRhKidjAj4UFUN0Ea6rVkQ=;
	h=From:To:Subject:Date:From;
	b=DTDYkwOgkMIbxb8CRiiOQgtDet0NvqKIZ1MSwfRyNl08onXzIuboG2ZzS40v6+x9w
	 RxggLam8bmii2SJFW+7UUABcUULQWMwZjUL04tS+K22OHKb5LpaCkw+7ELQWhb9ffJ
	 QKr6fn0ntxZuxRA5BoIOksdZWwP0ZrgUT/UZo2Qgj8EEoiOZe+54/P2r44hqG241cq
	 6ck9Yx2fjQBBxMmjjGCqpZd7L0vjKftG26ja/An3t3RvyeW7fmReiO/S8H2dgwplFm
	 BzgFF4RSL+Ssh0wjC6Ss1ZqsrjKUxsNIRzZ26YL6zFAIkbzPkjrAoFvepr1hSl1cAL
	 mBCdbA8xcqAJw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH] xfs: remove scratch field from struct xfs_gc_bio
Date: Thu, 26 Feb 2026 07:46:46 +0900
Message-ID: <20260225224646.2103434-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The scratch field in struct xfs_gc_bio is unused. Remove it.

Fixes: 102f444b57b3 ("xfs: rework zone GC buffer management")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 fs/xfs/xfs_zone_gc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 48c6cf584447..d78e29cdcc45 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -96,7 +96,6 @@ struct xfs_gc_bio {
 	 */
 	xfs_fsblock_t			old_startblock;
 	xfs_daddr_t			new_daddr;
-	struct xfs_zone_scratch		*scratch;
 
 	/* Are we writing to a sequential write required zone? */
 	bool				is_seq;
@@ -779,7 +778,6 @@ xfs_zone_gc_split_write(
 	ihold(VFS_I(chunk->ip));
 	split_chunk->ip = chunk->ip;
 	split_chunk->is_seq = chunk->is_seq;
-	split_chunk->scratch = chunk->scratch;
 	split_chunk->offset = chunk->offset;
 	split_chunk->len = split_len;
 	split_chunk->old_startblock = chunk->old_startblock;
-- 
2.53.0

