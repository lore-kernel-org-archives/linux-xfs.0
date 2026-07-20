Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AEB396561;
	Mon, 20 Jul 2026 08:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784535413; cv=none; b=QGCOdqlO97B/OMtPEQNIdGg10MIK4qkVC5MFmaJaa0oWkS3OY84zgSVwHUpKcTOzfNbmD/Ja2vroY9UDuUnoG2vKtdNvxnQZNRvMFAicHHrcHHepP6RyTOqX79WXM0LBiP64UIDq3JvJrGeMWMN6/llhDpwxJ/qg8urndRrM6Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784535413; c=relaxed/simple;
	bh=p+58p6R7lvw1RkKuaAs/qZ9HWVB4+nnBx1BugqTmG24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rL1U53SIYGgs1VyPpTObt4U5GdBbdbLJctioQEkMDS1NNJknrVU5mu4uVdg9BRFw+TA9/zJp9ppgFtkwEM8citvAzX0LCFn38BXwhQrpyqk9nPGRW1cEvyg5uZ8LpPiPxpMQZbAultVeU69ZfIr8h2wD8fN3ROxHeZSDdhCDz9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DD19268BEB; Mon, 20 Jul 2026 10:16:47 +0200 (CEST)
Date: Mon, 20 Jul 2026 10:16:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, brauner@kernel.org, hch@lst.de,
	willy@infradead.org, hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/18] xfs: convert iomap ops to ->iomap_next()
Message-ID: <20260720081647.GB18764@lst.de>
References: <20260701000949.1666714-1-joannelkoong@gmail.com> <20260701000949.1666714-3-joannelkoong@gmail.com> <20260702164339.GI9392@frogsfrogsfrogs> <CAJnrk1ZRQaFseAnz3zm31oR3KmQWje5HDJjhNbAQSAQyK9_PMA@mail.gmail.com> <CAJnrk1bj4pLpAzLhehrbDJuKWa=WMq-3XOAm9dhsEVDF9WCBPQ@mail.gmail.com> <CAJnrk1YkAEUhjw6mNEx70ojN7UMQT__oHn5m1Ng2Lz7FoLRhrA@mail.gmail.com> <20260717175552.GT7380@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717175552.GT7380@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 17, 2026 at 10:55:52AM -0700, Darrick J. Wong wrote:
> > Going back to this... "iomap_iter_fn iomap_iter" doesn't feel quite
> > right. I think there's too much naming collision with iomap_iter() and
> > struct iomap_iter, and I like how in general ->next() matches the
> > orthodox naming scheme for advancing an iterator. I think
> > "iomap_iter_next_fn next" would be the best of both worlds - I'll
> > change it to this for v3. But if you don't agree with this, please let
> > me know.
> 
> Fine by me :)

Same here.

