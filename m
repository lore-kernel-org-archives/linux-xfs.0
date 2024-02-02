Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F67148309
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 16:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706892251; cv=none; b=FIZ/w5Vl7UO/a/Hlupqhzz4uzSFJb6/w+PD02WsPsNdV5x0V437GjGXjNcti0R71LE868jG/70braBtxEgH34P/Pz8Ri/eHqFYbbrik6vbmmtxFmzq8UraeKe+iDfvih+/lF1/36ykECWHsdSbzgRGppBOIx6Wl3cuYx8pnloCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706892251; c=relaxed/simple;
	bh=uUzOoGiERZ7mGeuggiTyL0+KnvGqCFboKmKedY0kEZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZM8tYPzZo22Rn/42uQx1WIIAeliGnnjSH0c96trVhIryM6x8Tue8tKfbJN0GMemHGsrx1TJEyCdoboXA4kKdL+uLG+EmjQoThMf8XFlsbb/QkNjPpbw8TuizI4WPpv11wq7xiGofont5iJfyPtC0DJxnl6lb6RKYGaiDumwZoOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SgskXtVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SgskXtVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B021BC433C7;
	Fri,  2 Feb 2024 16:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706892250;
	bh=uUzOoGiERZ7mGeuggiTyL0+KnvGqCFboKmKedY0kEZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SgskXtVocZ1TkCDqWC85h/tTEjlCHj574jxR9WgKzX9+CTOtKCRwpFBecRj/pTNIq
	 YzZmvEAp6AhuRXckdV9nI8wgLC2YIOZ6VL/+ESTsrt7MQPmBR86YJrX7/vfyHKElSo
	 uuWrgOY8B9e7jU3B79ipvOJgN5mEmA0t+sJbqbFqF36DpSoQc6eS3mDn0SCw2Wni2i
	 z0KbybcLW+lQ1gipIzwXDKSdv9djRx0PfA9I4qfq6VopnO7w0cELEHaDUz5GMiW2k7
	 jnnBXVZC1833V5vLlGVxvyZ0PSHJNtJkEvy/yOn+TR31g4zPczi04hSAl6GbTLOQEL
	 UnBojjQWGKyog==
Date: Fri, 2 Feb 2024 08:44:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Sam James <sam@gentoo.org>
Cc: carlos@maiolino.me, linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to 3ec53d438
Message-ID: <20240202164410.GJ616564@frogsfrogsfrogs>
References: <l6nxtgxvlwmcejoylpuevoyzxxylkcl2vcsw4pwzilos6rph2k@o5ontnahuhz2>
 <87ttn3jawv.fsf@gentoo.org>
 <87jznncqo2.fsf@gentoo.org>
 <875xz7cqg9.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875xz7cqg9.fsf@gentoo.org>

On Fri, Feb 02, 2024 at 06:47:26AM +0000, Sam James wrote:
> 
> Sam James <sam@gentoo.org> writes:
> 
> > Sam James <sam@gentoo.org> writes:
> >
> >> I think
> >> https://lore.kernel.org/linux-xfs/20240122072351.3036242-1-sam@gentoo.org/
> >> is ready.
> >>
> >> See Christoph's comment wrt application order:
> >> https://lore.kernel.org/linux-xfs/Za4Yso9cEs+TzU8w@infradead.org/.
> >>
> >
> > Ping - I think it missed another push too. Please let me know if I
> > need to be doing something different.
> 
> (Oh wait, maybe the other one was a non-progs push.)

Huh?  The off64_t -> off_t conversion and the TIME_BITS=64 changes are
both xfsprogs.  Carlos hasn't merged either of those into for-next.  I'm
not sure if he's just going to release 6.6 as-is and move on to 6.7, or
what.

--D

> >
> >> thanks,
> >> sam
> 
> 
