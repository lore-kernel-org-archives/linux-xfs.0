Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792661283;
	b=drmhf+myopomNJY7qi8pIw23WJXsGTgURss+E6/uygf8Cy+HUCV3HfIw2ubwZmZelNPG
	 yVaQORj9TEGTIbgmQh2ZgkxEiRCKoet4m4SrbimM7Hwq3vrCp8Ja+/t7sNwhK5+fn0h7g
	 MdM8nQMwT03X1VkPhk2tOjePrQPXZ5USLNEFG2qAlopwv8wZdcb3hKVR2vfuB74UH2h0l
	 aBvhl9rGbYGmI34pb1E944D8Su+UnQIwktXrwsfdOZiR0GlNuJKsUuLVnUvt+L+2oopze
	 f/tLcV2cIgm7+u+mup4SxIpplM/Xo/DWMyaRMZ7HTUh/575faN8cgs8RY1+lU1sbrmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792661283;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=FN3sRWyIdvl/+txcRkdmNsRbF+3/wV+Y8oZpnnSep1g=;
	b=tlJ7clgp/A8iC3SMglFEwCocWBQVUZt/y7FTYTgKqD6LaDVzIDh3TTaWpLqlC4T4ARch
	 TUkbvIfFwMnuTY5QQLLIWffJSCHDE2tqkibPMd8e7o5BpYnBR0/4Jh7NhM6ZKZD7lI4wG
	 tD9okAmmN66bY2UiljQyUZSE3OXPYAqAyMJnNXG00VFvzKduoFdEO3lnlVN35ypQMMqg3
	 ObcrSkwHY8/g5ZjSrbjuIM9jtHpnzF1hLXzqampW4IXoIlx+qS7jq2OR/L7OknJESLyqZ
	 tAfsG4HL7UuJuvAOJU1BZTDOHp/Qts+P9bAIrf+LJjeYzdvxKxP78rQdIy/k2TwzFTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="P/PWFc/Y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AC7606A32C;
	Thu, 22 Oct 2026 09:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P/PWFc/Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7731F000C1;
	Thu, 22 Oct 2026 09:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792661283;
	bh=FN3sRWyIdvl/+txcRkdmNsRbF+3/wV+Y8oZpnnSep1g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P/PWFc/YqvNU9ei16AIqKNdonKgOZYumNRDLlo+P2fkaRl2z2u1m+0KDcIGi5BPwN
	 n+KN0LI5kzdGg/2zjH8zUpGhcBd99yne/RpX9Fw5JfYfWsTBI/+VwgYU/2IgzHdS+L
	 0/IN0LpNt33sgel/q7GwhD+80qsQOX7gFCgNGbCc1s/YB25kpGdbBh6J4bVS1oBBpJ
	 hEpEZn+SDUo2zBMlSwBnCTHluBxGzR724CnM+jqHLlSTN+7ZG5zGEskcyQJ4e0C6Tg
	 fguVbNU8PNdqBXgpnHdwGpkWUCwJvovFAuf5IQPo7d9JVqQiePxRhbQhO0pxe/NP9g
	 L4GIXe/B1pRdA==
Date: Thu, 22 Oct 2026 11:27:55 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	djwong@kernel.org
Subject: Re: [PATCH v5 2/3] man/man2: introduce man page for file_getattr(2)
 syscall
Message-ID: <atnVqseSsHGMkzpH@debian>
References: <20260916115141.3500780-1-aalbersh@kernel.org>
 <20260929130234.3547891-3-aalbersh@kernel.org>
 <asvBPbDfCIVm71jg@debian>
 <as9EIPE2lLJs9ram@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <atj5s3WAmsjv9aq9@debian>
 <atnFn3-KSPD3qmJU@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
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
	protocol="application/pgp-signature"; boundary="pjwzvbitjiassypm"
Content-Disposition: inline
In-Reply-To: <atnFn3-KSPD3qmJU@aalbersh-thinkpadx1carbongen13.rmtcz.csb>


--pjwzvbitjiassypm
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
Message-ID: <atnVqseSsHGMkzpH@debian>
References: <20260916115141.3500780-1-aalbersh@kernel.org>
 <20260929130234.3547891-3-aalbersh@kernel.org>
 <asvBPbDfCIVm71jg@debian>
 <as9EIPE2lLJs9ram@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <atj5s3WAmsjv9aq9@debian>
 <atnFn3-KSPD3qmJU@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
MIME-Version: 1.0
In-Reply-To: <atnFn3-KSPD3qmJU@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

Hi Andrey,

> Date: 2026-10-22 10:43:08+0200
> From: Andrey Albershteyn <aalbersh@kernel.org>
>
[...]
> > Sorry that I missed this email.  I had an attack from a nation-state,
> > and had to be very careful with my hardware and communications.  I will
> > probably say something more detailed on the mailing list, but I'll only
> > share some details encrypted with very few people to not give too much
> > information that might help them.  Anyway, when I got back to normal, I
> > missed this and some other emails.
>=20
> oh, sorry to here that, hope you're safe now

Yes, I am.  They infected my phone, but let me free after several hours,
and they couldn't infect my laptop as far as I could detect.  I got a
new phone, but luckily I didn't have to buy a new laptop.

> > And yes, this text seems good to me.  I see your new revision, so I'll
> > review that.  BTW, I wonder why there's this difference between
> > openat(2); was it on purpose? =20
>=20
> Not on purpose, but because file_getattr() uses newer
> filename_maybe_null() interface which works with a NULL.

Hmmmm.

>=20
> > Should we maybe require that callers use
> > an empty string with file_getattr(2) too?
>=20
> I don't have opinion on that, this could be done by dropping the
>=20
> > > 	with the divergence that
> > > 	.I path
> > > 	can be NULL meaning an empty string.
>=20
> then.

I'm worried about this, because people might experimentally realize
about the fact that NULL is accepted, and by saying that it behaves
exactly like openat(2), we might confuse them to think that openat(2)
also accepts it, so I think it's better to tell the truth.

>=20
> > Or perhaps allow NULL in
> > openat(2)?  (I prefer the former.)
>=20
> This, probably, would be not easy to change without any particular
> reason

I've been lately thinking that we should have an at(2) manual page that
describes the common features of all *at(2) syscalls.

I'll CC you and linux-api@ to discuss details about it, and know which
syscalls behave differently, because we should probably provide a
unified UX, and only deviate when there's a good reason.  Once such a
page exists, we could just refer to it in all *at(2) manual pages,
instead of repeating all the details every time.

But for this page, I'll take the text as is, I think.


Have a lovely day!
Alex

>=20
> --=20
> - Andrey

--=20
<https://www.alejandro-colomar.es>

--pjwzvbitjiassypm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrZ1xoACgkQ64mZXMKQ
wqmq0g//Vg5DDmOZ+ATIOwjWNR82KPU1ARvKusGnqD0UZqqFLdtAqBNaRSfIdQzg
/J9NNbPzeQrL2dKUGnzHojVuMrvUNnNViDPsdB+GtA/3MXD8n46p0SLPGS4yvtUw
n4IwvbhW5tmxhxta1kjGFowS4blAAlbnCErmI/35zsouUqrMIghYnNK34FGromjU
t6YiFGQs+06uKCExMFlnUmQM8iOTdxCl2WNNCtQVIIHt5RBFQ+p/+zCj2/xH1izo
kPfjdl6cem80TjGwGHdUmKLNO0dNYqvc+9Ezr9PDN2uR72TwsnuEAq0t7onilt16
51507ZA9STXYnzCx1JOTpf1JGXHSVCT2Z/nYXYrYvedHQZi7TbdX9vtDiq1R8ZHp
NpiUTII20jfRa9akuaSSodKmKKd1hSylKYcqrMR+eznxOwAc8sK8t+8leD0ys5QM
ss9kQRPcIaJNsuIwrG4rl1N1hiLrKO0y299r/g94N+ew1zDBA9hEIvy4tTUjCPvT
OtzPEopaC/axNIND9K1Bnqu9xD87ep7N+3dEsrEHps2t6CMjLriUTzeVwgUvltC/
gLIPvLC7nMcl7vg8uViGF9dQoF4p09P7wIzEOrtI0WEaL9ywnxYMu9dvucUNfkg0
N8KMdkauJ0y2zMW/AjREBBLv5tI3U4p2m2GQovKRbl5W7wk0Cn8=
=wHGo
-----END PGP SIGNATURE-----

--pjwzvbitjiassypm--
