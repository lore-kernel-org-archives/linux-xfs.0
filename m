Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OHx7/6nP"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B66C100
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WZdPn/4A1m0DU/bFDiNA+p3G37mgVI/ibSKJm7YBIaU=; b=OHx7/6nPnzFxyok344F85dqr/E
	Qcy5WZ68igfj9bcnhgZKMUG/YJwy4V7ZDThoTtkV7xxWUtCc4bHIPCCeOR0o9u3MurtAu8LHCw6hs
	cawcjrk17BKpm8lOTIR91FFr/zZNUmLuvJjUX41cBShsjXfDXmrHuqfAXb7dbc/I5Ek6aQhH6EBys
	L2FNK7usdXHLQl/NxNQUMQX7Wy5QmmeN+BnW7RT0Dr3mgCVj7epYqUFVCZU6FtwO52QqEnyZg/0qy
	363OuvWNMdtRya/jXmaH3aVl51UYxdYoPxI6Vw7Kv5romQkduL1gMJBuSAK+RS0tz4fbFODmk6To7
	mVf5+a6w==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDfJT-00GzRe-2p;
	Thu, 14 Dec 2023 06:35:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 13/19] xfs: tidy up xfs_rtallocate_extent_exact
Date: Thu, 14 Dec 2023 07:34:32 +0100
Message-Id: <20231214063438.290538-14-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231214063438.290538-1-hch@lst.de>
References: <20231214063438.290538-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use common code for both xfs_rtallocate_range calls by moving
the !isfree logic into the non-default branch.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 5f42422a976a3e..ea6f221c6a193c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -349,32 +349,24 @@ xfs_rtallocate_extent_exact(
 	if (error)
 		return error;
 
-	if (isfree) {
+	if (!isfree) {
 		/*
-		 * If it is, allocate it and return success.
+		 * If not, allocate what there is, if it's at least minlen.
 		 */
-		error = xfs_rtallocate_range(args, start, maxlen);
-		if (error)
-			return error;
-		*len = maxlen;
-		*rtx = start;
-		return 0;
-	}
-	/*
-	 * If not, allocate what there is, if it's at least minlen.
-	 */
-	maxlen = next - start;
-	if (maxlen < minlen)
-		return -ENOSPC;
-
-	/*
-	 * Trim off tail of extent, if prod is specified.
-	 */
-	if (prod > 1 && (i = maxlen % prod)) {
-		maxlen -= i;
+		maxlen = next - start;
 		if (maxlen < minlen)
 			return -ENOSPC;
+
+		/*
+		 * Trim off tail of extent, if prod is specified.
+		 */
+		if (prod > 1 && (i = maxlen % prod)) {
+			maxlen -= i;
+			if (maxlen < minlen)
+				return -ENOSPC;
+		}
 	}
+
 	/*
 	 * Allocate what we can and return it.
 	 */
-- 
2.39.2

