Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0AFrpHL007358 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 09:53:52 -0600
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1DB43161DE4C
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 07:56:02 -0800 (PST)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id eC0GACapXP6UnplK
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 07:56:02 -0800 (PST)
Received: by wyf22 with SMTP id 22so21411666wyf.26
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 07:56:01 -0800 (PST)
Message-ID: <4D2B2BD6.60800@gmail.com>
Date: Mon, 10 Jan 2011 16:55:02 +0100
From: Honza Fikar <j.fikar@gmail.com>
MIME-Version: 1.0
Subject: Re: no rw xfs file systems in mtab: /proc/mounts
References: <AANLkTi=Xes02L3XfZvUu6Yh2yi2FR8GtpVdOGzngVjJk@mail.gmail.com>
	<4D13648B.8000105@sandeen.net> <4D138457.8020008@gmail.com>
	<20101229130903.GD1035@infradead.org>
In-Reply-To: <20101229130903.GD1035@infradead.org>
Reply-To: j.fikar@gmail.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6993854702867664038=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============6993854702867664038==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB2BE0D89FCF0AFFD73513E1A"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB2BE0D89FCF0AFFD73513E1A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/29/2010 02:09 PM, Christoph Hellwig wrote:
> Can you please apply the debug patch below and see what output fsr give=
s
> with it?

the output is:

#fsr/xfs_fsr -v -d
fsr: cannot stat /dev/mapper/root
no rw xfs file systems in mtab: /etc/mtab

/dev/mapper/root is really missing, even though mount shows:

/dev/mapper/root on / type xfs
(rw,noatime,attr2,inode64,logbufs=3D8,logbsize=3D256k,noquota)

maybe it gets lost during initrd?

easy and dirty fix is ln -s /dev/root /dev/mapper/root

but how to fix it for real?

Honza


--------------enigB2BE0D89FCF0AFFD73513E1A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk0rK9oACgkQp4S3GwoQQ3sTlACfdTjgcUYmr9rw7+QtP9x1KU8l
racAoOFvHJE01keMiSe2vZu2RmAgyfI0
=O5Pb
-----END PGP SIGNATURE-----

--------------enigB2BE0D89FCF0AFFD73513E1A--


--===============6993854702867664038==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6993854702867664038==--
