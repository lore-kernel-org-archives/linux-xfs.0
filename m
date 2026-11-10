Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270523;
	b=yF0cQp3bIoQ6A1euAcx6DfdoroU9mE4GZ5dmGWlJeKG1/mGIwv4WShyhtj8VgIjBjkZB
	 xn6eaxpYk+2wsR89MwHh7rdmMflF+VGxVB/kloIs5hk7w24HwTN3/ZIZuNOOcpQSD0Lr7
	 WDitM8WNqs09WjvTYLwxyRrjExaD0zty8J7xATbwFc8VkvI6K9OVn3NdvuhX5IU307+mk
	 E7XMH8mnrMX809xqV9UElWLj9D42X2xsO3QVo/pnIan3PoSiohnqc639DcxCFlFqRj+K5
	 lqMU7t/xPmRLjGpYRaLjjKzqYson+lQWPp77nWjBJDqIxb+ZNg6//LhKdv/U5rtADcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=EsNZap66jluc6W0CGDMZs8KM/gAx1qMMg5K8N0AJzJQ=;
	b=uqEraa6McSz/LhBkbqx+r+2BKmuCWLl0Sseqp7VLkuTbjYsbVjiA2mE1dXROZmGqBHqr
	 Ppth/uH/yu/mFIjn/btBgc4WRrUO+TS8GHrxWZcd5Pl0TGtRm7duDvojWCplhEC7IK9MT
	 eUw7PW61K1dZVv3ipMRNw0oBZsWaQ6r8ZAEU+yf8qIseVwHf/6Sopk2L7nz9xe+QTahDK
	 oOQfzr3wWj1y+FCJK8b91WpkO6JP00YXwrtB0/NnDZAwpqFC+J7zvOf01hbznocJ5XCSZ
	 /Vi+a22N5W1c0Q43EwglJR5gVDXDwy5aY2j/8RFewb2dcm/6Imf+E1efbgfXrSyLOkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ntblhHGl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2FB606A31C;
	Tue, 10 Nov 2026 00:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ntblhHGl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97101F0089F;
	Tue, 10 Nov 2026 00:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794270522;
	bh=EsNZap66jluc6W0CGDMZs8KM/gAx1qMMg5K8N0AJzJQ=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=ntblhHGlX/k3NbBj/D/eaAJPyAb7ZdCOQYFTOx+0gcrp6HR2kzUrENO7CmhwVzkJP
	 hV2BOa6hEgnLX9aladwv4kkCfKyhJfXlQFd9zUCHRiwrnMdUsEqODnTtf0cJqQtXQw
	 3RpMHxMzAGjRSoO6I1B63JPhxfuBOVPRxrvg77L5fcMrceCBZLvJzmuPHNeWXwksp5
	 P8Uxrr2KyCuglwH0POnmln214J+KETJlExU7KG4J77f0Z665b0U8HRCrUdz0/nAPGb
	 fDBj+r/Ybd4OBgZ4oMDv5VSAqws77soXmAL74XW8IMYME/xqerBV8s9GbYeA3ivgsE
	 smUXtdfkThmNg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: don't skip free extents of the longest length in a whole-AG FITRIM" has been added to the 6.12-stable tree
Date: Mon,  9 Nov 2026 19:28:40 -0500
Message-ID: <20261110002840.3514650-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Reply-To: stable@vger.kernel.org
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    xfs: don't skip free extents of the longest length in a whole-AG FITRIM

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-don-t-skip-free-extents-of-the-longest-length-in.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit b3cc9b373a7b6185e2805eba7be67ee40a5cf85c
Author: Daejun Park <daejun7.park@samsung.com>
Date:   Mon Oct 26 10:54:06 2026 +0900

    xfs: don't skip free extents of the longest length in a whole-AG FITRIM
    
    [ Upstream commit 5745f4f10a1a16aa5bb020acc38afa33f2d5ff99 ]
    
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
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Carlos Maiolino <cem@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 9ad0d653f266b..66c2f2fcec7bf 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -207,12 +207,12 @@ xfs_trim_gather_extents(
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
