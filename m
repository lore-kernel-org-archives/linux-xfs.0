Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3E619AD9B
	for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2024 12:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729599245; cv=none; b=ioAK2b1gRT6JdvzBtJrb7P4NmG+poi3hXUqeXtcGbKcpJIUJpjCRAvfl+MfFlvxWxAToO+4Q7Lo2yYU/CKaR/WMJU/ThVprfLaEApVeK94nlsbukk84gAOiqEJP0ROMMMx+bgqCsoXXMTt9mgyBUx8hghQNmm0ND99GKqQ/267M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729599245; c=relaxed/simple;
	bh=AaRepaf8xYjBUmYnBlGVUe3QxdUqaoTcI3WiZnKSkEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvFi2E/ZgBWbBR6iri1DBRpd30kt7eUCnPZMFbRx7LsYD5P5dad62/oET7+ZR4uIkQNgoCIHKaJAgMX3p40aCGQighs5bWn1k+dVlMob+myIwtCs2tUC4Ijx84zyIwDM7xbQo6HK8lqFAZk9R3XrWQ94Pu3q8Cz9wsK4hjtA5gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z+lkvTj2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z+lkvTj2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xPxe9mIoVJyEi4Wa90Bzxq7uasxgy6x5YckTYolCQ1g=; b=z+lkvTj2dubFy/R3roUArRpB9v
	nXqMEY82v7FMaDe1Y8gxt3u1Uq0QUfg4sBqsGgljd1ZZqVZ55rb7x+5elfUudsHbPv9P7aJZvqCBQ
	EsZqhqBLqwJ4bjsex9m6C5KT1qnskPg24qSrOAlkbIi5ScXFq9Xaykyqy7ZAcd4joXEdZCukf9GuM
	RQB9geWHRc2DWQj4Lmom8hV5HDW+VOkI0G40T6IjTiepSuYBVHY+eEwAPDwniV7Q3UcbBXmdxDFKN
	M31HFjm1WcVehlGZ/hwfMidAXAfu/zlrxCkykdAHCdDfTnGropwT2G0iEkpmSpui86Vnu5W+LhcDY
	IY8b7G9w==;
Received: from 2a02-8389-2341-5b80-1159-405c-1641-8dd9.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1159:405c:1641:8dd9] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t3Dly-0000000Ao1o-39h0;
	Tue, 22 Oct 2024 12:14:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com
Subject: [PATCH 2/2] xfs: fix finding a last resort AG in xfs_filestream_pick_ag
Date: Tue, 22 Oct 2024 14:13:38 +0200
Message-ID: <20241022121355.261836-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241022121355.261836-1-hch@lst.de>
References: <20241022121355.261836-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When the main loop in xfs_filestream_pick_ag fails to find a suitable
AG it tries to just pick the online AG.  But the loop for that uses
args->pag as loop iterator while the later code expects pag to be
set.  Fix this by reusing the max_pag case for this last resort, and
also add a check for impossible case of no AG just to make sure that
the uninitialized pag doesn't even escape in theory.

Reported-by: syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com
---
 fs/xfs/xfs_filestream.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index f523027cc32586..ecf8a0f6c1362e 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -64,7 +64,7 @@ xfs_filestream_pick_ag(
 	struct xfs_perag	*pag;
 	struct xfs_perag	*max_pag = NULL;
 	xfs_extlen_t		minlen = *longest;
-	xfs_extlen_t		free = 0, minfree, maxfree = 0;
+	xfs_extlen_t		minfree, maxfree = 0;
 	xfs_agnumber_t		agno;
 	bool			first_pass = true;
 
@@ -113,7 +113,6 @@ xfs_filestream_pick_ag(
 			     !(flags & XFS_PICK_USERDATA) ||
 			     (flags & XFS_PICK_LOWSPACE))) {
 				/* Break out, retaining the reference on the AG. */
-				free = pag->pagf_freeblks;
 				if (max_pag)
 					xfs_perag_rele(max_pag);
 				goto done;
@@ -149,18 +148,19 @@ xfs_filestream_pick_ag(
 	 * filestream. It none suit, just use whatever AG we can grab.
 	 */
 	if (!max_pag) {
-		for_each_perag_wrap(args->mp, 0, start_agno, args->pag)
+		for_each_perag_wrap(args->mp, 0, start_agno, pag) {
+			max_pag = pag;
 			break;
-		atomic_inc(&args->pag->pagf_fstrms);
-		*longest = 0;
-	} else {
-		pag = max_pag;
-		free = maxfree;
-		atomic_inc(&pag->pagf_fstrms);
+		}
+		/* Bail if there are no AGs at all to select from. */
+		if (!max_pag)
+			return -ENOSPC;
 	}
 
+	pag = max_pag;
+	atomic_inc(&pag->pagf_fstrms);
 done:
-	trace_xfs_filestream_pick(pag, pino, free);
+	trace_xfs_filestream_pick(pag, pino, pag->pagf_freeblks);
 	args->pag = pag;
 	return 0;
 
-- 
2.45.2

