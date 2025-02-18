Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2691B87CF
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866413; cv=none; b=NBZonRJvXxmewdg0liuERrIC4+XuoFEnprZQ/feVAuI8jZNYR+JvdH9DSHgIC3DpY6kpGU3ASUy8DigR80m68hhxlkk6PXYg48p3MLUIpc3rKYNtZVet2Q49iMnPjOLhPQ/ze2x3lsm2G5JOdC+TUrU8erv+wPVlhzLN0v/6tOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866413; c=relaxed/simple;
	bh=o4qmu71mfsG0w66cyvwU+ui0elQnmaPwk3CEYVzA/w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtCGlf1ef5NDIkKHTY5nnmpiSmIQvxJ1hlaU/5Jb+zGLgISqZsCDBFnYioL9co/+WJCzJdi9GtWscqhSsn9vTS4CJVy1khReAr+yM34cgZVrJpp/SgyR7yVR/ZHtv4FLPDrPn7AYIvz9EUWArSz0qJKNQ5ohsFEUJhvI11KE3KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0gyIDmHH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0gyIDmHH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bC3TDk74gJ3fKZm+X3vAcQvxIZluCPHKLeeO5DbfNqk=; b=0gyIDmHH5GYlBctfT8FjkfiqN/
	MbHcXkYNSfTBwiLTJJ+6omkrAfNzEXtsBz2gPrcbN4ntUaSUfe9biGgfoBoeOc5Lev+5ZG42mvwtg
	LqFhL+OI3LjH1BAmywwr+iom8Lgc59ceP+2ijMMqF5X76wgvrMQKEQFN4QsAXRcpxIOYA7ZmWUBJT
	cDkBeA/Cr2jSen+oWf0frLgDPvLLhL4IMR1zwduKE6gV4bpLy0f1FSIALrBg6OrstqhOTIs3uhogs
	QZFeb1+XCwuib84//TwJxQo2xzytM4j7Knkmpp0hsdvh9a0w/Xp+MpA87oo2RCAS800/H1WKiLj7a
	dVvofOXQ==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIjT-00000007Civ-0DhN;
	Tue, 18 Feb 2025 08:13:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 32/45] xfs: allow COW forks on zoned file systems in xchk_bmap
Date: Tue, 18 Feb 2025 09:10:35 +0100
Message-ID: <20250218081153.3889537-33-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Zoned file systems can have COW forks even without reflinks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 66da7d4d56ba..4f1e2574660d 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -1038,8 +1038,8 @@ xchk_bmap(
 
 	switch (whichfork) {
 	case XFS_COW_FORK:
-		/* No CoW forks on non-reflink filesystems. */
-		if (!xfs_has_reflink(mp)) {
+		/* No CoW forks filesystem doesn't support out of place writes */
+		if (!xfs_has_reflink(mp) && !xfs_has_zoned(mp)) {
 			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 			return 0;
 		}
-- 
2.45.2

