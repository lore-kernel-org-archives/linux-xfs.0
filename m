Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE20415381C
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804024; cv=none; b=iblbzLB8kS2NUBRN6Jgy7T4EMUrJSAyjktdvyVqBFTduYFCSsgMdXNpOYf68DUmhz7Kv7NivQwhwQhykAqQ4Wv0y0mc2R6QI8RuwW1jYftMxMDP6UsAkmbuxYSKZUxww8/WLj9HvG3e/+un3yiQbuJVtRrnYOYoxw40ON8k9piE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804024; c=relaxed/simple;
	bh=LtvFK+XjmBa1pyC2AmAVTKKzbkA+sjg6mj1jT3WDKV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noPNoT7Gbopgz/Q9NRn72v6gxnxDH5Vs9Hdm/J+2+QM/Ymf9PfCgK9rMpw3JnZDqpXVUBuup4r3f8CcHGfdyw5gC7pnFq+3Pa8YvTdJrpKnEDSy5UvD4emuTGcB4AYn1yKY94QSR0TtxseI1G/ihk2pggshOvUJZKleNC4NuizQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DHqqE67X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DHqqE67X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D398AC32786;
	Mon, 22 Apr 2024 16:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804023;
	bh=LtvFK+XjmBa1pyC2AmAVTKKzbkA+sjg6mj1jT3WDKV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHqqE67X5ncPX+WKUWgGU7ILz6NhfgmVPdNKy1aMtzu0XXDoSSZODJ1pPaXUtKJjU
	 SEsrJTFZwBafNOemFkJk9K6lgIezc1pnyL0boNL6vrNgCbLc//fu6OKHc/hnD7BakA
	 7IzUr6aBH3abuwolJh62krJPRShg6J5k8r7sqfeQHg/6gVGWuhslSDz259ydouq8VO
	 ENCFs1tzMDQCZhvr2fPJAHU7PKWuZVXALS63kElcOMNRFfauP57cb4kBuSl5xxHdLs
	 frnV++mynb1TBCkQHCCKPQf2h208qPQvbAIYmCSH+N1o6fePXGidbJ63dDxA9KGN+9
	 MhCXZ4SksJoXg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 50/67] xfs: move xfs_rtget_summary to xfs_rtbitmap.c
Date: Mon, 22 Apr 2024 18:26:12 +0200
Message-ID: <20240422163832.858420-52-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: c2adcfa31ff606264fab6e69129d6d45c9ddb7cb

xfs_rtmodify_summary_int is only used inside xfs_rtbitmap.c and to
implement xfs_rtget_summary.  Move xfs_rtget_summary to xfs_rtbitmap.c
as the exported API and mark xfs_rtmodify_summary_int static.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtbitmap.c | 14 ++++++++++++++
 libxfs/xfs_rtbitmap.h |  4 ++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 726543abb..adeaffed7 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -517,6 +517,20 @@ xfs_rtmodify_summary(
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
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 1c84b52de..274dc7dae 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
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
-- 
2.44.0

