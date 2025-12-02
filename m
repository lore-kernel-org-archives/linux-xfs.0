Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B592C21E5
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 17:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764698360; cv=none; b=KlzjgGItWsUen8iHJCP8KV/rughOtXxLB0M3KNnQGWLCTtBitJUlPu6BTricpsf47nYsQy1igBskHJISERsMQVqscLaYoBDtwBVyLprAoPLARjHwCOy/n4Q08ehlaWo02zvVVupGqTjHfxE4PfEeESuaApYgMBbqOHvJUmSiFI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764698360; c=relaxed/simple;
	bh=oOADcZ1NdOpDYiCHyTzpUyoO1EULUTHr5ctgQDTNxc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s9rXwZYPsYMAOeXBYQ9cLUhBy3nTLUA5tNLyRt2Rvg95KXUTMOu/oUdmFkxUNgMeE2IdG8ZF+WD5YfSYiMePMPCbpkgI3bI2qeKRWas+cuvEDWMjsQ5OF8Yo2eysyP2J8e7ztkzs79QPLG9Id+H1HVpDYnDc6Gs7/cgHCWbKkEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VlGpfi18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VlGpfi18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA4FC4CEF1;
	Tue,  2 Dec 2025 17:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764698359;
	bh=oOADcZ1NdOpDYiCHyTzpUyoO1EULUTHr5ctgQDTNxc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VlGpfi18XQkRI3uLZ/UJWIIjl+dEoS0lU3npRRni40g6SPXarG6pR1XkyABZqzJLT
	 2WUlI93ZA3+jlYzp+OttYeuQKi0LgrW2flyhZ3sglbE12ikD1vpY15DilPhKfTt10n
	 cTVcS/ROg+7dxYvVxQq2G+3NtT/LbYJAmZbAIIoHIgeMec79qKwwYfHC7U0kLMY44p
	 jr1HgT77r6ag/c1jFSjx4auM+takjGJfhqWeoMw8L3pRnd7cXQjBi47VA2OoxLE/LC
	 cq7D0SN47OG1DfIS7Tb9aFLkVeBt0BSHSc3fRSFvpvR4znubBrkX1NSVXLGenbLGpm
	 1o6zf9Crx6+eQ==
Date: Tue, 2 Dec 2025 09:59:19 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] repair: add canonical names for the XR_INO_ constants
Message-ID: <20251202175919.GH89472@frogsfrogsfrogs>
References: <20251128063719.1495736-1-hch@lst.de>
 <20251128063719.1495736-3-hch@lst.de>
 <20251201224716.GC89472@frogsfrogsfrogs>
 <20251202073307.GE18046@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251202073307.GE18046@lst.de>

On Tue, Dec 02, 2025 at 08:33:07AM +0100, Christoph Hellwig wrote:
> On Mon, Dec 01, 2025 at 02:47:16PM -0800, Darrick J. Wong wrote:
> > BUILD_BUG_ON(ARRAY_SIZED(xr_ino_type_name) != XR_INO_MAX);
> 
> Or static_assert for the standard userspace version?
> 
> > > +_("size of %s inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"),
> > > +				xr_ino_type_name[type], lino,
> > 
> > i18n nit: In the old code, the inode description ("realtime bitmap")
> > would be translated, now they aren't.  I don't know of a good way to
> > maintain that though...
> > 
> > "el tamaño del realtime bitmap nodo 55 != 0"
> > 
> >                ^^^^^^^^^^^^^^^ whee, English in the middle of Spanish!
> > 
> > I guess you could write "_(xr_ino_type_name[type])" for that second
> > argument.
> 
> Seems like the standard gettext thing to do is to mark the array
> initializers as N_(), which we do in quite a few places.  Not sure
> where the actual translation actually gets applied with that, though.

That N_() thing is #defined out of existence for compilation in
platform_defs.h:

# define N_(x)			 x

and include/buildrules passes "--keyword=N_" to xgettext so that it'll
find all the N_("string") strings and put them in the message catalog.
I think you still have to use regular _() (aka gettext()) when you pass
them to printf.

IOWs, you'd still have to define the strings array like this:

static const char *xr_ino_type_name[] = {
	[XR_INO_UNKNOWN]	= N_("unknown"),
...
};

to capture "unknown" in the .po file, but I think the printf argument
still has to call gettext() to look up the localized version.

--D
