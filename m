Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2141AF0DC
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 05:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944136; cv=none; b=uOLlMp+Igo4ue27UQwvStM0QFUgtVbl/GDffM3yKq2Lv9gvYIStTf+CWIQhk+Z7/FZd54JMYe1c2mrv1XrJ365aGVrZ7XMWiemCT5aIGMkAWX7oWpr4he60gwHVeVErC/rSSIPNbXkTnKsfCr72G0JDFtQbhYS2Z+/dKDz3QkyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944136; c=relaxed/simple;
	bh=1/fH7cTJ7GEOQKibiEPa5735ZO+gaHKetvvGKShLjUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FSQGI3na0gOU/b6vWI+2/q0MJUoTJWy2QN37mNffoOenCkakqiXZBQw+S/kNJTOJj+Cb3u714EX55c0TOLZNwoV6O2QQYVIFOKHlbdf5ND9W36Lz56zDXETeLVIJLfDx6CzMd8Du83uBMUW+lv7QW2HBRNLvw2sR/V83kdTyAHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BB11067373; Wed, 19 Feb 2025 06:48:51 +0100 (CET)
Date: Wed, 19 Feb 2025 06:48:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs,xfs_repair: don't pass a daddr as the flags
 argument
Message-ID: <20250219054851.GA10520@lst.de>
References: <20250219040813.GL21808@frogsfrogsfrogs> <20250219053717.GD10173@lst.de> <20250219054515.GT3028674@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219054515.GT3028674@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 18, 2025 at 09:45:15PM -0800, Darrick J. Wong wrote:
> > The patch itself looks fine, although I don't really see the point in
> > the xfsprogs-only xfs_buf_set_daddr (including the current two callers).
> 
> Eh, yeah.  Want me to resend with those bits cut out?

As long as the helper is around there's probably no reason not to use
it.  Removing it would probably pair pretty well with passing a daddr
to xfs_get_buf_uncached.  Or maybe killing xfs_{get,read}_buf_uncached
entirely in favor of just using xfs_buf_oneshot more..

