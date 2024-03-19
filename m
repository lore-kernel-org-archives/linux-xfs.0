Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E71405FF
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 21:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710883970; cv=none; b=GkiKx1prju14jtKTNuRA5w1jKa7Pqw586awN65XRaQb0/DNSndaOOdYW+JnAqCQDlFRPzavYsIXgUsW1gCo9DnmJbZBioGLlRMtfi2pBbBOgmfTXVXLJUJSbIZ3Wa8O2O8LBIMM7pLWS0CkV9EpXhnrr5Yd3LLugFuDUnzy8jp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710883970; c=relaxed/simple;
	bh=z8AVaS01nBwKXx+ZoNJwsGEhkTakpWe5YAXeK4bsrZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=erqf88wfN0ZZnV0CEzhsz0WRH4DFaJVoyaZqJFsvCxS+dJSX3t1b5iIS71DbS8j9cl1ksfLSN7owLBByhfGrhzzrlaVh2KNzbiq1U/g231EKUI+qRDAiVo8qd2rX8l1IhHjlLkUoea5neSgi8bZ2q5fmgjG/KWrrz1YCxrzJxTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e6kDm9wI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e6kDm9wI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=u6V2iQsrEblmhlMr0dnddPqdRUbmqMAW5yuVuPORLf8=; b=e6kDm9wIIMv31uvsU8MLELrO7x
	7YVuLX9+Bf9GkQbIg7bl2WAn0C4jTTyjEnLm4qtEvbHMvdlzf1MdCOWguvBV21F7SC55f3ggQMSIB
	VSznb8Oz1hhWoZDr7eLeqUWtCW4MdjRFcG/Mh6sW3EQSiODwkAL6njY+qihJcgRjSBUp4Q6f/EMuS
	liOWV8s3WLMjdR43YkE+A0YGVP5rRGXwSlR6qJtuUswNtbrv5SxBlRKyJyeeABYOpF1o+ux0YHczu
	RWlmgnstRsMDB3I45A3+x5XUfCFR0blu2K5sc7nHP9/mWsOyZDndj8vodcwUkCfJQyd6ezPPTIqtT
	87jucH9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmh4i-0000000EJ8h-293Y;
	Tue, 19 Mar 2024 21:32:48 +0000
Date: Tue, 19 Mar 2024 14:32:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: map buffers in xfs_buf_alloc_folios
Message-ID: <ZfoEgJ7U7A6BxwIl@infradead.org>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-7-david@fromorbit.com>
 <20240319173413.GS1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319173413.GS1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 19, 2024 at 10:34:13AM -0700, Darrick J. Wong wrote:
> On Tue, Mar 19, 2024 at 09:45:57AM +1100, Dave Chinner wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > With the concept of unmapped buffer gone, there is no reason to not
> > vmap the buffer pages directly in xfs_buf_alloc_folios.
> 
> "..no reason to not map the buffer pages..."?

or maybe 

"..no good reason to not map the buffer pages..."

