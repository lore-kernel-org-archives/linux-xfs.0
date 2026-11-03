Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793700155;
	b=n/bQTq2oEjJf7azAp5kA9M7fx9IEwzzePxHj5f1aqDEZ8MOWDylBJgI2ehna0P+VDrB2
	 hp3VHn9Pyr31Efb9VlPjTB9uFhHvlnSuhs4aZqAtD4qPK8FM5G2yOPZrBabzS9ltStKiS
	 utxgeJNmASNO2jziowG19o+ASKs9YrdarjE8Cr7wC9hm0bP8WF3b95x899hPYeKZSodU1
	 wJZO/yJX++iBGuP/xtXf2T8DkHRQWMxV3tf/r7ZiruDWzCl8h6SAnNfc5/ElnPU8IagqJ
	 0vGPwgVXMoflPt5Wjh2DrAvSTXsKxRwCmzADSAW+hjU7bGTdrURsh7zXjHuONjY8Bng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793700155;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=+gqkuQx7kn7OAmZI1FyXY0eq0Rtk49p+Njk+cSqSFpw=;
	b=p3SYnrOFS+wYq/uUIbLVU0yWCvK1ygUTjO4uRgbdRZCluNwj+A9diKd+PCogjuluPDKm
	 ml/YAIO/dHxda7WCTMHiW7nMYMvSfqPQIYv/vACgN7D0lOa8RpRMRQBxRr3VV6llY8gUE
	 glUa7N8G1flS7Ya9UULgdS0lXZGGlAQqKpGb91/DIHsjxY1+flJrqLHrIK95r/sBHzvo+
	 Et8XcX+zt1zrtCT7Bl9Ki4WARhSHC3IfGBC2p+j1wW5t/4OUC6TNXr5UMiJ4dPEzv+rYw
	 BOMuQFt0NhxCpqfW/ukeVKEVkgwkkX6YT1pVV9VVZfIQMnM7SOEJsK1t3zKvuG1TkKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gdF9lyuu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DA1606D807
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 10:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gdF9lyuu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9231F00A02;
	Tue,  3 Nov 2026 10:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793700154;
	bh=+gqkuQx7kn7OAmZI1FyXY0eq0Rtk49p+Njk+cSqSFpw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=gdF9lyuuXLQ71DB6foN/oLM8WMUtlOlq2xyNhPQzpJpXpzs8BrMBSF3iab2B/IVVW
	 XqCK1HhAyNzG3sxi88qa0JFhfvpW/w3/29SQozpjHbD3KY5g1unM7c8pEmQbVKOLGo
	 eO8N4m7k3Ioc0BAk0mLBCgRBt/7N6d6OdG0vvRiLAyaUF5rfOjByBkXpa8y+tkH0+H
	 X2f7e8niTS43HQVbM+BAynoOsEo75+Dx7j38p0oLR2xrx3semtvRdRiacXhgA12ycH
	 iHIgzw5bNHEQCbrfhC/azQnRYWKv7d8+8lGVdZ0rOQQGqhSNPFweuqNwdouPgiTvYN
	 w/55iY0XMQwVQ==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Cc: hch@lst.de, dgc@kernel.org
In-Reply-To: <20261016193422.1630907-1-sandeen@redhat.com>
References: <20261016193422.1630907-1-sandeen@redhat.com>
Subject: Re: [PATCH 0/8] xfs: consolidate btree insert/delete checks
Message-Id: <179370015349.413123.5596789522965143641.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 11:02:33 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Fri, 16 Oct 2026 14:29:00 -0500, Eric Sandeen wrote:
> Every xfs_btree_insert/delete caller expects overall only success
> or failure, so these tests and mark_sick calls can be consolidated
> into those functions themselves, with callchain tests and extra
> "status" parameters removed.
> 
> libxfs/xfs_alloc.c    |   91 ++++++++------------------------
>  libxfs/xfs_bmap.c     |  139 ++++++++++--------------------------------------
>  libxfs/xfs_btree.c    |   14 ++---
>  libxfs/xfs_btree.h    |    4 -
>  libxfs/xfs_ialloc.c   |   51 +++---------------
>  libxfs/xfs_ialloc.h   |    3 -
>  libxfs/xfs_refcount.c |   97 ++++++----------------------------
>  libxfs/xfs_refcount.h |    2
>  libxfs/xfs_rmap.c     |   96 +++++-----------------------------
>  scrub/rcbag.c         |   12 ----
>  scrub/rcbag_btree.c   |    5 -
>  scrub/rcbag_btree.h   |    3 -
>  12 files changed, 110 insertions(+), 407 deletions(-)
> 
> [...]

Applied to for-next, thanks!

[1/8] xfs: remove redundant stat checks after xfs_btree_insert()
      commit: 20496da47af3197b69553518d491262343c1d491
[2/8] xfs: remove redundant stat checks after xfs_refcount_insert()
      commit: e2293d89c56b1a5992974de2b3ec5be2573c5d11
[3/8] xfs: remove redundant stat checks after xfs_inobt_insert_rec()
      commit: 87f5edcd7190d15d42b690f4a738929e73fe0c6b
[4/8] xfs: remove redundant stat check after rcbagbt_insert()
      commit: cfad3431d3ada395d70cfcf66570cca670129f09
[5/8] xfs: remove status parameter from several btree insert functions
      commit: 25b97ffb81111ed59beb27997aaf38621992f1c1
[6/8] xfs: add stat check to xfs_btree_delete and remove caller checks
      commit: c71f58e4fde5e3c65da507132f97d061adcde2bc
[7/8] xfs: remove redundant stat checks after xfs_refcount_delete()
      commit: 12be672e210c9935a034640b984bf8bb21759c6c
[8/8] xfs: remove status parameter from two btree delete functions
      commit: 01b68405c7f0ff7ceedd543b42fe6a5de23b3006

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

