Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 18 Oct 2008 12:47:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9IJjpZU001354
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 12:45:51 -0700
Received: from ug-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A8D7C10D3B33
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 12:47:32 -0700 (PDT)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.175]) by cuda.sgi.com with ESMTP id PW6uZrMvT238x0q8 for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 12:47:32 -0700 (PDT)
Received: by ug-out-1314.google.com with SMTP id k3so306894ugf.9
        for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 12:47:31 -0700 (PDT)
Date: Sat, 18 Oct 2008 22:48:53 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: XFS filesystem corruption on the arm(el) architecture
Message-ID: <20081018194851.GA2083@localhost.localdomain>
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net> <20081017070109.GA30726@deprecation.cyrius.com> <20081017094615.GT4504@soziologie.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <20081017094615.GT4504@soziologie.ch>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Michlmayr <tbm@cyrius.com>, Eric Sandeen <sandeen@sandeen.net>, Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org, debian-arm@lists.debian.org, xfs@oss.sgi.com

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2008 at 11:46:15AM +0200, Gaudenz Steinlin wrote:
> On Fri, Oct 17, 2008 at 09:01:09AM +0200, Martin Michlmayr wrote:
> > * Eric Sandeen <sandeen@sandeen.net> [2008-10-16 17:13]:
> > > So is this a regression?  did it used to work?  If so, when? :)
> >=20
> > The original report was with 2.6.18 but that was with the old ABI:
> > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D423562
> > I just installed a 2.6.22 kernel with EABI and I can also trigger
> > the bug.  So it's not a (recent) regression.
>=20
> As far as I can remember (I only used old ABI arm) this is not a=20
> regression. XFS never worked on arm for me.

You are wrong.=20

Our team have experience with XFS on ARM OABI on NAS. It worked fine on
2.6.12, but got broken on 2.6.17.

http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D712

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj6PaMACgkQbWYnhzC5v6r+NQCeNIhqvLMHizWqy2JUmZ0DHRqE
4OMAn0fGG3BBlfoOjv75tZwHdlLmmxeT
=6Tsu
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
