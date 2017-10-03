Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47671 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdJCU5m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:57:42 -0400
Date: Tue, 3 Oct 2017 22:57:40 +0200
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC 5/5] pm: remove kernel thread freezing
Message-ID: <20171003205739.GA30569@amd>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-6-mcgrof@kernel.org>
 <20171003201204.GA23521@amd>
 <nycvar.YFH.7.76.1710032213430.17517@jbgna.fhfr.qr>
 <20171003202121.GB23521@amd>
 <nycvar.YFH.7.76.1710032230450.17517@jbgna.fhfr.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1710032230450.17517@jbgna.fhfr.qr>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jiri Kosina <jikos@kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, rjw@rjwysocki.net, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-10-03 22:38:33, Jiri Kosina wrote:
> On Tue, 3 Oct 2017, Pavel Machek wrote:
>=20
> > > This point I don't understand. What exactly do you mean?
> >=20
> > Hibernation:
> >=20
> > We freeze, do system snapshot, unfreeze, and write image to
> > disk.=20
>=20
> Where/why do you unfreeze between creating the snapshot and writing it=20
> out?

Yep, sorry, we don't unfreeze.

> Again, I agree that the (rare) kthreads that are actually "creating" new=
=20
> I/O have to be somehow frozen and require special care.

Agreed. Was any effort made to identify those special kernel threads?
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlnT+cMACgkQMOfwapXb+vJZRACgnK0rPBu5eEwrtu4Z/M0CeMvv
bwYAnj03qFiTPP6ma8EI5saORXD+8emK
=jpug
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
