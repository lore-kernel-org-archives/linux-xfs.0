Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232F71373
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 04:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712118778; cv=none; b=KHhN27D/qQkX5rO8WFA7y3ugBNwXEKjmo9wwUBJwFwPBfcyyxVCDVsVmABDGMwW92acER6R0eeIp0hsYLF02W7tuHrUBO2h7hvbUy59G/rJou/0N/c8voFP+aRCYHAmbra/YfOKZTQ9aj4EXnZB98a7R9rLWjIaozuqvsaYlhg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712118778; c=relaxed/simple;
	bh=KyPRV1T43opvvVF5CE7V2dQN7NVG+Nwe+vUtg3dyuJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J8a484nhpIJb79Cd4FFn8X4p4RbFWlJTMW1lk6FBbpI5Y+cwPYTA5RXi8TStl3qA/B90hkn+84ZvdbhRHDVvRZeCNDQZRnKXFWKJv8OdEKyv25D9WLy0rL6WhKbDMb8KxERTKg+hJ9NZfJPU+pU6dpB7CQhX6VeKrhQ9xyOquBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QASWIaY4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QASWIaY4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vEi0cBmILF971qbZGmLgflebFONQKfEhY0cmIOMH8XI=; b=QASWIaY4VE9XzqBBa6x4wq/AGU
	3dzeh/vX1e7c3rgPyB5koWtqaTkhl7hq6YmGnmmb85/1pkiyKaPq8t4y0MW1D65ZaV17oQTE/prJ+
	vwh4OQfoKALpXGQn+u0Tl+lXIKBFMScbyKj68kNCzY4+goK10KRsJ2tM+aui4Y30xtwfVpreAjTme
	SCKyycdyD9wFRC18FJ1iuTVmnGP2hRfjhSS0CTa8TbnjDNtqseztKT7IrWhCmRbiOokCs/GePU2R7
	tZwPid/O2qx74TRFtrb7KyX0Xy2rcHCoF/ckVTv4U/4hu4rzUnGHLK+7rN6A3gbbzn1e0UBLeoD6X
	8Nn1+Y2w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrsIx-0000000DxYe-2gZp;
	Wed, 03 Apr 2024 04:32:55 +0000
Date: Tue, 2 Apr 2024 21:32:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: fix sparse warning in xfs_extent_busy_clear
Message-ID: <Zgzb96p-Qw86Lzd0@infradead.org>
References: <20240402213541.1199959-1-david@fromorbit.com>
 <20240402213541.1199959-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402213541.1199959-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

So while this works it looks pretty ugly.  I'd rewrite the nested loop
as what it is: a nested loop.  Something like the patch below.  Only
compile tested so far, but I'll kick off a real test later.

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 2ccde32c9a9e97..1334360128662a 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -533,21 +533,6 @@ xfs_extent_busy_clear_one(
 	kmem_free(busyp);
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
@@ -559,32 +544,43 @@ xfs_extent_busy_clear(
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
+	struct xfs_extent_busy	*busyp;
 
-		if (do_discard && busyp->length &&
-		    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD)) {
-			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
-		} else {
-			xfs_extent_busy_clear_one(mp, pag, busyp);
-			wakeup = true;
-		}
-	}
+	busyp = list_first_entry_or_null(list, typeof(*busyp), list);
+	if (!busyp)
+		return;
+
+	do {
+		struct xfs_perag	*pag = xfs_perag_get(mp, busyp->agno);
+		bool			wakeup = false;
+		struct xfs_extent_busy	*next;
 
-	if (pag)
-		xfs_extent_busy_put_pag(pag, wakeup);
+		spin_lock(&pag->pagb_lock);
+		for (;;) {
+			next = list_next_entry(busyp, list);
+
+			if (do_discard && busyp->length &&
+			    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD)) {
+				busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
+			} else {
+				xfs_extent_busy_clear_one(mp, pag, busyp);
+				wakeup = true;
+			}
+	
+			if (list_entry_is_head(next, list, list) ||
+			    next->agno != pag->pag_agno)
+				break;
+			busyp = next;
+		}
+		if (wakeup) {
+			pag->pagb_gen++;
+			wake_up_all(&pag->pagb_wait);
+		}
+		spin_unlock(&pag->pagb_lock);
+		xfs_perag_put(pag);
+	
+		busyp = next;
+	} while (!list_entry_is_head(busyp, list, list));
 }
 
 /*
