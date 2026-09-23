Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BD73921D8
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 06:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143246; cv=none; b=POdXjpfInIX9w924pE8vtHE1OhMmJ5cPk2qssaMQoxEMcpXh7nNxKv7qw1Yre+VyLf1duT+iKRInzp0jMPYs7qvhw4cbiyUFNy/sOrr6w8wsk6jEDJ3vEct2jI2D8qEcIirVOsjloQXkX3xju5Iv2HeK/miXgJpfZfX/dg5zKkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143246; c=relaxed/simple;
	bh=lCL7Tm+wyZ4/SApCCuOtjSZYSOzEXXJFDC6EFIwhLio=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fzXlfIaCuWuDGURCaqwrsiI42f1Z+JfikCLlKzOv6CftWNtouI5bYOWuLSJwwcLeE90G0rpnhouhaWoDhQ/lCXMFVeGSVAguk6Xdo6Me2tpIVPS+9MxB2vQA8njaEnmrbOrag3nYiJJiyKBZldf8l4w01l/aA27AhSNOz5EM9yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T7pPo400; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T7pPo400"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 394A91F000FF;
	Wed, 23 Sep 2026 06:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143245;
	bh=9ispT2/nUp3W1b2xyVE663/Vi1bQhtFXxmyqUvoNMuc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=T7pPo400x9QUj38tk6PMr0WEOfqsHn22r0qlJEHUzVDs8dZ56a8Dqx3BBx3IIRWO4
	 fitkHybTgQP+xQvAbBCAzn9Mp73yHhj0RMAeNjCv5AHGK6xJ/B3hncFZJMvTu8hBHn
	 KNw3ReK1F/hd3hUMFj5tW03mnbjnmT2rCze8wZ2hmCvEGZi+CituG4NIIHmJhrxqjR
	 jNsWHqgr3yvjtePFefbT3DxWYOb6O1JMV/ca5Z54d59+P75VE+MWcdFZvsaHEehLXs
	 J9jHTY3hcqdWkLpK/9x9aURpexmv0ePMCXyzJrl32c/CA1qB88CbT3uT/2qBBMmVxU
	 A9aRmZu/7iRuQ==
Date: Tue, 22 Sep 2026 23:00:44 -0700
Subject: [PATCH 13/13] xfarray: warn against sorting arrays with identical
 elements
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179014159206.1874904.2084692069033747141.stgit@frogsfrogsfrogs>
In-Reply-To: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
References: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains about a potential underflow here if xfarray_qsort_push
is called with lo==0.  However, this isn't possible in most cases
because filesystem metadata records cannot be identical.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/xfarray.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index 7f85855588ed54..c94f355607790e 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -682,6 +682,18 @@ xfarray_qsort_push(
 		return -EFSCORRUPTED;
 	}
 
+	/*
+	 * Avoid the integer underflow below in (lo - 1).  This shouldn't
+	 * be possible because the pivot is the median of nine distinct
+	 * filesystem metadata records, so at least four records will be less
+	 * than the pivot, which means the pivot will not be in the low end of
+	 * the range by the time we get here.
+	 */
+	if (lo == 0) {
+		ASSERT(lo != 0);
+		return -EFSCORRUPTED;
+	}
+
 	si->max_stack_used = max_t(uint8_t, si->max_stack_used,
 					    si->stack_depth + 2);
 

