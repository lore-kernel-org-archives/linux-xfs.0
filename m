Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BE43E8C74;
	Fri, 11 Sep 2026 11:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789127092; cv=none; b=KhhWhESzagTTePOivElc82Ag0nF1bRW/NRutQ5BQ0MDguUUFdRjSu6jew3uITzPAYy/sabPwsEa0N/P/ITr5dhYUQfbgkPwxy12QiOzPSRsWsQzP0TY60qlnzWhlbm+6Ps3ESwxOH/tjtvo5dmyEBgc6xFUjYONHOuK9tyqOMZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789127092; c=relaxed/simple;
	bh=G24zWoZh8gIjcqlohxiQwJID1kLljBarzLD/ayF5Drs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DPLcEBsDwv8fRUzxYAJ2zH18kOetJH//oGqTLi5o7OkhVcbYlE+IXuOcBlS+MLlvTmDp1T19L7Pq0WG8the7lLi1cA9B8Sd8lO16z6XUJ7OYwJE67zzIyatsvwXZbqxAfbPdbboJSSm5rMZbcUxiKTMgd+QCF8lWpev7h7CnVPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 19A6968C7B; Fri, 11 Sep 2026 13:44:39 +0200 (CEST)
Date: Fri, 11 Sep 2026 13:44:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: lazy bounce buffering for checksummed reads v3
Message-ID: <20260911114438.GA21957@lst.de>
References: <20260909060924.1102037-1-hch@lst.de> <fe537c5f-114d-4d9a-817d-93f359e12924@kernel.dk> <cff350b3-836f-4953-97f3-d664164746b4@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cff350b3-836f-4953-97f3-d664164746b4@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 10, 2026 at 02:51:33PM -0600, Jens Axboe wrote:
> > It's a little hard to split as you have eg block patches both at the
> > start and beginning... In the spirit of getting this some runtime, I'm
> > going to queue it up in a separate branch,
> > for-7.4/lazy-bounce-buffering for now.
> 
> On 2nd thought since this already relies on stuff in the XFS tree
> apparently, you can just add my
> 
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> 
> to the block patches. Would probably make everybody's life easier.

No, the current series is just on top of mainline with the block
fixes for Sashiko existing issues comments split out.  Which probably
was a mistake, as that now lead to a side-discussion and Sashiko can't
apply it any more because it is too stupid to parse the cover letter.

I guess I'll do another resend with the two of those that stick
included, and I'll leave the third on to John, who already has a
handle on it.
