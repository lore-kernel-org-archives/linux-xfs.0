Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46233 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbdJCUVY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:21:24 -0400
Date: Tue, 3 Oct 2017 22:21:21 +0200
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC 5/5] pm: remove kernel thread freezing
Message-ID: <20171003202121.GB23521@amd>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-6-mcgrof@kernel.org>
 <20171003201204.GA23521@amd>
 <nycvar.YFH.7.76.1710032213430.17517@jbgna.fhfr.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1710032213430.17517@jbgna.fhfr.qr>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jiri Kosina <jikos@kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, rjw@rjwysocki.net, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org


--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Can memory management doing background writes be a problem?
>=20
> This point I don't understand. What exactly do you mean?

Hibernation:

We freeze, do system snapshot, unfreeze, and write image to
disk. Memory management wakes up (this used to be called bdflush),
decides its time to write some dirty data back to disk. Powerdown.

But state on the disk now does not correspond to what the image
expects. Problem?
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlnT8UEACgkQMOfwapXb+vLLvQCgrbah0w4pswij9x8mDaOZ8tWj
JkEAnjAiMGrtMKQEmesRF5Lv5Xdr1ocD
=OMiR
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--
