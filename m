Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45811 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdJCUMH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:12:07 -0400
Date: Tue, 3 Oct 2017 22:12:04 +0200
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC 5/5] pm: remove kernel thread freezing
Message-ID: <20171003201204.GA23521@amd>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-6-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <20171003185313.1017-6-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-10-03 11:53:13, Luis R. Rodriguez wrote:
> Now that all filesystems which used to rely on kthread
> freezing have been converted to filesystem freeze/thawing
> we can remove the kernel kthread freezer.

Are you surely-sure? You mentioned other in kernel sources of writes;
what about those?

Can knfsd be a problem?

Can memory management doing background writes be a problem?

Did you do some hibernation testing?

> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>

Please don't apply this just yet.

									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlnT7xQACgkQMOfwapXb+vK4qgCcDxGX3eUe+PcZPHNiVxFML35E
slcAoJNxB4zJFlTZarJuhrPcwJiZQFAx
=eLRH
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
