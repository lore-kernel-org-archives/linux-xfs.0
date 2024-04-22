Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B728154425
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803966; cv=none; b=JLK+rcV5SHl+lGPTe8nZzSSUmCGNvA0XXycPP4fa30PMWG04HQWLXFCZFyJSKTpu2in4AsASQPS7UEWUF+YxaaDTTr8gwTHhM02roiDStX37wMlAjZl+/UKuon3t1jYyfhz3o6m4OUBTE4Z7HVnUCovlocW7s9Imt4llXyhagmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803966; c=relaxed/simple;
	bh=JW+rY1bP+8Phc2+wiHnjx3++O5tqTappEN6lUnU5e5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cg7UaXszl5MdhJavCOqiuz7XX7J7Hh8Ntj5CcxNX8pcxSunKx4DaJmtLXPBzO/ONDINgs0jIfVqYC0Cb19sFFgusjkuMpuIDn6OeRo5s2uRt+QBk1l5axyPTxvUdi6/vQK30/skTHFgAErhLbKFN9pUDx6woeipy3NnclSRU23s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nxuagD4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nxuagD4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D823C32782;
	Mon, 22 Apr 2024 16:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803966;
	bh=JW+rY1bP+8Phc2+wiHnjx3++O5tqTappEN6lUnU5e5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxuagD4ERz9v/Lfcth9cSCj3MvpGYo3TRhX+j2COulkZdZyMsauTmSXv+XfmczBza
	 mSxvrFpqLKOamAC/K/SWR9eHELNJC3hiw6cS+0MmPkIgMnDgZavOeJ8uxaf8xsf1+2
	 /Sa7cUkfXqAqY6rfuR6LnjjYjGcPIzRE2UOe97tSocYwLXsejk6KUzM11p4O5y7Lz7
	 IdVlvDRi6JRwjrY8t/MLLywkUjw6N87mCudIGABS96IhZ4WXUT4d9evST9sGkeb3Sc
	 2sA/EEXq6qcbypJ+5dJ3NgXWgEoKEDE9EvZFg5aY2gF+efXW8XXHtKZM2oBEh0i+/b
	 BJknEBQfZwoeQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 12/67] xfs: fix 32-bit truncation in xfs_compute_rextslog
Date: Mon, 22 Apr 2024 18:25:34 +0200
Message-ID: <20240422163832.858420-14-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: cf8f0e6c1429be7652869059ea44696b72d5b726

It's quite reasonable that some customer somewhere will want to
configure a realtime volume with more than 2^32 extents.  If they try to
do this, the highbit32() call will truncate the upper bits of the
xfs_rtbxlen_t and produce the wrong value for rextslog.  This in turn
causes the rsumlevels to be wrong, which results in a realtime summary
file that is the wrong length.  Fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtbitmap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 90fe90288..726543abb 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1130,14 +1130,16 @@ xfs_rtbitmap_blockcount(
 
 /*
  * Compute the maximum level number of the realtime summary file, as defined by
- * mkfs.  The use of highbit32 on a 64-bit quantity is a historic artifact that
- * prohibits correct use of rt volumes with more than 2^32 extents.
+ * mkfs.  The historic use of highbit32 on a 64-bit quantity prohibited correct
+ * use of rt volumes with more than 2^32 extents.
  */
 uint8_t
 xfs_compute_rextslog(
 	xfs_rtbxlen_t		rtextents)
 {
-	return rtextents ? xfs_highbit32(rtextents) : 0;
+	if (!rtextents)
+		return 0;
+	return xfs_highbit64(rtextents);
 }
 
 /*
-- 
2.44.0

