Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B07C38AC7D;
	Wed,  2 Sep 2026 05:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328127; cv=none; b=OtH6OFKY5+BUheX/gtCZN622KY0QoXlTxjuAN8vF3lGMnw6SSsG4mKpk6yjy661JrlrnYacysAcZuAGAGnKjsSms3+tGyJn/ODewRgUnReGlZITbcgLRj7NDaRvvRaBN8kHUgm11BwYMqyTuL6sb6pU8U6UFnfxKMca5MKAXgUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328127; c=relaxed/simple;
	bh=L3m8sGYX+oB9Mwfb035AXeabjMJvbmYi1ScoivsZ4/w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DVQvv7Iy+uWSORYw6uo3wqdaGjUVawDRZc2pgRWxAfiQbAbt/QlX653gONf2+US3Tch4Xhbo97EvF3GxaxIbPYLs9E/eML2Vr1w01zNjWEdGc2KlG6QBkzCEYWwuekgjWrhr8z7ogxChEm9wxT0KPhCk8RRoxYDk1p1sAd5GtIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MNwRiThc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MNwRiThc"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 04E111F000E9;
	Wed,  2 Sep 2026 05:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328126;
	bh=DVzpV8/gOQiNdgbWr+p4hjShdM2+dL84tyW6D7TN5lA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=MNwRiThciM3Y8x5OcjFWeI2veyhBL3v5bg85Hc5nei+4vQO8DAFlo4YrfsA1otvfi
	 Ybl/zROjm5hjVx/K4nQ4IFi5HB6wuC5chyIjzPKUy53vl+RPXTrEq2vLn04Op2CISY
	 eipzVirpHChA7R5k5LTMN1VcUgY3Mz8G0n7UkUGBBJ89hQG0MGNCJUP0DI9hj3laim
	 RKDXPY3hrvkxgI4xyX6CEm4ETxlAybOviTDCFQZhDIzIud8hI0j8KsmRJjd00wkdoq
	 7Yi35l4/1ZDgmrN2/HOvqauRFLplvophcG7bbOThl37SFVaery5DHojtYG0+tPFeNK
	 RyRz+0bw0bMOA==
Date: Tue, 01 Sep 2026 22:48:45 -0700
Subject: [PATCH 1/5] xfs: signal inode btree xref error if get_rec returns an
 error
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832750731.3508131.3210719479030610829.stgit@frogsfrogsfrogs>
In-Reply-To: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs>
References: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that xchk_finobt_xref_inobt and xchk_inobt_xref_finobt
both ignore errors being returned from the xfs_btree_get_rec function
and proceed with a (possibly stale) "true" value for has_record.  If the
*simple* btree record checks fail during cross-referencing, we can
immediately conclude that there's a cross-referncing error in the other
btree.  On those grounds, we can bubble up the returned error instead of
wasting time cross-referencing with garbage.

Cc: <stable@vger.kernel.org> # v6.4
Fixes: bc0f3b55467e1b ("xfs: directly cross-reference the inode btrees with each other")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/ialloc.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 19c0b1b2a787bb..9270ad075fe0a2 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -85,6 +85,8 @@ xchk_inobt_xref_finobt(
 		goto no_record;
 
 	error = xfs_inobt_get_rec(cur, &frec, &has_record);
+	if (error)
+		return error;
 	if (!has_record)
 		return -EFSCORRUPTED;
 
@@ -188,6 +190,8 @@ xchk_finobt_xref_inobt(
 		goto no_record;
 
 	error = xfs_inobt_get_rec(cur, &irec, &has_record);
+	if (error)
+		return error;
 	if (!has_record)
 		return -EFSCORRUPTED;
 

