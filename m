Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DB23624C5;
	Tue, 15 Sep 2026 20:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789505184; cv=none; b=l1C1gyCcLHF6aF9C0kHlnUNv5aQVliRLV3UQmXtWDNPgVeHyjQwVvhEdBWgPAYP4a0vXyaf0CGtMq9YIuP4ONrHGJty11k6OCpZn/7iYWJcnYZVXHmRBFoy0A3Ze4EPApXqtR/1LoB1vrSk4STWctpCEn8l1MjSPqjPobu1AStw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789505184; c=relaxed/simple;
	bh=G64HOmUdO4nN5UDLxaie23Q4xZ8x8Iz3jSAwQR7PjPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5yZ2W0NH8OKOuTEWp5a2todm/OcTnk/LSreDeJGYM6ODR+WHPn+d+Sur1Sag6vjRCBExH1zVxbntFbWRgE7BSZSISI06El9zmAVW+l7MClSqsXjLfuiXc+V4FJR8gorD3/HDtyDSxqiRMm6bI6Agn8Pz8FbQsx8KIAQR51xYW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RCLTvU+s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RCLTvU+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05141F000FF;
	Tue, 15 Sep 2026 20:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789505182;
	bh=vFvEh0BXCm8Rwq+/Fv1Hx7I2q/7L0MjJQYX3+20MVJ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RCLTvU+s3zGR2kVXFgmVYKRLBG9MGYyl4KFayJ3BKpOT6NJsfaYf+b/to5fHQaB8F
	 4Qp8FtLDC+TR6EYH07KyOi0S3V+mLqIO1Z7tVcjnhMyPvGatHLt+oPEVZI57Lyj0L/
	 dxDYvtM4a7329XfJVsZMESMRWVXbBaWNu8jvQRdhdmMuckfFRE+8dLuZ7ulBXRYCin
	 4YyEPPurHXrtwuDx1MLYErRLa4ttrNHI/aUAFvevLhrLbbQFjYZk/oKVwxtK15ECik
	 9qIATgvqoeuvJg7CycfZJbqjI5i3MG7U0Fn1BdsOQj1Y8Jo549aO+Di8L/z+E57MCZ
	 TLcmzDjpo14SA==
Date: Tue, 15 Sep 2026 22:46:19 +0200
From: Alejandro Colomar <alx@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-man@vger.kernel.org, linux-xfs@vger.kernel.org, 
	mtk.manpages@gmail.com
Subject: Re: quotactl(2) (was: [PATCH v2] man/man2: introduce man page for
 file_getattr/file_setattr syscalls)
Message-ID: <aqmtYCLEnLh-j6Yp@devuan>
References: <20260910104120.3964799-1-aalbersh@kernel.org>
 <aqKgTGHh3nDnM3eh@devuan>
 <20260910161204.GE6238@frogsfrogsfrogs>
 <aqLY-1do_4hmZpfI@devuan>
 <20260910164428.GF6238@frogsfrogsfrogs>
 <aqLfs-6crlKiqZw9@devuan>
 <aqMwVislUcWIRTUb@devuan>
 <20260915181047.GI6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tntiga3r4vzwjjpa"
Content-Disposition: inline
In-Reply-To: <20260915181047.GI6283@frogsfrogsfrogs>


--tntiga3r4vzwjjpa
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-man@vger.kernel.org, linux-xfs@vger.kernel.org, 
	mtk.manpages@gmail.com
Subject: Re: quotactl(2) (was: [PATCH v2] man/man2: introduce man page for
 file_getattr/file_setattr syscalls)
Message-ID: <aqmtYCLEnLh-j6Yp@devuan>
References: <20260910104120.3964799-1-aalbersh@kernel.org>
 <aqKgTGHh3nDnM3eh@devuan>
 <20260910161204.GE6238@frogsfrogsfrogs>
 <aqLY-1do_4hmZpfI@devuan>
 <20260910164428.GF6238@frogsfrogsfrogs>
 <aqLfs-6crlKiqZw9@devuan>
 <aqMwVislUcWIRTUb@devuan>
 <20260915181047.GI6283@frogsfrogsfrogs>
MIME-Version: 1.0
In-Reply-To: <20260915181047.GI6283@frogsfrogsfrogs>

Hey Darrick,

> Date: 2026-09-15 11:10:47-0700
> From: "Darrick J. Wong" <djwong@kernel.org>
>
> On Fri, Sep 11, 2026 at 12:38:23AM +0200, Alejandro Colomar wrote:
> > [CC trimmed]
> >=20
> > Hi Darrick,
> >=20
> > > > Date: 2026-09-10 09:44:28-0700
> > > > From: "Darrick J. Wong" <djwong@kernel.org>
> > > >
> > > > quotactl (and xattrs) have a similar weird history of originating i=
n XFS
> > > > and later getting yanked into the vfs.  Every time I have to go loo=
k up
> > > > the quota syscalls I just get a headache. :/
> >=20
> > I have recently worked on having quotactl(2) split into more organized
> > manual pages.  This has been part of the man-pages-6.19 release.
> > Have you had a look at these manual pages after that change?  Did the
> > headache experience improve (or worsen) after this change?
> >=20
> > Michael's man7.org already includes the latest version:
> > <https://www.man7.org/linux/man-pages/man2/quotactl.2.html>
> >=20
> > I'd welcome feedback, and any improvements or suggestions to improve
> > the pages.
>=20
> Oh hey, that /is/ a lot better!

Thanks!!  Michael didn't like these splitting changes at first (I don't
know if I've convinced him yet), but it's good to see users that like
the change.  :-)

> The only addition I can think of is that QUOTAOFF generally isn't
> supported anymore.

Oh, thanks!  I can add a note that it's deprecated.  If you want to add
a more specific note saying it fails for new kernels, I'd need some
information for preparing a patch:

-  Is it reporting an error?
-  If so, which error?
-  Which kernel version dropped support?
-  You said 'generally'.  In which cases is it still supported?
-  Any other ideas about it?

> Thanks for breaking up that big messy manpage. :)

Thank you for liking it!  :)


Have a lovely night!
Alex

>=20
> --D

--=20
<https://www.alejandro-colomar.es>

--tntiga3r4vzwjjpa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmqprpsACgkQ64mZXMKQ
wqk+dQ//RkH+emcrsrlE4kwsJF0FFMCyn+oHM/MKdwqUi4U5PWfOvOZTtzb8uEHQ
XFIuAaU40EfuFtxMvy4hrvYg3ePLCGcVxFi4GU0YkVPnOHV+CIQ0FEzw2NCukfSs
MCvjnWVWZzfJOlfAFryC0vCJPxp98bq5uOsOgAlz7ZqvLM4nzGXZ/46vpS/3kkLQ
d+3s2pZDu7GFJ6mkJp0YfHQMPIAvMUC4VMYL6LoQ+Vlr2Rl8Dj7KK0xzglxQZgXR
q0TlV1t2IC+zRSQTGr0YzOLVQ0n/lwE5ourMR6wpWOtT64GnOQx+B0z3d22NvpAZ
7FD4QJ8rbHt3mfKus21E/vV1ymdr8Y/FNFTgNMXoU79sc9+Rur0TaHo/QUVqUXKS
r5DsdvND/A+sPK0t+Mu9q2YsBWEIvzzxAkXXHUVvCLc+5cZ21qjxEbnqdFPOU871
bV4S6LbAFLBFbc7IdfBgQvqTNOlc4KV8hyJkK3jADrOqR4zRyoADlah3XE3fYpv1
4psBOP9QeibTiZAJDeUxZkMAGo2du0Vw03F0UwWSPIvdkKueS63eR+iuvBls5woU
QORZHFCzFbU45qdi09n3xTUu5yE3hacZsfbctHEo1MkvFoC9l03FU1W++P099d+u
PWv5gq4MHrQwdNJbD+pZ8oD3CWMOig3aJGuOywMz7l0Iz5/HF0U=
=sxXa
-----END PGP SIGNATURE-----

--tntiga3r4vzwjjpa--
