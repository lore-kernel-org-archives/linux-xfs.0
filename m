Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAC73783B5
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 08:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779956937; cv=none; b=RavT6sUO0qczC7LY8JmOwkWhnYQM99FYXkW09JdeVoNphXuirs8OfyXMVrfy6rX+d9NTBT/nLg2xykkcfnG16lAGvHjQ9q0cyaLblDH71mSX0cnzKmauOHjv5vb4zNAeVqMNk0SbGONMMZRzkeMo/T2u3Uy8hluDo5ATVu4li/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779956937; c=relaxed/simple;
	bh=m4UarANRdfqm2esO9mc87gQZSRjP7VnbHQhVwlq+pxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ezturCwSjrSwS1T5DW/ER7x8zUgAcwkwrdkEjEGQWY/8DXA9cWffOP2/AUlf0E9233hbTK/He47XGl984lX7S/NchJ2eBbfc1OAXBbNOOmGCAvqjhpWF0q8jgRJ5ODBITKGpcUtt17tmNEp4aX6lbF2IL2CXa50qiEDDxk5wv2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3E57168B05; Thu, 28 May 2026 10:28:52 +0200 (CEST)
Date: Thu, 28 May 2026 10:28:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: add a xfs_rmap_inode_owner helper
Message-ID: <20260528082852.GA6893@lst.de>
References: <20260515135103.4042407-1-hch@lst.de> <20260515135103.4042407-6-hch@lst.de> <agrzt5K9OVTPObMs@nidhogg.toxiclabs.cc> <20260518131639.GA7774@lst.de> <20260528052346.GJ6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528052346.GJ6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 27, 2026 at 10:23:46PM -0700, Darrick J. Wong wrote:
> > My direct aim was to reduce uses of i_ino so I looked for common
> > patterns.  I also generally prefer APIs that pass typesave objects
> > over those passing integers as handles wherever possible.
> 
> I'm curious, then, why are most of these new helpers macros instead of
> type-checkable static inline functions?

For these rmap ones because of our header mess - xfs_rmap.h is included
without or before xfs_inode.h, so without giant reshuffling using inlines
here will fail the compile.

For the xfs_format.h ones mostly to follow the surrounding style,
although if I tried I'd probably run into the same header ordering mess.

