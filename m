Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JPDb4eHn"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E104DB9
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pQgxYRQrH2IDFIpra9e+owboLXoPaOe68FbbpA3I4Ow=; b=JPDb4eHnQ4I7JdM9OsN23dqUhf
	xtxxxaCtBlqYeKXfC3u9mEb/uG8NeTdXV0N/M2Hz/dlr4HbVXnbzhCbsA9t2pLkhfkMzxM8lna/MT
	ZVP7Zodih0L+hOUilMG4w4A+wenBNqVfrtaxpGE4ILthSYEZDF6KJclUkKWJs2VF8ngDRv3suP7h0
	NT1xAYZpHBTtvU9pBqKajjJG/rsOsUdWiCYY+YqlPsx6x6dY9sG1WPu305btdsVlfMSTCnLRWu+8V
	Camd/6PbXS7ONQz/3wPfkItuIeDkEM2ayqNABF10LdBd7DhhtRqldfQGWnIyaWa9YaHyL5idoLkII
	ZyYGVsBQ==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDfJZ-00GzTO-0N;
	Thu, 14 Dec 2023 06:35:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 15/19] xfs: remove rt-wrappers from xfs_format.h
Date: Thu, 14 Dec 2023 07:34:34 +0100
Message-Id: <20231214063438.290538-16-hch@lst.de>
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

xfs_format.h has a bunch odd wrappers for helper functions and mount
structure access using RT* prefixes.  Replace them with their open coded
versions (for those that weren't entirely unused) and remove the wrappers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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
index 2e578e726e9137..70b4eb840df4f3 100644
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

