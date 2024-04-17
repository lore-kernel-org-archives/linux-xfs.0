Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E317F65190
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389690; cv=none; b=qSOmOsGSCnLf7OHkItuPcDHhKPBLHl+UQNUYR/FvTwFvghiUfbTRRJZzYz4smCpM6Y8ncESkg0+RzcV71j7N7hz4L0iqzooP3DU2B3EkBsKNLCDMBCTqLfHSoRfCcVqEjObMCjjma5GQPfn7uJK+qF+BSKlsfpUWT6wHnPHrxm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389690; c=relaxed/simple;
	bh=rsYdb58A1KaEJeHU+hk2b8NPHmJ9V7IivaACAq1baBs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vz3R/Ae2lBPMG/gQjM9fdEhCL7XQlyt2REtf7DMxd1M/XZeqjlXIvHEdQ0AeiF4GhK3Ij45WBHrN0LS5gBSnqzf+HhTOeQFHILYa1Y5Sx5Vh5YT/6CiBmaGtSFZ1yg5cG8c5Io1/+WOk1sAIX/t4kaXw6sA1st8fj2Q9hSvd0mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C9Lfqlka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C9Lfqlka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07A9C072AA;
	Wed, 17 Apr 2024 21:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389689;
	bh=rsYdb58A1KaEJeHU+hk2b8NPHmJ9V7IivaACAq1baBs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C9LfqlkabwkxZGxSu4okkJ1sSkx6ogjtZgdv9s4IZciF9pQsSwrloKJg0kKPF+Rqk
	 7g0YD/oPDAfhVh0TT/ICFC1+TpPrjYsg+68HmLUys5x7Z8/LaXyMIwP83n0+BrzNCt
	 lZQEiDV6UwCFN8SE4nk5RdBDTHsMZQmrGaenGtWVTlpBCL/iK6HThvImDXinL/6uXk
	 WMxxoYUlRzqvmc76/GLzBwzsCCYVofs0SG82mNw/kVIi7bh65yQdUseJdGkW8fnviF
	 9tLudD3BqOCd7OWiaHuvG+pA8UXIpMd2btoOhNUjUQmFbohwlzTkICsAwhGdzAnmEA
	 xV2STF6KsNbkg==
Date: Wed, 17 Apr 2024 14:34:49 -0700
Subject: [PATCH 50/67] xfs: move xfs_rtget_summary to xfs_rtbitmap.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338843090.1853449.16415841250650703807.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_rtbitmap.c |   14 ++++++++++++++
 libxfs/xfs_rtbitmap.h |    4 ++--
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

