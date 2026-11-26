Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795703264;
	b=tPgZQM730+FrXvBI/o1bXA0FhUrJj2JxjU+CaTAl/bPDddvPGPeAdfPPsgLAgoja6UjC
	 bjPA6GkUPrPqfkDTFkBs79SVeP2NQBC3+n8Vh4y9boEvWN8Koykx3rdKCNbkgSREK2TeK
	 xAxlpKOpjzsVBT6/jdsSCqHrHB3wvkx3A6KX/czS9YYqr5hOqJDnbTwbFNhW2+0FCdJhl
	 vp8cwW10bStzMIZaWB7dEHugSWWlPdS/pnHGKwo4vvn+/m/WBGO2OsUsaL85+e9pveyFa
	 dhyXqcS6kzykeTPnpmLiC01NwzrCtTqR0JK282k7qeVbRxn1VS+5tCwv6N/OemEqflA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795703264;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Ze1D/jyTMA+y2wLjuYJKArwHAUX574ow3qL7u5BdtxQ=;
	b=BlG1nb8zb6x1ASUqRVwWZB7ks3rITBxZzRCcGbl+0CpLT+sHcoLtyd1euQZHlOdekFfj
	 C4noQl7elYv9GjXKQy2KOEOam5YOrosHumD2nFMX1IUcjetPN2FNSwJGR8x9WTAnfWmIH
	 gKN9Fv64gdRn/UwYnY/76n1A+3Xog8iyF9F0lgKX6DNHHMV5wEvGvjGaQ/F+LlBuaUx5Z
	 147Ftt5tLJ8gAQ7xn/YWC+qCxIl9sbM4kcUAgQCeVdqmDtd8EboivEiKMU3k0iTvG97Pl
	 MZcNRo3yk+JhKGyqTNkPQJQEA4hFjc0GrfL2d8EV0452EDvnxr07w3C0XBaCo0Z4+og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h6Znx40u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4AB606A31E;
	Thu, 26 Nov 2026 14:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h6Znx40u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61E71F000C0;
	Thu, 26 Nov 2026 14:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795703264;
	bh=Ze1D/jyTMA+y2wLjuYJKArwHAUX574ow3qL7u5BdtxQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h6Znx40uqe0rY7RkGHXLUhoI86GKaIYKuthgYlMG7qtK9i7IsBl07MhVP4WbsmkIw
	 SUisP0dLe0O/nPgdh0DalbwdUNyBOWlq8gkSOPv6Jr+BasKtw5CYfO0HL0o8ikI+c+
	 zmwYSdQ4HG9gRj8jrrDaK9ofT1/0IXQX7E9bhe8qBAD2RkTHfJ9XVO1jzx1tyG6tnr
	 2stnbfulGYzkncTNen9W4hnYrGPcutKpH1dHFSgAitOaFWzqqb4q0MOhL0HUNHMpDM
	 IefDZmRTtR+KAey23ROUeDF1GoAXZu9MBkQ4uGquxPOxLTMNJarmQ4qSgJGcF2ttX9
	 zivxxD5M7FV+Q==
Date: Thu, 26 Nov 2026 22:27:34 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@infradead.org>, 
	Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: what should we do about xfs/136?
Message-ID: <awhALVy4OUef4ZNC@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <awaK2LnBPb8f36Ig@infradead.org>
 <awae4V7kaESFV-NW@cronus.toxiclabs.cc>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awae4V7kaESFV-NW@cronus.toxiclabs.cc>

On Wed, Nov 25, 2026 at 09:40:33AM +0100, Carlos Maiolino wrote:
> On Tue, Nov 24, 2026 at 11:14:32PM -0800, Christoph Hellwig wrote:
> > Hi all,
> > 
> > I stumbled upong xfs/136 because it is the only test in the attr2 group.
> > It also isn't in any other group, and takes more than 25 minutes and to
> > run in my usual test setup, and then the output doesn't match the
> > expected one at all and it fails.
> > 
> > It goes back to:
> > 
> > commit 7dcf3ce6f95603965b51c53d0a48864b0c6e8268
> > Author: Tim Shimmin <tes@sgi.com>
> > Date:   Tue Oct 17 06:10:19 2006 +0000
> > 
> > and apparently wasn't run much at all for a long time.
> > 
> > Should we just kill it?

Hi Christoph,

I'm fine with that. This's a xfs specific test case. If both you and Carlos
agree and there are no objections on the XFS list, I can go ahead and remove
it directly for you, or feel free to send a patch for review if you prefer.

Thanks,
Zorro

> >
> 
> Sounds good to me
>
