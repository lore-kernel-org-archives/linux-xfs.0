Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A389313959C
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 15:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713367939; cv=none; b=BBcBs3u1v4qXkjcpZBNNMuv1AV1aymhH+a+11Sr5gvOrtpBVTZOeKJfxWGvoMIpl0fEEfTyiXfI6Ju8y1PBdBBEQL2q04IZmQDdJTX3xL1OiitmqAunu7EVRrQD3GGgkGziXOlTb9EmMxE/97eURD60XUux4dUFDg0k6ZN/mrG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713367939; c=relaxed/simple;
	bh=ed1ld1gZwErZ+ISfQ1ADx6nS42JH2hkRBkHQnwQ2Nw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m7JGZYEJUONRmWTlemopxP3eNAzYECxjHBBKvh3qGdL/8FG21QqlP7ho+cs6XDio+ccSg74HFRsiTExQoOwVtCoERewdoKgbVF2O2QonsH2NCy4kMv4BqOIdggTRP+VUK/PkXrzvIpTV1tLCsoRNv8Ysg6AuUBlt/WLYQYntHTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J+61xxj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J+61xxj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E24C072AA;
	Wed, 17 Apr 2024 15:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713367939;
	bh=ed1ld1gZwErZ+ISfQ1ADx6nS42JH2hkRBkHQnwQ2Nw0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J+61xxj33Kk0YuRdwGXpGwyoXIQUOi3+n05HuV1dNyA0kF3jrlF0gc1ekTriqraEu
	 ngLGMlk68XRKE6mhsLkBzN/+VYLqWCTDbU6Yfq/x2/faAkh/k0Mew1FY4/fY2xK/OD
	 Jy81JtIW84WlDvvBKWPsSqRvOyg/wdSai8MbHNvIr84dJgcA8r1d60iS6Z7o25dA1/
	 Bffl6od1lAzRvJFBWp3XsKwB/8bD4m4iKKx2Jo7liyh6ShcpfGkJVxsy/tLbejIVU8
	 Xw2CHMiQJyN3R70R2ji1uJJuUWqGo0dS5vHqaAD6V+EO/ozuVezvUCpCSNgNF7GS23
	 X/RXVbiNNVYyw==
Date: Wed, 17 Apr 2024 17:32:15 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs v6.7.0 released
Message-ID: <pvsrakeforclh6cg576qn4u3ifgtzl6iwebzyjvxtvxqh2ph55@muhndh3a536k>
References: <fcm36zohx5vbvsd2houwjsmln4kc4grkazbgn6qlsjjglyozep@knvfxshr2bmy>
 <mMHk0yaj9LgGgzujpBfn8GpG3uZmXbQHUrGp5m_ZJWUAwpcEcZWzMa0KUUcZ8_oQ5T6lDTu0CcOl-hYmW7z-MA==@protonmail.internalid>
 <20240417151834.GR11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417151834.GR11948@frogsfrogsfrogs>

On Wed, Apr 17, 2024 at 08:18:34AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 17, 2024 at 10:13:52AM +0200, Carlos Maiolino wrote:
> > Hi folks,
> >
> > The xfsprogs repository at:
> >
> > 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> >
> > has just been updated.
> >
> > Patches often get missed, so if your outstanding patches are properly reviewed
> > on the list and not included in this update, please let me know.
> 
> Ah well, I was hoping to get
> https://lore.kernel.org/linux-xfs/171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs/
> and
> https://lore.kernel.org/linux-xfs/20240326192448.GI6414@frogsfrogsfrogs/
> in for 6.7.

To be honest, one of the reasons I decided to release 6.7 today, was because these patches were
cooking for too long on the list, and I wanted to pull them this week, but not delay 6.7 because of
them as I want to also not delay 6.8 for too long, mostly libxfs-sync and what we already have on
the list. The debian one I totally missed it btw

Also, I was assuming you were going to send PRs for these series according to our previous talks,
will you still submit PRs or shall I pull them from the list?

I'll try to pull those patches you meant asap.

I could do a 6.7.1 release with the debian patch if this is really required, but I don't think it
will change anything if I simply postpone it for 6.8.


> 
> --D
> 
> >
> > The for-next branch has also been updated to match the state of master.
> >
> > The new head of the master branch is commit:
> >
> > 09ba6420a1ee2ca4bfc763e498b4ee6be415b131
> >
> > --
> > Carlos
> >
> 
