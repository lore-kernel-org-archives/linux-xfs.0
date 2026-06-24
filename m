Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B623627587D;
	Wed, 24 Jun 2026 15:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782315766; cv=none; b=jJG8hHP3WF5NTECn3S3I09Eo6UQixzENBu4AtCkz2Lddf/ATte8gL3Ad9+EPa2lHPQUG+/HfoGEc9sslhCf0oFZ9MMxGThq36VwRqGRBzeeJPKXxuNC+TXOPrunbgzAKHWECxrdY82igjfhgbqb8W3JubBdyVpUbUoh8YiKTv7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782315766; c=relaxed/simple;
	bh=vIIG+NKSQ4WWFUVRsLxcAd6AOqNt52X9FbnfSyE6kuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ReYv04AZvl0Yef8II6FvkG6+jDjM0Bl5V3Mp9ICSf7ABTPgPnORigNZI+ZsxcOTjh8mxYqoymNHcmyflN5H7LHrJuWtw4RGSkc6+tCZhutbs6hPR0SlF6m8YbdLd4BvIpSszEsBL+z6TwAenOrvicDUhwl5sEHk+h+/bta10CSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 794CB68B05; Wed, 24 Jun 2026 17:42:41 +0200 (CEST)
Date: Wed, 24 Jun 2026 17:42:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
	Filip Blagojevic <filip.blagojevic@wdc.com>,
	Matthew Wilcox <willy@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: update BDI {io,ra}_pages values based on the RT device limits
Message-ID: <20260624154241.GB13186@lst.de>
References: <20260623142109.1838702-1-hch@lst.de> <ajuxIMzTbzxEuX5g@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajuxIMzTbzxEuX5g@nidhogg.toxiclabs.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 24, 2026 at 12:40:50PM +0200, Carlos Maiolino wrote:
> Giving the current tendency of filesystems being multi-device, this
> doesn't sound bad IMHO. Wouldn't accessing io_pages of each BDI also be
> worth even for a journal dev? I wonder if what you ran into wouldn't be
> possible if somebody would be using just a SSD for journal and a non-rt
> XFS on a HDD or a different/slower device.

Nothing looks at the value for the log device.

> 
> I don't know how stupid that sounds but perhaps it wouldn't be that
> complicated to support multiple BDIs without making it unpleasant for
> filesystems that don't care?
> sb->bdi could be turned into a dynamic array and a new sb->s_devcount
> fields to keep track of it on multi-device filesystems. Filesystems who
> don't care about multiple BDIs would have it pointing to a single BDI
> struct. Again I feel I'm missing something, so it might sound really
> stupid :)

This will get complicated really soon..

