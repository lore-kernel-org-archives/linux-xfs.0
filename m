Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4676338DC57;
	Wed,  2 Sep 2026 05:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328189; cv=none; b=H9LTyhnS39Kba2hCJuNep98LeKPDtgMFJb97BRX9UkZpt/jNQMqSbVmVwT8zY9G402QzA86tVWH+akZhV8yn4wW4Lvht0edOe6X3ograEBlbgLBJFrtUofijvcBnnBjUdElF1Cwt1axsNOyrye9mpyltTR5azacU1VNQ/b+Fwq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328189; c=relaxed/simple;
	bh=f+fVeDop3SpiTjvyBBaD18/nYTVCfRuSEAnocp4TovI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lCwPELxRjCEnEQYWFWCJZ3l4H6T2pRQE52UTKnto+aJsuGNHqNtp5UTHsQxIgSHmNKStKp53P64ie8t3cgNbmekG0/XTjGAvAvuUzN4v1JQZcKHgg6eHfs1U5jHkeblCPC32lH6NngQ+f3Fg+eTYF+S/zBUiit3BBcw2zUH75a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XXjqvzmb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XXjqvzmb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 177631F00A3A;
	Wed,  2 Sep 2026 05:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328188;
	bh=ILidY6yad5boBIUhtIxOamcW0IKf1WGZ65/pkLw7Epg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=XXjqvzmbO15jpAHpt4j9IreRpJXo76wTNPY81HIXLRh36j9KxKIpZtqus9+J6tkU1
	 GnnD1e6KQhji8vSsLpeFZFkO/JWx4EiDC3osEV2z31AWBYMqHwW7MXP/QJRx12uGXZ
	 JFpPakyXhjdvR62NT0ZcXixwJ6rFUaLi8Yhc+OtOX3bYA0qx7nI9WNSZj9IWInSuWI
	 qKVmHpS0Fs5ERZUxrWYRawujVAXLIBnA8q3+iiva5OHDheGeF2xGi6NhNy4hBL++FK
	 7aOAa2dXkDKy3ymlPFiVok3kled4SYjWTG3atDSgzjQFDgRH07zshqv2fc2hzqaB7k
	 eroNfpqxkSf2Q==
Date: Tue, 01 Sep 2026 22:49:47 -0700
Subject: [PATCH 5/5] xfs: fix backwards mergeability logic in refcount
 scrubber
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832750815.3508131.4005702119407893700.stgit@frogsfrogsfrogs>
In-Reply-To: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs>
References: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we start the refcount or rtrefcount btree scanners, prev_rec is
initialized to all zeroes.  This is done so that the record mergeability
checks skip the first record because you must have two records to
compare.  Unfortunately, I got the logic backwards, so scrub has never
complained about mergeable refcountbt records.  Fix this bug that LOLLM
noticed.

Cc: <stable@vger.kernel.org> # v6.4
Fixes: db0502b39c21d1 ("xfs: flag refcount btree records that could be merged")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/refcount.c   |    2 +-
 fs/xfs/scrub/rtrefcount.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 4e1bf23e5b8972..f2addaf13c58e4 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -410,7 +410,7 @@ xchk_refcount_mergeable(
 	const struct xfs_refcount_irec	*r1 = &rrc->prev_rec;
 
 	/* Ignore if prev_rec is not yet initialized. */
-	if (r1->rc_blockcount > 0)
+	if (r1->rc_blockcount == 0)
 		return false;
 
 	if (r1->rc_domain != r2->rc_domain)
diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index 4e7c540c8d2307..de100178f41c70 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -375,7 +375,7 @@ xchk_rtrefcount_mergeable(
 	const struct xfs_refcount_irec	*r1 = &rrc->prev_rec;
 
 	/* Ignore if prev_rec is not yet initialized. */
-	if (r1->rc_blockcount > 0)
+	if (r1->rc_blockcount == 0)
 		return false;
 
 	if (r1->rc_startblock + r1->rc_blockcount != r2->rc_startblock)

