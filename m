Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D591FA178
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 06:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764742188; cv=none; b=HmdW6JfPsDlnJBzPyiDVChizFsGYDU6e/Zehcoo8rqE6sq3412hVpgukM3kLpgyR4sIWEDrFIxhpJ2TflYXH0Yb0b/ITQYfgCe+TavxXHzW9UsVsd6rHsk3JnIHDbFo2te6IlYnnacCNfiv2pIf6Y5pYuUpBxQtpijrNiWUP9cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764742188; c=relaxed/simple;
	bh=KOvBHvyWEqd0LjtmNoSh/8jDVJpEZ2A1j1tftYxOOQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WdllWruyoLRhk9lbfIzequd5VJtf0tcqg0ppZ4solosEGeiIXcyt2yiQ5/8/1kYCHgUU/aUd/F6ckgjzR0uH8pSCgMSGnVIDV6xVKGQItxTY5tixPUe65uIjDYK4vxR7OB4x0DI7usNVJViaV0RSOuzRD09QZekjcU6w11AsbmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BFE7768B05; Wed,  3 Dec 2025 07:09:42 +0100 (CET)
Date: Wed, 3 Dec 2025 07:09:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] repair: add canonical names for the XR_INO_
 constants
Message-ID: <20251203060942.GA16509@lst.de>
References: <20251128063719.1495736-1-hch@lst.de> <20251128063719.1495736-3-hch@lst.de> <20251201224716.GC89472@frogsfrogsfrogs> <20251202073307.GE18046@lst.de> <20251202175919.GH89472@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202175919.GH89472@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Dec 02, 2025 at 09:59:19AM -0800, Darrick J. Wong wrote:
> > Seems like the standard gettext thing to do is to mark the array
> > initializers as N_(), which we do in quite a few places.  Not sure
> > where the actual translation actually gets applied with that, though.
> 
> That N_() thing is #defined out of existence for compilation in
> platform_defs.h:
> 
> # define N_(x)			 x
> 
> and include/buildrules passes "--keyword=N_" to xgettext so that it'll
> find all the N_("string") strings and put them in the message catalog.
> I think you still have to use regular _() (aka gettext()) when you pass
> them to printf.
> 
> IOWs, you'd still have to define the strings array like this:
> 
> static const char *xr_ino_type_name[] = {
> 	[XR_INO_UNKNOWN]	= N_("unknown"),
> ...
> };

Yes, that was the intent.

> to capture "unknown" in the .po file, but I think the printf argument
> still has to call gettext() to look up the localized version.

And that's what I'd expect.  But there are no direct gettext calls
anywhere in xfsprogs, despite quite a bit of N_() usage.  What am I
missing?

