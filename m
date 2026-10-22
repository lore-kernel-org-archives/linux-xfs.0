Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792666893;
	b=IvhAV8zW6miIJwngwPnMOIjRTeVnzRMHaP4IVw5oPsuuqcnfjz/Ifhv3Oox4hzUOxFJb
	 QADGVUKn2fWX9VSZtcGmhek+2usEFOOxOkCsBSt21elgBSv4G/WOZUHpC0otij0KHpBQG
	 LBUUmcVkm3kDqv2GWeadhQ+2pFYynaCmbxFMHVbaKM7fo4IxGALgox9YIDw8Lohj+o92/
	 ls8xI34WbFj8eBmuWZZzGH0x0/SHZI+OKYU4yr+MlDP+coAdrBmuJ7QlbJNnXxJdfB0gB
	 I43dwULnpM/55Ca6Tp9VLGVKJ6xs9Fu4ebi5vpxAH9I+Ur5/tK/CaE15XJu+dg4Kgig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792666893;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=FeBcB8xvZ2Pp6hLtOLFO9RpsTwcvbp4PO4RP7ourH6Y=;
	b=WuQJX8ipWse5u2AxOTUV2FCK869wa952CF/UNz8lYpp6o3g6pubisDAPSE8FZAnGMx0k
	 FbAfYn/rZJnT0dSi9HwhCl9qgmvt3ixwJWuOeG3krbI2OgsxFoxZjPzT3IsP65QUhDkz7
	 W/8c4VE7XCVlP8jzQTKU+Xt8MZhMrQ4bJPAhahNoxyGJn13k82xpM8RXCkW3KNGQ6giyL
	 5PVPDV0hertO2Aa3FxM3kL6PIHv6MJSGagdsPYKWrVJjHb1Pc1ZRI1mcwS+U91RBep46h
	 CUaIJZvCevVDiaYZkFEa//yALTdblGdlO/a8qyqsjt/Z+o7qRPNdeM5nGC5IS6ClYDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RQGkSiJF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D020606A31E;
	Thu, 22 Oct 2026 11:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RQGkSiJF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28551F000C2;
	Thu, 22 Oct 2026 11:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792666892;
	bh=FeBcB8xvZ2Pp6hLtOLFO9RpsTwcvbp4PO4RP7ourH6Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RQGkSiJF9w6My9PDxRHGukyjGhHJ4a5ZrgkE9Qn14vqTXh59yVnm1YXwuMlaXfZgf
	 d6M59XbEusxBPZmhYaqg7gumT4mersscPc72azwmUhkjvIaqrlvKABLjnJGk5xGaO7
	 ReEf0rYsajOyZx3/EP0LLyQPd+u70T0AHdZE503JRkczbJkaTeUwOeLpjXiTDQt1fP
	 RCdlLexpApED23w28CfoGCvh9pBTfSYzv3/kXH3gflEqWSlTrq1ksAkecnl2Oygn3b
	 8fvlHV3Ufu6feWqo3S31kG3WhnVq/3nxVKpb5qujY07vR8UByPxYCX5AnpnSKicqyS
	 SHX+mDC8dyK4g==
Date: Thu, 22 Oct 2026 13:01:28 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	djwong@kernel.org
Subject: Re: [PATCH v5 2/3] man/man2: introduce man page for file_getattr(2)
 syscall
Message-ID: <atnsT6ns6AADTaMP@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260916115141.3500780-1-aalbersh@kernel.org>
 <20260929130234.3547891-3-aalbersh@kernel.org>
 <asvBPbDfCIVm71jg@debian>
 <as9EIPE2lLJs9ram@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <atj5s3WAmsjv9aq9@debian>
 <atnFn3-KSPD3qmJU@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <atnVqseSsHGMkzpH@debian>
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
In-Reply-To: <atnVqseSsHGMkzpH@debian>

On 2026-10-22 11:27:55, Alejandro Colomar wrote:
> Hi Andrey,
> 
> > Date: 2026-10-22 10:43:08+0200
> > From: Andrey Albershteyn <aalbersh@kernel.org>
> >
> [...]
> > > Sorry that I missed this email.  I had an attack from a nation-state,
> > > and had to be very careful with my hardware and communications.  I will
> > > probably say something more detailed on the mailing list, but I'll only
> > > share some details encrypted with very few people to not give too much
> > > information that might help them.  Anyway, when I got back to normal, I
> > > missed this and some other emails.
> > 
> > oh, sorry to here that, hope you're safe now
> 
> Yes, I am.  They infected my phone, but let me free after several hours,
> and they couldn't infect my laptop as far as I could detect.  I got a
> new phone, but luckily I didn't have to buy a new laptop.
> 
> > > And yes, this text seems good to me.  I see your new revision, so I'll
> > > review that.  BTW, I wonder why there's this difference between
> > > openat(2); was it on purpose?  
> > 
> > Not on purpose, but because file_getattr() uses newer
> > filename_maybe_null() interface which works with a NULL.
> 
> Hmmmm.
> 
> > 
> > > Should we maybe require that callers use
> > > an empty string with file_getattr(2) too?
> > 
> > I don't have opinion on that, this could be done by dropping the
> > 
> > > > 	with the divergence that
> > > > 	.I path
> > > > 	can be NULL meaning an empty string.
> > 
> > then.
> 
> I'm worried about this, because people might experimentally realize
> about the fact that NULL is accepted, and by saying that it behaves
> exactly like openat(2), we might confuse them to think that openat(2)
> also accepts it, so I think it's better to tell the truth.
> 
> > 
> > > Or perhaps allow NULL in
> > > openat(2)?  (I prefer the former.)
> > 
> > This, probably, would be not easy to change without any particular
> > reason
> 
> I've been lately thinking that we should have an at(2) manual page that
> describes the common features of all *at(2) syscalls.

sounds like a good idea, it will also help while developing syscalls
like these ones. Having a good reference of how it should behave
will make things easier, I think.

> 
> I'll CC you and linux-api@ to discuss details about it, and know which
> syscalls behave differently, because we should probably provide a
> unified UX, and only deviate when there's a good reason.  Once such a
> page exists, we could just refer to it in all *at(2) manual pages,
> instead of repeating all the details every time.

sure

> 
> But for this page, I'll take the text as is, I think.

Thanks!

-- 
- Andrey
