Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B88307498
	for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 06:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750832524; cv=none; b=Y1H+zceZr2/h7IBQx+1kpJD8pIZfQnex+0qQdI7fpxfqTD+N22HWoMYo/JPYZLjQHPTe43P3hUPsvAQvcvAwQUxc73Ehx9q75fp9AJGZHc7ueINupaJ82f5Yzu+Fj8I8ENOK2dP6DycciONk6njTRLYE9cZRtuz8uFmTWG3BC7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750832524; c=relaxed/simple;
	bh=a9Ol6YJLfFGNuZQ9W+lG/D2nRSfq5HAYZkLft7U/EZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hi0O5UKfM9wLgxKOW75AoENSc5uO00PwjzIt9m8oh0gZqd1p4zAYi9h04NwjxHxR+UdlM78ylqLyw2CHN4O3/48FlqnBtEYh05NcTFR9j6SfJjQcf/RggWAyk8TPwweDrzX0RIZnK/0Kwar8qYXxVTiiTvDX6o9h5Wa1bV8n5ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1C1FF227A87; Wed, 25 Jun 2025 08:21:58 +0200 (CEST)
Date: Wed, 25 Jun 2025 08:21:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH 1/2] xfs: replace iclogs circular list with a list_head
Message-ID: <20250625062157.GA9641@lst.de>
References: <20250620070813.919516-1-cem@kernel.org> <20250620070813.919516-2-cem@kernel.org> <aFoKgNq6IuPJAJAv@dread.disaster.area> <39xujXwbUGTy3j2E9pH6kGvaRPmJbSuo2peOANlQ21_G69mQy2f2TQX2zhXE2fEvknjHBViVbuVkacBo3jLZ1w==@protonmail.internalid> <20250624135740.GA24420@lst.de> <b5q3uuhkn2jqcjgg6qcv6z444bftoec7dwxh4qoxbj64z2vnfv@gogvtu75o4qj>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5q3uuhkn2jqcjgg6qcv6z444bftoec7dwxh4qoxbj64z2vnfv@gogvtu75o4qj>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 24, 2025 at 08:17:05PM +0200, Carlos Maiolino wrote:
> > 	struct xlog {
> > 		...
> > 		struct xlog_in_core	*l_iclog;
> > 		struct xlog_in_core	*l_iclogs[XLOG_MAX_ICLOGS];
> > 	};
> 
> 	Thanks for the tip hch, but wouldn't this break the mount option? So far
> 	the user can specify how many iclogs will be in memory, by allocating
> 	a fixed array, we essentially lock it to 8 iclogs, no?
> 
> Cheers, and thanks again for the review.

Well, if you look at the helper I whiteboard coded below it only walks
the array until the number of specified.  As long as the maximum numbers
of iclogs is relatively slow and/or the default is close to the maximum
this seems optimal.  If we every support a very huge number or default
to something much lower than the default a separate allocation would
be better here, but that's a trivial change.

