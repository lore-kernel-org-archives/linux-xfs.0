Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E102833985
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 08:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725955493; cv=none; b=rXQ10SVC0alOTLZNhVGkj/xFSS2GIaf0a53JHdDkUjilP5GQeJDJbikct1LyK1+C2Ex9NlA0JZ/6m7/FCiexFruCU+93RtyeuHJ39Q18rU+CH6knacC3SmI3Bo2IkSdkrSU96fU/OPwbQCrhGZmBmqp0DasR9uTOr0YJjHwgU6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725955493; c=relaxed/simple;
	bh=YRK2FdJNH7V29GKSj+CUbzNdVBVwJ9pYQOGJ4xpd2nw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=obUVIAaAAit78eYgg3c8K8m93Upbra2GB5UM5KEr7oqy1HH/hpua8nM0ai589HFVtnQy07JaqHgWIpzXw/+aahPeAWm9fP6Znuie5e3AWarPWKtFdFaseaHCQ1XxBJT1pvN0rh6F0JTWluEdyCc1a/k+xBbJ+FetKYAlUZEErk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=v2zH1nQO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="v2zH1nQO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YRK2FdJNH7V29GKSj+CUbzNdVBVwJ9pYQOGJ4xpd2nw=; b=v2zH1nQOeSwDoJdwZvuFwGY4Wr
	ceakzGoTOLlSERJqlbwRhJl6+EmeVf+0eABxjUtJoPBqui7WKf+EyqVHR8XVcu3dhgUEyl5tDmibE
	PLmLWJwEQ8D7BmFhxxJbKRLedsfpva68Gq8+/ISKrRUpEHpqZaogxhPL9kqFBlWq7CWBIq3uGiV0H
	sq8xcx8Lm0038ljmFRUmjxbZ6qVD61Mboyor2zB5VqikTKN9kQjiLDbkRDClayS3fEtoBKxDlGwFP
	E1VqCa9KdTd/wm1yeuNDQ3m1pQ0wWYCzNw07LBghgLtnNxSHqB3mosudxjvkuhe1adEyDxeJDSXqW
	PUEthSpQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1snvrn-00000004jEC-1oe1;
	Tue, 10 Sep 2024 08:04:51 +0000
Date: Tue, 10 Sep 2024 01:04:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Brahmajit Das <brahmajit.xyz@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfsdump: Mimic GNU basename() API for non-glibc
 library e.g. musl
Message-ID: <Zt_9oxSRVzSRsnZD@infradead.org>
References: <20240903064014.176173-1-brahmajit.xyz@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240903064014.176173-1-brahmajit.xyz@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 03, 2024 at 06:39:18AM +0000, Brahmajit Das wrote:
> +#if !defined(__GLIBC__)
> +#define basename(src) (strrchr(src, '/') ? strrchr(src, '/') + 1 : src)
> +#endif

A hacky macro without any explanation is really not a good idea.
Now this basically open codes the glibc implementation of basename,
so maybe just turn it into a proper function always used and write
a comment explaining why it exists.

