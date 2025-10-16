Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7E61F131A
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 04:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760588477; cv=none; b=WjGQJwccabJH4QW98pzfALo59+I+jsbfEy71GsAjQbGQerLwAI8iAwjyLQzDgrL0HSyduriTAEfAlrwmxo2NyLeBSldcfda1tk94F2nemiEQR7KwJbyAZEfnQaw09jfdZGxWbwpomuQhzyd7DdGBQgVdlAJskvJbLwsQKycWulg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760588477; c=relaxed/simple;
	bh=uWEh2lfOsBQqkaQbakgZtdpAyM+MwFjJF0VeK5iV6WQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DQ5mlfc834LptrxMKhB0V8KLLKETmpFDS9rIfXs4CoklTzmk3czUB5AQ2XN/ys189B2hPAHz/V4hE2y4xlLsPkpIbsvJnjwLpe1lv6ZORhoDRkDNY+Rl44QJa4fcQhjqgtXR1lVV4zqYDYcoh6wjlpYKiuplGnbCdEWtIWnVZIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D42B8227A87; Thu, 16 Oct 2025 06:21:04 +0200 (CEST)
Date: Thu, 16 Oct 2025 06:21:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/17] xfs: return the dquot unlocked from xfs_qm_dqget
Message-ID: <20251016042104.GA29822@lst.de>
References: <20251013024851.4110053-1-hch@lst.de> <20251013024851.4110053-11-hch@lst.de> <20251015211714.GE2591640@frogsfrogsfrogs> <20251015211850.GG2591640@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015211850.GG2591640@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 15, 2025 at 02:18:50PM -0700, Darrick J. Wong wrote:
> > >  		error = xqcheck_commit_dquot(xqc, dqtype, dq);
> > >  		xfs_qm_dqrele(dq);
> > 
> > Hmm.  No mutex_unlock() ?
> > 
> > Oh, because @dq gets added to the scrub transaction and the
> > commit/cancel and unlocks it, right?
> > 
> > (Maybe the mutex_lock should go in xqcheck_commit_dquot to avoid the
> > unbalanced lock state before after the function call?)
> 
> Oh, you /do/ do that a few patches from now.

Yes.  And that later patch is the one sorting out the locking bug
you pointed out the day before as well.

