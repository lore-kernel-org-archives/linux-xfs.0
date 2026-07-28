Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C213A3815
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 04:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785213523; cv=none; b=RUaO3YmQvmhuzbzsiE5y+BXd9gTauyFFjB+TOw3Lqqgq5il6R6LmxmAD9vl3xvJDeCi1N3AJ6dq0cSt9+1R4aLfpwd88ttFH1GQc7JliTvmOIDqYMLckaL+XlG/fQ3BKX9poJYjay3RzXKo+pQVUEuZInA7xBlZybYt8+wkn7Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785213523; c=relaxed/simple;
	bh=VtIkivoHVuvLN2CyTiFb77yMrjfIyVQEG3RIjRfwEww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VohFBHTAy4Kw5l515oJENqgJdaTAugQSIYqJOd/DKVz77uIxTZC5OdtUotln43n0Bn00lCJpTsub3Uqew5An1OlVpWWbA5cxA/8UHoUrX5OjF6u79syeyXtvJrTJtC1SmsfY1UKkjQ//zlgQurzZr1mFQu4avelogCyoAbEI4rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F26BD68AFE; Tue, 28 Jul 2026 06:38:38 +0200 (CEST)
Date: Tue, 28 Jul 2026 06:38:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: consolidate buffer locking in
 xfs_buf_get_map
Message-ID: <20260728043838.GA20064@lst.de>
References: <20260715145147.95654-1-hch@lst.de> <20260715145147.95654-3-hch@lst.de> <aljY0uI6jY8y2b3Z@bfoster> <20260717085950.GA32056@lst.de> <alo4doLYG7BzuCfO@bfoster> <20260720075902.GA18645@lst.de> <20260724164218.GP2901224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724164218.GP2901224@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 24, 2026 at 09:42:18AM -0700, Darrick J. Wong wrote:
> It could emphasize that b_lockref is used to make rcu lookups safe
> against a freed buffer whereas b_sema is used to prevent racing threads
> from doing anything non-trivial with the buffer once they've gotten
> themselves a lockref, and that's why the comment is obsolete and can go
> away.
> 
> Or modify the comment?

I've picked up a slight variant of this, thanks.

> Is there a subtlety here that the buffer creator might not be the one to
> read the buffer contents in from disk if another thread happens to find
> the buffer in the cache, take b_sema, notice that it's not XBF_DONE, and
> start the read on its own?

Yes, but it doesn't really matter.

