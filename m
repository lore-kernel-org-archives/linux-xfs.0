Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE0517E006
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 23:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371174; cv=none; b=UYlUOlvmXLA5HTdd6sDaQrXjmKLxsbMEdaXooeRyLyAx2xzxDgydn6hVKln/AOQaE7DP0TleYEtCcUViimTflC+/XZAIngyOyale5CoXsjfa2MZn9H17JBDNY7g3qJWTrI2ng2qmpGJQZ6tnj8ZUldZbzvsxOMydiuozfKj6OeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371174; c=relaxed/simple;
	bh=OCfNDuvB5PBHF78VLOzk6RbtJTOlHXml9nN6tKC03mw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s3wo2/5fG1wziYhvJ9+k/dOLS8YVwNXby48/ved9PqNE9IL73Ag8dtaeKl5CS6EGN0k8LC35ohgYmWpIHuXYG4jjlQ2DDHLWDh45OEFvvm6Ud1Nz/z2dvcxHaPcWbCPV06s8vgd5ez9v1tGeq7vmyjj42hAPPlLPXpiICk53ej8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZyfXaFTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZyfXaFTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C856C32782;
	Thu, 22 Aug 2024 23:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371173;
	bh=OCfNDuvB5PBHF78VLOzk6RbtJTOlHXml9nN6tKC03mw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZyfXaFTcpC44tN4ySqJYSf8v/TaE6Zd1cfw4XmQW31mlob9GiNgjpKOzZKIKkrMh9
	 0dDLV7zFKwNZvQ3Hl7UUSmVDqnz+ay+s8WHhqnj7AbMq/TH1m8jlNySpvl80A6HeMu
	 rLwhfzvUhRJrhuSjNiWw4vUBZdmhSAYvuZcnGuD/yXaaWRsUZDCwCFW7ZMbTCRivji
	 XYo5fGipQxoWPxcvYzwd1Lo6RNO82VtM3XwNluPPK64uLcm2NZJbLP+IECvqw6auYl
	 emyPMON9KYVaRuYAe+Vg7ocgZ2rne9bCnmYaVnuPHWMw2PQlK9n9ZvPPfbjEcsC67+
	 fSj4LART21/fA==
Date: Thu, 22 Aug 2024 16:59:33 -0700
Subject: [PATCH 3/9] xfs: xfs_finobt_count_blocks() walks the wrong btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Anders Blomdell <anders.blomdell@gmail.com>,
 Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437083802.56860.3620518618047728107.stgit@frogsfrogsfrogs>
In-Reply-To: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
References: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_ialloc_btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 496e2f72a85b9..797d5b5f7b725 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -749,7 +749,7 @@ xfs_finobt_count_blocks(
 	if (error)
 		return error;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp);
+	cur = xfs_finobt_init_cursor(pag, tp, agbp);
 	error = xfs_btree_count_blocks(cur, tree_blocks);
 	xfs_btree_del_cursor(cur, error);
 	xfs_trans_brelse(tp, agbp);

