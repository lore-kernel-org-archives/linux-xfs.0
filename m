Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7569E23A0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442680; cv=none; b=ashgzHV1bZwU0+c564uzzZhvHtbvGMVZTlNdC6YDtDuI17uCj9jCS8qaOYMbUAzUXTKQx0q6jlMLHi6oy/WZ7R2oUrtlchg4EwQOcYiv06hnKgUqdaOCBvmzaRktBqN0LDA/jUIt9BkV+epjQX2aLWUpy0VSwzNTT8PpE6KiHLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442680; c=relaxed/simple;
	bh=7u7O72OLgUxnzyjzAhUNcjp0IUqymFin15CRh6GGS6Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rxBfsBi7q12yihj/8KFXnX0CXYYwjuTVX9iEb8Bb1t37s8lbjn/kYJsEztTegS+dpJr5bLXTi5B6RYDHYdVmky2BRtrgPP8yfYOrAA6J3GnF62AK9r9rgYw7CC2f/2MyCMv9gQaZCYzTzI+ZQVqf1DCThNlakc5x/sk6Suhb+0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nNIB/D65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nNIB/D65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2EFC2BD10;
	Mon,  3 Jun 2024 19:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442680;
	bh=7u7O72OLgUxnzyjzAhUNcjp0IUqymFin15CRh6GGS6Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nNIB/D65lgcmB+wA5Y4imYSRtDrVemrzlzAfR96u6WHe80fqYlyMDCMPES0bZuwlq
	 yoTgnG989dbP51md8y4ILEenwoE4/scujR3T0uKEG1MRYiaQ4t2YXLlOGvd59doPEG
	 dMZAI1rFVXe7Dv08gy5SBVfzqe4PUYucaflDPSFSEG2SGcuNsaM1O+r2MIxUNljkrM
	 J7azLh70xm40cEfl7a6DZcldaQQLx4iTh+3glok7PTQbx5W1v2gzervMvYjoIT2N9D
	 NoZRx4Glpm386tIRO65KXjwlUjE31UlKjlcTSlTMbEoLps8pQi7/ghcXzSgT4bZO+m
	 UMIC2pIHWo6Jg==
Date: Mon, 03 Jun 2024 12:24:39 -0700
Subject: [PATCH 2/2] xfs_repair: check num before bplist[num]
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744042774.1450026.17783252586105632029.stgit@frogsfrogsfrogs>
In-Reply-To: <171744042742.1450026.8930510347408107889.stgit@frogsfrogsfrogs>
References: <171744042742.1450026.8930510347408107889.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

smatch complained about checking an array index before indexing the
array, so fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/prefetch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/repair/prefetch.c b/repair/prefetch.c
index de36c5fe2..22efd54bf 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -494,7 +494,7 @@ pf_batch_read(
 						args->last_bno_read, &fsbno);
 			max_fsbno = fsbno + pf_max_fsbs;
 		}
-		while (bplist[num] && num < MAX_BUFS && fsbno < max_fsbno) {
+		while (num < MAX_BUFS && bplist[num] && fsbno < max_fsbno) {
 			/*
 			 * Discontiguous buffers need special handling, so stop
 			 * gathering new buffers and process the list and this

