Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F0F20E03F
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 15:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771945353; cv=none; b=BuDCVsxhVom7lpXnwIdJwuHzOudvYH12p0clnhy3G6eq/8/rRbeY+SfiaxnDPXFoGARxYftp0sPfAtyb8wcLKqcYeB+bUTdK0hKkvrEiP8mX/jOfDnC9GGzJSAkUh1IXkmns7KCW0OW6XD2mC/v2SDu5OzkCfXjbpwMoJHiA5R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771945353; c=relaxed/simple;
	bh=QzUZW5XFaBpYNpmaHIKRxdDXURotfSQ7tqMLriAIWcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gy2seIkpKviFHvfg7eP5+M+IeDp+l6XWcFou0S9pX3sm2y+R8sYnv2ADnvL1/THNl5ynVk+xuSIK+gkvFPlx0BKE5lAyFJ7BBTo0/obG11Cp4ZsnX9ubdqfbojlw4ENRZ1kLrBpqLuCiGln7aFfkP+/5xMsSQTDPJ+N/RlPvRUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GiKy1LfW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GiKy1LfW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=taEQhLI7B0/Qtg0csdC4UBiIQJin36MQ3aF2fF/2DpU=; b=GiKy1LfW3je9K1dA6tNpI297xk
	wWJaMiq8RcQEf+/2GWTzSTfK7pVNOWocxALPedqoKUrnX8sdh4SF0gPeJD1mtZyB9j+fBwc86LqeM
	w9jVHWatyFgVuCZD2zUNzjNSC1/QgmIXyt0jRvxeDjMcusemVa1o/Vv8x/qQbIXIT1k55ghQjEzlf
	p9wCm0BlUwxUkGIfslXgE2IC0XAkmOU6zLl70xYVDTaJBV5fCMYUIkD13OM3m4W0r7FZ2noImNXHW
	Rp+1P/Fx62WbQACVE98MLVM8raE9WQ4r9g+sF8pH0fhy8hKyKxkddw9OQyv0NMlhzT9QLyTDqOs3b
	SHKP2Rfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vutvk-00000002HjR-0pHA;
	Tue, 24 Feb 2026 15:02:32 +0000
Date: Tue, 24 Feb 2026 07:02:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: =?utf-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFE] xfs_growfs: option to clamp growth to an AG boundary
Message-ID: <aZ29iJJF9sGfya1k@infradead.org>
References: <CAEmTpZGcBvxsMP6Qg4zcUd-D4M9-jmzS=+9ZsY2RemRDTDQcQg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEmTpZGcBvxsMP6Qg4zcUd-D4M9-jmzS=+9ZsY2RemRDTDQcQg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 23, 2026 at 02:48:48PM +0500, Марк Коренберг wrote:
> This feels like something xfsprogs could support directly. My proposals:

I like your proposal.  This is actually a relatively east project,
and I've happy to mentor whomever wants to take it up.  Although
I think json output while generally useful is probably a separate
issue and should be addressed separately and in a more general
fashion.

