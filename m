Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF301FBEB0;
	Wed, 22 Oct 2025 04:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761106857; cv=none; b=R4t9lMRxB1souwVLPafHUFsgjckxzojohajU3QjdoLgPAeZMNeo1203Y1vhcx5MnoAYmyBYw7DT48a/cA17W1g0jXcPYLENHS+oCzADTxrRlma7VJZMDQaAt1KBVrLZ9cODiBvLuy2FxNg9gthSNVC0szMYdJBojz35kSsg25HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761106857; c=relaxed/simple;
	bh=Qa4SIXNPsktlHSnF5w5CDqjsuVixma41sj8etMd82Ok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L9tVtpTSIZZ4llaQeRwe6v8qW7WCrsH9no60x/JliQ5MhPaY9I8PRaoGQ8MOCvmKrFmxhHHsuM8ZJrtwq/TjCy6SaUckwBZgrY477SGeBqADQUamGUnAQhGnROmtJ8z3gy0YGinqXla4IZHwLGz9LiD/1NkzgTF+LtKQ6aMhLlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X6/dL+JS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X6/dL+JS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=b+g9A3za6Vagzgh8degVWLKAqbClPE1j6giM6mPU+nY=; b=X6/dL+JSPWCyCEZfTQoxhn/1dD
	tEwtZEvcKoEKpEUNmx8hYRGYfVXtA4zLd8i7/VuvAgSkuAdofC93EmPClBEiSUdnnHXPTm0VyzliD
	P5ed5YBCXhRITFSzOaI2OI/8U5anPN0No6isQQBp8gd0XrgXe1ICFOhe2LLI78gnv/Ex1AnUMkRyH
	jz5RqOMoERgxkTstL2pbQ5QDSDM1xhh2NJjWNPecmHEG2sLtGskJ2qogcHa+fm6Zh8VyHe+VX8VGY
	JSKdZge2ca7NHuyik4Xs0DsNaD1sI52ASHhA7U8xkImhhYdRQrbTAhO732oG3ZRvHiyzIjOxmws9W
	bTZqF4Kw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBQLH-00000001QEl-3Cvj;
	Wed, 22 Oct 2025 04:20:55 +0000
Date: Tue, 21 Oct 2025 21:20:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] generic/778: fix severe performance problems
Message-ID: <aPhbp5xf9DgX0If7@infradead.org>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
 <176107188833.4163693.9661686434641271120.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176107188833.4163693.9661686434641271120.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 21, 2025 at 11:41:33AM -0700, Darrick J. Wong wrote:
> As a result, one loop through the test takes almost 4 minutes.  The test
> loops 20 times, so it runs for 80 minutes(!!) which is a really long
> time.

Heh.  I'm glade none of my usual test setups even supports atomics I
guess :)

> So the first thing we do is observe that the giant slow loop is being
> run as a single thread on an empty filesystem.  Most of the time the
> allocator generates a mostly physically contiguous file.  We could
> fallocate the whole file instead of fallocating one block every other
> time through the loop.  This halves the setup time.
> 
> Next, we can also stuff the remaining pwrite commands into a bash array
> and only invoke xfs_io once every 128x through the loop.  This amortizes
> the xfs_io startup time, which reduces the test loop runtime to about 20
> seconds.

Wouldn't it make sense to adopt src/punch-alternating.c to also be
able to create unwritten extents instead of holes for the punched
range and run all of this from a C program?

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

