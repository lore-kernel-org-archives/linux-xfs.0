Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792EEEEA9
	for <linux-xfs@vger.kernel.org>; Thu,  6 Mar 2025 01:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741225226; cv=none; b=JNb8yRk1hAG6W5ZQheK6xeMHYOkXtCGta44yucLGeKkyaUMTjQvVrnJ+V+FXBb6CoJc17iDsD095GzVmNB0N5nUOP8wWzZxdAsh2Xlvh3c+YmfB3om65eDEOJM2XXZtfsnDMy0eYqJQU6zCcmg0FgORWJJXdADDQq6FPEQ9cY0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741225226; c=relaxed/simple;
	bh=CpA3WfdzrQLuDVguthRfV73xKwDNonWvCTiuXGZipWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kzg4RhFuBExp/LNO1SS0y1d8TY+ZX45BMX6cqmIv8WTGIYu6E3YnAK5EgX0QSh9CklrcjLQ946WrfsFokS5vCYFyhP11AtskbrqCC8my1dE6h0PnwulPlSRB8be4GL+A2kaZNLwcX5QEo0FH9J4L+woFEFTvsrPOLc9iLZLmy4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C342268BEB; Thu,  6 Mar 2025 02:40:19 +0100 (CET)
Date: Thu, 6 Mar 2025 02:40:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: use vmalloc instead of vm_map_area for
 buffer backing memory
Message-ID: <20250306014019.GA3494@lst.de>
References: <20250305140532.158563-1-hch@lst.de> <20250305140532.158563-11-hch@lst.de> <Z8jACLtp5X98ShBR@dread.disaster.area> <20250305233536.GC613@lst.de> <Z8jy-VIjs47EDiow@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8jy-VIjs47EDiow@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 06, 2025 at 11:57:29AM +1100, Dave Chinner wrote:
> Can you add a comment that the code is done this way because
> of the mismatch between block layer API and mm object (folio/slab)
> handling APIs? Otherwise this code is going to look wrong every time
> I look at in future....

Sure.  Although I hope we'll have the bio_add_virt helper by the
following merge window.

