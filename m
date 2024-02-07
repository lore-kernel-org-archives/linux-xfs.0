Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28C077F20
	for <linux-xfs@vger.kernel.org>; Wed,  7 Feb 2024 13:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707314205; cv=none; b=rkKlF0Gm3beIPnbq5ifKmKVgpIFiQ+Z1cFtn5QrjI7Rq6FN/gf3nZht0KWo78glHs0+gvZbI5pEw8gtHxREQABKr1t5OqT1QyY2x6TDJUWSpNLURpZf8iB0AswxUf6L1U7kuHyxqnC2vr/NIfPorjL5sVC9jbFWcRfRFb2Hvfwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707314205; c=relaxed/simple;
	bh=23IXXvuy7aPAJM/9p6g9qSdFTCOaeEt0Yxgh3U5ABrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r9ms6iwhep+ZBTLyIhcZymfY3vHrt65co/dmQTZogiEwcKxuMEUke7VnhZIm2u+6tW43kLOrJNXcVdLv3CLh7xcidaf0OoFI0y/dRiCjKLO61YA1Ut/EDXzWw6Erofi4laoqPXjSeTv5nw6ZuySm3hWYY4Ps1b5z6U2GPBuMIAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WhhB4zYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WhhB4zYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BD8C433C7;
	Wed,  7 Feb 2024 13:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707314204;
	bh=23IXXvuy7aPAJM/9p6g9qSdFTCOaeEt0Yxgh3U5ABrk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WhhB4zYuwYVe8HalP7RBNxdI+MwBcz4OTpyJNTrikUcPNPZ8Sk8F4TG0+WNJJxUie
	 2sebHWCYtn88Rah9pZe1ZWEx3kEpzuSUBJjXaH7wZlTK2/hK+zED0r6Q9ljAK1MIlJ
	 dbWtUmXMbWFWUMb8r4rAB1adkvd5B7kGGPgFWKddAufhG3miC0s6Cl4Jho6Me2QIIi
	 FPvukTavzbAaSCyZ5wf2268zVjtjkhIPs7041bFFN+m5Yc6dydBk/9fJ3BxQ5goU1e
	 KsWgCRCDqkK4ceLs3scT6HAoO2lqPzAlMu5iepDZY2XZdj9CJtuusagjkRNUPtx7xp
	 jKpV1gmeMrguA==
Date: Wed, 7 Feb 2024 14:56:39 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Sam James <sam@gentoo.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, carlos@maiolino.me, 
	linux-xfs@vger.kernel.org
Subject: Re: Re: [ANNOUNCE] xfsprogs: for-next updated to 3ec53d438
Message-ID: <k7znflgh73mksfyetmza4rziakunbppktct346fzakfm5jfmmr@crjkzd3ex4ln>
References: <l6nxtgxvlwmcejoylpuevoyzxxylkcl2vcsw4pwzilos6rph2k@o5ontnahuhz2>
 <87ttn3jawv.fsf@gentoo.org>
 <87jznncqo2.fsf@gentoo.org>
 <875xz7cqg9.fsf@gentoo.org>
 <20240202164410.GJ616564@frogsfrogsfrogs>
 <AZzmmM-zLo5si9ODh-F7rrtfeQwS4NuDGa5OvWJABT7_liOD6rM3z39FnZ7l89Jk-i9HQt2dDH9Okwr3qzPNEg==@protonmail.internalid>
 <87wmri8pg8.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wmri8pg8.fsf@gentoo.org>

On Mon, Feb 05, 2024 at 11:24:11PM +0000, Sam James wrote:
> 
> "Darrick J. Wong" <djwong@kernel.org> writes:
> 
> > On Fri, Feb 02, 2024 at 06:47:26AM +0000, Sam James wrote:
> >>
> >> Sam James <sam@gentoo.org> writes:
> >>
> >> > Sam James <sam@gentoo.org> writes:
> >> >
> >> >> I think
> >> >> https://lore.kernel.org/linux-xfs/20240122072351.3036242-1-sam@gentoo.org/
> >> >> is ready.
> >> >>
> >> >> See Christoph's comment wrt application order:
> >> >> https://lore.kernel.org/linux-xfs/Za4Yso9cEs+TzU8w@infradead.org/.
> >> >>
> >> >
> >> > Ping - I think it missed another push too. Please let me know if I
> >> > need to be doing something different.
> >>
> >> (Oh wait, maybe the other one was a non-progs push.)
> >
> > Huh?  The off64_t -> off_t conversion and the TIME_BITS=64 changes are
> > both xfsprogs.  Carlos hasn't merged either of those into for-next.  I'm
> > not sure if he's just going to release 6.6 as-is and move on to 6.7, or
> > what.
> 
> Yeah, sorry -- I'd misread the email and realised too late.

Hi.

Please rebase and re-send them. You can also send a PR if you prefer, I'll queue
them up for the next release.

Carlos

> 
> >
> > --D
> >
> >> >
> >> >> thanks,
> >> >> sam
> >>
> >>
> 
