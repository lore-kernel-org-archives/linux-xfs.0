Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B221F1520
	for <linux-xfs@vger.kernel.org>; Fri, 25 Apr 2025 13:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745586616; cv=none; b=aSwKDYZ+rPC9KwY+MoucVa2+EuaoBV1lvk0P/Ngl2UKF0H653rpGIPy5UnO+2FR2tgoQLdu4sGHhXMEBH8BfkemvEZVL15S2BWS0jleuOAZRxkKI08i1VPDLHHbFtAgFjWzPP1BYKy3S/8zq/hRO78jaLiA8dVyGa+PNyZYqsSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745586616; c=relaxed/simple;
	bh=uda3xHTc7BGkR00UHwzuQGG0SC3PhcWoBxXfneCyEoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MXyHAE17UncPxUL1g0hQwMGVw3lMGIZwzgd845DtCu4TIiFJB7IivNyHO6SHxTX4/gZYn+Wam3yFvPvqKd052NwIF26/vb0Fkhl1qVcqVclJou1SKkmsg/slN4VsECYzwaYcXGE2k/NJ0pYgFQ3dUmcUKx1FjEKkB6PG17Ju63c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZqfyExAl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZqfyExAl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nvgCMNz9z9yzPtz9VMIerNYMuUBGYdLqwKWZIzSPFjU=; b=ZqfyExAl/26bLdo+x/r+dTnM6C
	Pqxb+iYjkT+MjSKy2oQJH9vHzmwVPXfZIQJnY32HEbc64pPR5jrlYdid6cwI8qbLgWin1ekbCOhZK
	G5YDrZ7ynPiOrC3BwwkKEmtFHWixU5JYLvQwZV1Ydetmgg+B5PyPnvo0myGrmMYtlZDiSQxtktiLS
	tmeVWXOBpgJjBkn4seaHIHz9G4pRe/DqikF4gN7wBzxAVOdJtYTwG3Z/EDjS2IHdrd3bcppeVps96
	+KA3dioyjLMHiiPRITMUL+BD3sDTZiBO13gHzkD7NL+2alkswws936Yg8LEaW7J0LemVt7Q2Cfa7S
	ENxExiag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u8Ioo-0000000HEH3-1pFR;
	Fri, 25 Apr 2025 13:10:14 +0000
Date: Fri, 25 Apr 2025 06:10:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Luca Di Maio <luca.dimaio1@gmail.com>, linux-xfs@vger.kernel.org,
	dimitri.ledkov@chainguard.dev, smoser@chainguard.dev,
	hch@infradead.org
Subject: Re: [PATCH v6 2/4] populate: add ability to populate a filesystem
 from a directory
Message-ID: <aAuJtnJQXOlZ6LLi@infradead.org>
References: <20250423160319.810025-1-luca.dimaio1@gmail.com>
 <20250423160319.810025-3-luca.dimaio1@gmail.com>
 <20250423202358.GI25675@frogsfrogsfrogs>
 <vmiujkqli3d4c7ohgegpxvwacowl2tdaps6m4wyvwh6dcfado7@csca7fs5y7ss>
 <20250424220041.GK25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424220041.GK25675@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Apr 24, 2025 at 03:00:41PM -0700, Darrick J. Wong wrote:
> The thing is, if you were relying on atime/mtime for detection of "file
> data changed since last read" then /not/ copying atime into the
> filesystem breaks that property in the image.

I don't think that matter for images, because no software will keep
running over the upgrade of the image.  Also plenty of people run
with noatime, and btrfs even defaulted to it for a while (not sure if
it still does).

At the same time having the same behavior as mkfs.ext4 is a good thing
by itself because people obviously have been using it and consistency
is always a good thing.

> How about copying [acm]time from the source file by default, but then
> add a new -p noatime option to skip the atime?

I'd probably invert the polarity.  When building an image keeping
atime especially and also ctime is usually not very useful.  But that
would give folks who need it for some reason a way to do so.

