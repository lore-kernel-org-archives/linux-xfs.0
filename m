Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CEB331209
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 04:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785213653; cv=none; b=NWzrHlI2rw8U9KATJ1n/xBq0vxtSxORCQw+g21vreWwrIOEz55/7p0LonO0gm2UwSGuLDrNrCHFRX/EZpksc/1x/Ro5HQuf+7ju4SRdOBAxIaE+yoNmj4DrQ3F7M+uKkxemGW7zSwoXKfeSwS8Il4qk4h7uZ+Pv4FcfeW9TO4uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785213653; c=relaxed/simple;
	bh=MO1FXce0kxpNg2kpxyS/Qtxq14xu5vVXyWzu8t4+otY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Em8HGDbPjtZ+AYI6UqTROXTNpnuxsTYzQ9trhGXgvKKBRAnP7snVYup1Pw27Q2jB9XOXFkYDJFzMaxtd39deytxcFMJsjb2su42BVRkKxMsN+0kWkx+0PIrT77Vd2oFkkeL55wwytWHprvK9LOzZqDWuvtlaxodBjzD3uJPpc88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 389F868B05; Tue, 28 Jul 2026 06:40:50 +0200 (CEST)
Date: Tue, 28 Jul 2026 06:40:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: use WRITE_ONCE to update b_flags
Message-ID: <20260728044050.GD20064@lst.de>
References: <20260715145147.95654-1-hch@lst.de> <20260715145147.95654-8-hch@lst.de> <20260724165335.GU2901224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724165335.GU2901224@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 24, 2026 at 09:53:35AM -0700, Darrick J. Wong wrote:
> > @@ -436,7 +451,7 @@ xfs_buf_find_lock(
> >  			return -ENOENT;
> >  		}
> >  		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
> > -		bp->b_flags &= _XBF_KMEM;
> > +		xfs_buf_clear_flags(bp, ~_XBF_KMEM);
> 
> Looks ok to me, though it took me a while to figure out that this line
> correctly preserves clearing every bit *except* _XBF_KMEM.

Yeah.  And I'm still struggling why we even clear all the state here
in the lookup path and not when marking the buffer stale.  I've given
up for now, but eventually I'd love to understand it.

