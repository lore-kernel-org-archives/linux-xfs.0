Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792979647;
	b=SilpCVJ4mQ8egUuHVdB0tzjHlsMB5NKvLsnULBVknLsIP/NSOIeqYzNeCZuw8WE2pm+L
	 XHCwzhv2v6Pz40bR8NB2xZ+5ErnOvwa5SPqZ0AqBEjmYmakpMhixMDVll97s6p4mfVlbK
	 wEz26WXlRkWE9Fu+5OVfWcpdvUDPNEeMWn5V/S+i2NurzBB5bh6DTnRwQb/dvfU/od0NJ
	 wZQxpBJRs7aI77GdvIOWqf9R+3TTe5bwiplDBWQikirzhv6dIC4qnq6ttuwfICih37QZH
	 NNZ47zGk7XhgS2FmAyZq7wQeYe3CWXp7GkuHYskgh5/kkf0tv836GkfBTx7+l23HZcA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792979647;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=hwf42MmqiictqeAXTJJ0tDtgRB1pwdbe6TvnDURAkTU=;
	b=OeIlPFoc8AQkMCwO1WcoSTVSEg8bH2/DIaiVQ8K9TEjmAfbvukUGFWE+ioGNvMBBq12l
	 Ca5uEa7+0c/EpEPvcGoulX1PZY0nPVRTcISPJvK2ie/VNGbeJjYO+qPbreok7X4lfgmRJ
	 IGNAdgMHNRXY1RhoOrtgOGofonuFaFCM0sABGwZqipbpgNe3hNnyqCg/potOwbztuRXem
	 83IrUPE0zb591zBuuEz5D0PqdH5ZqMDn91DbOlEz3/9X1D2M/czJKmNtzSq5MrOM5v884
	 sEmbNznPvbYXuCRG87So84m2VvOd9/9hv4OG38W+TSnhx8L1E/I5BU+LyFx1hGJa/Vw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="RQ1o6/Zb";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D1F606A31D;
	Mon, 26 Oct 2026 01:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RQ1o6/Zb
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792979646;
	b=LdZ3JR0B6ch/VQ4PBUTGQsVJbDJm0e0jQBBPqA9kdsZjz4jbymkursbN07kM75r/lVV+
	 5n38QJzymNf/z+7pBHWPj8anaEPE0O4QTG5AumpZv/f+EGf9H94y/+5BgrFU3/73kayfL
	 fFAf59LxQgl3m7E81H0s5wxMxrVawpP1MkN30K8sHVpnvU27wywz9reTP1U+8utviP0pY
	 +0qZHw0uSrxJIPI+h9DL5Z4nbBifwEeWtThapKo+SbN/jK7vyHzBFXJvi50rOpf5LVnRK
	 iEzFYmbJm6cg6OqBhIqxsCjhNJ6g/uyQfN71oGnVDWHSuTnmh028dTBrMbhGMQWBnlA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792979646;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=hwf42MmqiictqeAXTJJ0tDtgRB1pwdbe6TvnDURAkTU=;
	b=Ss2ScRqoA+3GPGZoOazIHsx2ujiSMbSri50unprzQatC19qeUs7SUstwLEhgyCol9rHo
	 hNEloDZpVj0coFGlWB8y2O8ZX70T1N0MoQSs/s51lIqIznG1aJVwaRXijoOdFjt+GOgT9
	 Ux00FZV57SidgPCdR4Q0RvNYZLFAmbWudUZnm4mB32St0/+9s4xMkKwbMlP4NY+wFwJw7
	 2LA1mGpEtPX4wrnZ3jD0yui6DrxYiTuqZvB/H1hezgamahY/DfXRw/fd+GFzfO1LcLDgX
	 C/Fuug1h/wm9RFOsvYmEMjqg3VfQJ1owZSYYaRF/jdMuXqvoQGFnXigVotgkksFSiUA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 6909C1F01825;
	Mon, 26 Oct 2026 01:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792979646;
	bh=hwf42MmqiictqeAXTJJ0tDtgRB1pwdbe6TvnDURAkTU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=RQ1o6/ZbtTUpRGXCepNdotbBYJ3iLW/FABOCdKPEB1/UsQzjuvVSWuEXf++Wtwfge
	 QM/IMNd6ZZicjfw6A2rDNXw5C/pJS4/cNSrR+ecieDDBmMp2mm2xJrcx7pA4dWU1W/
	 KhxmHOghHIdS45SsjcBfhwNoggzfQvRpVmZPUPfkD5cOJctV4cHVCiUrczirXp8O3E
	 g02C+wA9uvg6DnlP51RD7X9TFUYEqYLlzIclwoeCLgQ+EXzcZnWZnFcMHBTpa3QtUY
	 XViDANjhe0q3+XMWNrKS1oEax5UpTyvztDlQEm9IsmZfiDvyaFVPXrNLGEq0Z1QxFo
	 3yKcE26XE7rAQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D61C044BB1;
	Mon, 26 Oct 2026 01:54:04 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Mon, 26 Oct 2026 10:54:06 +0900
Subject: [PATCH 2/2] xfs: don't skip free extents of the longest length in
 a whole-AG FITRIM
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261026-xfs-fitrim-skip-v1-2-cddd8414f99c@samsung.com>
References: <20261026-xfs-fitrim-skip-v1-0-cddd8414f99c@samsung.com>
In-Reply-To: <20261026-xfs-fitrim-skip-v1-0-cddd8414f99c@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792979644; l=2296;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=aB3YdzosB9+MLmbMgvq8EWq31a8TDk+3lXux5xdb1mU=;
 b=+Jv3c76RNB6Z7iHbgFJyUMxriwOSH/IwqigFKgIczG2+rmLqffC9/t8PhDA8iJqiS0g4JS3gl
 QKXWszn3tLwAhoTWz+l49zyKYhU0gS8CtPX+CJyR+MHTYwmSdG/bvoW
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

Since commit a66d636385d6 ("xfs: fix fstrim offset calculations"), the
by-length walk of an AG in FITRIM starts with
xfs_alloc_lookup_ge(cur, 0, pagf_longest) and walks down. The lookup
lands on the longest free extent with the lowest block number. The
other free extents of that length sort after it and are never
discarded.

Start every by-length batch with xfs_alloc_lookup_le() at restart_bno.

Suggested-by: Dave Chinner <dgc@kernel.org>
Link: https://lore.kernel.org/r/ZgiJWxVcVwag0fIP@dread.disaster.area
Cc: stable@vger.kernel.org
Fixes: a66d636385d6 ("xfs: fix fstrim offset calculations")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
In xfs/842, 6 of 15 free extents that held data were not discarded
without this patch, and none with it.

On v6.10 and later this needs the previous patch. Older stable trees
need a small backport, which I can send:
- 6.6.y: always use xfs_alloc_lookup_le(cur, tcur->ar_startblock,
  tcur->ar_blockcount, &i), and backport 23be716b1c4f ("xfs: don't
  assume perags are initialised when trimming AGs") with it.
- 5.10.y to 6.1.y: replace xfs_alloc_lookup_ge(cur, 0, agf_longest)
  with xfs_alloc_lookup_le(cur, NULLAGBLOCK, agf_longest).
---
 fs/xfs/xfs_discard.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 8120f136af..cdf660344c 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -200,12 +200,12 @@ xfs_trim_gather_extents(
 		error = xfs_alloc_lookup_le(cur, tcur->start, 0, &i);
 		if (!error && !i)
 			error = xfs_alloc_lookup_ge(cur, tcur->start, 0, &i);
-	} else if (tcur->restart_bno == NULLAGBLOCK) {
-		/* first time through a by-len starts with max length */
-		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
-		error = xfs_alloc_lookup_ge(cur, 0, tcur->count, &i);
 	} else {
-		/* nth time through a by-len starts where we left off */
+		/*
+		 * A by-len walk starts at the last record of the longest
+		 * length (restart_bno is NULLAGBLOCK until the first batch
+		 * ends) and then where the previous batch stopped.
+		 */
 		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
 		error = xfs_alloc_lookup_le(cur, tcur->restart_bno,
 					    tcur->count, &i);

-- 
2.43.0


