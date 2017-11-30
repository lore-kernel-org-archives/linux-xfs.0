Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53676 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751224AbdK3VwA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Nov 2017 16:52:00 -0500
Date: Thu, 30 Nov 2017 22:51:57 +0100
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 00/11] fs: use freeze_fs on suspend/hibernate
Message-ID: <20171130215157.GB2808@amd>
References: <20171129232356.28296-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WhfpMioaduB5tiZL"
Content-Disposition: inline
In-Reply-To: <20171129232356.28296-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, yu.chen.surf@gmail.com, dan.j.williams@intel.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org


--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Proposed solution:
>=20
> Instead of fixing such semantics and trying to get all filesystems to do =
it
> right, we can easily do away with all freezing calls if the filesystem
> implements a proper freeze_fs() callback. The following 9 filesystems have
> freeze_fs() implemented as such we can let the kernel issue the callback =
upon
> suspend and thaw on resume automatically on our behalf.
>=20
>   o xfs
>   o reiserfs
>   o nilfs2
>   o jfs
>   o f2fs
>   o ext4
>   o ext2
>   o btrfs
>=20
> Of these, the following have freezer helpers, which can then be removed
> after the kernel automaticaly calls freeze_fs for us on suspend:
>=20
>   o xfs
>   o nilfs2
>   o jfs
>   o f2fs
>   o ext4
>=20
> I've tested this on a system with ext4 and XFS, and have let 0-day go at
> without issues. I have branches availabe for linux-next [3] and Linus'
> latest tree [4].

Was hibernation tested? uswsusp?

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--WhfpMioaduB5tiZL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlogfX0ACgkQMOfwapXb+vKAXACgnqWMFQA+PKvI9Rq5vdZq0eqm
DmkAn2v6+NlkogtL87tOprZw+w4DXzjv
=rmjt
-----END PGP SIGNATURE-----

--WhfpMioaduB5tiZL--
