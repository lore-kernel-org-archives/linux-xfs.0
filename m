Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1824A7F87
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 18:37:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 01B7F304032
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 16:37:04 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 0rscFiaOrQQHp49a (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Apr 2015 16:37:02 -0700 (PDT)
Date: Fri, 10 Apr 2015 09:36:52 +1000
From: NeilBrown <neilb@suse.de>
Subject: Re: interesting MD-xfs bug
Message-ID: <20150410093652.73204748@notabene.brown>
In-Reply-To: <20150409231035.GI13731@dastard>
References: <5526E8E9.3030805@gmail.com> <20150409221846.GG13731@dastard>
	<5526FB2A.8060704@gmail.com> <20150409225322.GH13731@dastard>
	<20150409231035.GI13731@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6745028015976649533=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs <xfs@oss.sgi.com>, Joe Landman <joe.landman@gmail.com>

--===============6745028015976649533==
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/j+wwvI/G_S+uNcS=ZFU83.E"; protocol="application/pgp-signature"

--Sig_/j+wwvI/G_S+uNcS=ZFU83.E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Apr 2015 09:10:35 +1000 Dave Chinner <david@fromorbit.com> wrote:

> On Fri, Apr 10, 2015 at 08:53:22AM +1000, Dave Chinner wrote:
> > On Thu, Apr 09, 2015 at 06:20:26PM -0400, Joe Landman wrote:
> > >=20
> > >=20
> > > On 04/09/2015 06:18 PM, Dave Chinner wrote:
> > > >On Thu, Apr 09, 2015 at 05:02:33PM -0400, Joe Landman wrote:
> > > >>If I build an MD raid0 with a non power of 2 chunk size, it appears
> > > >>that I can mkfs.xfs a file system, but it doesn't show up in blkid
> > > >>and is not mountable.  Yet, using a power of 2 chunk size, this does
> > > >>work correctly.   This is kernel 3.18.9.
> > > >>
> > >=20
> > > [...]
> > >=20
> > > >That looks more like a blkid or udev problem. try using blkid -p so
> > > >that it doesn't look up the cache but directly probes devices for
> > > >the signatures. strace might tell you a bit more, too. And if the
> > > >filesystem mounts, then it definitely isn't an XFS problem ;)
> > >=20
> > > Thats the thing, it didn't mount, even when I used the device name
> > > directly.
> >=20
> > Ok, that's interesting. Let me see if I can reproduce it locally. If
> > you don't hear otherwise, tracing would still be useful. Thanks for
> > the bug report, Joe.
>=20
> No luck - md doesn't allow the device to be activated on 4.0-rc7:
>=20
> $ sudo mdadm --version
> mdadm - v3.3.2 - 21st August 2014
> $ uname -a
> Linux test4 4.0.0-rc7-dgc+ #882 SMP Fri Apr 10 08:50:52 AEST 2015 x86_64 =
GNU/Linux
> $ sudo wipefs -a /dev/vd[ab]
> /dev/vda: 4 bytes were erased at offset 0x00001000 (linux_raid_member): f=
c 4e 2b a9
> /dev/vdb: 4 bytes were erased at offset 0x00001000 (linux_raid_member): f=
c 4e 2b a9
> $ sudo mdadm --create /dev/md20 --level=3D0 --metadata=3D1.2 --chunk=3D11=
52 --auto=3Dyes --raid-disks=3D2 /dev/vd[ab]

Weird.  Works for me.
Any messages in 'dmesg' ??
How big are /dev/vd[ab]??

NeilBrown


> mdadm: RUN_ARRAY failed: Invalid argument
>        Problem may be that chunk size is not a power of 2
> $ cat /proc/mdstat
> Personalities : [raid1] [raid10] [raid6] [raid5] [raid4]=20
> unused devices: <none>
> $
>=20
> So I can't actually reproduce what you are seeing because MD doesn't
> allow the device to be activated and so mdadm tears it back down.
>=20
> Cheers,
>=20
> Dave.


--Sig_/j+wwvI/G_S+uNcS=ZFU83.E
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVScNFTnsnt1WYoG5AQLKzRAAr89mRPsqZp41aSF64nX7ubGIg2amEbD7
+uLh4iqYTrT0YiT3Pw/5CcW3rs3XYFuW+rWUAnxP90q8gJb6DEwBmJG+8vPsmDxg
L0z7PPHXRJauIljdHEgYGiqP6/PhqEeq5PYOka3zAeGxxiUIE7zJAX54g/srwK2O
zF6SlBNPQtuXDgkUtKlhZTVRqZXtV3F3aqiFlk306vQuXSAcUkxE7Ymb8qT/WmNc
aGcjUs4XE5suUzcQfSBjbgDWCxcPMccnYJ7fyeHpsX6W37OFF068dBe9Ce13t/dH
1GUBO08oeu6QzxpAKEYVc/NZkpVeIsC/4R+0M4ke5Gmx5t57+Eil1+HNb10XhO2i
upzLvGstKgD4Zif3uU8oJxoojCUAVO2+HPI1TOMhpd2RSK+1CrQl+mVBnRjo+KNM
+R2dUPkqFmASSnoalclthSgpUB34TSJ8bFTroLSPbDVnV5DxEpdUu2vpLd1poYWR
4hQY8Mokszd6JiWpdflizB6fnMQCBs5T9xm0DGb3y0dhbueA5p7XHNmKVE7zEPHB
AY67Cl2MCaE4O5rtmmD2gL0A5srkYm46cadne3dV5w58DGxSbF8lhCiNKSRI55HS
CZJzzTV9lHWYZF/9sjRhmHOBPJCdEIBcXy0uZ00vzwh0yVLu+8/2MKiNkiGg3TUB
aWrP+QHBTwM=
=oMF3
-----END PGP SIGNATURE-----

--Sig_/j+wwvI/G_S+uNcS=ZFU83.E--


--===============6745028015976649533==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6745028015976649533==--
