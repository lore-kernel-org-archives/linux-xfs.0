Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A060D14534A
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 15:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709049039; cv=none; b=V96gjHcxbVpOkBv3QojwcUmDfCbTWv6j2XH8TtFEyCvoXX6U+ajMPlA8dSfw6d+5OAvflMa7txiIbj3oPH6HISyUQ/fJv5ZUd2nzuY7MWpg7/UK7SDrglZsXgIpHnud7Ml2MpJx2J0L9h21Rh1YKoJiUleX1JuHPlF6XJb5Hz8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709049039; c=relaxed/simple;
	bh=2yyLSZ1grJl1RPq118VVFyqHR5QpCHG1zilf7Y7/Ssw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P1gkOHZhFO4T2v/Fcv7ZsPrJ5jpsGHFgqGWLlko1p7yqnqcbH8zAF21fQLtp/Gutwld0Wny2GudNcqixmwPX3R5xlH1WzqChg+CruS/TFq6qk/9AYRMH/r3eadQNz5sRu0GcKQfzVHGHhj5x74mJPXSEn6CXXgXAs0K2NtL2Uk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XQC9S9U8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XQC9S9U8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Joit6TV6bbQM/ST1wyt02kTrJwPHymnN6v3qt4jHgjE=; b=XQC9S9U8aJLHQvFaJxJA0van14
	Sa2hQpl8u5X1k/QVv0fOuknuNSSTxjfXuIGMNAdkp5xIcTjBnp/mv7HrZbCeE4Vmw6gBQmzUs7J4d
	TZ57QcwdYr4xTtq7OpchgyzkEqMFCe5fQUD4TOoCv4T9/ywsBkEzk9tQPPbWuyzTwyyCCiEClP38s
	g/sjBuprHksIBzk7/2W2eFTrF7h4tZU1+KzGPsUvLX7fNRhi7tSp8F8KhTiHeTD6Src+/ItuAo/2g
	QwZL9Gu4Unliq7zBZKcwqVTa5NMrNvyPAs9rh5P2fUAMYqoyzxbbk6LOr9DIIArCuCjRl8lsB/hsw
	47NFBf+w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rezj4-00000005rQW-0hdl;
	Tue, 27 Feb 2024 15:50:38 +0000
Date: Tue, 27 Feb 2024 07:50:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/6] xfs: create a new helper to return a file's
 allocation unit
Message-ID: <Zd4EztAQFfsyz6me@infradead.org>
References: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
 <170900011198.938068.6280271502861171630.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011198.938068.6280271502861171630.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 26, 2024 at 06:20:20PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a new helper function to calculate the fundamental allocation
> unit (i.e. the smallest unit of space we can allocate) of a file.
> Things are going to get hairy with range-exchange on the realtime
> device, so prepare for this now.
> 
> While we're at it, export xfs_is_falloc_aligned since the next patch
> will need it.

No really exported, but only marked non-static fortunately.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

