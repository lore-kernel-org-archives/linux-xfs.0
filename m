Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B921C1A26E
	for <linux-xfs@vger.kernel.org>; Fri,  5 Apr 2024 03:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712287637; cv=none; b=OE+i4tbThfuXMJzo5LY4O1z8JFNnKdRnLQ0i2VO+l7ck4fy4ncroHtUlRgUZT/m/oLp9ulkHG0KDEAsBq/qGMvCxBEIyiqlclpPk3bHaznqco8pKfRcXuJsh6/V1UMs+avYDBM1dCDA9BXJ3OsbCKwjluVAbAAzedXBH50FhIiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712287637; c=relaxed/simple;
	bh=7IMd77PAKMPA0KBOYcMbuxe4sMS6yHNmSSkI9Jxkv7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wcvumgatd+thkESHMvW0QB8usOe1IHGBgQwUxu/KI89ATTiaqTXfpaLUbOhhJQmvdCYhNoqQEgSLGjiBfc5rTzuJuYhJvOw/+vBIeLXqkf4YlfYkTR52DCO+8+SgynkjB5b4T5p9uQTKcywXLhBbqgPCXQKkyXuS2lmB+Rim+A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ToiyGLPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ToiyGLPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB52C433C7;
	Fri,  5 Apr 2024 03:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712287637;
	bh=7IMd77PAKMPA0KBOYcMbuxe4sMS6yHNmSSkI9Jxkv7A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ToiyGLPvGqVPCveGUDGQqtMeDQ9hJf/AF/vaBz5kHR4BbQygmrJOF52G1kaFvzNRo
	 PpGH9js0j9K4pvhbz30rnvxWZkO/sAxfe+Qtd8zmCcpkAjHXJk1cHcr6lr5gBm0PR2
	 ea5b53A6XH6K8FY01vJEGCMKP6g7Og8IacgAKs2F6QHS5X/1Il/CaoPBpv8EYCtLMA
	 3y30uLKk1Ao2NyeO1Av5axeQxckvpG1kMd8ASidkFczZ79LDrd/J00qPq2YZ0X3+G+
	 br+MFUPjsTM/+SGN3lyKb8q31GQn8Wpd/fxbg+6xpwy0V0M8Fo8nNMZrwQHLYf9T3J
	 CI9Fwdd/3n9oA==
Date: Thu, 4 Apr 2024 20:27:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>,
	Chandan Babu R <chandanbabu@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/3] xfs: fix error bailout in xrep_abt_build_new_trees
Message-ID: <20240405032716.GX6390@frogsfrogsfrogs>
References: <171150379369.3216268.2525451022899750269.stgit@frogsfrogsfrogs>
 <171212150033.1535150.8307366470561747407.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171212150033.1535150.8307366470561747407.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Dan Carpenter reports:

"Commit 4bdfd7d15747 ("xfs: repair free space btrees") from Dec 15,
2023 (linux-next), leads to the following Smatch static checker
warning:

        fs/xfs/scrub/alloc_repair.c:781 xrep_abt_build_new_trees()
        warn: missing unwind goto?"

That's a bug, so let's fix it.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 4bdfd7d15747 ("xfs: repair free space btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/alloc_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index d421b253923ed..30295898cc8a6 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -778,7 +778,7 @@ xrep_abt_build_new_trees(
 
 	error = xrep_bnobt_sort_records(ra);
 	if (error)
-		return error;
+		goto err_levels;
 
 	/* Load the free space by block number tree. */
 	ra->array_cur = XFARRAY_CURSOR_INIT;
