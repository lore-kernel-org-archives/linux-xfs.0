Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 161C37F54
	for <xfs@oss.sgi.com>; Tue,  9 Dec 2014 17:48:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E7DE8304048
	for <xfs@oss.sgi.com>; Tue,  9 Dec 2014 15:48:32 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	iQu1O9ckTByECiVu for <xfs@oss.sgi.com>;
	Tue, 09 Dec 2014 15:48:30 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1XyUPC-0006f8-50
	for xfs@oss.sgi.com; Wed, 10 Dec 2014 10:41:22 +1100
Date: Wed, 10 Dec 2014 10:41:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC] xfsprogs: libxfs update to current kernel code
Message-ID: <20141209234122.GC9756@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0193508258985513049=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============0193508258985513049==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

I just pushed a libxfs-3.19-update branch to=20

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

That contains an update of the libxfs code to match the current
kernel libxfs code. It's in pretty rough shape right now, but it
seems to work. It will get rebased as I refine the patchset.

The stages of the update are:

	- rework some libxfs definitions
	- update to 3.16 code
	- introduce libxfs error negation patches
	- restructure libxfs to match kernel code
	- update to the current for-next branch

In doing this update, there are a few things that need to be
separated out to the head of the series and made explicit:

	- support for anything pre- dir V2 goes away, so there's a
	  bunch of new "use and older xfsprogs" conditions that need
	  to be added and a significant amount of "handle old bugs"
	  code that needs to go away
	- the equivalent kernel code only supports v2 inodes - it
	  unconditionally sets the NLINK feature bit and converts v1
	  inodes to v2 inodes. All the userspace tools need to be
	  updated to match - they'll read v1 inodes, but they'll
	  unconditionally set NLINK and write only v2 inodes.
	- the SHARED superblock stuff goes away, so killing that
	  needs to be a standalone patch

Given these changes in supported functionality, I expect the first
release with this update to be a 3.3.0 release, not a 3.2.x release.
This probably makes it a good time to update mkfs default behaviour
as well (i.e. to default to CRC enabled filesystems).

There is also more cleanup work to be done after the 3.19 update:

	- the include file structure is somewhat cludgy. I simply
	  made the new libxfs structure link into the existing
	  include/xfs structure in a slightly different way, but
	  this needs substantial rework to clean it up.
	- there is a convoluted mess of include files between
	  include/ and libxfs/ that determine what code gets
	  compiled and how it is seen externally. The first commit
	  in the series sort of points out how messy this is, but
	  this really needs to be better sorted to separate internal
	  and externally visible libxfs functions, as well as
	  separate libxfs structures from userspace structures like
	  struct xfs_mount....

I don't really expect significant *code* review of the libxfs part
of the update - it's pretty large at at +7000/-6500 lines. I'm more
interested in getting feedback on the changes of supported
functionality and the infrastructure changes.  If anyone wants to
kick the tyres they are more than welcome to - at this stage any
feedback is better than none. :)

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUh4ihAAoJEK3oKUf0dfodpI4QAMG25U8zj+IYbNK+XrgnVuPF
q1QOYw2PKR3lUUPAoHaDu/SOHAKiaYl8tj40dl6U4MoeR11SIbM8kZe/MnbQT3VH
hWtR9u9RF2ewMhyJRmLH+jpcUEBLjDtVndr6rsQN+FBpFD1JTKnP/1Bw6msI5eqJ
bPYZO7oUaiGMKF/t40pPqSuAaw/oUqYJtc3grfczAfl1TVOmoHMeEzBY7fXD+bf2
1+y7SYnTaNOhsuLIYYAId/AndE6peX3VNpVqG/RuU9mJ8Zx1c8fJGTFbMRryFJXE
1XWdu1Bu4NksF31wOeFmVS2wTUV5AsB0/+/0bDH4R1zF05JHpLsaNLrXHInu63ZR
zCmRqkUsCftdtIOlTfyOsx9Tg50KCwTCt9T4wAKDxAOwevc+9XyjchOOQCn2SIvj
UVRfKgkE8d0jAHphxwGjt4toxiqbmj7bHhFHt0g4sOn/z41lKcojJD6S0iAsIkh8
m63TRibzzOSZtNB7e0UDZcfHTW2GA0/7ef62mABu3U2u9CglKNuisZedi44/OArJ
JufeDqSiYYCPOyA9oTQh+c0UyQDBik6zjxV2TdXwi/SoN7O3TrdZcUhXem+hmj8w
HfgcCFDVC1s/LpsWwe91mhDehnvJfXaIs2kwwk9IDRqD3SXDusAVzV+/kmjWXgHa
qqL6GiysmvqrQ9SSWvYz
=nVeX
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--


--===============0193508258985513049==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0193508258985513049==--
