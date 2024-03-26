Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A289128392
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422640; cv=none; b=V5/qgkIhqU9eE389KW2RJ42YskWLGyczKoBgkXiD0nWoaq6fRRaJY+JdRI1M0T5VQIsAqhD49Qnx5kNbmSvg80+GxLK/iFgFOkNSSulI408m6g0JzPtUoL/9+QVg2e9ak/FMuqJ9U0k7sexKCuE7NbSsCLyAmDAgD8xrPFwKXmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422640; c=relaxed/simple;
	bh=j0SCOyxhM4OdIl+9jvTiY5NzffchKXp/IxUvyIVU/10=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zyxei/ksuJ2CS3hSf1zL1pfbsWPcF3o8nP2QsHZYi2pkyxkT1JKW/yVuWI2W4pMfdlkVOMb3xfxGYw9oyf/Z4P8OYGUd0CJ9wY3EABsfVXRJy4M4gY0HHz3+p6fZsIUq7zsw2UI4PfMyu2rKEi5lGt1TSV3H9qFbnNvK+ZsYGOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p0j5A3mI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p0j5A3mI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB05C433F1;
	Tue, 26 Mar 2024 03:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422640;
	bh=j0SCOyxhM4OdIl+9jvTiY5NzffchKXp/IxUvyIVU/10=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p0j5A3mIuTzQCfMrQ8cTCyGlQIH7t0XpF/YHduIS1/ufRLc1gwV4J/YeRWfa94UqU
	 tZqIhd381q0UXsp8vlggK39ojxN+d+tdQL+6uq4eIxH4Netfqrl1u1Qb2SSRMHIZ2I
	 mdlmtjUGJrKHHs75ycanzpLjAxL8o1btGft7RsunuugOyt+0E07RRnyaOpzqSI6Bvv
	 HtaqbqFZOWwSiZyjMSI6oD4QK42kVVZCC9z/dUOc05+ijVa6BDzulEqCC6B4PW8oQX
	 lLDltXaaqT1qHOqGywjeBVCzxbdcIC1Z5CY6S3RVQU3UtpJmLIJ312mOABTANrd6M2
	 ciPJH6gqEtWJA==
Date: Mon, 25 Mar 2024 20:10:39 -0700
Subject: [PATCH 30/67] xfs: set XBF_DONE on newly formatted btree block that
 are ready for writing
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127395.2212320.5436159640482826125.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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
index baf7f422603e..ae2d9c63f484 100644
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

