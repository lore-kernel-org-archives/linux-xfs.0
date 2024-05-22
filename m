Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3E2770FB
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347770; cv=none; b=jbsFGZAl9acfQb84YYvCs4bremqZM/GAvJui4x/afqb44pNOp5y7lYknCTCIHWMSKex41+KC01x1KFXVitiHYDkX78wPoS4X2ghc1N+9ZOjBhpiKFdaGw/aVU1NejAkHswd0o06oWspfittckQu4S5cGK7CPAsbt33T9UXQ8KW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347770; c=relaxed/simple;
	bh=TzrzilFry2LLuwbFWjhn7CMX03seUvccIIx4Y52kz+4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R1KRMjooWN05CPbtRrGYvfkxFxX9QePZNr7Ucx5dO55D3fDM882WyYrqv7fbsixe8lKf3BrluwGM2rBaSu9kyrr4EwC+K9GslMU60ITIE81A5KWQPyN4x41ROrv3x+UTix792w7q8rYHjMeIt4EOpvW9lUJf6D3EgSGK1UUPWe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oGyI51BW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oGyI51BW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19105C2BD11;
	Wed, 22 May 2024 03:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347770;
	bh=TzrzilFry2LLuwbFWjhn7CMX03seUvccIIx4Y52kz+4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oGyI51BWENWCY9t9g2GM8Q11cUpX+f0LQdQxMXiPukeB4/5ybW7f0hz15LR+maq6P
	 zmMqOaXJnE1v7aYNVCLwcVWF8syYk46aAQyszjDbb06MX+m+sYmNGw1qlp91xMk6Q+
	 HNwc0wWqTywHkV9Ic4E+74KbG7rEcopwtbMm23/reUXRTqUqC7AfaMvkVwqZrciBFI
	 Q2+WzamQCKKLFZVrAidJ9g/a2GWyAldv+i98IR07S+WNBkEHwv97SdxFkwOPbYBqyD
	 eQSmVPgcyR1sY1R7VL2RM+XAJSC3wutPcfE9b61bwpFuUZnvfoIX91K5R8CnrJSXPt
	 FYLlZ3gwHFokQ==
Date: Tue, 21 May 2024 20:16:09 -0700
Subject: [PATCH 105/111] xfs: xfs_bmap_finish_one should map unwritten extents
 properly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634533279.2478931.15091263545048704868.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 6c8127e93e3ac9c2cf6a13b885dd2d057b7e7d50

The deferred bmap work state and the log item can transmit unwritten
state, so the XFS_BMAP_MAP handler must map in extents with that
unwritten state.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index f09ec3dfe..70476c549 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6239,6 +6239,8 @@ xfs_bmap_finish_one(
 
 	switch (bi->bi_type) {
 	case XFS_BMAP_MAP:
+		if (bi->bi_bmap.br_state == XFS_EXT_UNWRITTEN)
+			flags |= XFS_BMAPI_PREALLOC;
 		error = xfs_bmapi_remap(tp, bi->bi_owner, bmap->br_startoff,
 				bmap->br_blockcount, bmap->br_startblock,
 				flags);

