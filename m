Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1196FA4
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 04:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wIyOxLfX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bvxgx1Ypmdob1QTqsbd7AGaHTBSRRAPtpHbMxEDFeOo=; b=wIyOxLfXIbxOcbphwmKqa3fp0m
	Rb2Gl3txzz8j3G4sXAioXSao9gK7fGIDMX5h21FpPhMx+HgxUQm2yN+q7buaSJ4Xx1VDI6R6pP093
	sQtODj701XlvF3fhoOsB1xBB0GdrBvaN0G8ikfwiVIIJWF2HaJ0/fmY2Pmdg16eRKoYqcCHUoyawY
	H9jvdXLeYbjUidIc7XzTI2ayu63WdUJWUU+oKNG9gP+6KBQjjlNnkhuXYFtayYq24DInJLf8XKWAM
	ooWD1YRVhqdTA3MbpzKrauJokOgD0wejPRVixP19bOLhlSwznaiQA1nXZaEX1FZB7G7boCBOwL5ov
	lBPF6E1A==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rF5hj-0095BT-0a;
	Mon, 18 Dec 2023 04:58:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/22] xfs: invert a check in xfs_rtallocate_extent_block
Date: Mon, 18 Dec 2023 05:57:28 +0100
Message-Id: <20231218045738.711465-13-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231218045738.711465-1-hch@lst.de>
References: <20231218045738.711465-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Doing a break in the else side of a conditional is rather silly.  Invert
the check, break ASAP and unindent the other leg.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index fbc60658ef24bf..924665b66210ed 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -283,12 +283,11 @@ xfs_rtallocate_extent_block(
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
 	/*
 	 * Searched the whole thing & didn't find a maxlen free extent.
-- 
2.39.2

