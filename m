Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nVTv5wbu"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDFEA6
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yE+rdZD9NroxBGJ0htqSosyhpKor4f9HCE4ehNpTug4=; b=nVTv5wbuUQmKnAilzIvU59QxL7
	4fYFb10vCBAP8oN3ReFmz3oeVS8M7fDXFcP9rxVy0BP6BXmU5u4LG1fRvC6bsKTCQErX8y+zurjrS
	fIebgU6HUF1g7O8m1YDCtKcLigJkY8hN6a/VTX3ZVjxT4w0NGDFBlYDs+cUiD0maVddEmXgFOkW2k
	fHKd1tbLkXKpIc4Pg/KrnqYptH9hmh3cHMt4qdVdS3Yqv8kaPx9oG43dsxx63N3hrY9O/xaCcQdKK
	RCGc9YNVTEqKzT7jC0UvFP/+fmnI4Ijqv4KocbddAsKCSDi6gotOGebK5qHygssdh6+pUZf2XyFBJ
	5dQQPdNQ==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDfJR-00GzQh-15;
	Thu, 14 Dec 2023 06:35:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/19] xfs: tidy up xfs_rtallocate_extent_block
Date: Thu, 14 Dec 2023 07:34:31 +0100
Message-Id: <20231214063438.290538-13-hch@lst.de>
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

Share the xfs_rtallocate_range logic by breaking out of the loop
instead of duplicating it, invert a check so that the early
return case comes first instead of in an else, and handle the
successful case in the straight line instead a branch in the tail
of the function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 63 +++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index fbc60658ef24bf..5f42422a976a3e 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -257,13 +257,9 @@ xfs_rtallocate_extent_block(
 			/*
 			 * i for maxlen is all free, allocate and return that.
 			 */
-			error = xfs_rtallocate_range(args, i, maxlen);
-			if (error)
-				return error;
-
-			*len = maxlen;
-			*rtx = i;
-			return 0;
+			bestlen = maxlen;
+			besti = i;
+			break;
 		}
 		/*
 		 * In the case where we have a variable-sized allocation
@@ -283,43 +279,44 @@ xfs_rtallocate_extent_block(
 		/*
 		 * If not done yet, find the start of the next free space.
 		 */
-		if (next < end) {
-			error = xfs_rtfind_forw(args, next, end, &i);
-			if (error)
-				return error;
-		} else
+		if (next >= end)
 			break;
+		error = xfs_rtfind_forw(args, next, end, &i);
+		if (error)
+			return error;
 	}
+
 	/*
 	 * Searched the whole thing & didn't find a maxlen free extent.
 	 */
-	if (minlen <= maxlen && besti != -1) {
-		xfs_rtxlen_t	p;	/* amount to trim length by */
-
+	if (maxlen < minlen || besti == -1) {
 		/*
-		 * If size should be a multiple of prod, make that so.
+		 * Allocation failed.  Set *nextp to the next block to try.
 		 */
-		if (prod > 1) {
-			div_u64_rem(bestlen, prod, &p);
-			if (p)
-				bestlen -= p;
-		}
+		*nextp = next;
+		return -ENOSPC;
+	}
 
-		/*
-		 * Allocate besti for bestlen & return that.
-		 */
-		error = xfs_rtallocate_range(args, besti, bestlen);
-		if (error)
-			return error;
-		*len = bestlen;
-		*rtx = besti;
-		return 0;
+	/*
+	 * If size should be a multiple of prod, make that so.
+	 */
+	if (prod > 1) {
+		xfs_rtxlen_t	p;	/* amount to trim length by */
+
+		div_u64_rem(bestlen, prod, &p);
+		if (p)
+			bestlen -= p;
 	}
+
 	/*
-	 * Allocation failed.  Set *nextp to the next block to try.
+	 * Allocate besti for bestlen & return that.
 	 */
-	*nextp = next;
-	return -ENOSPC;
+	error = xfs_rtallocate_range(args, besti, bestlen);
+	if (error)
+		return error;
+	*len = bestlen;
+	*rtx = besti;
+	return 0;
 }
 
 /*
-- 
2.39.2

