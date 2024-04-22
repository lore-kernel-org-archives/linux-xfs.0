Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5D91465A8
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 11:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713784829; cv=none; b=ls5v8adDW0bGxCwnBAmSZabDzOpFdWCqLPqQxlMJXOVRh8KRbYhSuSNqW1P5+Nrh31ZCEScbleIIfnsAkwOwNhlaGbwaMAlBPgVLq3vEtSxrz9Bp5IWM/Fu6lkDLeEKabs8HZa6gX0OkLS+Ea6feQ0IC5MGjmnCovlJF0FFrU9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713784829; c=relaxed/simple;
	bh=ADvbqIXjxrjRO1P5Q44+TigMGw/BqHJsOrDimOH1y/w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MtzgF2Pe2BKPrgniPrSMgjP5D4w+FG6PBUh7r+AcmJ456RT4n2LkLGSm+L7yNEyu5TwBy1qVMLVqmFPdxpo1Bpcv5zQ2JKo5Rh44ityjiOLdqkJRe+j3jWvDpu2cuxRQMT1DRM28+/HR49zCIcNB0shWVUos9gOZwiJFFFLQ69E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JBzRntZM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JBzRntZM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9LyweYzSVjcvj0FFS9dX8bG23KO1zNtzLi+Cl9pJ/4s=; b=JBzRntZMqoe9vhFk1u9QUGdRKG
	xG2GwHfVnsvUnn70o8XwrpXtL9Cy1TT8dF9UfuKlC3EzJj/LcqBjkY1WIMoDNbLVaCRFerK9VpYSg
	J1qsxX0ACq1P/5AeEiTioKzB9BD/hTow8dXruMUPS2niczfgy6UEb3QBfrJxbswNNObgFzGMQC+Yg
	tufSWs3Imf6EMTAxAYDtI7Zmzh3iLlps5+ookmLuAUuL+Np/eDW6x8BQnvyD+hUDbAhDsKrhOOXfd
	038SAjF5K3edfg6qygWgV60GD7y8HP7xiayN8vnf9EQAzIRzFG+Rdb5XJ2XTawCoPLfgiWLsPG0xD
	fE0M3nVg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ryrik-0000000DKxK-3mqr;
	Mon, 22 Apr 2024 11:20:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 01/13] xfs: make XFS_TRANS_LOWMODE match the other XFS_TRANS_ definitions
Date: Mon, 22 Apr 2024 13:20:07 +0200
Message-Id: <20240422112019.212467-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240422112019.212467-1-hch@lst.de>
References: <20240422112019.212467-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Commit bb7b1c9c5dd3 ("xfs: tag transactions that contain intent done
items") switched the XFS_TRANS_ definitions to be bit based, and using
comments above the definitions.  As XFS_TRANS_LOWMODE was last and has
a big fat comment it was missed.  Switch it to the same style.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_shared.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index dfd61fa8332e1a..f35640ad3e7fe4 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -124,7 +124,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define XFS_TRANS_RES_FDBLKS		(1u << 6)
 /* Transaction contains an intent done log item */
 #define XFS_TRANS_HAS_INTENT_DONE	(1u << 7)
-
 /*
  * LOWMODE is used by the allocator to activate the lowspace algorithm - when
  * free space is running low the extent allocator may choose to allocate an
@@ -136,7 +135,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
  * for free space from AG 0. If the correct transaction reservations have been
  * made then this algorithm will eventually find all the space it needs.
  */
-#define XFS_TRANS_LOWMODE	0x100	/* allocate in low space mode */
+#define XFS_TRANS_LOWMODE		(1u << 8)
 
 /*
  * Field values for xfs_trans_mod_sb.
-- 
2.39.2

