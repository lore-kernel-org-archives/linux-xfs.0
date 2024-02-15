Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF74A57872
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998983; cv=none; b=uVczFxyo78jPU/e7CVJWMo+w6iHabh5JpNA22Z/7J+vhAM9yPX356FEGmmqOte1cpjiANIZBNe4OJKKePHQNvpNsFnJn/zirs2cnluACU63mSNcnsIZr9y7TieBWmrzfANAGVJ6wgpm4zYsM/v4lBiOoAjV+bwbh24ZaB3lh1Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998983; c=relaxed/simple;
	bh=1On0fX3NB/NOv4ztxAPBzxWSRWhiBImnIFdRwbEPHsc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3cHmd4orTofk0uNYc3z1y351TUlHzVr6PgNyOzHx4Xd2LYs9AnF8TYeTbCLrlh3pRXAjshAEXLpc/vjIkGiuEdpyH7IaDNTRDCm07MzPn5T5Xxvgbd7BwPsruBrk6+pmBIJd2pqKayXNY8T80PwRavMnLyRJ1YYez/WTfXqOx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CnB6Ak7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CnB6Ak7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E018C433C7
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998982;
	bh=1On0fX3NB/NOv4ztxAPBzxWSRWhiBImnIFdRwbEPHsc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CnB6Ak7Io04hliGKLTG3Syg5FHT/VdhcDE4Ql5ViinCt2b6K/GDpjHHJoAkwd6HVB
	 tjl+nXGJ33BmTzmKKLnxQIpFxM4BCJ6RVh5NQLGCyGBT0H85oYOs5fgECo+z5rWfaj
	 qaIY89Fos4k8d0cpgtJKfI7LjhLasOCHjuEgsZsahTADJcn7Db1jVpnlcDwujOaToy
	 wXUgf0NjgAYP8/Uxv0YP3Ph7o0zBzb7nJXQc15fdVM1HGmV9Xqui48x5kII4Ds/Dz3
	 rBHzYSPGJnopop/iCWtKQDyUdhFtjfnkR74LCqB/su6nro1Vl4liike+DUvRxsOWR1
	 FTHy794TB66Eg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 26/35] xfs: use accessor functions for summary info words
Date: Thu, 15 Feb 2024 13:08:38 +0100
Message-ID: <20240215120907.1542854-27-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 663b8db7b0256b81152b2f786e45ecf12bdf265f

Create get and set functions for rtsummary words so that we can redefine
the ondisk format with a specific endianness.  Note that this requires
the definition of a distinct type for ondisk summary info words so that
the compiler can perform proper typechecking.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_format.h   |  8 ++++++++
 libxfs/xfs_rtbitmap.c | 15 ++++++++-------
 libxfs/xfs_rtbitmap.h | 28 ++++++++++++++++++++++++++--
 3 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 2af891d5d..9a88aba15 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -698,6 +698,14 @@ union xfs_rtword_raw {
 	__u32		old;
 };
 
+/*
+ * Realtime summary counts are accessed by the word, which is currently
+ * stored in host-endian format.
+ */
+union xfs_suminfo_raw {
+	__u32		old;
+};
+
 /*
  * XFS Timestamps
  * ==============
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 44064b6b3..869d26e79 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -449,7 +449,6 @@ xfs_rtmodify_summary_int(
 	int		error;		/* error value */
 	xfs_fileoff_t	sb;		/* summary fsblock */
 	xfs_rtsumoff_t	so;		/* index into the summary file */
-	xfs_suminfo_t	*sp;		/* pointer to returned data */
 	unsigned int	infoword;
 
 	/*
@@ -488,19 +487,21 @@ xfs_rtmodify_summary_int(
 	 * Point to the summary information, modify/log it, and/or copy it out.
 	 */
 	infoword = xfs_rtsumoffs_to_infoword(mp, so);
-	sp = xfs_rsumblock_infoptr(bp, infoword);
 	if (delta) {
-		*sp += delta;
+		xfs_suminfo_t	val = xfs_suminfo_add(bp, infoword, delta);
+
 		if (mp->m_rsum_cache) {
-			if (*sp == 0 && log == mp->m_rsum_cache[bbno])
+			if (val == 0 && log == mp->m_rsum_cache[bbno])
 				mp->m_rsum_cache[bbno]++;
-			if (*sp != 0 && log < mp->m_rsum_cache[bbno])
+			if (val != 0 && log < mp->m_rsum_cache[bbno])
 				mp->m_rsum_cache[bbno] = log;
 		}
 		xfs_trans_log_rtsummary(tp, bp, infoword);
+		if (sum)
+			*sum = val;
+	} else if (sum) {
+		*sum = xfs_suminfo_get(bp, infoword);
 	}
-	if (sum)
-		*sum = *sp;
 	return 0;
 }
 
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 62138df6d..e4268faa6 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -235,16 +235,40 @@ xfs_rtsumoffs_to_infoword(
 }
 
 /* Return a pointer to a summary info word within a rt summary block. */
-static inline xfs_suminfo_t *
+static inline union xfs_suminfo_raw *
 xfs_rsumblock_infoptr(
 	struct xfs_buf		*bp,
 	unsigned int		index)
 {
-	xfs_suminfo_t		*info = bp->b_addr;
+	union xfs_suminfo_raw	*info = bp->b_addr;
 
 	return info + index;
 }
 
+/* Get the current value of a summary counter. */
+static inline xfs_suminfo_t
+xfs_suminfo_get(
+	struct xfs_buf		*bp,
+	unsigned int		index)
+{
+	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(bp, index);
+
+	return info->old;
+}
+
+/* Add to the current value of a summary counter and return the new value. */
+static inline xfs_suminfo_t
+xfs_suminfo_add(
+	struct xfs_buf		*bp,
+	unsigned int		index,
+	int			delta)
+{
+	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(bp, index);
+
+	info->old += delta;
+	return info->old;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
-- 
2.43.0

