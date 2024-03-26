Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6447157314
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422953; cv=none; b=u12lxJN4OLtTl+oGBpQellAqfZm3OWDYLtsKM+/jS/gsQDmFeZKI1kGcHZ90G1J1NYXxOEybEwAgLNegA4IR4ath2D4ueCB3tXTZoGaEmGkAFT7YRFB/Y4jYeG46GXn7yGtfG+9n18cT+7vHoyShPSBC8U89hU9CTy8aIlRUySg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422953; c=relaxed/simple;
	bh=EEoADi1yhmUsiKondayb4+iWCHa8xtjYSFz7E5ef16E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I+pTDadvJ2b0p7bYi9c/bU8wPdEorW+urEFUqysLn1NAWYoixPORjTyV50/yuE6U7mq5NWPCKLzZJQbf84pM9sarL0v+BCNU7gms+dXwvtuxKvK493SlnutFrufeTofa3YclUYCFlEmouLhB33Fn7l/0gZ0vQCNmkPTYSWauMSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DcERrVWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DcERrVWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCB9C43390;
	Tue, 26 Mar 2024 03:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422953;
	bh=EEoADi1yhmUsiKondayb4+iWCHa8xtjYSFz7E5ef16E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DcERrVWDWmeGRJF5hoDHsZc+ODkVnfrmR1WoxicVUz//pWMogQvFCcEdi/FoMNIyh
	 eZhr5MVvQS7NvV05DhL7r9DJVplJgpYom+R/a637zPcDUV6dTE6NPIUS13MyzlyTLS
	 3xubuu6W2IBP3549RSLxhnOCoqITDhArrZ158voI6KuTgVqG0E0ZF0/gRUknXNLdsy
	 paBAWDFzELMZxdh8bLtvGIIvASh5A9POmy/wMSFD4g1Z0kUEk8UHx2m0gGyH7Jw9Fp
	 o0enaaLrYDtmLegxHserQJ7OR66fF66ty1KUaTiw20kHi5ncvywxzqrex0NjkISLo8
	 FzvPzrFgIhoMg==
Date: Mon, 25 Mar 2024 20:15:52 -0700
Subject: [PATCH 50/67] xfs: move xfs_rtget_summary to xfs_rtbitmap.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127677.2212320.14061734573077722778.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

