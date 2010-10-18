Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9I6cDbu174927 for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 01:38:14 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 982FB1516B7F
	for <xfs@oss.sgi.com>; Sun, 17 Oct 2010 23:54:11 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id We3sp49M7aBE4WWO for
	<xfs@oss.sgi.com>; Sun, 17 Oct 2010 23:54:11 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [RFC,
	PATCH 0/2] xfs: dynamic speculative preallocation for delalloc
Date: Mon, 18 Oct 2010 08:39:15 +0200
References: <C8DCC927.48D3%ivan.novick@emc.com> <201010171631.53183@zmi.at>
	<20101017234905.GG29677@dastard>
In-Reply-To: <20101017234905.GG29677@dastard>
MIME-Version: 1.0
Message-Id: <201010180839.20418@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2306293549808186538=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2306293549808186538==
Content-Type: multipart/signed;
  boundary="nextPart1697374.EtrhjPgxj6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1697374.EtrhjPgxj6
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 18. Oktober 2010 Dave Chinner wrote:
> delalloc does not do any waiting. The system decides when to flush
> data to disk. We even do delalloc for sync writes - the system
> flushes the data to disk immediately instead of via memory pressure
> or background writeback.
>=20
> > Isn't that controlled by the values of=20
> > vm.dirty_background_bytes and vm.dirty_expire_centisecs and=20
> > vm.dirty_writeback_centisecs?
>=20
> Exactly.
>=20
> > Then dirty_background_bytes would be the=20
> > maximum possible delalloc size?
>=20
> No. Those numbers control the amount of dirty pages in memory, not
> the amount of space we've allocated speculatively. Indeed, by
> definition speculative allocation past EOF means it is space that
> currently has no dirty pages.... ;)

The big picture is becoming clearer, but I still don't get it. So=20
delalloc is not really about delayed allocation, but more a speculation=20
about needed filesizes, combined with in-memory preallocation of=20
physical blocks on the storage? So it's "future allocation with delayed=20
data filling". Or what is "delayed allocation" refering to, when data=20
can be on disk already?

You wrote in another mail:
> that is the default behaviour for _physical_ extent allocation
> on files larger than one stripe unit (i.e stripe aligned and sized
> allocation). That is very different from speculative allocation done
> at delayed allocation time, which is purely in-memory until physical
> allocation occurs

So when a file is slowly uploaded, delalloc can imagine it will be 1MB=20
on disk, and reserve that space in-memory. And when a write occurs,=20
because dirty_background_bytes is hit, the fragments will be written,=20
and the full 1MB is physically reserved on disk. Then more data arrives,=20
delalloc now imagines the file will be 100MB on disk, it will reserve=20
that space, first in-memory and after the next buffer flush on disk. Is=20
it like this?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Radiointerview zum Thema Spam ******
http://www.it-podcast.at/archiv.html#podcast-100716

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1697374.EtrhjPgxj6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAky765gACgkQzhSR9xwSCbSNzgCfaq+0cZcyXxwMUFuQG2e7Jb+9
wvsAoMqUDURlm65ywQDSfAFxQtljt3Ha
=gPcA
-----END PGP SIGNATURE-----

--nextPart1697374.EtrhjPgxj6--


--===============2306293549808186538==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2306293549808186538==--
