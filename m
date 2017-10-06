Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51422 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751913AbdJFMHP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2017 08:07:15 -0400
Date: Fri, 6 Oct 2017 14:07:13 +0200
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC 5/5] pm: remove kernel thread freezing
Message-ID: <20171006120713.GG9497@amd>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-6-mcgrof@kernel.org>
 <20171003201204.GA23521@amd>
 <20171003204940.GA5659@wotan.suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/i8j2F0k9BYX4qLc"
Content-Disposition: inline
In-Reply-To: <20171003204940.GA5659@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org


--/i8j2F0k9BYX4qLc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-10-03 22:49:40, Luis R. Rodriguez wrote:
> On Tue, Oct 03, 2017 at 10:12:04PM +0200, Pavel Machek wrote:
> > On Tue 2017-10-03 11:53:13, Luis R. Rodriguez wrote:
> > > Now that all filesystems which used to rely on kthread
> > > freezing have been converted to filesystem freeze/thawing
> > > we can remove the kernel kthread freezer.
> >=20
> > Are you surely-sure? You mentioned other in kernel sources of writes;
> > what about those?
>=20
> You perhaps did not read the cover letter, it describes this patch will v=
ery
> likely take time to *ever* apply. We must cover tons of grounds first, to
> address precisely what you say.

Yeah, I was not careful enough reading cover letter. Having series
where 1-4/5 are ready to go, and 5/5 not-good-idea for years to come
is quite confusing.

Really relevant parts of cover letter should be moved to 5/5 and it
should be clearly marked as "not for application".
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--/i8j2F0k9BYX4qLc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlnXcfEACgkQMOfwapXb+vLNWQCfeztojjeyGl/Ilk8j4RodDnvU
wC4An0ClhXGuYA8yIiWg3oyNvdf11oOo
=lg5+
-----END PGP SIGNATURE-----

--/i8j2F0k9BYX4qLc--
