Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B66A1527B4;
	Tue, 19 Nov 2024 06:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731996805; cv=none; b=TmyqEa6+2QzONmFCTy4Ae1LEAEBISbWyYRSXtTwqIZ9e16NerppljAx+A0aqTQX39oGfYeE0Rmtw+S9Zm73PHqS0bDMnpbb7XjEDhSt0X4wyOOGo+WMiyZY4g7muY/0f65GlV6rCh+SFL2JGr7TJ0jDjaolKxBK/LrzeOsD5czs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731996805; c=relaxed/simple;
	bh=dX+14lpY6ThHnkkAApMBKzYLSGOJR1QcEMZeZfarRc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cY/xE7z8xZz2G2aXYGflpcpsbNVpEpBYgygAEjZwatU7bVcsBkZ6xQwlLsmJ3qRsOJAF3pJUDtJwUy72e1CXMuli4vWFEnNJm04ZRGPT386u2SSd537OnsMqzQV8bV/DcEJEgGDgmEemB/hij984PB4v5HqmxVFzs7x1A9RilVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HFrUV56A; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HFrUV56A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+8+b/D8sexm2rRahcyGmLCAhK6dhnCOC3ns9q+QYJEU=; b=HFrUV56Ac9ueFZsCD3+KmeEYwd
	Js9PWiFzVS19KknYmkSA/Bh8WFR2UU+EKJBqmLfA0dfF9Xtry6dM8LMVBcs4mYSiItwcr2LbIz6fu
	hasdgR8vgPWW5APyVcWVBjR45nu9MW047EgY0yuv0qUJiX/mzSmu6nfuhcbpY0fsLwViJQNm07g5N
	kHT8cpNVqJp0BbZXdMOdlmv0jVHmyzjvr1r8+cDuoKF+ORJQ6FCmEvMDa+rBL1YNTXMlSBvF4SfId
	doigzWCcGOWNEPsgwtHX/kdbmThDl7z2KKLHwW7AdPsJwpzhp6YJNlqDad1ydE5qLLzpZ/13qa1nM
	R/nEBtHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tDHUJ-0000000BVNK-21BE;
	Tue, 19 Nov 2024 06:13:23 +0000
Date: Mon, 18 Nov 2024 22:13:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 09/12] generic/251: constrain runtime via time/load/soak
 factors
Message-ID: <Zzwsgzu81kiv5JPB@infradead.org>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064562.904310.6083759089693476713.stgit@frogsfrogsfrogs>
 <ZzvtoVID2ASv4IM2@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzvtoVID2ASv4IM2@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 19, 2024 at 12:45:05PM +1100, Dave Chinner wrote:
> Question for you: Does your $here directory contain a .git subdir?
> 
> One of the causes of long runtime for me has been that $here might
> only contain 30MB of files, but the .git subdir balloons to several
> hundred MB over time, resulting is really long runtimes because it's
> copying GBs of data from the .git subdir.

Or the results/ directory when run in a persistent test VM like the
one for quick runs on my laptop.  I currently need to persistently
purge that for just this test.

> 
> I have this patch in my tree:
> 
> --- a/tests/generic/251
> +++ b/tests/generic/251
> @@ -175,9 +175,12 @@ nproc=20
>  # Copy $here to the scratch fs and make coipes of the replica.  The fstests
>  # output (and hence $seqres.full) could be in $here, so we need to snapshot
>  # $here before computing file checksums.
> +#
> +# $here/* as the files to copy so we avoid any .git directory that might be
> +# much, much larger than the rest of the fstests source tree we are copying.
>  content=$SCRATCH_MNT/orig
>  mkdir -p $content
> -cp -axT $here/ $content/
> +cp -ax $here/* $content/

Maybe we just need a way to generate more predictable file system
content?

