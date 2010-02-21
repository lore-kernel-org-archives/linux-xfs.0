Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1LJl86Y059936 for <xfs@oss.sgi.com>; Sun, 21 Feb 2010 13:47:09 -0600
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 79F6B13C4477
	for <xfs@oss.sgi.com>; Sun, 21 Feb 2010 11:48:26 -0800 (PST)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id 3RK17TEpaIRJgXP9 for <xfs@oss.sgi.com>;
	Sun, 21 Feb 2010 11:48:26 -0800 (PST)
Date: Mon, 22 Feb 2010 08:47:53 +1300
From: Johannes Buchner <buchner.johannes@gmx.at>
Subject: Re: [patch 0/7] per-bdi flushing model improvements. reiser4
Message-Id: <20100222084753.0a5d613c.buchner.johannes@gmx.at>
In-Reply-To: <4B68A68C.6030001@gmail.com>
References: <201002020255.46920.edward.shishkin@gmail.com>
	<20100202081728.GA2384@infradead.org> <4B6843E9.9070600@gmail.com>
	<20100202194208.GD5733@kernel.dk>
	<5e2ec5ac1002021345g569c743dtc5ccf77cde6738ae@mail.gmail.com>
	<4B68A68C.6030001@gmail.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4747411232619805994=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Edward Shishkin <edward.shishkin@gmail.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>, linux-kernel@vger.kernel.org, Andrew@oss.sgi.com, ReiserFS Development List <reiserfs-devel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Ronni Holm-Nielsen <theronni@gmail.com>, Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com

--===============4747411232619805994==
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Feb_2010_08_47_53_+1300__Sx+aOQ/8.uWm8.0"

--Signature=_Mon__22_Feb_2010_08_47_53_+1300__Sx+aOQ/8.uWm8.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi.

Thank you Edward. The related bug was/is
http://bugzilla.kernel.org/show_bug.cgi?id=3D14915
It'd be great if someone could solve this, as the reiser4 patch is
not usable in its current state, with or without my illfated attempts
to fix it.

Kind regards,
Johannes

On Tue, 02 Feb 2010 23:26:20 +0100
Edward Shishkin <edward.shishkin@gmail.com> wrote:

> Hello everyone.
>=20
> The patches 1-3 are reverses for the following -mm stuff:
>=20
> http://userweb.kernel.org/~akpm/mmotm/broken-out/reiser4-fixed-null-point=
er-dereference.patch
> http://userweb.kernel.org/~akpm/mmotm/broken-out/reiser4-generic_sync_sb_=
inodes-doesnt-exist-anymore.patch
> http://userweb.kernel.org/~akpm/mmotm/broken-out/reiser4-vfs-add-super_op=
erationssync_inodes-2.patch
>=20
> This is incorrect attempts to adjust reiser4 to the new per-bdi
> flushing model.
> The authors are cc-ed,
> any comments, suggestions are welcome.
>=20
> Thanks,
> Edward.
>=20
>=20
> Ronni Holm-Nielsen wrote:
> > To clarify (being a ReiserFS subscriber):
> >
> > patch 0, 4-6 sent to Andrew, ReiserFS, linux-fsdevel, linux-kernel,
> > xfs, jens.axboe
> > patch 1-3, 7 sent to Andrew, ReiserFS
> >
> > - Ronni
> >
> > On Tue, Feb 2, 2010 at 11:42 PM, Jens Axboe <jens.axboe@oracle.com>
> > wrote:
> >
> >  =20
> >> On Tue, Feb 02 2010, Edward Shishkin wrote:
> >>    =20
> >>> Christoph Hellwig wrote:
> >>>      =20
> >>>> I got this introduction twice, but patches 1-3 didn't make it to
> >>>> any of the lists.
> >>>>
> >>>>
> >>>>
> >>>>        =20
> >>> done
> >>>      =20
> >> Where?
> >>
> >> --
> >> Jens Axboe
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe
> >> reiserfs-devel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >>    =20
> >
> >
> >
> >  =20


--=20
Emails k=F6nnen ge=E4ndert, gef=E4lscht und eingesehen werden. Signiere oder
versch=FCssele deine Mails mit GPG.
http://web.student.tuwien.ac.at/~e0625457/pgp.html

--Signature=_Mon__22_Feb_2010_08_47_53_+1300__Sx+aOQ/8.uWm8.0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkuBje4ACgkQ7X1+MfqVcr0wLgCeOJ7XVuqYHjy4twdFtIiBA82l
v6MAoJSr/2YiUOOLKnaAfONO7YbTKGUc
=1YuB
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Feb_2010_08_47_53_+1300__Sx+aOQ/8.uWm8.0--


--===============4747411232619805994==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4747411232619805994==--
