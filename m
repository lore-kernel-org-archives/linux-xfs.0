Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EF732B9BB;
	Tue, 14 Jul 2026 06:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009112; cv=none; b=L09xq43WzYDwGqGYve6yxHszxRqFwS7z6Irn57eWfosP/5rM2ANsFqvgonyqtDF2aALmqIe6Cwg8lnup+J55rh+4IIHdtKyd10p+Uefjr/CETVTYOQrp3/s87DTYb51ZZjBVVc6h+g3afR0V8hhIZQ7+ebD4ZdLNOHEA0CyDSXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009112; c=relaxed/simple;
	bh=acN8/KG/UGZ03+FWD8TQf5mTnOIgAsZMVSzU9ynLSX4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X+XjcTL2+M5Tv0rwVNY7w/lLhqp+0wXikL1hlHkoBOFrLm2BRQFEV+Yf63ByXtWvxFpoEKnGtZbN8tgCTBBhHe/iJr3RquNm9WUHYxKDSC/OsVfYk1y8FVi/oFn9IZYltMgoNJKrNCT/j7B76sxq03Wyiv+9Iyl9w+b0P3Avync=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EY7EmSKb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EY7EmSKb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0A5ED1F000E9;
	Tue, 14 Jul 2026 06:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784009111;
	bh=dQzDKXk99AtSaZNtTXaCmTADdTAMXSR0phrjIrwAYw0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=EY7EmSKbdbkEJTSSaq26UBTSqOMq/IeV19Jqk/H6k5sMAxP5FvXuIhreqCQUJWDzE
	 V+RtqOCYxZQuNPYUJIfr5j0V6xdnZKdR1yvJhqtKuunX8nsU/Rb0Vv/K5HjQ8X4JcH
	 vKb/PaPZ2wt1T5ZRiW77nQwyvm7Dj3a5IKNGcxzhoLlQcd9v/xKBBk1TxpZz+gXn4b
	 J2g3fJYLR+jNrujvMON2fQEUUg29FxPRj10wNfSoV8Ez0h0PfJOhncukoahVl4M0Dh
	 t90DX8E5gu+S466YhSovlIBFZw33aPhuPLuDGV28JGHArbgWbvUm1MWXKIDHyaScPE
	 fWPKWEUe3vYYw==
Date: Mon, 13 Jul 2026 23:05:10 -0700
Subject: [PATCH 5/8] xfs: use rtrefcount btree cursor in
 xchk_xref_is_rt_cow_staging
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178400716477.267810.554262741674866787.stgit@frogsfrogsfrogs>
In-Reply-To: <178400716321.267810.14342805775513660564.stgit@frogsfrogsfrogs>
References: <178400716321.267810.14342805775513660564.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that we pass the wrong btree cursor here.  We want the
rtrefcount btree cursor, not the non-rt one.  This is fairly benign
since it only affects tracing data.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: 91683bb3f264c0 ("xfs: cross-reference checks with the rt refcount btree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/rtrefcount.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index 0d10ce2910c2cb..4e7c540c8d2307 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -607,7 +607,7 @@ xchk_xref_is_rt_cow_staging(
 
 	/* CoW lookup returned a shared extent record? */
 	if (rc.rc_domain != XFS_REFC_DOMAIN_COW)
-		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+		xchk_btree_xref_set_corrupt(sc, sc->sr.refc_cur, 0);
 
 	/* Must be at least as long as what was passed in */
 	if (rc.rc_blockcount < len)

