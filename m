Received: from sg-1-18.ptr.blmpb.com (sg-1-18.ptr.blmpb.com [118.26.132.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAD61DB122
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 05:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764567947; cv=none; b=s5ecSaSeTKyPryLG/77OapWBTd19Yop3QN63UJ74j7eXJebOZh8p2Hskg1/wFQgSx8cDqEV1dbXAxq9qXQqhnukX8EbVS8AHfuvN/GCvfzlIqlzWvfn5sqH9ZygctnSKZGJByjj7knqa22uwTOk/H2k7QeGJP6LvRNi78jcQJIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764567947; c=relaxed/simple;
	bh=FrLZeS9iVrmZMi5DRhrhFzf5CcnM5AZI3fO/L2TjI1E=;
	h=Cc:From:Subject:To:Date:Message-Id:References:Content-Type:
	 Mime-Version:In-Reply-To; b=S4jpzkQ7tdtKwuV/OwwNLrScCsQWkB0Nb/ZVoiKQ6Kcq3lotW1YcoKDp1+CJXpxZCfc9LSDd5U8Q2hY7SPoS4orOoFVjhcq+qx+Qjv/t30/WdA5GnlDhYXsdsb1oW+fq390nqH5XavSqGGq2h71Wy2IZqgflFjQspeZxSSaHcJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=mlVsioHM; arc=none smtp.client-ip=118.26.132.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="mlVsioHM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1764567939;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=sCJL8NM5LN4ox9qDlAfQe91dK8F8fKCk/Hgg80m0H8Q=;
 b=mlVsioHMKYge9CWuleC4jliVQ3Weuv5CzkJGzTH4vCKC9ax/M+RcxXilpXCcI9Li7jFLI8
 6g6MaYOl7pBPRzOZaX5ES9+GjkqLm19EQDx4+VJLCQDJSBmAuRSZrQ/t3dS6dwYyHhDhmo
 J+CartXY1deG2DRV5hNzfveNCu0BwpW6NyNM6nbomfE7HaBeptBfLG/SNEAv6I9PWMInax
 9g3cOQBpt4AOcmz8zGyqty+FEXZ9MM/6e3kp4zjt15kQjIobhFnV3nPmstIjwVLQKQeyvY
 E99pLMpvh4HJ35t0TwbduzeYR/8fEX2pNPmUCbWLsLZCZbOzhjH0marQlOgVvQ==
Cc: <Johannes.Thumshirn@wdc.com>, <hch@infradead.org>, <agruenba@redhat.com>, 
	<ming.lei@redhat.com>, <hsiangkao@linux.alibaba.com>, 
	<csander@purestorage.com>, <linux-block@vger.kernel.org>, 
	<linux-bcache@vger.kernel.org>, <nvdimm@lists.linux.dev>, 
	<virtualization@lists.linux.dev>, <ntfs3@lists.linux.dev>, 
	<linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<zhangshida@kylinos.cn>
From: "Coly Li" <colyli@fnnas.com>
X-Mailer: Apple Mail (2.3864.200.81.1.6)
Subject: Re: [PATCH v3 1/9] md: bcache: fix improper use of bi_end_io
Content-Transfer-Encoding: quoted-printable
To: "zhangshida" <starzhangzsd@gmail.com>
Date: Mon, 1 Dec 2025 13:45:24 +0800
Message-Id: <DFAC6F10-B224-4524-9D8F-506B5312A2E8@coly.li>
References: <20251129090122.2457896-1-zhangshida@kylinos.cn> <20251129090122.2457896-2-zhangshida@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+2692d2b81+e49eb8+vger.kernel.org+colyli@fnnas.com>
Received: from smtpclient.apple ([120.245.66.121]) by smtp.feishu.cn with ESMTPS; Mon, 01 Dec 2025 13:45:36 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Coly Li <i@coly.li>
In-Reply-To: <20251129090122.2457896-2-zhangshida@kylinos.cn>

> 2025=E5=B9=B411=E6=9C=8829=E6=97=A5 17:01=EF=BC=8Czhangshida <starzhangzs=
d@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> From: Shida Zhang <zhangshida@kylinos.cn>
>=20
> Don't call bio->bi_end_io() directly. Use the bio_endio() helper
> function instead, which handles completion more safely and uniformly.
>=20
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
> drivers/md/bcache/request.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index af345dc6fde..82fdea7dea7 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c

[snipped]

The patch is good. Please modify the patch subject to:  bcache: fix imprope=
r use of bi_end_io

You may directly send the refined version to linux-bcache mailing list, I w=
ill take it.

Thanks.

Coly Li
