Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qsdedf9g"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC73A6
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ESR1YJ2kSkuWz1X/07urbz8GKffpJKgu9yphxrE8Xes=; b=qsdedf9g+vY3RoPJTLWUWEHIYP
	O9xFxHkXdkn+iMaS1yeyZ5fD0HDH6120aiyDl7RbDymcsyt76P8zwx/ce5W1u3F68YU6AKvKa+haa
	PXMztuWS0J35/61iJOUwsbHOLqNmEEAdHL5WYpgDF0Xp6PiNR+bRMz7aFt/wIUnASS6fOW8X/Kqmg
	LnYFofC+IWjF5iFiFq8necjKLdR5ODkwHBGb6h8lpJyeWr2K+6xdlgi0a0vPz/hFamWDMkKNgoSeV
	vegSOAehbFRVPSfvtUdTfkKGARzLjqqK7U6OoQgIvidzNwAxpTIBFQ17Kx5m1tqY0Rr03ha0qBAg7
	GEx7Kmnw==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDfJM-00GzPa-0D;
	Thu, 14 Dec 2023 06:35:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/19] xfs: move xfs_rtget_summary to xfs_rtbitmap.c
Date: Thu, 14 Dec 2023 07:34:29 +0100
Message-Id: <20231214063438.290538-11-hch@lst.de>
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

xfs_rtmodify_summary_int is only used inside xfs_rtbitmap.c and to
implement xfs_rtget_summary.  Move xfs_rtget_summary to xfs_rtbitmap.c
as the exported API and mark xfs_rtmodify_summary_int static.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.c | 14 ++++++++++++++
 fs/xfs/libxfs/xfs_rtbitmap.h |  4 ++--
 fs/xfs/xfs_rtalloc.c         | 16 ----------------
 3 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 30a2844f62e30f..e67f6f763f7d0f 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -519,6 +519,20 @@ xfs_rtmodify_summary(
 	return xfs_rtmodify_summary_int(args, log, bbno, delta, NULL);
 }
 
+/*
+ * Read and return the summary information for a given extent size, bitmap block
+ * combination.
+ */
+int
+xfs_rtget_summary(
+	struct xfs_rtalloc_args	*args,
+	int			log,	/* log2 of extent size */
+	xfs_fileoff_t		bbno,	/* bitmap block number */
+	xfs_suminfo_t		*sum)	/* out: summary info for this block */
+{
+	return xfs_rtmodify_summary_int(args, log, bbno, 0, sum);
+}
+
 /* Log rtbitmap block from the word @from to the byte before @next. */
 static inline void
 xfs_trans_log_rtbitmap(
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 1c84b52de3d424..274dc7dae1faf8 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -321,8 +321,8 @@ int xfs_rtfind_forw(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
 		xfs_rtxnum_t limit, xfs_rtxnum_t *rtblock);
 int xfs_rtmodify_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
 		xfs_rtxlen_t len, int val);
-int xfs_rtmodify_summary_int(struct xfs_rtalloc_args *args, int log,
-		xfs_fileoff_t bbno, int delta, xfs_suminfo_t *sum);
+int xfs_rtget_summary(struct xfs_rtalloc_args *args, int log,
+		xfs_fileoff_t bbno, xfs_suminfo_t *sum);
 int xfs_rtmodify_summary(struct xfs_rtalloc_args *args, int log,
 		xfs_fileoff_t bbno, int delta);
 int xfs_rtfree_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 2ce3bcf4b84b76..fbc60658ef24bf 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -23,22 +23,6 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_quota.h"
 
-/*
- * Read and return the summary information for a given extent size,
- * bitmap block combination.
- * Keeps track of a current summary block, so we don't keep reading
- * it from the buffer cache.
- */
-static int
-xfs_rtget_summary(
-	struct xfs_rtalloc_args	*args,
-	int			log,	/* log2 of extent size */
-	xfs_fileoff_t		bbno,	/* bitmap block number */
-	xfs_suminfo_t		*sum)	/* out: summary info for this block */
-{
-	return xfs_rtmodify_summary_int(args, log, bbno, 0, sum);
-}
-
 /*
  * Return whether there are any free extents in the size range given
  * by low and high, for the bitmap block bbno.
-- 
2.39.2

