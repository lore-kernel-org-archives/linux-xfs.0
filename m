Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792604978;
	b=oY+hvloFXuVZbO0/KI4H3m/v6ihlxI+z+DlYrC//9M6NcF462XcPNpMpWC1wy6Ngjo52
	 yqUFjPordTRE+hkOQtF3QMM8mQj8qIYXk6uKQmULxZ2oUhw+4uB2MaD+GA7USpaK34N+7
	 Igr4e+OU7PYqrA+LYy7WJRECsy3746Kb4tG/shJpo3H3B680YsnNAlKBEOH4n8BvDMlBC
	 zIwVg+hQVGDHfowwREA9bP33AuogEU7NdnuC0q5AUr0B9xVA0jLr8LXJLcIfphcSd+1ku
	 vfAWPvZlrdjwuBWEkvJ9WsdcXCg4fX6FRSjihThKVIvr0c3jlw02vRXtDVgu2V5dZvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792604978;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=opB/5WIa71WGwgXNjnUdKA69+DZiYmo5oS6nfPVlS50=;
	b=5NnG/KCA1ZNP8JHTyFktzpPK1ccRkOecjDQ0PWO/MeUxTp8ghBk0/wf+mQQWBYt1/qw5
	 uRS+ipA3IfIZrpbXWJ4LRHb26tY4DKJ8diQcvpYoWxflJTOdwqPO8wkVo5MrUf8o5dWIa
	 AzlJDca9lPI6Q135RQusB4G9yiA/m6Tfg5LDElYuGlWCtnJ6BrbNdQnxum/DIykfh2eQ/
	 BgF09nulZUlhgLo46N1bZRAiUnmPjiIJFElRqztljiCHE+IvdSveDP8L643w+N2ecu7jl
	 FEN0n1ermUz0dEoc2d1XMUPwONa7RMctrVVuK7pD6x1gG3pCKOygqZKmzdHJzNW1xig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bnt3TxOZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64715606A319;
	Wed, 21 Oct 2026 17:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bnt3TxOZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878E51F000C1;
	Wed, 21 Oct 2026 17:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792604978;
	bh=opB/5WIa71WGwgXNjnUdKA69+DZiYmo5oS6nfPVlS50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bnt3TxOZbWqYE/KHkoC3L4HdBDKXB63bgxGzuuzW+Pm4pctlqYpgCQDPK57SQAC/T
	 /vJiQOayVS9Nd3OMwhG5x87Qwzqj7cmZ1lPcZhL2tKZmN94Q3ao8Sfsh1S1TQf/BCj
	 R7b+wWLCdNjCz7JMYRKcYGyvxRNmLuluByNd/fmxJpPoAVytE37VjreEN184JJE61C
	 JtyNejEG9pWg0cFthf5NUbP+pjeJM2WJQrTRxRQQxLD+uP4JJ14PydIKl243ZB4EkR
	 JibRLw8Q7xgtnly4JmP8vhsyesjQejzgKaZSQ4z/g2bcuNMzqUGpTpvJWldjsftOCH
	 N6r7J1MeuQ5xw==
Date: Wed, 21 Oct 2026 19:49:29 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	djwong@kernel.org
Subject: Re: [PATCH v5 2/3] man/man2: introduce man page for file_getattr(2)
 syscall
Message-ID: <atj5s3WAmsjv9aq9@debian>
References: <20260916115141.3500780-1-aalbersh@kernel.org>
 <20260929130234.3547891-3-aalbersh@kernel.org>
 <asvBPbDfCIVm71jg@debian>
 <as9EIPE2lLJs9ram@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="35izgnwpri3vnjrf"
Content-Disposition: inline
In-Reply-To: <as9EIPE2lLJs9ram@aalbersh-thinkpadx1carbongen13.rmtcz.csb>


--35izgnwpri3vnjrf
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	djwong@kernel.org
Subject: Re: [PATCH v5 2/3] man/man2: introduce man page for file_getattr(2)
 syscall
Message-ID: <atj5s3WAmsjv9aq9@debian>
References: <20260916115141.3500780-1-aalbersh@kernel.org>
 <20260929130234.3547891-3-aalbersh@kernel.org>
 <asvBPbDfCIVm71jg@debian>
 <as9EIPE2lLJs9ram@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
MIME-Version: 1.0
In-Reply-To: <as9EIPE2lLJs9ram@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

Hi Andrey,

> Date: 2026-10-14 11:14:07+0200
> From: Andrey Albershteyn <aalbersh@kernel.org>
>
> On 2026-10-11 19:06:32, Alejandro Colomar wrote:
> > Hi Andrey,
> >=20
> > > +As with
> > > +.BR openat (2),
> > > +if
> > > +.I path
> > > +is relative,
> > > +then it is interpreted relative to the directory
> > > +referred to by the file descriptor
> > > +.IR dirfd .
> > > +The special
> > > +.I dirfd
> > > +value
> > > +.B AT_FDCWD
> > > +can be used to refer to the current working directory of the calling=
 process.
> > > +If
> > > +.I path
> > > +is absolute,
> > > +then
> > > +.I dirfd
> > > +is ignored.
> >=20
> > Is there any difference with openat(2) regarding the handling of 'path'
> > and 'dirfd'?  If not, we could say:
> >=20
> > 	The
> > 	.I dirfd
> > 	and
> > 	.I path
> > 	arguments behave in the same way as in
> > 	.BR openat (2).
> >=20
> > Is there any small difference, or is it exactly as in openat(2)?
>=20
> The difference I found is that
> file_getattr(fd, NULL, ..., AT_EMPTY_PATH) succeeds but the
> openat(fd, NULL, O_EMPTYPATH) returns -EFAULT. openat() always wants
> an empty string while file_attr() can work with NULL.
>=20
> 	The
> 	.I dirfd
> 	and
> 	.I path
> 	arguments behave in the same way as in
> 	.BR openat (2),
> 	with the divergence that
> 	.I path
> 	can be NULL meaning an empty string.
>=20
> so maybe like this?

Sorry that I missed this email.  I had an attack from a nation-state,
and had to be very careful with my hardware and communications.  I will
probably say something more detailed on the mailing list, but I'll only
share some details encrypted with very few people to not give too much
information that might help them.  Anyway, when I got back to normal, I
missed this and some other emails.

And yes, this text seems good to me.  I see your new revision, so I'll
review that.  BTW, I wonder why there's this difference between
openat(2); was it on purpose?  Should we maybe require that callers use
an empty string with file_getattr(2) too?  Or perhaps allow NULL in
openat(2)?  (I prefer the former.)

In any case, I'll take your wording, since it documents reality.  I just
wonder whether reality should be changed.


Have a lovely night!
Alex

--=20
<https://www.alejandro-colomar.es>

--35izgnwpri3vnjrf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrY+yIACgkQ64mZXMKQ
wqnsyA/+ONTlNc9ceGf9tp3u+fjG0QzaCu2tdKnSP54L4FEi5aVcohf73cNa99qA
aG+zMoRHEpkwr8PXEtKto1vKReyObJ1U2f3VsS972LyCTqwXnWyO8yIYuzBWSnfm
7Ks9UdSS7es5at1hBYglnu1bkmZsT1dAaRHrBDGvgjCqnlw8T9ftjtrMGk+C3zcs
zgUl1Msu7OCABPPe+73RANizNMTjD78il7XZGSRHQny2zuD9RUV8wDomUk3SHAx4
E5wl8sj84Zlxx2QKSDHrW6O3WJ3Jc0xz41h901laTjSsXvM4FIAMIddteAwDwxZX
z3vnD+C3flaZgLVFEZOvNplmMKYXsLFrlC4vRUnB+nD1o+CM2BiWjAS+0qy6ZtU3
xGPMjJ+wHSwqNTp4qc5qYbWf/HoyErkFahcKFwYnzNxt7ky5ZSCSBvEb31wgGQJn
jhnZOwoxQMKCujkYvIbnWrW05/iXNKl5aUyAa0sggRzThrFwdGd/ybLxdbDkxk0O
pTL9+0iawkaBOWHiy1b4V3p3d3nwDmhw4ArdaMgfrWDbBTilM1BCyYXXqNXokI1W
AD9WCzEL7JN7s2v8NRLUzsb+zzD5fhi1QXpQCJp3Ek/Ur66AsdLnpolATRhzrqR1
NwPArjlquaKWUsQZYVAls66aExze5W9XSAfEt+BfXwtXsZx0wyA=
=+/3/
-----END PGP SIGNATURE-----

--35izgnwpri3vnjrf--
