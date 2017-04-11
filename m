Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52872 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753017AbdDKNev (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 09:34:51 -0400
Subject: Re: allow mounting w/crc-checking disabled? (was Re: filesystem dead,
 xfs_repair won't help)
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
 <58EB53CA.7030608@tlinx.org>
 <8b9b764e-8fb5-af30-f135-be51b6a67558@sandeen.net>
 <58EBC972.6040509@tlinx.org> <20170411145721.7d3676a1@harpe.intellique.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7847f469-6a83-8a35-360d-13a0e0341f5d@sandeen.net>
Date: Tue, 11 Apr 2017 08:34:44 -0500
MIME-Version: 1.0
In-Reply-To: <20170411145721.7d3676a1@harpe.intellique.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lnfMfO5wjwj3hoMkdt6XIsCpnkvrNe961"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>, L A Walsh <xfs@tlinx.org>
Cc: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lnfMfO5wjwj3hoMkdt6XIsCpnkvrNe961
Content-Type: multipart/mixed; boundary="XqtNPDeDNwdJhAIF4RNpO6LTi34oPap3N";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: Emmanuel Florac <eflorac@intellique.com>, L A Walsh <xfs@tlinx.org>
Cc: linux-xfs@vger.kernel.org
Message-ID: <7847f469-6a83-8a35-360d-13a0e0341f5d@sandeen.net>
Subject: Re: allow mounting w/crc-checking disabled? (was Re: filesystem dead,
 xfs_repair won't help)
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
 <58EB53CA.7030608@tlinx.org>
 <8b9b764e-8fb5-af30-f135-be51b6a67558@sandeen.net>
 <58EBC972.6040509@tlinx.org> <20170411145721.7d3676a1@harpe.intellique.com>
In-Reply-To: <20170411145721.7d3676a1@harpe.intellique.com>

--XqtNPDeDNwdJhAIF4RNpO6LTi34oPap3N
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 4/11/17 7:57 AM, Emmanuel Florac wrote:
> Le Mon, 10 Apr 2017 11:05:38 -0700
> L A Walsh <xfs@tlinx.org> =C3=A9crivait:
>=20
>> 	I'm sure it wouldn't be trivial, but creating a separate
>> file system, "XFS2" from the original XFS sources that responded
>> to data or metadata corruption by returning empty data where
>> it was impossible to return anything useful instead of flagging
>> the disk as "bad", would be a way to allow data recovery to
>> the extent that it made sense (assuming the original sources
>> couldn't do the same toggling off a config-flag).
>=20
> It would probably much easier to add an option to mount the filesystem
> without crc, similar to "norecovery", that doesn't replay the journal.
> It would be of course read-only, but in a similar case it would be much=

> easier and practical for everyone.

Yes, I actually whipped up a patch to do just that, because I was curious=
=2E
Although I don't think it would fly, I may send it just to have
a record out on the list.

> So far I believed that metadata CRCs were a promise of safer
> filesystems; now that I've setup several multi-hundred terabytes
> volumes with CRC enabled, I'm getting nervous...

Why?

So far there's a lot of fear & speculation from some quarters, but no
reports of any actual real-world significant downside to CRC integrity
checking.

A few amendments to my possibly too-quick reply yesterday, though...

One, not every CRC error will shut down your filesystem - far from it.
As a quick test of Linda's first scenario, you can corrupt a timestamp
without changing the CRC, using xfs_db's expert mode.  That inode
will be inaccessible until it's fixed with xfs_repair, but the filesystem=

continues on happily.

Two, after talking with Darrick I realized that I misrepresented
things a bit; we checksum the entire sector of metadata, so yes,
even a bitflip in an unused portion of that location could cause
a crc mismatch and therefore a metadata read error.  But again, this woul=
d
render that data structure inaccessible until repair, but it would not ta=
ke
the entire filesystem offline.

Three, none of this has anything to do with the email that started
this thread.  Bad firmware turned Avi's SSD into a vat of goo, and CRCs
are not in any way related to his inability to recover his filesystem.

Thanks,
-Eric

=20


--XqtNPDeDNwdJhAIF4RNpO6LTi34oPap3N--

--lnfMfO5wjwj3hoMkdt6XIsCpnkvrNe961
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJY7Nt6AAoJECCuFpLhPd7gFM4QAJ1SwwLF2HuNO0kFxzzLqw62
775Q6yg1R1Qwqq40fLLJC+GVuu5OIjZjij23j8vyotCM4PecrT8AfTKh1ysYWONx
+gQTB16vuAgFcc9OjHqmoBMgV6e6NPdpIwDXLmcve0ym4RNzERe+gryiVl2v0PV5
ER2Ex+4YDlTUQHtkeTwKhnWp0Z1fM1gpp1W+7LlTGCRtlQ9xbxSOhMQrI2hAMaa2
z/VZbaOkJiYBSnrvfHm88GYz6T/J15Q5OTk3mfb6JVr9tpiatmBqrdxLt/8GvDA+
NzFg59xdxYCuJ4KGhVumPzFXXTeFHwH+vhGpE6m1ifDFl5pia5f3j+L+PcHxLCS/
E5Xcr4vOWupwbV95V2el6noRV3HXGI7aVgxUQI2y9SUuvokG8HIsBQd1Y2KpS+cO
YNCMl0aZjK3maztsqVstAvAoowuyI9UNN5DkP/dTDHyWADCO9kKEAlafkIaQIhz+
LQe+z6DSYJw8I7FFP673nFLC+3PtXUBTf79WdZYiITjMvqdhrCvlP4E5N0/amUSr
fDMxtJJlK29waW/kUxeYhj2ZyhfjcJ3D3N++SUt9LCq/FJRS4cpttzYawg9+RLR7
EY9EB5Gb8zygrK8PiQJnJHSSIVqPEC8q6U9W0QItgw1Eq2RuULpZAqVvlsVZ0WrS
+J0orUQ1zCusAWBuEHHl
=HvMW
-----END PGP SIGNATURE-----

--lnfMfO5wjwj3hoMkdt6XIsCpnkvrNe961--
