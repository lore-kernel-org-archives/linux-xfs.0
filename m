Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3675D3EA66;
	Thu, 13 Aug 2026 05:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786598797; cv=none; b=p/1BCCOcjVfHiEUpd/wlNx2KcI3oDMannUa5VJ/Tv78QqKwyRuO+gE1o4ye/lewPNcOmFs/kJTdj8xtFBgJ8fOPPgxfz1FlMLGk2NMg1M4O6aKlefocASlhEOoKSh/If71KOEYSoritjqmM64oSJR0mqxKCK5dwwsRX2Ta2jHjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786598797; c=relaxed/simple;
	bh=k1rfcU5m2UOOl4QIxTjI+M23Z6fZ9mcGmN+yPQtJuqM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q/6j1PVTvGd/EXOfal8FpXKVkkCAK9rssq3VyCc66kI1Q1uhSshi0LXRgPIuO9I6JnSppvia1vYAUQ0186zLfA9ML0eXxuo4rt0PweoVD4tCH5vLLe9Wh3h6UefiG81WFcJHOEDxxjObdRZDShJfn0kWM2AUlb0IJljphoQGOZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cNwZrRXN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cNwZrRXN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E8F541F000E9;
	Thu, 13 Aug 2026 05:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786598788;
	bh=m2wyBRt0YIG9xxBHywxoTd9Oz27YEZ/4FzIMYcPX1Is=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=cNwZrRXNNxuTQgnrFRQlSuJGvomBSgPgOuAQ7QtVGwduk/uj6r2NWHRRvtvWxxPN7
	 ftYullnhtrtuXZWljBuKGpwqBccR/f30L/oIOm46nk7mq4P2KN19IokQSQzxw34gPo
	 0Jo471VBsHRn/JMMmMy8uo1OifyQU1p57EciiG5yhfuEPpofHv51KV/6zklE4VeJ7E
	 H9bZ6LrYrjhQ7NlSurqr9uU35m0p4zdLI5lMTFLA6rnc8PAku7Y9xC8srWoDr/hS9H
	 RoJq8gVHmgxGYLqyXNUvexnefZrZzPuBj/V4B2YE6rQ8kFn+eDDpHqQ3lUwCNER7R9
	 1fI8o6ntN/3Pw==
Date: Wed, 12 Aug 2026 22:26:27 -0700
Subject: [PATCH 4/6] xfs: actually recover intended file sizes in
 xfs_xmi_item_recover_intent
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178659861961.833922.14504822154596349205.stgit@frogsfrogsfrogs>
In-Reply-To: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
References: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
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
 

