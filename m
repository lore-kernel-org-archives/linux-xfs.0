Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4CpjIG029146 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 06:51:45 -0600
Received: from smtps.tip.net.au (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 263C016956C7
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 04:51:43 -0800 (PST)
Received: from smtps.tip.net.au (chilli.pcug.org.au [203.10.76.44]) by
	cuda.sgi.com with ESMTP id K7ABDKyHvH1QhRH1 for
	<xfs@oss.sgi.com>; Thu, 04 Dec 2008 04:51:43 -0800 (PST)
Date: Thu, 4 Dec 2008 23:46:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: XFS breakage on m68k (was: Re: linux-next: Tree for December 3)
Message-Id: <20081204234603.b5a28cd6.sfr@canb.auug.org.au>
In-Reply-To: <20081204121330.GA18815@infradead.org>
References: <20081203183602.c06f8c39.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0812040956370.10635@anakin>
	<20081204121330.GA18815@infradead.org>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7132473538437081520=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-next@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Christoph Hellwig <hch@lst.de>

--===============7132473538437081520==
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__4_Dec_2008_23_46_03_+1100_Y4i_FBnC6Lw+PbDs"

--Signature=_Thu__4_Dec_2008_23_46_03_+1100_Y4i_FBnC6Lw+PbDs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Thu, 4 Dec 2008 07:13:30 -0500 Christoph Hellwig <hch@infradead.org> wro=
te:
>
> On Thu, Dec 04, 2008 at 10:02:15AM +0100, Geert Uytterhoeven wrote:
> > On Wed, 3 Dec 2008, Stephen Rothwell wrote:
> > > Status of my local build tests will be at
> > > http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> > > advice about cross compilers/configs that work, we are always open to=
 add
> > > more builds.
> >=20
> > On m68k (32-bit only, no compat32), XFS fails to build in linux-next:
>=20
> Yeah, it's broken on all 32bit platforms.  Today's xfs tree has a fix
> for it.

I tried that tree but got this error from a powerpc ppc64_defconfig build
(which is 64 bit):

fs/xfs/linux-2.6/xfs_file.c:365: error: 'xfs_file_compat_invis_ioctl' undec=
lared here (not in a function)

Eric mentioned that your patch "had a problem of its own", so I assumed
that was it and left it removed from today's linux-next.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__4_Dec_2008_23_46_03_+1100_Y4i_FBnC6Lw+PbDs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk30QsACgkQjjKRsyhoI8x5WACgmRsYcHOOMlUMk0zCz8iRXkm5
OB4An3bYWlAaP8j5dF+vffc9iKvlEtmh
=YjVi
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Dec_2008_23_46_03_+1100_Y4i_FBnC6Lw+PbDs--


--===============7132473538437081520==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7132473538437081520==--
