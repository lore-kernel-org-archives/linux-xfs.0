Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7AD33DED1;
	Wed,  2 Sep 2026 05:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327863; cv=none; b=naF3M/ZkunffJHT+5xmzzIw9jTOC1SQcqOCC1YBBJ3AxVWgZNxccEzVfiiNt1Gng/tzfxOr+qrs2Vzwzh3VqkUY4ERUeL8vWDcI3A9tIGrWd4GZxV63guS1gThEbYsq/WChQvgthnAgdpUDF2WwY/6Zyjw/xmSm1IuLc2m99HTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327863; c=relaxed/simple;
	bh=qwvm8K6FhI44MhPeRHkN/CScIiJLjXwZeVC5+/pwBSU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ifYhCwveck8AzH9yTs9y1Mfo4Zsf/ac76s3u/2GTIHAm+8L5SClxsVd0GbbCtIHhGfADAJLKTozOwWbWsVi8R6HpOvaLtcgt3vABbdSpYtBmtyLpm4tHIgWUKxP34x2uJ/N/R/Grh+qIDf+Uh1M94BVAnlW40NeomXRIPAD1pZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a4QiRVeL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a4QiRVeL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DAA331F000E9;
	Wed,  2 Sep 2026 05:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327862;
	bh=en6hu8jG7x/04cDEOTo6INMsHLXS9DsBYtPP3jujVgk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=a4QiRVeLw0jTrgfVd+hm3UFWIrR5nkpQlFe81i6BkvwG5R6imd+GlP0iMyeN+r94a
	 A0Q4Nvtrlc6oOERn59six/xIjhTwZNN0NhzR09Su9Mmpi+Ycnv0vjhYmiBMIqMX8BC
	 13fPS0WP7VoPi6wPFWd0DU+XOpUUSe2DjlwplK4Djj9ztmRUiyZ3thBCX/yPLwCPS3
	 I4xpyKvSWf2QsS5lVGDDWHMm7negMrTeUhfY2ZWuxmpP/BLmyX3gYYtuKBDUgPSNB1
	 vqJXjNZ+3cojFCvtL1oyrPSqXnblZTazCO0NKm/DWwH0v6xCugJiQRZ2qNFOW62AwD
	 zNtRmjk65Vueg==
Date: Tue, 01 Sep 2026 22:44:21 -0700
Subject: [PATCH 4/6] xfs: actually recover intended file sizes in
 xfs_xmi_item_recover_intent
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832749507.3507209.974632272982178994.stgit@frogsfrogsfrogs>
In-Reply-To: <178832749387.3507209.8650516312948237987.stgit@frogsfrogsfrogs>
References: <178832749387.3507209.8650516312948237987.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that xfs_xmi_item_recover_intent doesn't actually
restore the isize1 and isize2 fields that were recovered from an
unfinished exchmaps log intent item.  Instead, xfs_exchmaps_init_intent
sets the wrong isize values from the recovered inodes, with the result
that the file sizes are not set correctly when item recovery finishes.
Fix this by restoring isize[12] from the log item.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 966ceafc7a4371 ("xfs: create deferred log items for file mapping exchanges")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_exchmaps_item.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
index c3745d33e54ea2..dd5d92ca1010fe 100644
--- a/fs/xfs/xfs_exchmaps_item.c
+++ b/fs/xfs/xfs_exchmaps_item.c
@@ -344,7 +344,17 @@ xfs_xmi_validate(
 	if (!xfs_verify_fileext(mp, xlf->xmi_startoff1, xlf->xmi_blockcount))
 		return false;
 
-	return xfs_verify_fileext(mp, xlf->xmi_startoff2, xlf->xmi_blockcount);
+	if (!xfs_verify_fileext(mp, xlf->xmi_startoff2, xlf->xmi_blockcount))
+		return false;
+
+	if (xlf->xmi_flags & XFS_EXCHMAPS_SET_SIZES) {
+		if ((int64_t)xlf->xmi_isize1 < 0)
+			return false;
+		if ((int64_t)xlf->xmi_isize2 < 0)
+			return false;
+	}
+
+	return true;
 }
 
 /*
@@ -403,6 +413,13 @@ xfs_xmi_item_recover_intent(
 	*ipp1 = ip1;
 	*ipp2 = ip2;
 	xmi = xfs_exchmaps_init_intent(req);
+
+	/* Restore intended file sizes from recovered logged item */
+	if (req->flags & XFS_EXCHMAPS_SET_SIZES) {
+		xmi->xmi_isize1 = xlf->xmi_isize1;
+		xmi->xmi_isize2 = xlf->xmi_isize2;
+	}
+
 	xfs_defer_add_item(dfp, &xmi->xmi_list);
 	return xmi;
 

