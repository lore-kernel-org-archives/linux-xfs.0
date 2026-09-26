Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744832E762C
	for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2026 06:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790403432; cv=none; b=iYHOffaj7hThKNiDS5oJd2SHhuiiKXJ5f+Uqzaxhgaw5aWJBfwvhwfjVKFfKJtCLoSmFDEWrahe9GNOaF3FL7+/ketXaQtaypzYKdEL1yPMNX/ZFfi37p9MGq/9xWI6vYU6Dbs5zPn87ZiV1Ls+3T2sY6fSAQt7fGft3ZtGdT+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790403432; c=relaxed/simple;
	bh=9RuoqE8pnGeLtj6nZX2DmfeL9XwJ7BkWC3BqIyU4qjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lm+p290pZYrHvBAuX34RU3JvgZvHO6wFTlEwkpWNrQG3TDPD/24kLx3+gP1+dN+/7DIuE5VuiwC7uAt0kcKaLiB5MWLqaokIYhjH6veB9wAC5Ug1loxvf0r8EsTNdrJZY9OGybTjtxyVNRLWvBXV+iKWIPiz+H+fz8eHsP62WZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E524768C4E; Sat, 26 Sep 2026 08:17:07 +0200 (CEST)
Date: Sat, 26 Sep 2026 08:17:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/32] FIXUP
Message-ID: <20260926061707.GH20636@lst.de>
References: <20260924100512.2733748-1-hch@lst.de> <20260924100512.2733748-10-hch@lst.de> <20260925232944.GK2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925232944.GK2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 25, 2026 at 04:29:44PM -0700, Darrick J. Wong wrote:
> > +static inline void
> > +xfs_buf_set_uptodate(
> > +	struct xfs_buf 		*bp)
> > +{
> > +}
> 
> Should this set LIBXFS_B_UPTODATE?

Old xfsprogs didn't map B_DONE to it either.  But maybe we should do
a separate series to align buffer flags and semantics between the
kernel and userspace, including using uptodate instead of done in
the kernel.   The repair slob series had some advances in this direction,
but unfortunately is was never split our or followed up upon.

