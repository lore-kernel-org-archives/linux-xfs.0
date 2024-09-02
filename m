Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC9719CC01
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301670; cv=none; b=Dta73pnB5LtdxuiVY2zBqhiAgx0VCp9N/jFDqFl142DyanUUf1F0qTpYnLFEReC6PR+9t2EPl0czh8OLwo4kVtt3WT5itEbN9hBFJJN1Dv8zrJMcCnMpUPQz4QZwQTA610GPZWQoAZVgpW3CIqwr3sN199Ql8eaucTRaYJSBlzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301670; c=relaxed/simple;
	bh=SJBW7y5P4k09cJeC63tXqABJUnlR9tq/2WaCcAYh4ow=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QBLsPhCtXeJxnXXvQg9OSoKbEXwfjrqW0XfE5yf9FfjcVlmwHV2ybe95FBhwzAoD2ULbdMfCIFY1T9rd/qtPL2y+dCZ5otxRJoQjGneNd/baWjbpV1SAAW8FiduJU2Sga9OLl32BzcpS2kUMSXHmOy3PhxB/nf/yD+0GYov3jOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LDrMCZum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LDrMCZum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB80C4CEC2;
	Mon,  2 Sep 2024 18:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301669;
	bh=SJBW7y5P4k09cJeC63tXqABJUnlR9tq/2WaCcAYh4ow=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LDrMCZumcOhjzxQyrUngAyZtFuxFshS23aSy9cprtjI//LeawXYyS5urGpFUPt2ei
	 OWoU7aoG4/2hldKjDJcP3aHPyPly897ds1FVv6p+xfnn4u9aQqgqiBep6Q/Bh6+BvM
	 VinzB/m04bruv8IRRu1mUnfufifS/OpB8xGmBIRwd2jFwvxTezwjdGvmAWLa7SEAcs
	 hXDpWi+MiLNVDw5UfHhz8y3RZGDHeVBpbvUJq3s53isgMPtt07AvAuPLc0ahO0dMXM
	 0v9tjraaSsRculCmbXhzShj/2rJ4z3c3pBOFI8F3ceJ4iEMODmk73zmeI1dEZykPlU
	 giG9gRJlQlDMQ==
Date: Mon, 02 Sep 2024 11:27:49 -0700
Subject: [PATCH 03/10] xfs: don't return too-short extents from
 xfs_rtallocate_extent_block
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530106308.3325667.11584195823309747266.stgit@frogsfrogsfrogs>
In-Reply-To: <172530106239.3325667.7882117478756551258.stgit@frogsfrogsfrogs>
References: <172530106239.3325667.7882117478756551258.stgit@frogsfrogsfrogs>
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

If xfs_rtallocate_extent_block is asked for a variable-sized allocation,
it will try to return the best-sized free extent, which is apparently
the largest one that it finds starting in this rtbitmap block.  It will
then trim the size of the extent as needed to align it with prod.

However, it misses one thing -- rounding down the best-fit candidate to
the required alignment could make the extent shorter than minlen.  In
the case where minlen > 1, we'd rather the caller relaxed its alignment
requirements and tried again, as the allocator already supports that.

Returning a too-short extent that causes xfs_bmapi_write to return
ENOSR if there aren't enough nmaps to handle multiple new allocations,
which can then cause filesystem shutdowns.

I haven't seen this happen on any production systems, but then I don't
think it's very common to set a per-file extent size hint on realtime
files.  I tripped it while working on the rtgroups feature and pounding
on the realtime allocator enthusiastically.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4bbb50d5a4b7..c65ee8d1d38d 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -289,16 +289,9 @@ xfs_rtallocate_extent_block(
 			return error;
 	}
 
-	/*
-	 * Searched the whole thing & didn't find a maxlen free extent.
-	 */
-	if (minlen > maxlen || besti == -1) {
-		/*
-		 * Allocation failed.  Set *nextp to the next block to try.
-		 */
-		*nextp = next;
-		return -ENOSPC;
-	}
+	/* Searched the whole thing & didn't find a maxlen free extent. */
+	if (minlen > maxlen || besti == -1)
+		goto nospace;
 
 	/*
 	 * If size should be a multiple of prod, make that so.
@@ -311,12 +304,20 @@ xfs_rtallocate_extent_block(
 			bestlen -= p;
 	}
 
+	/* Don't return a too-short extent. */
+	if (bestlen < minlen)
+		goto nospace;
+
 	/*
 	 * Pick besti for bestlen & return that.
 	 */
 	*len = bestlen;
 	*rtx = besti;
 	return 0;
+nospace:
+	/* Allocation failed.  Set *nextp to the next block to try. */
+	*nextp = next;
+	return -ENOSPC;
 }
 
 /*

