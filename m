Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E362107
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832271; cv=none; b=cB/IO+10VuyW7TN3SRfytuuVDn1Gh7KRkO+7ITSkhFgCkwlOiT3Me4KPOWC9lwS5oBolxx52nlhTfIO3lNIu6cg/8qRynZGdG7y618yTqUKGySlcQJe2bid24/idau3emmaIGfW+K6TaxzAUIQ1aHp6aTk+VZgWjAZji5CRHdlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832271; c=relaxed/simple;
	bh=66W4NCqZ/ekh1+3kCgVwsk44ixXDltScm59XDT02wn8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DZhvEQc3+v3Hr/R/bk9FNNEJ6vBEV7bp1GtSaIRv86+nyhjnB8DIwoAZb+tWGACa0eIIB460qaOHhOvU3fh1Vq3W7S5EJSede2bzctxOQVqE/mJOeOH0gFQXwbhOM0tlY6J9n8mx4rObsAGbl06ilqOs1Y2a31rPYLnDdGd+WFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rqt8yR1I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rqt8yR1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCD9C4CEC6;
	Wed,  2 Oct 2024 01:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832269;
	bh=66W4NCqZ/ekh1+3kCgVwsk44ixXDltScm59XDT02wn8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rqt8yR1IvvY3i/llU438dCWPr3tCIh2A7NgbqOMRYUDBIUxjaQEWl9n0fxHQxVZ3Y
	 DWC7ZXPyUR/Z79HAu4b0BuEDlxg6yGMe1VHCflCkqhcYvNS/v/Dbi2zg2nQsIDGq8x
	 iUS0RKdhfh4Jlltasf/uUSZtzwcJQI41uA3oN3uRu2kFGbS37f/VdTqe4jAsL8z7zr
	 uB3ZuWzPc3KGBJ38Y/9SC+AwF2AePcZ6/HrsXREqpIYMmdzrg2xtZDsDTRovvp0q/w
	 TMymv57nwxpLQ5C18+w9JI9Nwj8afRI9e8qsQT9xFdsU3w47dpzYy9S/jabd1Tp9Mj
	 34q8XpxM9ft0Q==
Date: Tue, 01 Oct 2024 18:24:29 -0700
Subject: [PATCH 64/64] xfs: xfs_finobt_count_blocks() walks the wrong btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Anders Blomdell <anders.blomdell@gmail.com>,
 Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172783102744.4036371.8015589025601603573.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 95179935beadccaf0f0bb461adb778731e293da4

As a result of the factoring in commit 14dd46cf31f4 ("xfs: split
xfs_inobt_init_cursor"), mount started taking a long time on a
user's filesystem.  For Anders, this made mount times regress from
under a second to over 15 minutes for a filesystem with only 30
million inodes in it.

Anders bisected it down to the above commit, but even then the bug
was not obvious. In this commit, over 20 calls to
xfs_inobt_init_cursor() were modified, and some we modified to call
a new function named xfs_finobt_init_cursor().

If that takes you a moment to reread those function names to see
what the rename was, then you have realised why this bug wasn't
spotted during review. And it wasn't spotted on inspection even
after the bisect pointed at this commit - a single missing "f" isn't
the easiest thing for a human eye to notice....

The result is that xfs_finobt_count_blocks() now incorrectly calls
xfs_inobt_init_cursor() so it is now walking the inobt instead of
the finobt. Hence when there are lots of allocated inodes in a
filesystem, mount takes a -long- time run because it now walks a
massive allocated inode btrees instead of the small, nearly empty
free inode btrees. It also means all the finobt space reservations
are wrong, so mount could potentially given ENOSPC on kernel
upgrade.

In hindsight, commit 14dd46cf31f4 should have been two commits - the
first to convert the finobt callers to the new API, the second to
modify the xfs_inobt_init_cursor() API for the inobt callers. That
would have made the bug very obvious during review.

Fixes: 14dd46cf31f4 ("xfs: split xfs_inobt_init_cursor")
Reported-by: Anders Blomdell <anders.blomdell@gmail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_ialloc_btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 5042cc62f..489c080fb 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -748,7 +748,7 @@ xfs_finobt_count_blocks(
 	if (error)
 		return error;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp);
+	cur = xfs_finobt_init_cursor(pag, tp, agbp);
 	error = xfs_btree_count_blocks(cur, tree_blocks);
 	xfs_btree_del_cursor(cur, error);
 	xfs_trans_brelse(tp, agbp);

