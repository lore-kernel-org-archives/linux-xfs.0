Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CD48F4A
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389376; cv=none; b=NL1RyeXn2djAGb//HTBmAGT/5q2SoIxDNuQgaqZptdJTf9E0+H7T+tBxs/Ik1r9xwi9yek8DbChOrN4mVmj2p50BttkDZTk8/xobw35Nb/YFNXhLtUnvZ2tXUoUXo/cMvpQ1fruorADW/TbIppj53OFCaMLh8iAN0H4dSOxmseg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389376; c=relaxed/simple;
	bh=6CmXb5D/Y8cTPPdc9JuBAzJpNW/AvJcE+RrNI/3mKLE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lwq4W6iuvlqUgJtXYTE0xldKyWku2LB16VRjmIryWu0B/YswLL2mgL+V8cw5HnBJvfS5nzK6ZvdrpJ8LeSIQtZk+WpNOH7Pay5w9gXNFd272jYh934K9Ir4MopUdnrFv8CUuFg8GWwTd5R2NJlwYDEvu/Gqm3e4UWeBJBbsq+cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XMmsjWDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XMmsjWDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927D1C072AA;
	Wed, 17 Apr 2024 21:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389376;
	bh=6CmXb5D/Y8cTPPdc9JuBAzJpNW/AvJcE+RrNI/3mKLE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XMmsjWDsAv09C+iRpODtgxWF6Ig4EXzT0ABXbiV/Ww9I+XVhjgvnVnF4XjhEhfZzL
	 fFmu18cH4gK5QjEAF7L4I361+6gp4oJf+aUC3Vl39sgEDiFGKWKzMsUHLnVqq9L2Gb
	 vPe3L7ydoqRmCQbCYZl0Iov7EXp6SXkEOhUsS8qEriM614Q6uH276Bl4D0M/Spa2O3
	 rBFx7BXJmh9amSKBLV7ZngsI4oTcx6Cl8PT/ZuF6PrwsJd7GLEXbzO9jalgYxgfQWW
	 k5++nygD5kERmPuWgFg58iRpHTCUUxS7bFYNHCggY3+kUBhQG6oS7OBaVx2DnaENGk
	 mWytk0l9n3YIw==
Date: Wed, 17 Apr 2024 14:29:36 -0700
Subject: [PATCH 30/67] xfs: set XBF_DONE on newly formatted btree block that
 are ready for writing
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842791.1853449.4841452903819754573.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: c1e0f8e6fb060b23b6f1b82eb4265983f7d271f8

The btree bulkloading code calls xfs_buf_delwri_queue_here when it has
finished formatting a new btree block and wants to queue it to be
written to disk.  Once the new btree root has been committed, the blocks
(and hence the buffers) will be accessible to the rest of the
filesystem.  Mark each new buffer as DONE when adding it to the delwri
list so that the next btree traversal can skip reloading the contents
from disk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_btree_staging.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index baf7f4226..ae2d9c63f 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -342,6 +342,12 @@ xfs_btree_bload_drop_buf(
 	if (*bpp == NULL)
 		return;
 
+	/*
+	 * Mark this buffer XBF_DONE (i.e. uptodate) so that a subsequent
+	 * xfs_buf_read will not pointlessly reread the contents from the disk.
+	 */
+	(*bpp)->b_flags |= XBF_DONE;
+
 	xfs_buf_delwri_queue_here(*bpp, buffers_list);
 	xfs_buf_relse(*bpp);
 	*bpp = NULL;

