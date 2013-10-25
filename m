Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3F86F29DFB
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 16:21:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 27553304066
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 14:21:16 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id DsLU5IpflIfkGhMX for <xfs@oss.sgi.com>;
	Fri, 25 Oct 2013 14:21:11 -0700 (PDT)
Message-ID: <526AE0BE.9060502@suse.com>
Date: Fri, 25 Oct 2013 17:21:02 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
Subject: Re: [patch 0/3] xfstests: tests for btrfs publishing/export patchset
References: <20131025205246.269327744@suse.com>
In-Reply-To: <20131025205246.269327744@suse.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0672019926478448212=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============0672019926478448212==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ojf2fX8tGr722dOAPA6922ORSo2HQhJFv"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ojf2fX8tGr722dOAPA6922ORSo2HQhJFv
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/25/13, 4:52 PM, Jeff Mahoney wrote:
> These are the tests that Josef requested accompany the submission of
> the btrfs publishing/export patchset[1].
>=20
> 100: Test new global metadata reservation ioctl
> 101: Test new sysfs exporting of allocation and device membership
> 102: Test new sysfs exporting of feature bits
> 103: Test setting/clearing feature bits via ioctl
> 104: Test setting/clearing feature bits via sysfs
>=20
> As part of the ioctl testing, I added a helper that can be extended
> easily to export simple information via ioctl. This means that the
> tests can be independent of btrfsprogs version or its output formatting=
=2E
>=20
> -Jeff
>=20
> [1] http://thread.gmane.org/gmane.comp.file-systems.btrfs/29307

Apologies for the formatting of the subjects and lack of direct btrfs
mention in the commits. I'll fix and resend.

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--ojf2fX8tGr722dOAPA6922ORSo2HQhJFv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSauDDAAoJEB57S2MheeWyVHMP/3knq3Uo7ro/0mdWprwdLAuU
wALn9OD9uBmqNbjYOxveFfVs4jq6+CesHIqgWzOnpV0Hhx1MTkwvLX0iuQZBg7Bb
kUsLlPEDHMwiT3BdtjnNkI5E2XFwq76B7+MX7IvxMFjK9AYv9bonne6QLkFOO7DK
NgS+IvdJD1RrzRV/vhyY4Lwypq8RZ/7pjypplpxeugLRwEtfJpp2JH3Xr1MnEBQY
0XysvqU1e1KJt7krRk8CPmjZosbjH84N2sELHMz8IjmgzOGOmg6UBTb9yZBCVCsq
C1mGhPVnbrsdInmIbmz+nNK71hlfMfJd+vOLVYGRx4yNuegs00ZDpLhDxXZFSCqO
+/0ksaRdL/VmkZTbHSuEufAVhVSQVoYSvpVEe0ct8RUM9SFBr8Iu4vT8Ravc9U6+
02Fv3eww7eM+GRx12d1rKZRJOpTVbTgZm2L1C2ou0nFW6JgS18TxhXRcZ2X/MOTE
lws5JAiDsc3VTu+NOh7Mh5SdOPzfE0XFREXOLKzr4YtYzbRKUwJ1XGKgRCl5XPB6
WoKWi38kjB/VKRTTDmgOm8V3N3y9QBxOLQROORflixfPAFoWiak+VA/3M6fTYr/m
gA7/jeGrU+FOJSkr8RR502QJMlZ8zxZ01szzTPD9GF97UPZRpFRiFkjm8XsFtIMK
Blug9yfEZdr56hycd1/i
=BCED
-----END PGP SIGNATURE-----

--ojf2fX8tGr722dOAPA6922ORSo2HQhJFv--


--===============0672019926478448212==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0672019926478448212==--
