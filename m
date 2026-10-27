Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.231.201
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793114237;
	b=ZG+gjpu8lggzizy+p6CyS1wpHxDUpj93wEwbIdMtZh9u6LJ3L9eh2J04gcwDMAZjcce3
	 th8bV5pnnS0Ogm6KdBacCmdwbuN+unE2MoP1wBr8MUi6fWfqTkwtcIWF03qVUXsSsuTHu
	 dvRYAG1DROdMxd/OULzInLFrLeDBMy5EB0W89pwwWf5uBawUVQo2jLWM7ttP4jtFGgZ41
	 rNn3hX1RLdhu0BCl0cuEwz88tEVbrDzXmguYgzx9FJTn8iWrRHlh1OPUpCkRd/+GBqBP2
	 BHOJf80HfakxVdzw6/nGAimE8+oZnz7Oy27oNEu1dluJM1v8eCBglhqJ6T+11KwT9hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793114237;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=cRq9t0qIqm1WrofTQOp5zElqXMgWMX02w9eR+vGRDO8=;
	b=VO9wJn4ljRVZuZLGDenNxhrFfvqzIFhr/D6k5FBdEAohD/B2+WLg+VDiSt42cNggMY3s
	 r+1264HXu+bEIJr2jGtBV36vVqWO5QWPnz+ClSc/qqS6LX95ZKMyLJZuCCJJcpAo1mk/p
	 WCJvd5fQE7qHaZe9ctIy6K1BJGsqLQYFDl2fBdtg6I9d/wIPqmphsR/2GHZPWY000vBtT
	 glVt5G3hzvR//ag/bG7CmxU3TibVM4T7X+MJ/poLklK+369ZnuvGThzkh7gYjYcvJAT9m
	 jezpLcQWaAkXg0F07cmqvM1TbC7I+rK9SzrP2Aek3heyQ4+qplrFtaw2MiJf9DWEZtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hKnAHZMw;
	arc=none smtp.remote-ip=74.125.231.201
Received: from mail-oi2-f9.google.com (mail-oi2-f9.google.com [74.125.231.201])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F700606A31B
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 15:17:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F700606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hKnAHZMw
Received: by mail-oi2-f9.google.com with SMTP id 5614622812f47-4f47feb5a15so725251b6e.1
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 08:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793114235; x=1793719035; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cRq9t0qIqm1WrofTQOp5zElqXMgWMX02w9eR+vGRDO8=;
        b=hKnAHZMwirqdOZyPxF7SWjj0SCGQXFMiaWQLQ36LwEdV48EGwzpW8o8tTqS8R0E8jR
         /tIaWAbKkJXcH4O84WsWQgWPeXdNEHOWFEa0iz1tCB33GQnTo86Gf7EwF3qiBMBIiE+c
         8Z1kqYgBRa8kzmXKaHorQ1MFZ0Ro1cvSsolrfXo6cxJwnz/Z9hGsa/+4KWtHqQdgAALO
         ENh3heGBbwfRHC9IApvcmRQ/iG1UcaKcmOPANVixbtJJzwf/c/H8WOJQGJqNUWF8Anl8
         XvSxFZwpH7s9OQ6UuzoxsE5NZj2V45GZIzn85Y8eIiPR44jJxXHDqB3txKO50HuVLTrZ
         3YDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793114235; x=1793719035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cRq9t0qIqm1WrofTQOp5zElqXMgWMX02w9eR+vGRDO8=;
        b=WqXid8LXbNedXbr6zClF5HCd9vmelIi/7QG8VTJluo7rv8t+agSpu0w4KE5F3+nPPe
         IW3Y7dUnYiIU1FAtNQJbU85sjK6qxQbYg/UZ2m+xT40lP3UCuKxY/ctq8KuVZUjKjznL
         4cIyRbW501HHvgJCVMjua9y1zrUE2o9u1hLqhy+fyqJrT120EqeKlYRgU3nU+m7NJGrR
         qXWqtxJi9Ok76dAUd/e5CEp/41BuPgMe+Z/GQKVPW6GqTW3LTZxm96S/jI5PpAUApF0c
         MYbccJoV/GEF1NnparOxRBk0n22f3y7JiD7K3hfny5PQc60NzTq4uKUHLTvKVvE9iKwO
         1t7A==
X-Gm-Message-State: AFq9FYLpZ7SOy5+xM9jmfBNWPJSymSbkFn9vb/vgo3uHnqMHkx2m9fkb
	LnVI+U9C1QIB9BmQqVlFAwe2jC6tjYfWfrGkHi+u2JBNWeRHvGVUeGzQ
X-Gm-Gg: AYBFou11k03ARIFKVetaYtxAm+KQHBQl1/PmnfOn3HWoHeXuGV5TwLvStRmF+2FDbJ2
	eVjML9IvKxQ3Y2S+BuqZG3nOeoIyBzVMoMy2Oqe68UUDaN2iXlLrzoeBRTrzcBxlaKEJSrCL3/K
	mlhlLatJ2V07UJVTTykqwMik8j3YRn08TEHMNBXANhqOpcQ9BCA58h/zAuGcxlEZZ/JUE5ugbeU
	DRrrK/eAIWw4HGmmqbW7/bcNRC18jBKu8JD2/3Szek/jHJJdnXIgLPpoy4qdcGMVYLjNpz1bC7t
	C/4oBNnDfU/vpqjAynzFym4WGKIAyIaLXmfC1frUVR5VnhHsYb328r+QxfIlM797RpK6UTtZ4Ji
	14PGuL+UUdByuUuWdGNbJCXwyYcXZjq3e1IQZ5bZ8O1R3ffUHyKjVDy/XAi9r4CaB01ibYMgejr
	aBsYl5uSaEak7Vfz7QO3L+sfWBTUCMK3BLNmR4/rJBUWXGucgKfhqXf3OQrI7TwVxBqEkSq+ve4
	S6zxzpbFN04FBALJiv3R9BHjqb5GIsMoRr2IhyeZnvfMzGIsUhJTNh4fPGVK7xQCVFVAYs7rbhd
	Eyp30UOjAUxXV/Qj3P8OD6PShueYXai8CWPBMncYYLnflfTbU1ojILQLzpwyw5qr3Qk=
X-Received: by 2002:a05:6808:2215:b0:4d6:92b3:5c84 with SMTP id 5614622812f47-55c00421867mr6297968b6e.65.1793114235460;
        Tue, 27 Oct 2026 08:17:15 -0700 (PDT)
Received: from localhost.localdomain ([14.22.11.161])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-55c0429c932sm8197469b6e.7.2026.10.27.08.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 08:17:14 -0700 (PDT)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Hildenbrand <david@kernel.org>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Kairui Song <kasong@tencent.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Rafal Ostrowski <rafal.ostrowski@amd.com>,
	Likun Gao <Likun.Gao@amd.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Henry Martin <bsdhenrymartin@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] xfs: fix out-of-bounds write from crafted btree root numrecs during log recovery
Date: Tue, 27 Oct 2026 23:17:03 +0800
Message-ID: <20261027151703.973392-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.43.7
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_bmbt_to_bmdr() converts a logged in-memory bmap btree root block
into its on-disk short form, and it trusts the source block's record
count for the copy sizes:

	dblock->bb_level = rblock->bb_level;
	dblock->bb_numrecs = rblock->bb_numrecs;
	dmxr = xfs_bmdr_maxrecs(dblocklen, 0);
	...
	dmxr = be16_to_cpu(dblock->bb_numrecs);
	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
	memcpy(tpp, fpp, sizeof(*fpp) * dmxr);

The capacity bound (dmxr from xfs_bmdr_maxrecs) is computed and then
immediately overwritten with the attacker-controlled numrecs from the
source block.  During log recovery, xlog_recover_inode_dbroot() and
the XFS_ILOG_DBROOT/XFS_ILOG_ABROOT paths pass a raw log iovec as the
source block, so a crafted log item with numrecs up to 0xffff makes the
two memcpy calls copy up to 512KB each (8 * 65535) out of the log
buffer and into the inode fork area (a few hundred bytes) and past the
end of the inode buffer page: a page-granularity out-of-bounds write
with fully attacker-controlled length and content, before any dinode
verification runs (xfs_dinode_verify() only sees the result
afterwards).

The same pattern exists in xfs_rtrmapbt_to_disk() and
xfs_rtrefcountbt_to_disk(), which convert rt rmap and refcount btree
roots from log blocks using the source numrecs unbounded.

Validate that the source numrecs fits within the destination capacity
before converting, in all three conversion helpers.

This issue was discovered by Tencent CodeBuddy Security.

Fixes: 658fa68b6f34 ("xfs: refactor log recovery inode item dispatch for pass2 commit functions")
Cc: stable@vger.kernel.org
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap_btree.c       | 13 ++++++++++++-
 fs/xfs/libxfs/xfs_rtrefcount_btree.c | 13 +++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.c     | 12 ++++++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 758a4b1ccf5bb..118e8ab35f1d1 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -148,6 +148,7 @@ xfs_bmbt_to_bmdr(
 	xfs_bmdr_block_t	*dblock,
 	int			dblocklen)
 {
+	int			maxrecs;
 	int			dmxr;
 	xfs_bmbt_key_t		*fkp;
 	__be64			*fpp;
@@ -167,7 +168,17 @@ xfs_bmbt_to_bmdr(
 	ASSERT(rblock->bb_level != 0);
 	dblock->bb_level = rblock->bb_level;
 	dblock->bb_numrecs = rblock->bb_numrecs;
-	dmxr = xfs_bmdr_maxrecs(dblocklen, 0);
+	maxrecs = xfs_bmdr_maxrecs(dblocklen, 0);
+	if (be16_to_cpu(dblock->bb_numrecs) > maxrecs) {
+		/* Corrupted log block: refuse the conversion instead of
+		 * copying past the end of the inode fork area.
+		 */
+		xfs_warn(mp, "bmbt log recovery: numrecs %d > max %d",
+			 be16_to_cpu(dblock->bb_numrecs), maxrecs);
+		memset(dblock, 0, dblocklen);
+		return;
+	}
+	dmxr = maxrecs;
 	fkp = xfs_bmbt_key_addr(mp, rblock, 1);
 	tkp = xfs_bmdr_key_addr(dblock, 1);
 	fpp = xfs_bmap_broot_ptr_addr(mp, rblock, 1, rblocklen);
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index dcc89b8e149b0..c6b351b7fbcdb 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -696,6 +696,19 @@ xfs_rtrefcountbt_to_disk(
 	dblock->bb_level = rblock->bb_level;
 	dblock->bb_numrecs = rblock->bb_numrecs;
 
+	/* Corrupted log block: refuse the conversion instead of copying
+	 * past the end of the inode fork area.
+	 */
+	numrecs = be16_to_cpu(rblock->bb_numrecs);
+	maxrecs = xfs_rtrefcountbt_droot_maxrecs(dblocklen,
+						 be16_to_cpu(rblock->bb_level) == 0);
+	if (numrecs > maxrecs) {
+		xfs_warn(mp, "rtrefcountbt log recovery: numrecs %u > max %u",
+			 numrecs, maxrecs);
+		memset(dblock, 0, dblocklen);
+		return;
+	}
+
 	if (be16_to_cpu(rblock->bb_level) > 0) {
 		maxrecs = xfs_rtrefcountbt_droot_maxrecs(dblocklen, false);
 		fkp = xfs_rtrefcount_key_addr(rblock, 1);
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index a15e460a1ec7f..29d948b42af66 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -929,6 +929,18 @@ xfs_rtrmapbt_to_disk(
 	dblock->bb_numrecs = rblock->bb_numrecs;
 	numrecs = be16_to_cpu(rblock->bb_numrecs);
 
+	/* Corrupted log block: refuse the conversion instead of copying
+	 * past the end of the inode fork area.
+	 */
+	maxrecs = xfs_rtrmapbt_droot_maxrecs(dblocklen,
+					     be16_to_cpu(rblock->bb_level) == 0);
+	if (numrecs > maxrecs) {
+		xfs_warn(mp, "rtrmapbt log recovery: numrecs %u > max %u",
+			 numrecs, maxrecs);
+		memset(dblock, 0, dblocklen);
+		return;
+	}
+
 	if (be16_to_cpu(rblock->bb_level) > 0) {
 		maxrecs = xfs_rtrmapbt_droot_maxrecs(dblocklen, false);
 		fkp = xfs_rtrmap_key_addr(rblock, 1);
-- 
2.43.7
