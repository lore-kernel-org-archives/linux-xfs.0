Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEE03002BC
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 05:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765344525; cv=none; b=f++Lu0gsQ4Gvkhb6p7s11mz6d2YU6+4biKUG80E3lvjwZZ5Jz6Dv1i7ds6ysR1aLXDjQKuiVmq3ZZ5WL1/HZTqNq05U99yeXYVq6q8RPbjOmTTDxz65LUv+0oJzmnUZ8F1xFaa4tBBKI45yt6cNQP2/Aimk8SE6kNDpaXSLFiaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765344525; c=relaxed/simple;
	bh=uwjD55s30hzIv99/+X4g+BbKKnCOErZeddssUXdr3BY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LF4QoGsty6oL5kG0cZE4d+1yuqhZZURRauiQdM2SDIcmoaCNDsgRGqlRfBfjPMv1reEpOi2ZZb3CqgbQWBMB/42fOCOFO06D0M5RYox4pUhAAYHu+FBOPnJGQbCUmYQw6Iq1RAUgXOzujkCn3nF80cvUpZ7zf/1rUabDMgtbV3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rujVlGQZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rujVlGQZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Pnnd7wrXmCNsxJb7zMUUciGvKiJHFl4gQKLlmcRGndw=; b=rujVlGQZhFTeOmmQJDWvu7MHBv
	NXNlK7QSPfnpwDFFlUSTaY2AySG9TqoOJe9tbmEbrhAC0TDKwjLVpl2YpCY+4CxeuwnyuwLDG6UuP
	zqVtdIb/YSY0pFTWTfurD8kqopsQ7hmDVjV9u71V80bkpsKCirMyIrIeuHuyB2elzqXIxzuKbw8gK
	7UV89jacvoW2nufJ1Z0MZmXwWLjPs/Zg92etn/cVAoRyYMYK+Xnl/fGGHfJGD7GnclZfl1Suo7SX+
	TU4+hBl29qQsDuMGYtkuCiLzSFOejtn3Dcfr/Hq5tfZTwDFmX9XUAyd2pyViy/hj8+AWJEEap/BUe
	fdmkld8A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTCkl-0000000F8Oh-1vzn;
	Wed, 10 Dec 2025 05:28:43 +0000
Date: Tue, 9 Dec 2025 21:28:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org,
	chandanbabu@kernel.org, sandeen@redhat.com, zlang@redhat.com,
	aalbersh@redhat.com
Subject: Re: [PATCH 1/1] mdrestore: fix restore_v2() superblock length check
Message-ID: <aTkFC2EWf5UX5y9w@infradead.org>
References: <20251209202700.1507550-1-preichl@redhat.com>
 <20251209202700.1507550-2-preichl@redhat.com>
 <20251209205017.GX89472@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209205017.GX89472@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 09, 2025 at 12:50:17PM -0800, Darrick J. Wong wrote:
> > -	if (xme.xme_addr != 0 || xme.xme_len == 1 ||
> > +	if (xme.xme_addr != 0 || cpu_to_be32(xme.xme_len) != 1 ||
> 
> xme.xme_len is the ondisk value, so that should be be32_to_cpu().
> 
> Otherwise the patch looks ok.

We really need to bring back regular sparse runs on the userspace
code.  Let's see if I can get it back working..

