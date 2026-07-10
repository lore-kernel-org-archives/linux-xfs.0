Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E7224336D;
	Fri, 10 Jul 2026 05:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783660980; cv=none; b=iOj0xu07u2TiVrRKS0WK+9VWSIqOuZT1+ee6KlRUTZBNBoVXDMx/dhxBvoy2YghIB4OJLWllLg+cR40fzc7Sc1KaILQRUPcsmvfpc6aI2uzwxlpyIbOu4bB9/QZBixErF9s4mB/ZDru3v+ux+yd+6rQa+KqTK4wHeLXTNUhjRGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783660980; c=relaxed/simple;
	bh=acN8/KG/UGZ03+FWD8TQf5mTnOIgAsZMVSzU9ynLSX4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sCI9/XLbBcfd75GBmRV/wDIc08kd5zVC2qv+oLKOodhphWz5iMWwx53gnPSgGD7cS7ngA+fuiyQ3fbGQGTtTB84LAz84d+VE3EXEVQ24OJvNS8tkWK9Sz6s7JjcgoXBaIA2Gi90gkyVS/ZZoSaKVB4T11WWXAKIy3QR4c9tpsWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7FO+LZl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7FO+LZl"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 220231F00A3A;
	Fri, 10 Jul 2026 05:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783660979;
	bh=dQzDKXk99AtSaZNtTXaCmTADdTAMXSR0phrjIrwAYw0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=b7FO+LZltGr0ibVjtl1lLUxJ/PLW7bQDbQUUVDFIZ+n7UVZc76pYuMKrrAorRmCSH
	 Qjpeu798tQj6G5XVXJLtN3LYAfuep5Zy1L9Fl58bGf2LJvyD1OJix5z/GUfo0zdzjW
	 xfQ20SzGliCrZZ40zVw9KOAX2stRPay/ENc7HWT+mBm8ltckJnClVQvMR72cEjvLVa
	 B2QGayMEFDnT39PaOg+pv8zmyqLciZtcqq8M3D9VAtqMpHWDJAX3QZYJ39PtRS55Pd
	 23tMiRpyMZAxARFPau9paEVwZKhtydRIMqdzoA/UN4iXLqld1FDyISQPzzPwTl1bYA
	 vlKyec7obtD3w==
Date: Thu, 09 Jul 2026 22:22:58 -0700
Subject: [PATCH 5/8] xfs: use rtrefcount btree cursor in
 xchk_xref_is_rt_cow_staging
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178366081099.1173468.12035180432743902143.stgit@frogsfrogsfrogs>
In-Reply-To: <178366080946.1173468.2461850065055339934.stgit@frogsfrogsfrogs>
References: <178366080946.1173468.2461850065055339934.stgit@frogsfrogsfrogs>
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

