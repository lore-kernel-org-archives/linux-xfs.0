Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E4D2F30
	for <linux-xfs@vger.kernel.org>; Sun, 15 Dec 2024 06:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734243548; cv=none; b=BglTs8OnLH701aJ4hOL3uHTze2EOsxZge9EiFqTC14mk+X3FUMwLT7FFquaawBaobCfkGclVPVyFEUzZ9z23rbmp8fXyCB0RcmdaS2y3ciWZqsToKF2qQFNfV9k5Ptc5FGHHx2YvgvWt6Ca8ziuS0anMQ5rDkTQfjKi94Zxop1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734243548; c=relaxed/simple;
	bh=KNL0PNucUURDUvL405KaptkL3QM852FQyCXv+7npDtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G+FrGpSxSdEGvQ7KXH++p32tKBxKUs8BYdKVFiKhOC91vsE307cbEl2Tw+0dkintAJrwnzg0HDQXwiDNk4T/kifDlxqGZy+OUI9hb6x79GSwnCukw7viy59/D/xiJpKUM9szNdrQWKENwOGJ7HwWNQC7fu9gTVXv873eUTY+kdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7DAE568C7B; Sun, 15 Dec 2024 07:19:02 +0100 (CET)
Date: Sun, 15 Dec 2024 07:19:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 41/43] xfs: support write life time based data placement
Message-ID: <20241215061902.GE10855@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-42-hch@lst.de> <20241213230051.GB6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241213230051.GB6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 13, 2024 at 03:00:51PM -0800, Darrick J. Wong wrote:
> >  		if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_FREE))
> >  			oz = xfs_steal_open_zone_for_gc(zi);
> >  		else
> > -			oz = xfs_open_zone(mp, true);
> > +			oz = xfs_open_zone(mp, WRITE_LIFE_NOT_SET, true);
> 
> I wonder, is it possible to remember (at least incore) what write hint
> was associated with an open zone all the way to gc time so that zones
> with compatible hints can be gc'd into a new zone with the same hint?
> Or is that overkill?

We've been thinking about that a lot.  Right now we don't have an
immediate use case for it, but it sure would be nice to have it without
needing another incompat bit.   But then we'd need to find some space
(3 bits to be exact) in the on-disk inode for it that doesn't make
otherwise useful space unavaіlable for more widely useful things.
If you have a good idea I'll look into implementing it.

