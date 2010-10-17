Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9HEUlex068358 for <xfs@oss.sgi.com>; Sun, 17 Oct 2010 09:30:47 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B6409FAEC8
	for <xfs@oss.sgi.com>; Sun, 17 Oct 2010 07:31:56 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id bcL6sKnLLJ5nEVen for
	<xfs@oss.sgi.com>; Sun, 17 Oct 2010 07:31:56 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [RFC,
	PATCH 0/2] xfs: dynamic speculative preallocation for delalloc
Date: Sun, 17 Oct 2010 16:31:48 +0200
References: <C8DCC927.48D3%ivan.novick@emc.com> <201010150914.55604@zmi.at>
	<20101015114508.GI4681@dastard>
In-Reply-To: <20101015114508.GI4681@dastard>
MIME-Version: 1.0
Message-Id: <201010171631.53183@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2910639957306963714=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2910639957306963714==
Content-Type: multipart/signed;
  boundary="nextPart5828544.gkqh0x8fkP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart5828544.gkqh0x8fkP
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 15. Oktober 2010 Dave Chinner wrote:
> On Fri, Oct 15, 2010 at 09:14:54AM +0200, Michael Monnerie wrote:
> > The question is: what is a good value for preallocation?
>=20
> If you can't answer that, use the defaults.

Who can really without testing? For a webserver, hosting hundreds of=20
different websites, with many ftp uploads and where the rest of the=20
writes are webservers temp and log files, do you know the best value=20
without investigation? That's what I meant.
=20
> > I'd guess for a database 1GB seems reasonable,
>=20
> depends on  your database. If it does direct IO, then allocsize is
> completely meaningless....

True, I was thinking of postgresql and mysql (innodb, 1 file per table).=20
Both increment file sizes when needed.
=20
> IIRC, that is the default behaviour for _physical_ extent allocation
> on files larger than one stripe unit (i.e stripe aligned and sized
> allocation). That is very different from speculative allocation done
> at delayed allocation time, which is purely in-memory until physical
> allocation occurs.

Together with your other answer (swalloc...) I get the picture now. So=20
delalloc, speculative prealloc, and physical allocation are done, where=20
the first two are in-memory. And the mount option allocsize sets the=20
delalloc size.
=20
Now something comes to my mind: When I make an ftp upload, it's very=20
slow in terms of disk speed. Say 2MB/s. How long would delalloc wait=20
before flushing buffers on disk?=20

Isn't that controlled by the values of=20
vm.dirty_background_bytes and vm.dirty_expire_centisecs and=20
vm.dirty_writeback_centisecs? Then dirty_background_bytes would be the=20
maximum possible delalloc size? But it's value is the top for the whole=20
machine, so it would need to be much higher than I want it to be for a=20
specific filesystem.
Or are those values controllable per mount?

Sorry for my maybe boring questions, I'm trying to understand how to get=20
the most out of a server with lot's of VMs, and tuning seems to help=20
(and be needed) a lot in this situation.

> Nobody should need to use the allocsize mount option except in
> extreme corner cases, and that is what my patchset attempts to
> achieve.

Sounds good :-)

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

--nextPart5828544.gkqh0x8fkP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAky7CNkACgkQzhSR9xwSCbQ1wgCfW1aIJPXsClg+tm3/cVv7KX6V
HyMAnid/QKq75eL5MuVBcMozyoXD/m2l
=sTLv
-----END PGP SIGNATURE-----

--nextPart5828544.gkqh0x8fkP--


--===============2910639957306963714==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2910639957306963714==--
