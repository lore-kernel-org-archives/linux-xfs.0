Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CB443CEF5
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 13:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183442; cv=none; b=HzPRkVqpzKO1sDGffFkB78hDmY2PL195qYfGUBOdLfmDDTXwbCVfKJG9xTi1RniA+7eM9qmaUN6sdS+fQhYz77ZayhSuX6KtkPPvzNHP6ZGrlRktZT3x3hdTqnhvUfvgxpCrhBkxXx8pm5tFiQniz4eyLb5m3zOAgOiwJuKtUcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183442; c=relaxed/simple;
	bh=jYO5tjyCAZWuYoB1nLuuWwDvJ5EvZCvc6ceTQBtiQx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LeaMLN/mNgRYA+SHdlKtnomTpzpmQxPy3LOuEiXoobVou3crln85nMQ9KRquA2+p5UDP6uWIANCpgZOYZv6HuzJIJs3xGpSs1n5puSo0ZITmXb2ru80FlQOjiN6ey7AU+VDDdOf30+L16kFMBFcHvUcomlyKkHR/epx/PvXancA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RetEu8em; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RetEu8em"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jYO5tjyCAZWuYoB1nLuuWwDvJ5EvZCvc6ceTQBtiQx0=; b=RetEu8emGBzkLuIlfOQgGLtbAz
	UNSZ4AxygKdSmvNtx7+G2unortzAoDpeg1/3pZAPaAZK/EYSRK82KTWSY4QHhV8AwmzPrmGOqkO7J
	ULvaJglqlDf+cRHYxUQAoGumO2eOsYh5tujV/Gn9Y7ylmqGqyv85rsVhDizTyNHpmDppIAirqf/al
	6tZ2EYu9LK2qMGqmqg1n6u7e4qQbIq2EdoKh1iOY8rKF3+KmXb/TMuS3uqpd2g7EquYat/HDeH1GR
	ckx2aTm7NnVJnVu6lczK9QNyYn+oWeDkKhdC1P8IkF4w0tFxugV4mp0nYPXu+lHH9FS4mS0q4qVQQ
	Sk/dtjnA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x12CN-00000009RWf-0mw6;
	Mon, 31 Aug 2026 13:37:19 +0000
Date: Mon, 31 Aug 2026 06:37:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] libxfs: make XBF_DONE actually mark a buffer uptodate
Message-ID: <apWDj38CKIEWIsRZ@infradead.org>
References: <cover.1788110147.git.cw@f00f.org>
 <60509d17767ab0c93d22269c507350840b92e3e1.1788110147.git.cw@f00f.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60509d17767ab0c93d22269c507350840b92e3e1.1788110147.git.cw@f00f.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Note that the current libxfs 7.2 sync (hopefully about to be merged
ASAP) actually kills XBF_DONE, so this will need a bit of a redo.

