Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7242533506C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 05:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765862360; cv=none; b=SlkXNqPHBJ4OwvxnHjHKmfPIb2Y6G5AESqbOrwNqBf1RwtUf9bimH64OHhxChbhRZz3KsQ1AeY7HFy/iPd9/wnxbPjZg5UDGR1IoRslGpFpNe4tn+y8hIG3iat1Zirngi2r1QcugBt3psjycbf7UnbIxFvG+VuXEhSaWmAI4T2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765862360; c=relaxed/simple;
	bh=kS/CP9a8owE1DsCPIn8YF99OijF+IJz3Rtrjb6jQWOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JyYOk2kKSuxoo265VaqgpBHZaMJwpzBalgi8P1p8oc9M/Dtoz27t9FjoiTkZ65iD13x2EiH4icKN3wlsQxLgeuLwdbPYaZ3oqPlexgwOnSGq2h5GcGt9cZP46LDQQO/K9KvAUJrVXHqUzTeUbSy5PJv/2FkezziQXFS/y7gfr98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AnUU74mQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AnUU74mQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FTt3A/pthFhLlT0fSJAl2HnRN0Iot0eIzrfXcBGn38A=; b=AnUU74mQgrwXueC4jT23CAs+Od
	PtIz+6HG+qZizjDoH5PozzAOsHGbfLha+6XVAqTOxnraNLHoh+gDN9DIK4rwNOLxOHGL/SVdoFcIz
	5aTee5yo6lNlQuDWZKzL/ZWYJDdJpCrH3GKpJ7KNu8dFjVjfd0B4XuI5ptnX/262P7/nKEpBgFvrY
	9INM2PJE9eNmciPlLvEjHkDRIx78glssmJ2fSYqVub7AnxcXmzrGwzimCIdhxDEaxi3WWa2lVdbG8
	JF4VpDHonkiuF7XlF8f8wiczDciMB9fCkDV0a1oC7r9/H69BFhTKfme7B6YFL2kLdP1lGHQ7oE681
	7e3nrUSw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVNSk-00000004i8s-0SKs;
	Tue, 16 Dec 2025 05:19:06 +0000
Date: Mon, 15 Dec 2025 21:19:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Luca Di Maio <luca.dimaio1@gmail.com>, linux-xfs@vger.kernel.org,
	djwong@kernel.org
Subject: Re: [PATCH v4] xfs: test reproducible builds
Message-ID: <aUDryjk9wdZZQ5dz@infradead.org>
References: <20251215193313.2098088-1-luca.dimaio1@gmail.com>
 <aUCSSuowzrs480pw@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUCSSuowzrs480pw@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 16, 2025 at 09:57:14AM +1100, Dave Chinner wrote:
> > +_cleanup() {
> > +	rm -r -f "$PROTO_DIR" "$IMG_FILE"
> > +}
> 
> After test specific cleanup, this needs to call _generic_cleanup()
> to handle all the internal test state cleanup requirements.

There's no such thing as _generic_cleanup, and none of the
_cleanup()-using tests that I've looked at recently hooks into any
kind of generic cleanup routine.

