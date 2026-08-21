Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7E5360EF5;
	Fri, 21 Aug 2026 05:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787290554; cv=none; b=q4NlqU4M2YaZuDOSif2VFaaU67alel4YaCfM7TZ3E1NV7qc+Zn2lUExh0n0nCcEukh+0pfnoT83GxzIrpZ4kyoCCDup49edesOAtjvn9aLasuHPU/2jh0ftTQuDg/Kkt+LURTtJ6Gd0W4gdVopGatDVmQeL8UMAGrl3hWgq4QJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787290554; c=relaxed/simple;
	bh=emzljrDBz6/hK6DuLYQ1qsS3sVOmmTbii3xtOFjpi7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jW4yI2t2oC2O7PKhRN2OrCAnhGk/f5f1ATDiHH0fo06TuoZfzIhhI9FnofrtLvWkMpIk32Kpu9QZaZ4BGWQj980Xb27HoCBlzJYSBYf068L6hYfHPhgbQOPLEVWpXsWJs0b8BrgHpMW6txoOXwt/AFWzowYqmtuh09jEIeGwsPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EgtEwKQL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EgtEwKQL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZSyDUkhP016O9m+lZ/kMZSp3JXYLBodipeWAdaYMufg=; b=EgtEwKQLFntoOanGHY4nrhp3S8
	3SpbdyjQlzJwSYpeo6jCAR/vnxJAvBaIGXIoyC9RV0GqeSNY8pfBpyPMQpke4IkvVTVP45WYwT4Vj
	bBX5oNMgpBHp8ip1X1vtC7walkZpu+YotJC9AxycZQr6nxdFhYeKZ5mpWI4W1vmA5FuHQETpFh6MZ
	Ov0m0tu19v1nh1bcDcJRgTdY2HF/s+PLnwZAEWogtqDq5TpeCT0mF+soHJWFH4YclYR49xIEPBqY/
	trDhKHal2Yygn5AogCsFcz2DFLvhZKniiXCMr+PGkRtjNViOHqLuzLDQzff55upvl98AEgvsT/8sb
	pWSoO50Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxHux-0000000CZKA-1hrj;
	Fri, 21 Aug 2026 05:35:51 +0000
Date: Thu, 20 Aug 2026 22:35:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, qsa@qualys.com,
	fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic: regression test for refluxfs fixes
Message-ID: <aofjt-8uJvl994E7@infradead.org>
References: <20260819155432.GC839663@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819155432.GC839663@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 19, 2026 at 08:54:32AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Regression test for refluxfs as found by Qualys.

Looks good.  Should this get a Cc and Co-Developed-by for the authors
of the C code?

