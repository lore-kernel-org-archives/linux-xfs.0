Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09D9148832
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609074; cv=none; b=Lt6sZpRk3PRNRpa7K7X3ggzaMSrxiCemc3bI5ZHh7CMJwhxMqMsyrHCVdGRSG11/B0dJOO2jMuUr1Qc/wmzYNiR7QhGHSIWNBmWHCCrER3M0Nd6iyxqzG2Ub90CyR5jEonEDz5ppzQdn5Zk9NkpsdcSfbrd0mJ0HShJk5UrCtfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609074; c=relaxed/simple;
	bh=bHR/40QZa/CIYpWpQYFkXvqDTbyAEsP36vkF3Yfw99w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cv5fAr2UoV8jfB5kolNWNOVW77HXsKmWhPpL/ceFM0JNUhrgfakbTxBCxOlvGKNi7KNpR5HjtyYftnrCik+LeHg6GmjbXf61T4qr5NMYtV0nY2yEbKSTzOHpuo5Sm10m1P2h3qFgxEaFvfey0hIVBj9I3UUxn3zVNf1wbV757l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ebnlLAJb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ebnlLAJb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nicK/+aSrQuWtxv4RDRCtM5OSfprVtlp4iDL3/ByPkI=; b=ebnlLAJbf313lhtPKBNOx5Vdmq
	nkdRjGrw74i/7NaDxcasdUKQyhjM7WPLdY3HCKoV/HUuO1Js6M5OSjL2+pYdDUZDQ3/T19dVwlT81
	fbtq0zqXsjs/ms4kiAPrIZ8QxbPq+hOg6y5Tl+cqBi9ZJLPx6JjfEx+SZe7Lr+EUynG2tJe9mh4Mh
	RsUYfxOC9u9sWuY92Hh2BU6ibpFrJtLAq7LX3qSOoTD1RSq4JZFuEpuz9urtSw1i9PWFQcjvHfEcP
	96REUn6QDY7tLxR70mFKZE0U9VctjMSvHa72D9PNIoOIABdL2xCjAeXupVuw3hMmLzM05ceUqpRlu
	BxUOmJxQ==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CW1-00000000iM2-0E23;
	Mon, 14 Apr 2025 05:37:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 28/43] xfs_repair: fix the RT device check in process_dinode_int
Date: Mon, 14 Apr 2025 07:36:11 +0200
Message-ID: <20250414053629.360672-29-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Don't look at the variable for the rtname command line option, but
the actual file system geometry.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index 7bdd3dcf15c1..8ca0aa0238c7 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -3265,8 +3265,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			flags &= XFS_DIFLAG_ANY;
 		}
 
-		/* need an rt-dev for the realtime flag! */
-		if ((flags & XFS_DIFLAG_REALTIME) && !rt_name) {
+		/* need an rt-dev for the realtime flag */
+		if ((flags & XFS_DIFLAG_REALTIME) && !mp->m_sb.sb_rextents) {
 			if (!uncertain) {
 				do_warn(
 	_("inode %" PRIu64 " has RT flag set but there is no RT device\n"),
-- 
2.47.2

