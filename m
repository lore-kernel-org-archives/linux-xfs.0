Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE2F168D0
	for <linux-xfs@vger.kernel.org>; Fri, 19 Jul 2024 04:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721361709; cv=none; b=eXfTIgH3ty6wwreCZH1OKo8Pd85npTo87XCrJhlYIVLutKrQZ8Zx+vsmxvFGWnDFIprsFLHNslsXgaoCwlIHVcxA0yu/q3zfny/7BQh2/Ccj7Bzok4BNP8ffS2klJOfUsDdcHXAiY/dYvzLColilgkORgA3HnBhswEAvZKOA5H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721361709; c=relaxed/simple;
	bh=mox3g1KwQe5wiRWzWj5aEzySvrow9qMk/Yazf6bRiMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TYLGO4f1kC6m+KCEzQ5uzsfWXTGu/5OQFtwyM3I3FcFMnc6K9IG/U+SF590kVi2CgOP5hc5Pqo/4z0cpAjKClzhoffbdf92VdZM+Suz6+ifaLJ4xYWCchXHqr1OgBOJuKpGblm+KsqBOEuiNdrhDOeRUigd0Z4mLZIAqXTLsbuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jortiMkS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jortiMkS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OoZRhsn/iTuJqTAHj9roXzT2zQE5Kkvq81fxztM2G+E=; b=jortiMkSjNY/trN/OlKtIWYkDa
	6Ca7+42wb83rdKmka27s2pZXzlVWCbUR4QhfIkyvv/2MPkfw1Gy5p1f2LPlxzDA3jSRZ5HJ21DpTh
	e42aa0sNU1uohYmBKT082CW3B6QauTp/cJtjZ8p/JUWixDfGdvhVkp85me/03xZyxa33nNVIeuUJx
	bFi/j5xXY36ca6FBy8jVL8Nbr5lZAjaqqUgSh9ZVHu24SixBRzCHg9hyOGHPkm2YQGKG7KvU3/LPW
	lt9zk9CbysTJW9bevH9xvJmpb7ETyyuzp4ZIUjeHWsj4i77y3T2aaT1aC0mzlXdO3TpPndPpCE/f5
	dqIfmalA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sUeoE-00000001Tn6-34eJ;
	Fri, 19 Jul 2024 04:01:30 +0000
Date: Thu, 18 Jul 2024 21:01:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Wengang Wang <wen.gang.wang@oracle.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/9] spaceman/defrag: pick up segments from target file
Message-ID: <ZpnlGt0ziiPcXJUX@infradead.org>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-3-wen.gang.wang@oracle.com>
 <ZpWzg9Jnko76tAx5@dread.disaster.area>
 <65CF7656-6B69-47A3-90E4-462E052D2543@oracle.com>
 <ZpdEZOWDbg5SKauo@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZpdEZOWDbg5SKauo@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 17, 2024 at 02:11:16PM +1000, Dave Chinner wrote:
> Yes, I know why you've done it. These were the same arguments made a
> while back for a new way of cloning files on XFS. We solved those
> problems just with a small change to the locking, and didn't need
> new ioctls or lots of new code just to solve the "clone blocks
> concurrent IO" problem.
> 
> I'm looking at this from exactly the same POV. The code presented is
> doing lots of complex, unusable stuff to work around the fact that
> UNSHARE blocks concurrent IO. I don't see any difference between
> CLONE and UNSHARE from the IO perspective - if anything UNSHARE can
> have looser rules than CLONE, because a concurrent write will either
> do the COW of a shared block itself, or hit the exclusive block that
> has already been unshared.
> 
> So if we fix these locking issues in the kernel, then the whole need
> for working around the IO concurrency problems with UNSHARE goes
> away and the userspace code becomes much, much simpler.

Btw, the main problem with unshare isn't just locking, but that is
extremely inefficient.  It synchronously reads one block at a time,
which makes it very, very slow.  That's purely a kernel implementation
detail, of course.

