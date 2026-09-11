Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCC135F170;
	Fri, 11 Sep 2026 11:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789127822; cv=none; b=oWC5uKokKIh0Ub5QKGrpS0tqSHxqesd0yH7ltgJg1QNCcAPLG11zRlL0JWaMUi8kUKJ08vtwJou1aecgn6A9xrmSQDzLcvGzXEqAb/tR8jjRyobxzmd6LMjwEEnTM+123s9+9hoWcK4CmGI7QgoTMwTmZOzByV5wVd/1GD549oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789127822; c=relaxed/simple;
	bh=w9StJE+nn0gkG1gomyMgGNCH6NI28semBIPVleJDVGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FGSFcZGaKk5lkHdlb1s81ISx0SoOZgVQgX/tvQWw92uxhPoDtpM/Np6u0DlCii6uyoBU8FgcLudzgtaeZ0c2mYnx3zPzsimgP5Jq7QBW1YD/56oDg7VKx9toonLwiuOZgB24ahqjTQ1zZeIYPuVyXokyfbQ1qV9101lUevLqHpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K11BV0Q0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K11BV0Q0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FD01F000FF;
	Fri, 11 Sep 2026 11:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789127820;
	bh=L1OeiMMiUuX2c3YfVw5XAKf2PuPZvV9E0osxi7XkgcM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K11BV0Q0GfXgRWBY9hWvTQTZUx1Y/DXSo9d5Lsn/KBpbt7Fweoopm7LTE6t7xgAUP
	 NShNd5sxVrhUs74tL8AyqYIc3l62PRAwMsYrWuiQT0AOYotHhdpOIOmjs9XckKD5Ai
	 mioUp6silLKJgXoQsE7Y9nAWcZ83QyJ3DN4NcRuNyDpCGaVbbI4f2PIOtazYVI3jGl
	 N/TpPN5b9boXVr9/DwwHPOGvh2VpTWaDWieU1lspaJLR1Hvajkq3FQHbiufN3HqWtw
	 Ia6UuoUw69iWxKJcz2v4457+ig63Hgy8+Azvrq4n8/Dh/w6BAMbXFm/8JyGQpJyaFU
	 fFWBr2lbIGglg==
Date: Fri, 11 Sep 2026 13:56:55 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-man@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, djwong@kernel.org, 
	linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] man/man2: introduce man page for
 file_getattr/file_setattr syscalls
Message-ID: <aqPrI5F-IE6_lmK7@devuan>
References: <20260910104120.3964799-1-aalbersh@kernel.org>
 <aqKgTGHh3nDnM3eh@devuan>
 <aqPg20OSbTsxRd6-@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="szfb7nu3rmkucoyg"
Content-Disposition: inline
In-Reply-To: <aqPg20OSbTsxRd6-@aalbersh-thinkpadx1carbongen13.rmtcz.csb>


--szfb7nu3rmkucoyg
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-man@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, djwong@kernel.org, 
	linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] man/man2: introduce man page for
 file_getattr/file_setattr syscalls
Message-ID: <aqPrI5F-IE6_lmK7@devuan>
References: <20260910104120.3964799-1-aalbersh@kernel.org>
 <aqKgTGHh3nDnM3eh@devuan>
 <aqPg20OSbTsxRd6-@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
MIME-Version: 1.0
In-Reply-To: <aqPg20OSbTsxRd6-@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

[CC +=3D PERFORMANCE EVENTS SUBSYSTEM maintainers]

Hi Andrey,

> Date: 2026-09-11 13:17:12+0200
> From: Andrey Albershteyn <aalbersh@kernel.org>
>
> Hi Alejandro,
>=20
> Thanks for the review, I will apply your suggestions, responses to
> some of the questions below:
>=20
[...]
> > > +The
> > > +.I flags
> > > +argument is a bit mask, available flags are:
> >=20
> > The usual language we use for this is:
> >=20
> > 	The
> > 	.I flags
> > 	argument contains
> > 	a bitwise OR of zero or more of the following constants:
> >=20
> > See for example readv(2).
>=20
> I will use "constants" then (the readv uses "following flags")

Ok.

> > There are some minor variations of this in other pages, and I should
> > make them more uniform.
> >=20
[...]
> > > +.TP
> > > +.B EBADF
> > > +.I pathname
> > > +is relative but
> > > +.I dirfd
> > > +is neither
> > > +.B AT_FDCWD
> > > +nor a valid file descriptor.
> > > +.TP
> > > +.B EBADF
> > > +.I pathname
> > > +is an empty string,
> > > +.B AT_EMPTY_PATH
> > > +was specified,
> > > +but
> > > +.I dirfd
> > > +is an invalid file descriptor.
> >=20
> > I was wondering: is it valid to specify AT_EMPTY_PATH, use an empty
> > string, and use AT_FDCWD as the dirfd?  That should act on the current
> > working directory itself, right?  Or is that not supported?
>=20
> Yes, this is valid combination. I can describe this case.

Thanks!  I think using wording similar to the one above would be enough:

	but
	.I dirfd
	is neither
	.B AT_FDCWD
	nor a valid file descriptor.

[...]
> > > +.TP
> > > +.B EINVAL
> > > +.I size
> > > +is smaller than
> > > +.BR FILE_ATTR_SIZE_VER0 .
> >=20
> > perf_event_open(2) reports E2BIG for a size smaller than
> > PERF_ATTR_SIZE_VER0.  This seems unnecessarily inconsistent.  I'm not
> > sure which I'd say is more appropriate, but I'd expect them to be
> > consistent.  I mentioned perf_event_open(2) because that's the only page
> > that has a *_VER0 constant and documents an error if a size is smaller
> > than it.  There's also mount_setattr(2) which documents
> > MOUNT_ATTR_SIZE_VER0, but it's not documented in ERRORS.
> >=20
> > I think kernel maintainers should have a look at the different APIs that
> > have such a value, and discuss whether the error codes should be made
> > uniform retroactively, or whether we should accept the existing
> > divergence but decide on an error code for new APIs.
> >=20
> > I've CCed linux-api@.
>=20
> The MOUNT_ATTR_SIZE_VER0 also returns an EINVAL

Thanks!  I'll document that.

> I'm in favor of EINVAL as E2BIG is probably a more confusing naming
> for the too small argument.

I think I agree.

I've CCd the maintainers of perf_event_open(2).  Can perf_event_open(2)
be changed to report EINVAL?  Or is that mistake set in stone?


Have a lovely day!
Alex

--=20
<https://www.alejandro-colomar.es>

--szfb7nu3rmkucoyg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmqj7IEACgkQ64mZXMKQ
wqlezg//RLQAo0BxssEGu8xfo6SW+0W2DNb3gXUM9X7eVQuUNVndRL3KWcRf0lSD
bdpX9Z4eK9TfgvYM6U6QLI1qkJMdc76zQKhgU2OwTgJECziYSDaPWeDdTXEU4XTe
seSFHNg/PKr/FWZaSII4AtH8XIeJt7vMoJcr958fHUnflFb87oXOoyYxQzQ/f69k
fvLN7IlIJj7ARdJOEHnVinv45b1VSoNNSo2vo6Z9iO6DdIfd8fiROQgz7TG2MhRo
C38uQapJ77W4V4uF5ui0MMq7AXcN8Ire1+4tZrmWevUYehOJYujROuhxwjfA5VeL
v9lteYeeyiv4sQIpLgUmI5HmhRyoER43J1N5iXrTbAQhsMxFoslnoruw33lnJ79L
AVTz2qEm23M9QFHwrxstuv0m2OnH28DIMdu7v439Cpso9NGTtVuPF016gwIapNge
P7E6g4qgb85H5qZy5JumNB/0OdBBYfYz5CVOsW+0m3D0XwjJYmlw42MMOh5TRDrF
o5brnzgbdtwJuZaLTZVbB/8HGil5xHQMt8szE6FgKxbWm7aAUNto+MQrhq0TuaRD
+wzhCILjvWNSbueJ/r9gN9PHqU7ura6s1OOnJi6mJ3/YAIueKN0ZCjIwtKBzdugH
HTkCNhYUgB4udiV9O/+EI8xtDsihKRJbSBm/joWWFV0A08A32n4=
=pDVG
-----END PGP SIGNATURE-----

--szfb7nu3rmkucoyg--
