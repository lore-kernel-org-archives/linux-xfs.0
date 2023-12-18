Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DFF63A3
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 04:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gvHbgsLk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jXylWAa9f+9Kxm+HUGbVvHnCyR4dgtrxQq2groWnc3s=; b=gvHbgsLkkGWTugU6Lio8aJqRHj
	zdxH9en3d7AAZikiKbjKOCfCH0TaM7ZPTK8PrHeMubo6JLVLDOfH7OiE/kuwVeKOxiZ9G6A1P8zz8
	h0eC8lG8GBKjbJZBXFG3MU1WUQ9ddyCTWPBSxG7Zl1VTfIKzWRpvPuTkOWqUokRJf90001dCMrDmB
	QLg7xH+avodcsIRd5Nfl4yOIeDMs1tcZxvlmAsj+fNhexLh2uX549YZvBqkINRzK+7HfOeaxQtW/J
	Xnf99nbwIiCrn+TM5IRfay2iRhA+UznKAFEI+qU1deQmalRAMPa2YZ1dvXfXs3IJ21reJMYLS3CZn
	h6U2R9jg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rF5hw-0095G6-1c;
	Mon, 18 Dec 2023 04:58:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 17/22] xfs: remove rt-wrappers from xfs_format.h
Date: Mon, 18 Dec 2023 05:57:33 +0100
Message-Id: <20231218045738.711465-18-hch@lst.de>
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

xfs_format.h has a bunch odd wrappers for helper functions and mount
structure access using RT* prefixes.  Replace them with their open coded
versions (for those that weren't entirely unused) and remove the wrappers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h   |  8 --------
 fs/xfs/libxfs/xfs_rtbitmap.c | 24 ++++++++++++------------
 fs/xfs/scrub/rtsummary.c     |  2 +-
 fs/xfs/xfs_rtalloc.c         |  6 +++---
 4 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 9a88aba1589f87..82a4ab2d89e9f0 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1156,20 +1156,12 @@ static inline bool xfs_dinode_has_large_extent_counts(
 #define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64kB */
 #define	XFS_MIN_RTEXTSIZE	(4 * 1024)		/* 4kB */
 
-#define	XFS_BLOCKSIZE(mp)	((mp)->m_sb.sb_blocksize)
-#define	XFS_BLOCKMASK(mp)	((mp)->m_blockmask)
-
 /*
  * RT bit manipulation macros.
  */
 #define	XFS_RTMIN(a,b)	((a) < (b) ? (a) : (b))
 #define	XFS_RTMAX(a,b)	((a) > (b) ? (a) : (b))
 
-#define	XFS_RTLOBIT(w)	xfs_lowbit32(w)
-#define	XFS_RTHIBIT(w)	xfs_highbit32(w)
-
-#define	XFS_RTBLOCKLOG(b)	xfs_highbit64(b)
-
 /*
  * Dquot and dquot block format definitions
  */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 5773e4ea36c624..4185ccf83bab68 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -195,7 +195,7 @@ xfs_rtfind_back(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			i = bit - XFS_RTHIBIT(wdiff);
+			i = bit - xfs_highbit32(wdiff);
 			*rtx = start - i + 1;
 			return 0;
 		}
@@ -233,7 +233,7 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
+			i += XFS_NBWORD - 1 - xfs_highbit32(wdiff);
 			*rtx = start - i + 1;
 			return 0;
 		}
@@ -272,7 +272,7 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
+			i += XFS_NBWORD - 1 - xfs_highbit32(wdiff);
 			*rtx = start - i + 1;
 			return 0;
 		} else
@@ -348,7 +348,7 @@ xfs_rtfind_forw(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			i = XFS_RTLOBIT(wdiff) - bit;
+			i = xfs_lowbit32(wdiff) - bit;
 			*rtx = start + i - 1;
 			return 0;
 		}
@@ -386,7 +386,7 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			i += XFS_RTLOBIT(wdiff);
+			i += xfs_lowbit32(wdiff);
 			*rtx = start + i - 1;
 			return 0;
 		}
@@ -423,7 +423,7 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			i += XFS_RTLOBIT(wdiff);
+			i += xfs_lowbit32(wdiff);
 			*rtx = start + i - 1;
 			return 0;
 		} else
@@ -708,7 +708,7 @@ xfs_rtfree_range(
 	 */
 	if (preblock < start) {
 		error = xfs_rtmodify_summary(args,
-				XFS_RTBLOCKLOG(start - preblock),
+				xfs_highbit64(start - preblock),
 				xfs_rtx_to_rbmblock(mp, preblock), -1);
 		if (error) {
 			return error;
@@ -720,7 +720,7 @@ xfs_rtfree_range(
 	 */
 	if (postblock > end) {
 		error = xfs_rtmodify_summary(args,
-				XFS_RTBLOCKLOG(postblock - end),
+				xfs_highbit64(postblock - end),
 				xfs_rtx_to_rbmblock(mp, end + 1), -1);
 		if (error) {
 			return error;
@@ -731,7 +731,7 @@ xfs_rtfree_range(
 	 * (new) free extent.
 	 */
 	return xfs_rtmodify_summary(args,
-			XFS_RTBLOCKLOG(postblock + 1 - preblock),
+			xfs_highbit64(postblock + 1 - preblock),
 			xfs_rtx_to_rbmblock(mp, preblock), 1);
 }
 
@@ -800,7 +800,7 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			i = XFS_RTLOBIT(wdiff) - bit;
+			i = xfs_lowbit32(wdiff) - bit;
 			*new = start + i;
 			*stat = 0;
 			return 0;
@@ -839,7 +839,7 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			i += XFS_RTLOBIT(wdiff);
+			i += xfs_lowbit32(wdiff);
 			*new = start + i;
 			*stat = 0;
 			return 0;
@@ -877,7 +877,7 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			i += XFS_RTLOBIT(wdiff);
+			i += xfs_lowbit32(wdiff);
 			*new = start + i;
 			*stat = 0;
 			return 0;
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 8b15c47408d031..0689025aa4849d 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -143,7 +143,7 @@ xchk_rtsum_record_free(
 
 	/* Compute the relevant location in the rtsum file. */
 	rbmoff = xfs_rtx_to_rbmblock(mp, rec->ar_startext);
-	lenlog = XFS_RTBLOCKLOG(rec->ar_extcount);
+	lenlog = xfs_highbit64(rec->ar_extcount);
 	offs = xfs_rtsumoffs(mp, lenlog, rbmoff);
 
 	rtbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6b8b657e40dc0b..dac6f17e4f0305 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -156,7 +156,7 @@ xfs_rtallocate_range(
 	 * (old) free extent.
 	 */
 	error = xfs_rtmodify_summary(args,
-			XFS_RTBLOCKLOG(postblock + 1 - preblock),
+			xfs_highbit64(postblock + 1 - preblock),
 			xfs_rtx_to_rbmblock(mp, preblock), -1);
 	if (error)
 		return error;
@@ -167,7 +167,7 @@ xfs_rtallocate_range(
 	 */
 	if (preblock < start) {
 		error = xfs_rtmodify_summary(args,
-				XFS_RTBLOCKLOG(start - preblock),
+				xfs_highbit64(start - preblock),
 				xfs_rtx_to_rbmblock(mp, preblock), 1);
 		if (error)
 			return error;
@@ -179,7 +179,7 @@ xfs_rtallocate_range(
 	 */
 	if (postblock > end) {
 		error = xfs_rtmodify_summary(args,
-				XFS_RTBLOCKLOG(postblock - end),
+				xfs_highbit64(postblock - end),
 				xfs_rtx_to_rbmblock(mp, end + 1), 1);
 		if (error)
 			return error;
-- 
2.39.2

