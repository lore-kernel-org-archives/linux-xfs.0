Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F57481B3
	for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 05:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708405813; cv=none; b=nB9WGwa8/syapravqFOhrKQf6BJc5PlFUfbg+l3nmUvs7wnOaG9dKT+2pW2/+mriRrOm09ICP9mBotAcoii6yF9jEtBue98gE1XdSJAYnc2J36iN4ohsXR3X4RlaKNqlW++eSXH3GRIX39Hl8KJb4+a8RnlJmQecuoNVvi188Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708405813; c=relaxed/simple;
	bh=OaHwWGOq7mcL0maibXVbF+4duHZ6oXt8uKaFcAEARm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jWevfe6KHTLiUSA5SSQDbyJuESMJZmxSwwMtQPc11OdBoiEbWiaamlt5XY3VcHdrAUeIB3xp+pLSECt1zlSHZ2PwASKp1ludzMJzPaGYGzNTkpvlPG+JOEiOtQI6xt4QwzvS8MatmRpHxkmDhkd+h/v1zESvqKy59y5OIVpQoFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 80BD668AFE; Tue, 20 Feb 2024 06:10:05 +0100 (CET)
Date: Tue, 20 Feb 2024 06:10:04 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: move RT inode locking out of __xfs_bunmapi
Message-ID: <20240220051004.GA5988@lst.de>
References: <20240219063450.3032254-1-hch@lst.de> <20240219063450.3032254-3-hch@lst.de> <ZdPqj0gJhBekH+Kg@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdPqj0gJhBekH+Kg@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 20, 2024 at 10:55:59AM +1100, Dave Chinner wrote:
> I'd also like to see the rest of the rt-only code in __xfs_bunmapi()
> lifted out of the function into a helper. It's a big chunk of code
> inside the loop, and the code structure is:

Yes, this code has been bothering me forever, and I've started at least
three attempts at cleaning it up and for now given them up due to the
really compliated exit conditions.  I think it really should be done
eventually, but I don't plan to add it to this series.  It will probably
end up changing some of the existing loop logic as some of that is
pretty questionable and predates the nice iext iterators.
