Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6820637E2E5;
	Thu, 10 Sep 2026 16:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789059052; cv=none; b=NhIWAhlmwRWJFQheK35qpgMpw3Mu62TWEsoNGURRlr8yKo2OQxGlm/COLJRUbjieyhs+MJe/aMab/iLS3rdFrKxG9leM8ds6ex7pNqrqDNJRHiPs1cbfWTQlrQJO1sMWtZG6SkiuwHh2eq7sy4XqMRq8+B3DSQL3o5yBsLHVPQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789059052; c=relaxed/simple;
	bh=ve+YzAe1THUrssJx9M0hn0ogePi0eRNIQbzjOTvRZBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kRQHszbEPnhkd4isG+5eTIlopqmh1dgMXuxVwELdT0PggxC6IObmP5A8yNh/gJcXXpg0jF1Jq7gJiSIISxXJ5dgJhjMR62sarBh/0RMScoKssK+bXHJa3PdmaluoBBElMYwOGwyKwwP0uFa/1oK3M32xTGKm/9H8bDZs/+sDBng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gBOAFJFX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gBOAFJFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC68E1F000FF;
	Thu, 10 Sep 2026 16:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789059050;
	bh=IqJaHL1SoRN/fotdlqk5VLMGRkmaCB9LrRkSUPHbFYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gBOAFJFXcsUfzZ7HUbA2L4BZ/os79bLL9sOZgRLs+QlBJSJOQ9RapQCnGB3aBUfua
	 dU4uAhYx4Ex4W7yZ8J1OKmWo9jLpC4xIlQ+FqBupnW42bnSg8aJi/pYdqZ04e92yUd
	 Kxf5Arcsc6UTWxPzArcx9PNNdg0hyysSJyrgydPuhURYVcHD90qTNOm+fkNsi+Es/p
	 x0fsJv2vtUtcQSGs4X3uCWnTV2WW9Hjkr7hiJc7NU+nKPWc4v44ugdz21y5vYaZ9TL
	 0+G/AOSfXmU7SOsAUirPtDS9Tm6eiLyxNMtwHc228ZMAFuVYKTf8WujBfcO/I9+Y+q
	 ZL+hMLxpHPoig==
Date: Thu, 10 Sep 2026 18:50:46 +0200
From: Alejandro Colomar <alx@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-man@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	linux-api@vger.kernel.org
Subject: Re: [PATCH v2] man/man2: introduce man page for
 file_getattr/file_setattr syscalls
Message-ID: <aqLfs-6crlKiqZw9@devuan>
References: <20260910104120.3964799-1-aalbersh@kernel.org>
 <aqKgTGHh3nDnM3eh@devuan>
 <20260910161204.GE6238@frogsfrogsfrogs>
 <aqLY-1do_4hmZpfI@devuan>
 <20260910164428.GF6238@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5wzgosbtrgpzmppd"
Content-Disposition: inline
In-Reply-To: <20260910164428.GF6238@frogsfrogsfrogs>


--5wzgosbtrgpzmppd
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-man@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	linux-api@vger.kernel.org
Subject: Re: [PATCH v2] man/man2: introduce man page for
 file_getattr/file_setattr syscalls
Message-ID: <aqLfs-6crlKiqZw9@devuan>
References: <20260910104120.3964799-1-aalbersh@kernel.org>
 <aqKgTGHh3nDnM3eh@devuan>
 <20260910161204.GE6238@frogsfrogsfrogs>
 <aqLY-1do_4hmZpfI@devuan>
 <20260910164428.GF6238@frogsfrogsfrogs>
MIME-Version: 1.0
In-Reply-To: <20260910164428.GF6238@frogsfrogsfrogs>

Hi Darrick,

> Date: 2026-09-10 09:44:28-0700
> From: "Darrick J. Wong" <djwong@kernel.org>
>
[...]
> > > > Should we document FS_IOC_FSGETXATTR in a new FS_IOC_FSGETXATTR(2co=
nst)
> > > > manual page?
> > >=20
> > > https://www.man7.org/linux/man-pages/man2/ioctl_xfs_fssetxattr.2.html
> >=20
> > Thanks!  I didn't know that page.
> >=20
> > I see the page uses the constants as XFS_ instead of FS_?  I think the
>=20
> The sorded history of the xfs(ish) file attributes calls is that they
> began their lives as XFS_IOC_FSGETXATTR since they were XFS-specific.
> Then we tried to make them "generic" by removing the 'X', and that's how
> we got FS_IOC_FSGETXATTR.  Finally Andrey came along and made them
> proper syscalls with path-lookup abilities ... but for now they use the
> same struct as the old XFS_IOC_FSGETXATTR.
>=20
> Personally I think we should only document XFS_IOC_FSGETXATTR (in
> xfsprogs) and file_getattr (in man-pages).  And leave FS_IOC_FSGETXATTR
> unmentioned.
>=20
[...]
>=20
> quotactl (and xattrs) have a similar weird history of originating in XFS
> and later getting yanked into the vfs.  Every time I have to go look up
> the quota syscalls I just get a headache. :/

Thanks!  That makes sense.  :)


Cheers,
Alex

>=20
> --D

--=20
<https://www.alejandro-colomar.es>

--5wzgosbtrgpzmppd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmqi3+AACgkQ64mZXMKQ
wqnqGA//UFWo6BWamWW0lHUOwM1TBq/jb8eQNiDgOZ8S/EEotA/iGJSxnjFasvcW
dxSaYDVVfom1gEWv1UDGO56rwVDB2Onwj65k3OJZ+JYm9o04VvRZ5ZeMxWXPXmxV
AmTpan0viSRx0ZYMiBTDEkDDc0M8qnh5msYUyif4HLnDqVg5JBOBQ6byfd90x8Jw
wwvC3TR0P8nZDxIPfoRmtk1Y3Cw5R6YNevcv4YILsTA8tMXNoirqE88zSsNRkL6l
ZY8dwetCnS+FjlI/qDBrWEIHoXh+6Clzbj5Uk1HFE20e0uA/RALMjvr1FQGd95K/
34yuJMo8K+ydyVjggpWT10D5cIDaZ8RBa4qJadS30l/UGkDkshHLx/dJ0ZvG3tFx
mfb7x/AfH7PkpE88bAw1IIhf3x9a3YbCNbzjj9Sc+dpBorQebEoZAKlrzqAEH5JR
gqKy56L6enutEO7UwZp2MkTFcUjM2MvKEIwm3ZCxOxunj7LFtkVl+8Noy8xGdACD
FhZso906rr4wnHvXmE4mVV6i7QZevqAO7m/EXyl3qnXX5AmeMVKiDZL6nBJx1cFp
yOX+g/faY3pFJyBZMG1KRptNBTuITHLoig3DJdKbeCbszOOf2E5b7URsM8cxIaUJ
BmtGCalk11zMO8TJKG/cM3d0gkhI0Fu5T2/BiRPecE6S0iF4vq0=
=3ZuC
-----END PGP SIGNATURE-----

--5wzgosbtrgpzmppd--
