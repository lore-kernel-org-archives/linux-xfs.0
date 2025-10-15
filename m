Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF2B7E110
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 04:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760503745; cv=none; b=Zc03gCqqPJbhR+U+CW+n52BWXs5xrSxQFTSo5zAnFd/t1S9nnXvDEOSq5dJxYhNO/Gsp8hNgHzdWwisnT+7Okbg3ZRJxqH08MuJ1L/9PbeNYBxPWSY00ZzFlKC6RvBuJ2b/4jD+mAZq6cEybyl/pQz0IGCBkR6LXbGUz/v23mzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760503745; c=relaxed/simple;
	bh=Ek9KbbBrJiAxYR+dTXRpKL5PddtcJrIurmFEz2b00cA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BX3ENhDFD6BW6COMmyGCEmQRJEsP1WPWVd1Qpj7z/pS2j/zbiw0tB2jiLmE+G7tB9tq/xCXscLH+iHF7XwUhVN5/TEGtp4NF4vtsE8IktjpKX6XjeR2QLd9KEuaU5WnduxjrWdSBGX8uRbDCiRgA+pOe4WPE5wLvzUAeM2ykNy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5B092227A87; Wed, 15 Oct 2025 06:48:59 +0200 (CEST)
Date: Wed, 15 Oct 2025 06:48:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/17] xfs: make qi_dquots a 64-bit value
Message-ID: <20251015044858.GA7700@lst.de>
References: <20251013024851.4110053-1-hch@lst.de> <20251013024851.4110053-2-hch@lst.de> <20251014231627.GQ6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014231627.GQ6188@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 14, 2025 at 04:16:27PM -0700, Darrick J. Wong wrote:
> > -	state->s_incoredqs = q->qi_dquots;
> > +	state->s_incoredqs = max_t(uint64_t, q->qi_dquots, UINT_MAX);
> 
> Isn't this min_t?  Surely we don't want to return 0xFFFFFFFF when
> there's only 3 dquots loaded in the system?

Yes, this should be a min.  Looks like nothing in our tests actually
cares about this value..
