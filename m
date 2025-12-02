Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28B94594A
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 07:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764660792; cv=none; b=DcXHjuQtMgdVTRGo/ypZcantDKRO06bOipfbgxkpYFhsid6i9Turz7vGDlWeBgRSS8KS960AuwhhH/8lLs5PrxTZXu4PMWiHYnAKASGYUlvoERzIakwErJ9Kue7CDgxcD53RYQuTHINGyYOSdylb43Wssna+GSp8KilemwcP+z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764660792; c=relaxed/simple;
	bh=dgonFfBzsIbsGuE/cLycdzLEuXRuTryko1BfTr7uA6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZFEhGqQDxTWWu4n0355QmhcYSwIPXC9RRrL+gVPKvqHWA8GirYfGbpLosVgCTAmCaFd5W9XDKrqsioiGDLCiTWHIiWUQqZns0j6xpBkTjNGsnnKeZt/aoUKHHSIpNvqR59DDoy77l45g/0oe1ouj8jnFkxqKM5kdxTwTLYQqcXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6C90368AA6; Tue,  2 Dec 2025 08:33:07 +0100 (CET)
Date: Tue, 2 Dec 2025 08:33:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] repair: add canonical names for the XR_INO_
 constants
Message-ID: <20251202073307.GE18046@lst.de>
References: <20251128063719.1495736-1-hch@lst.de> <20251128063719.1495736-3-hch@lst.de> <20251201224716.GC89472@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251201224716.GC89472@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 01, 2025 at 02:47:16PM -0800, Darrick J. Wong wrote:
> BUILD_BUG_ON(ARRAY_SIZED(xr_ino_type_name) != XR_INO_MAX);

Or static_assert for the standard userspace version?

> > +_("size of %s inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"),
> > +				xr_ino_type_name[type], lino,
> 
> i18n nit: In the old code, the inode description ("realtime bitmap")
> would be translated, now they aren't.  I don't know of a good way to
> maintain that though...
> 
> "el tamaño del realtime bitmap nodo 55 != 0"
> 
>                ^^^^^^^^^^^^^^^ whee, English in the middle of Spanish!
> 
> I guess you could write "_(xr_ino_type_name[type])" for that second
> argument.

Seems like the standard gettext thing to do is to mark the array
initializers as N_(), which we do in quite a few places.  Not sure
where the actual translation actually gets applied with that, though.

