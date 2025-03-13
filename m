Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC5B22F150;
	Thu, 13 Mar 2025 07:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741851031; cv=none; b=jUpBXLEUmaCgoi3VGIKj1xJAp7vR3WNB5fLiWiZEQ03FNW+bNfo79PCsOrqBSBeQfrDkb9AIl8/6BtJ6mQPWAlWhoreFSUfLWNbKIBkrSUqIuERyyUk5lnak0I1lcmHxYLq79L4kAvQcfK5ygWnj5za447CaBfR1wHO6H6RZEPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741851031; c=relaxed/simple;
	bh=Vrh7y8YtMMB2cMcBuMCxI3ckYR/tVoKg0IT4TqTFGRk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WkQqxhjWwGJ7Pz8MrK3/THknccNZsEx8SZ7AYWIW7y6FuxYgYepBYWn5fbprvohBU49QtJgjVYXeTCzRM+8XR+jRIR9U6EC/J9kz2GCSSi9ZdIKwimj+c42V+0wHrucwvLDVH/gXiTeeZA+8WkRgf0XrWVhsfq84Xtkmln2klGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6783568C4E; Thu, 13 Mar 2025 08:30:25 +0100 (CET)
Date: Thu, 13 Mar 2025 08:30:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/17] xfs: no quota support with internal rtdev
Message-ID: <20250313073025.GF11310@lst.de>
References: <20250312064541.664334-1-hch@lst.de> <20250312064541.664334-13-hch@lst.de> <20250312202511.GM2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312202511.GM2803749@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 12, 2025 at 01:25:11PM -0700, Darrick J. Wong wrote:
> >  # apply to any scratch fs that might be created.
> >  _require_xfs_rtquota_if_rtdev() {
> > -	test "$USE_EXTERNAL" = "yes" || return
> > +	if [ "$USE_EXTERNAL" != "yes" ]; then
> > +		xfs_info "$TEST_DIR" | grep -q 'realtime.*internal' &&
> > +			_notrun "Quota on internal rt device not supported"
> 
> Huh, I wonder if we should've allowed internal non-zoned rt devices.
> It might've made the whole "we want 2MB blocksize on pmem" mess a little
> less unpalatable.

The code should be able to easily support it, but we'd need a new
feature flag to look for the rtstart value.   We can probably just add
that feature the next time we add a somewhat relevant feature flag.

Hopefuly until then we'll support quotas on zoned so this check can
go away.  Of maybe we just need to find a better way to probe for
quota support in general as the checks in xfstests are a bit of a
mess.

