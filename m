Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D50229A1
	for <linux-xfs@vger.kernel.org>; Tue,  2 Sep 2025 05:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756791980; cv=none; b=OAq/dCDvX3NpG/qQ4yDqzxUMbxmSZv35e7vwLdRvwsMNqwwVptAudNUYFzRWwlehFwNg/25i05r1yq1RpwYJAczEraY32l638TvY4NaVkiT1ctqo/brqAM8rE+VO5bRwxJFIb1YZekBpI8cOlfTnCdIU6/BI4zlintws1o+1550=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756791980; c=relaxed/simple;
	bh=PqQX7BhFBqN7c0n2Xqix/NSaVkk0ByOwqARUBfW6ENc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AoRI+tN7rLYMT482+6mcwI9IBrTii09n6Ab9ii3X7bOO/0bmTuKLpyDkhkuPk5hbyirdXNV1blCI5UcNW//upufzfaqXYMaPskP5Dfk3UCDfVMrYAtBt4Q1Z61Z4DeYq3tKBDilP5Amm5AT4g+pxspK59P/wTFH7LBvDXKUCWzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1yPGed7V; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1yPGed7V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=c86sNJ3UsBUVNdWZ4kWEnt/kun0oZ6FrZ71DJdsaDpY=; b=1yPGed7VHRoWd4EQdf+dDtKTcp
	Aw3oOH/37AF6uEx6i3qAQLa+IIa+a8u3NV3jg8bg6lVCnfL/ZQcQNuoQ84u2WPxhutd9orRfrun4i
	8qbaemYZdYH97awIX/Xm+MhXdZy42OD/vnAP+zml0rsi6dIlOrGvF8tB5JDcRwL3AlMELkU7wyUiD
	JfKDJrV/5x1bhuaBa6XFtDviv/mrIt2KzbFfndegMiOeJTIDAVYmvXtqfoH4WAnBFGepvopu/9yXi
	/1RZ3M1dttVAebhv4yD32SH7JlEiQCKo2nWnWEpKbghg3bDJqXVrEAyROk06ZH1vEUJ6CnQQ2aMcA
	/PAqZglg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1utJqU-0000000FN87-2e7p;
	Tue, 02 Sep 2025 05:46:18 +0000
Date: Mon, 1 Sep 2025 22:46:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Adam Thiede <me@adamthiede.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: xfsdump musl patch questions
Message-ID: <aLaEqnYLvadoG-Qs@infradead.org>
References: <ba4261b0-d2a2-4688-933f-359a8cc6b75e@adamthiede.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba4261b0-d2a2-4688-933f-359a8cc6b75e@adamthiede.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Aug 30, 2025 at 06:23:36AM -0500, Adam Thiede wrote:
> Hello - I'm interested in packaging xfsdump for alpine linux. However,
> alpine uses musl libc and I had to change a lot of things to get xfsdump to
> build. Mostly it was changing types that are specific to glibc (i.e. stat64
> -> stat). I'm not much of a c programmer myself so I am likely
> misunderstanding some things, but changing these types allows xfsdump to
> compile and function on musl libc. xfsdump still compiles on Debian with
> this patch too.
> 
> Would the maintainers of xfsdump be interested in this patch? It's >4000
> lines so I'm not sure of the right way to send it. It's available in the
> following merge request, and linked directly.
> 
> https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/88452
> https://gitlab.alpinelinux.org/alpine/aports/-/raw/f042233eff197591777663751848ff504210002e/testing/xfsdump/musl.patch
> 

Using the proper LFS APIs instead of the *64 is a good thing, and
xfsprogs has done this long ago.  So in general patches are welcome,
but please split them into one issue per patch, maybe starting with
removing the *64 APIs.

