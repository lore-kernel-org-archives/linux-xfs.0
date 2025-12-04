Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FE52F1FDC
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 17:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764868692; cv=none; b=oUlAkwV7eotCkyGd62l5Yq3kSp4MJ7OfXyTKpoIL7/heFoUxjjMM+hWNZLKDYqfhAKasmt27HAbuTmhcBLlknIPKOH0qMZs5UPnVfqI3OvoWVhRIs/O3LHjG+tLnNLSpUtJHJr/r3QCxIU34l4XXZvJ6vsrKO0yzWuC7U7ZRDXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764868692; c=relaxed/simple;
	bh=n5KN+b7jZJZRbJ9zDu07tL3s77uDEcq5o7cfuri58zo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gcnfVMWWB1lgDmXxwinYlbkbd6DvIgYIgZMS5MyNLikDvU83IZcxTxDfR9v0biuo59HdrqyAFIrbHEd5o+fnKss6rxN/ddTeVXnZbB9teyMYcyctD7kvkrdfrZiH2I8AcVGOhU9ayCg2e2COmeSoUWL6D6nB+ln5UdgupL+X0rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jguwzmsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jguwzmsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A90DC4CEFB;
	Thu,  4 Dec 2025 17:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764868692;
	bh=n5KN+b7jZJZRbJ9zDu07tL3s77uDEcq5o7cfuri58zo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jguwzmsPyWsvemEG00E1WNFo252YfQV+UtT5B4mU87ho+vS5oCgPbdZQQcrWahqA8
	 4nGNgFoIyxALBX2ii9hlbHHbrNiuhuE1FY8XIJI5lvw/0QsP5KXwY1n9pdaF2qVKNT
	 z6ozjPQcT697DVuxszjVEokxb0l6cycW0N+m14Ryi8bmm6igj66P78HLCp8dzTGaXh
	 UORQRAgW7cFzVtjwL2uPvTk1Cuam583jKmbOCdlsblHrgZ+wXOfzU2JLoQskriLSt7
	 8ySe5NiCHZPPw9nGCSq37HA4BHV5UObKc3Ij7UGuIIdraaSdiqhK3SsGiL0PR0KiAO
	 tzcSzqbJrLk0Q==
Date: Thu, 4 Dec 2025 09:18:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] repair: add canonical names for the XR_INO_ constants
Message-ID: <20251204171811.GE89492@frogsfrogsfrogs>
References: <20251128063719.1495736-1-hch@lst.de>
 <20251128063719.1495736-3-hch@lst.de>
 <20251201224716.GC89472@frogsfrogsfrogs>
 <20251202073307.GE18046@lst.de>
 <20251202175919.GH89472@frogsfrogsfrogs>
 <20251203060942.GA16509@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203060942.GA16509@lst.de>

On Wed, Dec 03, 2025 at 07:09:42AM +0100, Christoph Hellwig wrote:
> On Tue, Dec 02, 2025 at 09:59:19AM -0800, Darrick J. Wong wrote:
> > > Seems like the standard gettext thing to do is to mark the array
> > > initializers as N_(), which we do in quite a few places.  Not sure
> > > where the actual translation actually gets applied with that, though.
> > 
> > That N_() thing is #defined out of existence for compilation in
> > platform_defs.h:
> > 
> > # define N_(x)			 x
> > 
> > and include/buildrules passes "--keyword=N_" to xgettext so that it'll
> > find all the N_("string") strings and put them in the message catalog.
> > I think you still have to use regular _() (aka gettext()) when you pass
> > them to printf.
> > 
> > IOWs, you'd still have to define the strings array like this:
> > 
> > static const char *xr_ino_type_name[] = {
> > 	[XR_INO_UNKNOWN]	= N_("unknown"),
> > ...
> > };
> 
> Yes, that was the intent.
> 
> > to capture "unknown" in the .po file, but I think the printf argument
> > still has to call gettext() to look up the localized version.
> 
> And that's what I'd expect.  But there are no direct gettext calls
> anywhere in xfsprogs, despite quite a bit of N_() usage.  What am I
> missing?

#define _(x)		gettext(x)

in platform_defs.h.

(and no, I don't get anything meaningful out of "N_()" for magic
tagging and "_()" to mean lookup, but according to Debian codesearch
it's a common practice in things like binutils and git and vim)

--D
