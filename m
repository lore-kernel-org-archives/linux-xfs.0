Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A74A1F91E3;
	Thu, 10 Sep 2026 22:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789079907; cv=none; b=nfFNfkZOsCzgpmOSCDuraCQmM+WoEXgpU0tDlGNYyOGQj+m/md+ulCMtMbzrtVt2M3Cl1+9k/kr1qXAOuD5WW2CypMkqN8TtUcaOJP69MF4CRGnQk1yyRrhQ/2dVxYVcDivsFg7FdE5ODuodoy+CCZiLRUB1/l6ICB2FQXD3ITc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789079907; c=relaxed/simple;
	bh=gG4Kc6X/pJNavuySiOjwo58rC1hP+lXJlzh8VLjrjtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q8S1dzNFuyYzveiQ5qM5uoUOt7sk/UcnqvOfggvPcRppGRzAf7sFat3xji6Bj/kcHNmWE3G5O8Sv/tHSbB9vD6pXktXaRXfGb+6/sWn1HcMsxS3eKjbS54YjFyAqzQ5xJeSGXT4j0Kc4rT9urkLG4qN9+XFyi4kV3AOlpTNf4UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iKEL3NWb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iKEL3NWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C6C1F000FF;
	Thu, 10 Sep 2026 22:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789079906;
	bh=nrB/z21/ndSYlKuXF/4TZ1eS8rCPAlvlLs1OSophTus=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iKEL3NWbeQ6D+cxh3KJ4TSDFW2qEkU/qwIGcM3WBTqyLSd1JYrctcssR4gdl9DO6J
	 KUgdCDfFehnL9ikUJRqm53Gu/0B5Gq/QScOF8A9MBXA5kJauHuKKEXWUHU1Fsua61w
	 WzqZdc1j8/FDYl6WHzPCtmsudERbnRlO3pycVziLLkw2dizDkvkoYc6mwuYEKziZgP
	 KemJBVoz3zFjzq4DHjnmkKug8bntlLR+cEy4Xxm2qiOmaFC4CHD96EN7/eCKAqYx+0
	 EDKxGwYVtrR3gbwi2rf/6N0g/wMVnuOzUmSipgYzMMqzBL1Zme1mDCSWhJkjsxqaAX
	 2vo+0XSqdLXdg==
Date: Fri, 11 Sep 2026 00:38:23 +0200
From: Alejandro Colomar <alx@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-man@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: quotactl(2) (was: [PATCH v2] man/man2: introduce man page for
 file_getattr/file_setattr syscalls)
Message-ID: <aqMwVislUcWIRTUb@devuan>
References: <20260910104120.3964799-1-aalbersh@kernel.org>
 <aqKgTGHh3nDnM3eh@devuan>
 <20260910161204.GE6238@frogsfrogsfrogs>
 <aqLY-1do_4hmZpfI@devuan>
 <20260910164428.GF6238@frogsfrogsfrogs>
 <aqLfs-6crlKiqZw9@devuan>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="36qfbwysvk5yvru6"
Content-Disposition: inline
In-Reply-To: <aqLfs-6crlKiqZw9@devuan>


--36qfbwysvk5yvru6
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-man@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: quotactl(2) (was: [PATCH v2] man/man2: introduce man page for
 file_getattr/file_setattr syscalls)
Message-ID: <aqMwVislUcWIRTUb@devuan>
References: <20260910104120.3964799-1-aalbersh@kernel.org>
 <aqKgTGHh3nDnM3eh@devuan>
 <20260910161204.GE6238@frogsfrogsfrogs>
 <aqLY-1do_4hmZpfI@devuan>
 <20260910164428.GF6238@frogsfrogsfrogs>
 <aqLfs-6crlKiqZw9@devuan>
MIME-Version: 1.0
In-Reply-To: <aqLfs-6crlKiqZw9@devuan>

[CC trimmed]

Hi Darrick,

> > Date: 2026-09-10 09:44:28-0700
> > From: "Darrick J. Wong" <djwong@kernel.org>
> >
> > quotactl (and xattrs) have a similar weird history of originating in XFS
> > and later getting yanked into the vfs.  Every time I have to go look up
> > the quota syscalls I just get a headache. :/

I have recently worked on having quotactl(2) split into more organized
manual pages.  This has been part of the man-pages-6.19 release.
Have you had a look at these manual pages after that change?  Did the
headache experience improve (or worsen) after this change?

Michael's man7.org already includes the latest version:
<https://www.man7.org/linux/man-pages/man2/quotactl.2.html>

I'd welcome feedback, and any improvements or suggestions to improve
the pages.


Have a lovely night!
Alex

--=20
<https://www.alejandro-colomar.es>

--36qfbwysvk5yvru6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmqjMVkACgkQ64mZXMKQ
wqnW6g//RmLKAIopqRvPSP/CPKFzq1zgWlotwXOFpTMZGs5YOzBuNYRfrgTnB0Um
WR59gXjYwbCOzM5NYB/pS0HqnKhu1CiLQQUH5FqOhdLQKvVioauD3WyRSkL/gAZv
yKe9gD/l405LjQQGFgO6BjwXR5tBEpFSYHmggfq97kz8tznsCl/xseSokte7TBjp
SH9+At8h6arRnhmVmWkQtm/aFT0ri3QyFOOM4VNHT4x+ZZxBsRv2epi/LderjUzw
9zRvt85aATweGVg3p12MGcTlYWWfef+BsyBN3bv7KEZb+PfpZ73lLmXh4BGqEuN4
87bMzUD//6e5cUiirqwdZx35f9Dloewz/3sKfmE52I7s7FQ1lDvYx3bjfxbfshPT
T9XBRxKTl68WRr6sZRyqLe9I/O0h+S0MXk/9Fnw/j+3SZExYpcCz83CPZ3SmkDrg
Uxb73tDO90AlFOrAzIyngpmY1JrYfUr3qoRHdGqqhdB5UJ3FojA0eoH3sW/mNGDH
yXnm5sY3X+KceaidxCOVPup/xeiKKj2c81uKe3F3ltd3HG5DW0USGlUVxktGVv0H
Jsshrb3nZ7nfZ/p40bFrq5rDSQUhc4mwq6Dr28jpoHlLMU8V+qsK9LADiATsFb1B
wRG1TTtpEgkx6lAe5ieiwrH6AdgA9zKH8suHxWvf+1S/1yyfTuE=
=lL1q
-----END PGP SIGNATURE-----

--36qfbwysvk5yvru6--
