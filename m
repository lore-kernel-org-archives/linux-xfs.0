Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E0D1EB2B
	for <linux-xfs@vger.kernel.org>; Fri,  5 Apr 2024 06:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712297239; cv=none; b=ru+/F/0r1r8IBzT01Fg8WBGCMzRLWuFHzq0dE5G5fImfTbpnF8YN6CfN+V4CdvltOrmV83eqHYZTjLKwLR0AnNBW+JkA7lDwdgG1Z7l8pj3ZAV3y+cn8d++um6HIPBGOAWw4mlDa7h4JGu8g6iS/EAA1nDbPcDSlXbdISzYOsYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712297239; c=relaxed/simple;
	bh=GrjfQ//OMwzUSVx6mkzlR2qidWMTpxka32/y3c9tBJk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JWfhT7NBqdQ57si1UHisIgbBcNI+VBWBYRrkSbWRytfxq/raOENkZFChovgxIg6+HUYtyOhj+/18pCxPtLtMEP8aShxWiHJ/cmK5hhFXRHie6LXtWLG28LitAn43EZCDzbAoOlr5ioFzDyyJRzOY3bnXeRmx5eqmkfS7737ZfpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Iu2dfTb6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Iu2dfTb6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0ejniRSIDGKKpe0V9DXbr01vQ7Uoo6I5RAcU91/joZ4=; b=Iu2dfTb6g7Pufkxh6m7k0yL1kg
	4PP8Y/xyUW/EVDS/qc3zXRr9y4wtcxm9UkpwImRAnwXc9LOnowBM8wH+WqPXC2dtfxEnnOP/ctHyn
	miPYQwLDVy3n0R3vPQWkqvAGkukTSIAkkdYsiDdknxX4p4rb2N1XXyKlWARnt5s9yYg18Tqv567Zx
	uFWosilihRxlb8jdfPYyqOH4PmzUyq5xQOD5yCOtCXxaXZgpDpLIvAV7Y3lpT6BMj0UEmIixmvHg+
	ZeeZALNWtUzsq1LV2tpnSXBqKKdV7RDRpxALZvHre4TNtc4/yoann8SDbDc82/D2+zpp53GjZJU2e
	w9x7miLA==;
Received: from [2001:4bb8:199:60a5:d0:35b2:c2d9:a57a] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rscjN-00000005ONH-1ouA;
	Fri, 05 Apr 2024 06:07:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: unwind xfs_extent_busy_clear
Date: Fri,  5 Apr 2024 08:07:09 +0200
Message-Id: <20240405060710.227096-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240405060710.227096-1-hch@lst.de>
References: <20240405060710.227096-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The current structure of xfs_extent_busy_clear that locks the first busy
extent in each AG and unlocks when switching to a new AG makes sparse
unhappy as the lock critical section tracking can't cope with taking the
lock conditionally and inside a loop.

Rewrite xfs_extent_busy_clear so that it has an outer loop only advancing
when moving to a new AG, and an inner loop that consumes busy extents for
the given AG to make life easier for sparse and to also make this logic
more obvious to humans.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_extent_busy.c | 59 +++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 6fbffa46e5e94b..a73e7c73b664c6 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -540,21 +540,6 @@ xfs_extent_busy_clear_one(
 	return true;
 }
 
-static void
-xfs_extent_busy_put_pag(
-	struct xfs_perag	*pag,
-	bool			wakeup)
-		__releases(pag->pagb_lock)
-{
-	if (wakeup) {
-		pag->pagb_gen++;
-		wake_up_all(&pag->pagb_wait);
-	}
-
-	spin_unlock(&pag->pagb_lock);
-	xfs_perag_put(pag);
-}
-
 /*
  * Remove all extents on the passed in list from the busy extents tree.
  * If do_discard is set skip extents that need to be discarded, and mark
@@ -566,27 +551,33 @@ xfs_extent_busy_clear(
 	struct list_head	*list,
 	bool			do_discard)
 {
-	struct xfs_extent_busy	*busyp, *n;
-	struct xfs_perag	*pag = NULL;
-	xfs_agnumber_t		agno = NULLAGNUMBER;
-	bool			wakeup = false;
-
-	list_for_each_entry_safe(busyp, n, list, list) {
-		if (busyp->agno != agno) {
-			if (pag)
-				xfs_extent_busy_put_pag(pag, wakeup);
-			agno = busyp->agno;
-			pag = xfs_perag_get(mp, agno);
-			spin_lock(&pag->pagb_lock);
-			wakeup = false;
-		}
+	struct xfs_extent_busy	*busyp, *next;
 
-		if (xfs_extent_busy_clear_one(pag, busyp, do_discard))
-			wakeup = true;
-	}
+	busyp = list_first_entry_or_null(list, typeof(*busyp), list);
+	if (!busyp)
+		return;
+
+	do {
+		bool			wakeup = false;
+		struct xfs_perag	*pag;
 
-	if (pag)
-		xfs_extent_busy_put_pag(pag, wakeup);
+		pag = xfs_perag_get(mp, busyp->agno);
+		spin_lock(&pag->pagb_lock);
+		do {
+			next = list_next_entry(busyp, list);
+			if (xfs_extent_busy_clear_one(pag, busyp, do_discard))
+				wakeup = true;
+			busyp = next;
+		} while (!list_entry_is_head(busyp, list, list) &&
+			 busyp->agno == pag->pag_agno);
+
+		if (wakeup) {
+			pag->pagb_gen++;
+			wake_up_all(&pag->pagb_wait);
+		}
+		spin_unlock(&pag->pagb_lock);
+		xfs_perag_put(pag);
+	} while (!list_entry_is_head(busyp, list, list));
 }
 
 /*
-- 
2.39.2

