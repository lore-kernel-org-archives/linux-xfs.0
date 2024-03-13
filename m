Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7217B663
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295564; cv=none; b=SN2WPLfBg+ZnvjBv/sm2odAphHLJxq8osvt/P84bnWR3aVeXe/NLuS1xtYCN2OtYLGg82WIwI68Tn63G5t3+GUC/MlSk1oM8NQi4Thhywh3NbV0j1IroD34tPAzMhWDJl+92Q1vYmozL9osP4mFYKW9sMUx8h6GuZyqPxvhvbVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295564; c=relaxed/simple;
	bh=d135qYkL5tZTrvIZtfe1/acmvqKeoAyrztESqwQiWjE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h/QkFXXMdZK9e406PDVyT0IEoDMhaHTspP5eWmsQnLBWomSqVdHWODiHMMcsT24Is0L2tzs16CTrPPf0hZaEjltcWFmdtoAHs3+U9oYLNXn4U/j3vPEhcQsXBhEf/Z3ur3ntAIr4qBTdEejhKSKfOqAS/50wOh6Zw/SuFR1iE80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dQLP/xx5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dQLP/xx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DA0C433F1;
	Wed, 13 Mar 2024 02:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295564;
	bh=d135qYkL5tZTrvIZtfe1/acmvqKeoAyrztESqwQiWjE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dQLP/xx5+a37EFEiZXyAG43OY1F6iJzl4wNGbaBMlaK3Xly4iMVEBEZ4YbQiYIscD
	 NAmPst16P2ZiVnojQ8oz6o/+gjSn6Sj1xL9e8dBeJIFqUrM/0lA1yNWx5c/TNVJMrp
	 Wr8Toun9ujaBy9yVjyRWoOjpVXk9x7h8V+KJWEw65hB2JdKFJJk8pUk0wPe0fV36vT
	 6wYsmG1DJK6vdiefE/p7V0Wz3SAAse9XvkfD1bSLTQ1IkvNLgi+R2NqjyQrOrG19JS
	 SWNb9qlf82dtPoBaXKYgOoztyqiX2Vn7gE2tiUvPp3vk40k5FLLDwwV75ayrUF8fPE
	 IdbmuwUi8rFjg==
Date: Tue, 12 Mar 2024 19:06:04 -0700
Subject: [PATCH 50/67] xfs: move xfs_rtget_summary to xfs_rtbitmap.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <171029431915.2061787.9801038684009357665.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: c2adcfa31ff606264fab6e69129d6d45c9ddb7cb

xfs_rtmodify_summary_int is only used inside xfs_rtbitmap.c and to
implement xfs_rtget_summary.  Move xfs_rtget_summary to xfs_rtbitmap.c
as the exported API and mark xfs_rtmodify_summary_int static.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_rtbitmap.c |   14 ++++++++++++++
 libxfs/xfs_rtbitmap.h |    4 ++--
 2 files changed, 16 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 726543abb51a..adeaffed7764 100644
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
index 1c84b52de3d4..274dc7dae1fa 100644
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

