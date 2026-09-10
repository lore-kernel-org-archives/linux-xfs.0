Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1412E381B0F;
	Thu, 10 Sep 2026 16:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789057920; cv=none; b=sHhtAg8z/WEUyUopG6FAwWUBhxTZpWVi3mYDeXP7jt3delDxnrbUZ8MREf77bXMK9Ecav7VsWLZbwEW5YDTRl8YE19N9votydY06YxNINZqshFwXEVXtXFhg0A9E49bBhCDHl76yLk7c97pUGX/msz97aCJBDdG55NiV9eqI+Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789057920; c=relaxed/simple;
	bh=YxpH7ZodGeXHax27ES3ZIvnJ1qNocBm5pBmGblwlJWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dTfZSbOkJHom6gOY12N8CumK42UrC8Rbi/a6ijT6U1VsJ9rYxN/H4rN3JJX3Jw+vVoP7srcFT1RBDwDRAgmfVU5m9EdRYL3GeDSmD5nglg66/yTiiGPtD7sws7RAS5/D4lZqwaQTxJWoLlhvJfx+We0SauGYhPql6FPrtWR6Rjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E1ZLf2iv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E1ZLf2iv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EDC1F00893;
	Thu, 10 Sep 2026 16:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789057914;
	bh=3LVeqwi5tm4sdZt9Csi8D/LF9DDraSSeruA3CeYpsdY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E1ZLf2ivFGMab2p8sxPaumqZMOWoB7DfCGEdDK+IFQClCQumb6KCK4TrcTkE7enoy
	 nD6NOz9+YLb4aaT+l2SRbr1nZWaLcSYdBi9KaCslIz3JBfh6+ZOXveM0ScJDoV/f9z
	 CiOirhXvgPYov2d5q+xL4S5qpph5xQ8lFx3Dw3gs3UHZbxyx+amI353Bd6oxKbOCEf
	 A3deLJF85TibLrihhJNWe3hFzzCXxPERp0xtFdPAkxc75v0Q2OINQiLO5fDor4QZJf
	 xOd6wZmy3PL+EKguFwD0U6ymX6jrcwCiJU4E8otWfDNvD0YamfauDZiAxcLkZH8up8
	 TM3CkRXjnis2A==
Date: Thu, 10 Sep 2026 18:31:48 +0200
From: Alejandro Colomar <alx@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-man@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	linux-api@vger.kernel.org
Subject: Re: [PATCH v2] man/man2: introduce man page for
 file_getattr/file_setattr syscalls
Message-ID: <aqLY-1do_4hmZpfI@devuan>
References: <20260910104120.3964799-1-aalbersh@kernel.org>
 <aqKgTGHh3nDnM3eh@devuan>
 <20260910161204.GE6238@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fgwke4pvnxo2zsjv"
Content-Disposition: inline
In-Reply-To: <20260910161204.GE6238@frogsfrogsfrogs>


--fgwke4pvnxo2zsjv
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
Message-ID: <aqLY-1do_4hmZpfI@devuan>
References: <20260910104120.3964799-1-aalbersh@kernel.org>
 <aqKgTGHh3nDnM3eh@devuan>
 <20260910161204.GE6238@frogsfrogsfrogs>
MIME-Version: 1.0
In-Reply-To: <20260910161204.GE6238@frogsfrogsfrogs>

Hi Darrick,

> Date: 2026-09-10 09:12:04-0700
> From: "Darrick J. Wong" <djwong@kernel.org>
>
> On Thu, Sep 10, 2026 at 03:20:25PM +0200, Alejandro Colomar wrote:
> >=20
> > > Date: 2026-09-10 12:41:18+0200
> > > From: Andrey Albershteyn <aalbersh@kernel.org>
[...]
> > > +.SH DESCRIPTION
> > > +The
> > > +.BR file_getattr ()
> > > +system call retrieves filesystem file attributes
> > > +from the file specified by
> > > +.IR pathname .
> > > +.P
> > > +This system call provides functionality similar to the
> > > +.B FS_IOC_FSGETXATTR
> > > +.BR ioctl (2)
> > > +operation,
> >=20
> > Should we document FS_IOC_FSGETXATTR in a new FS_IOC_FSGETXATTR(2const)
> > manual page?
>=20
> https://www.man7.org/linux/man-pages/man2/ioctl_xfs_fssetxattr.2.html

Thanks!  I didn't know that page.

I see the page uses the constants as XFS_ instead of FS_?  I think the
page should have some mention about it, especially since it says non-xfs
filesystems also implement this.  Is it the same as (or related to)
what's mentioned in quotactl(2)?

	NOTES
	   Alternative XFS header
	     Instead of <xfs/xqm.h> one  can  use  <linux/dqblk_xfs.h>,
	     taking into account that there are several naming discrep=E2=80=90
	     ancies:

	     =E2=80=A2  Quota       enabling       flags       (of       format
		XFS_QUOTA_[UGP]DQ_{ACCT,ENFD}) are  defined  without  a
		leading "X", as FS_QUOTA_[UGP]DQ_{ACCT,ENFD}.

	     =E2=80=A2  The  same is true for XFS_{USER,GROUP,PROJ}_QUOTA quota
		type     flags,     which      are      defined      as
		FS_{USER,GROUP,PROJ}_QUOTA.

	     =E2=80=A2  The  dqblk_xfs.h  header  file  defines its own XQM_US=E2=
=80=90
		RQUOTA, XQM_GRPQUOTA, and  XQM_PRJQUOTA  constants  for
		the  available  quota  types,  but their values are the
		same as for constants without the XQM_ prefix.

I think we should probably have a xfs-xqm(2head) manual page documenting
these conventions, I think.

Also, given it doesn't seem exclusive of xfs, should we move the manual
page to the Linux man-pages (from xfsprogs)?

> > > +but with the advantage that the file does not need to be opened.
> > > +By using a pathname,
> > > +.BR file_getattr ()
> > > +can retrieve filesystem file attributes
> > > +from all file types,
> > > +including special files such as FIFOs, sockets, block devices, chara=
cter
> > > +devices, and symlinks, where opening the targeted inode may not be p=
ossible.
> >=20
> > This seems to be a limitation of FS_IOC_FSGETXATTR(2const), and would be
> > more appropriately documented in that page (if we add it).  There, I'd
> > document it in CAVEATS.  Then, file_getattr(2) wouldn't need to mention
> > this at all, because it's not an issue here.
>=20
> Agreed, that belongs in ioctl_xfs_fssetxattr.2, not here.

Thanks!

>=20
> --D

Have a lovely day!
Alex

--=20
<https://www.alejandro-colomar.es>

--fgwke4pvnxo2zsjv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmqi228ACgkQ64mZXMKQ
wqmfXxAAjSgsmtd8P9/3PN7tRrwstiIyXdAqkN2/xHpXYjhxOK7botRqEoWzFmos
TcwK/Z2kPrW6kYMmoauOkUoAV7X85ca/7kSGHRKBBM8M+R4U4s88fobOkoGDag/0
6y6zpbd9XGJRNdxT1b4EUp6eh7SOwR53ZKMfoPxLXJ4peaq+idbIHiIfP3u76ERx
yIop7uAd+pwJjGZtwmwZb71rzIMjbK/nXbHj6JRW4jsjCc7Ltm5fN/SeLaAbNkgH
NFPlAnyQIRH16R/bafNW33PCklG6+KQGjCcrhN5wkNKdXgpTE/hhibw53khVt1Ya
Fevpzl9gZOwWPRytV4XWEzJVonR1+prhY6WomsRdpkZCut7BLA6JCBlTg0b5C091
gtJPo0KjaEy5pEvSsl926Lg1T7ffh6zLfT+fj6OCMjETg88h1CcevdDFWM+U9Ru9
Ov8v8C0BnlGxqjHLfb/oyLJU6ycHRRahqv9eZh3Dppjg3ImbkRbjJMVAALpBD3dQ
zOswuHDocrboPJMX/Y5tddbmLvoDgKhSJvmzMqgVk+5cOBuhYIQIrrxWhZ/xpMSv
pdy5d5Y+ugtbt5a4JdLNvx/ThpLgKX5eAsciKKnlvqQf0Zb5ggZbq1nByx8fb92r
ENIJxvxSljdSlrmOJ3yBZPxrUqNv9vGdxjJke3EWyFgZ5p4jpbw=
=qNIN
-----END PGP SIGNATURE-----

--fgwke4pvnxo2zsjv--
