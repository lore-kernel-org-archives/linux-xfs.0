Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40027 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754328AbcKEA1k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:27:40 -0400
Subject: [PATCH 29/39] xfs: scrub should cross-reference the realtime bitmap
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:27:37 -0700
Message-ID: <147830565697.4165.16930074308934665449.stgit@birch.djwong.org>
In-Reply-To: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
References: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

While we're scrubbing various btrees, cross-reference the records
with the other metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_rtbitmap.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 70ea975..80fff5f 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1011,3 +1011,33 @@ xfs_rtfree_extent(
 	}
 	return 0;
 }
+
+/* Is the given extent all free? */
+int
+xfs_rtbitmap_extent_is_free(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	xfs_rtblock_t			start,
+	xfs_rtblock_t			len,
+	bool				*is_free)
+{
+	xfs_rtblock_t			end;
+	xfs_extlen_t			clen;
+	int				matches;
+	int				error;
+
+	*is_free = false;
+	while (len) {
+		clen = len > ~0U ? ~0U : len;
+		error = xfs_rtcheck_range(mp, tp, start, clen, 1, &end,
+				&matches);
+		if (error || !matches || end < start + clen)
+			return error;
+
+		len -= end - start;
+		start = end + 1;
+	}
+
+	*is_free = true;
+	return error;
+}

