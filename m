Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CD0204680;
	Thu, 13 Mar 2025 07:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741850713; cv=none; b=XPJV/Ia6PQCv0wzzLr8HOpMVTbHyYYttIkbVKdmUsuLSlH85pSnTcesa454BoIN+IwcmoyVklHLjmVWLUBzVplL5bXasJ0tL7pf05pOz1tfrsYoW9Ty+Cw1sCk53ic3snJw55LKZvG+gK55t2xQxVuj22R5HczIH6LMkwwwLKT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741850713; c=relaxed/simple;
	bh=awxpNavcr4TSo7gxUEu7ISrKn5OFsu9wX+dcqzQyT1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GfB6aTmnzpkdT8LqwHi8w53WHih4pbclYoxdlQuxmlI/serXXmeDzytVRk/Ee84lDykaRFnxRvJcrwgVuhwUiobVqgNyapolSkprMSZ2UZ9w9yzbkd8uhe+ZEZRzBP6X5Kq4+3o22CILCvg9Y0ROEbyqUkTJDawZXeyH5EWm5VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2681768D0A; Thu, 13 Mar 2025 08:25:07 +0100 (CET)
Date: Thu, 13 Mar 2025 08:25:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/17] common: support internal RT device in
 _require_realtime
Message-ID: <20250313072506.GC11310@lst.de>
References: <20250312064541.664334-1-hch@lst.de> <20250312064541.664334-7-hch@lst.de> <20250312201242.GF2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312201242.GF2803749@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 12, 2025 at 01:12:42PM -0700, Darrick J. Wong wrote:
> On Wed, Mar 12, 2025 at 07:44:58AM +0100, Christoph Hellwig wrote:
> > If SCRATCH_DEV is a zoned device it implies an internal zoned RT device
> > and should not be skipped in _require_realtime.
> 
> /methinks that should be a comment in the code itself.

Sure.

