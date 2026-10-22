Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792658594;
	b=cyiIAu3b8aVlT7Xr0gzRjykVW91LJ2qaSyl+XNokRQbiIUBxXXIqnu4CBmWkcuK6qq+7
	 SMgiWS1eSuPudLcK8RZEhV84ZuxrXjuPj69R322fVE99BALeR7qWqswmsgx2ZVDQFjNii
	 8Uordr29H2jiGNEsyxjRxO9SYktilSnFxaXKixQCrU+Qy5KTHFjZ6qwcERACm8ZFSEao3
	 UsCAmDzDFtJj2XYlk1jflc+qVkhDstuXNNH6L3e/rcvD3X89aZc5qz/y59lk+PYhA2Jds
	 vCzRZihZKa5GL1dZeCaDLqoMU13z+nOjiv/ZGfi93ZcD4RWCTeuWzJ5m8oRlajBBu9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792658594;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=aDvUlbBjke1wchRXocub8eukRjOOzXl1LD0fW/2XnxA=;
	b=TG3QthgHKa3ckaiSCj3mU7gzFaK2im6eJb/VncuKYLtmH8GZYOmSikfP3/LZouEU5YO1
	 ByJqpNbVWBLJwyZ7eGe/6uOl7SPMDqKcY5zqRdQ9GqmX+gaSr9cpyQgrFoTMTigCX38sr
	 oD0K+ABlrzD1u4G+xehtvjX859ErpFaIZi+ucIpU24vYgtOqEUxIMVrtiiQlnAr42RD7N
	 iOviAU/oGqVUZ2oIp7C+xk4tooZNss74o3YIbWTp4ERXcT2J3kJU2qGJBjFL5KrCxUrwM
	 pYVEm2zOzxSDobBNqCelJh04u0WoFYfqV6JRBtW/K+0kL9RU7DtSUyb4Gf0JyLv2YLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cuNcsWro;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADAF606A319;
	Thu, 22 Oct 2026 08:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cuNcsWro
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C4E1F000C1;
	Thu, 22 Oct 2026 08:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792658593;
	bh=aDvUlbBjke1wchRXocub8eukRjOOzXl1LD0fW/2XnxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cuNcsWroet8Ts9FgEkexP2G3NpUD47irnzrNnZFgs8Jg8cTNj1qmDRyEbUt9KOET1
	 e95Q4Fsl4LCVNB3MnoFJgx2Q4ywPvB//kFDt+S7M9ez+StMxocCRtCPqIY+VAOm5f6
	 K58i6i9xoz8/t2pOsvA+ZHV52ZkXVzIiUUvYng/mdjzBk87gtvFivvG42L00H+J5m3
	 gYZeTnsprhRgfPerrp43oRaWQgF7gaPEchEcwWWcHJ+zntqrV/AlttY2LTjCrgcU/B
	 NRwZXPK6smlOxeCRBD5il7BXFJHhnlIkH1la43N/xdEoFSBxvJh8GjBRkxxLUfcNvf
	 TRiUXaly1tIQQ==
Date: Thu, 22 Oct 2026 10:43:08 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	djwong@kernel.org
Subject: Re: [PATCH v5 2/3] man/man2: introduce man page for file_getattr(2)
 syscall
Message-ID: <atnFn3-KSPD3qmJU@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260916115141.3500780-1-aalbersh@kernel.org>
 <20260929130234.3547891-3-aalbersh@kernel.org>
 <asvBPbDfCIVm71jg@debian>
 <as9EIPE2lLJs9ram@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <atj5s3WAmsjv9aq9@debian>
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
In-Reply-To: <atj5s3WAmsjv9aq9@debian>

On 2026-10-21 19:49:29, Alejandro Colomar wrote:
> Hi Andrey,
> 
> > Date: 2026-10-14 11:14:07+0200
> > From: Andrey Albershteyn <aalbersh@kernel.org>
> >
> > On 2026-10-11 19:06:32, Alejandro Colomar wrote:
> > > Hi Andrey,
> > > 
> > > > +As with
> > > > +.BR openat (2),
> > > > +if
> > > > +.I path
> > > > +is relative,
> > > > +then it is interpreted relative to the directory
> > > > +referred to by the file descriptor
> > > > +.IR dirfd .
> > > > +The special
> > > > +.I dirfd
> > > > +value
> > > > +.B AT_FDCWD
> > > > +can be used to refer to the current working directory of the calling process.
> > > > +If
> > > > +.I path
> > > > +is absolute,
> > > > +then
> > > > +.I dirfd
> > > > +is ignored.
> > > 
> > > Is there any difference with openat(2) regarding the handling of 'path'
> > > and 'dirfd'?  If not, we could say:
> > > 
> > > 	The
> > > 	.I dirfd
> > > 	and
> > > 	.I path
> > > 	arguments behave in the same way as in
> > > 	.BR openat (2).
> > > 
> > > Is there any small difference, or is it exactly as in openat(2)?
> > 
> > The difference I found is that
> > file_getattr(fd, NULL, ..., AT_EMPTY_PATH) succeeds but the
> > openat(fd, NULL, O_EMPTYPATH) returns -EFAULT. openat() always wants
> > an empty string while file_attr() can work with NULL.
> > 
> > 	The
> > 	.I dirfd
> > 	and
> > 	.I path
> > 	arguments behave in the same way as in
> > 	.BR openat (2),
> > 	with the divergence that
> > 	.I path
> > 	can be NULL meaning an empty string.
> > 
> > so maybe like this?
> 
> Sorry that I missed this email.  I had an attack from a nation-state,
> and had to be very careful with my hardware and communications.  I will
> probably say something more detailed on the mailing list, but I'll only
> share some details encrypted with very few people to not give too much
> information that might help them.  Anyway, when I got back to normal, I
> missed this and some other emails.

oh, sorry to here that, hope you're safe now

> 
> And yes, this text seems good to me.  I see your new revision, so I'll
> review that.  BTW, I wonder why there's this difference between
> openat(2); was it on purpose?  

Not on purpose, but because file_getattr() uses newer
filename_maybe_null() interface which works with a NULL.

> Should we maybe require that callers use
> an empty string with file_getattr(2) too?

I don't have opinion on that, this could be done by dropping the

> > 	with the divergence that
> > 	.I path
> > 	can be NULL meaning an empty string.

then.

> Or perhaps allow NULL in
> openat(2)?  (I prefer the former.)

This, probably, would be not easy to change without any particular
reason

-- 
- Andrey
