Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F388F19259D
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990500; cv=none; b=AcM+ozT7XYIoa70DfL+NXdOO5pY0N0VT5jVH4lLKtNQiSJe4KhiYdO6xXyG4AX++yANIsNjzerbbo/1yl8vEy8aUmeJtzUL2x+bcyctRJi0CKJhA/Xzu63XmYG+6cu3cLwf96MyKBRiWCEBLN+AUQrLy58HOHWwk/szOpF2qg1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990500; c=relaxed/simple;
	bh=px8gqbE8jCVa8R9TGm/mMoCBtya3uZX7RMJnMJrYs/4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B2lTXwXz5I6mAH3yTEMN5cLgxMzGOs7U7F8KBm8py/swDp5hpj0E+DR8qLi5uRX/5G45WL3nOIczmRG120r4I3acorIwMcn7CV5o+BKppPQd7z3NuP2wQPcQkQcnIT0x1JSGojOV/GuriWHK2vUJpXb1xxW8+hjYRNCTeD4k39w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o1dw7m3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o1dw7m3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3A0C4CED3;
	Mon, 23 Dec 2024 21:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990499;
	bh=px8gqbE8jCVa8R9TGm/mMoCBtya3uZX7RMJnMJrYs/4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=o1dw7m3GtAw4L/mkh9E7SFgjWuoaYungIyFm05xYrAxw96/4NMW18iyMhwW8ucNng
	 3k7MAILG8HOiPgbjpS5zny2l+xP4vhWWCVjnBzvJNCMVH7OVe40QgvCxB+qYSr6E9Z
	 B5AkLRFvMgsjwUlC4PyQrlWsKGbsCadiCm80jTZ9pHg+ZYcAtXKHkiSGNUb+K9K2AD
	 +k3hbY5tPTMGhoE7TVmHPG703y1VgYkkXRYWTGZ1aBAcuR8jfF1P3BFidCLWUJQKCK
	 YLNOH6CD3YxReh6qL+QqK4qCC8l+h8l1T5zLMnqckSwDLr3LyqETP3f9Yoe9Rqqxs2
	 YRDI+Js2pACOw==
Date: Mon, 23 Dec 2024 13:48:19 -0800
Subject: [PATCH 07/41] libfrog: allow METADIR in xfrog_bulkstat_single5
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941074.2294268.6364367114782702645.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This is a valid flag for a single-file bulkstat, so add that to the
filter.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/bulkstat.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index c863bcb6bf89b8..6eceef2a8fa6b9 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -53,7 +53,8 @@ xfrog_bulkstat_single5(
 	struct xfs_bulkstat_req		*req;
 	int				ret;
 
-	if (flags & ~(XFS_BULK_IREQ_SPECIAL | XFS_BULK_IREQ_NREXT64))
+	if (flags & ~(XFS_BULK_IREQ_SPECIAL | XFS_BULK_IREQ_NREXT64 |
+		      XFS_BULK_IREQ_METADIR))
 		return -EINVAL;
 
 	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)

