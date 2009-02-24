Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1O7MlBq132139 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 01:22:48 -0600
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78D451991CBE
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 23:22:16 -0800 (PST)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id sH2ZzcjnqVIWOUrS for
	<xfs@oss.sgi.com>; Mon, 23 Feb 2009 23:22:16 -0800 (PST)
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Date: Tue, 24 Feb 2009 02:21:43 -0500
References: <200902240010.25434.vapier@gentoo.org>
	<49A38420.5030700@sandeen.net>
In-Reply-To: <49A38420.5030700@sandeen.net>
MIME-Version: 1.0
Message-Id: <200902240221.44184.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5846293850100563684=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============5846293850100563684==
Content-Type: multipart/signed;
  boundary="nextPart10401435.EWoVr1z79d";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart10401435.EWoVr1z79d
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 24 February 2009 00:22:40 Eric Sandeen wrote:
> Mike Frysinger wrote:
> > i noticed that xfsprogs-3.0.0 sometimes fails to build in parallel with
> > an error about fsr not being able to find libhandle.  looking at the top
> > level Makefile shows the obvious missing depend (fsr: libhandle).=20
> > playing around a bit found a few more not so obvious missing depends on
> > the include subdir, so i fixed that too.
>
> Oh, can you resend with a formal Signed-off-by: line?  Being a little
> nitpicky here but we follow the same process as kernel patches.

where is the git tree now ?  i tried git://oss.sgi.com/xfs-cmds but that se=
ems=20
to be dead now.
=2Dmike

--nextPart10401435.EWoVr1z79d
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iQIcBAABAgAGBQJJo6AIAAoJEEFjO5/oN/WB/7gP/AkiS6/TeExOmfHNRHushRnU
3em164kzGEqfaHHrXPfP+XUs8H/+8PDARyWuLD5CNK8Kr+g/8wMSM0vMpjvag3pZ
CQvkmOL0jLM35bpvnAnOF6YAzeMrNtkPDPcAB0Ls6wNsW93WT7wx66A6TvZsam31
F8KH0qUflU/bY8aKzM8LtRMkMxqa9osaV9vvfASOOZHtc6gIyq/1juak8SS7P3qQ
c1lc32eONNl3CpfePEov9d9b94CID8xzKI8vhh+jH0BadW9rvs1KuEN9GXCOPZ8F
V0Qa3GPrWJP5tYeVrNaDHjyMj0FpNTIzyFfV9L6H2ns0Wra+v0eIXOlZvUGgJ3JY
Xl5AHXydCb69XvYFeS+QQWVxaBCbEmdrsiMcoVjjhT8KeED/pO4Cc3/aq87AKCMV
yatZhl1C1uomQ5Fpt0q/hPlHPGSezPk3QkponcbUHwuBlz3jc0sOm4svIcfB47d1
QkI0a08FC7F9tLsBQyLqHJJwNtHbhZn6o/r/R1gB4ExW7ogU3xbtnZ2w9jLLTzhS
ilhoF0yzs2vG+yhLvLrytlM6sHkfEFRGgHFUpl3oNmXRPSin4nKq8Fnlm3ZpwGyl
ipy2TP7OgLliptcPVqVk7QUH9dsWb1d2K+QZFmPyx+EkxP/f6eI0vpNU5MW+mrpP
eeVJIM7S6SwlC9u1b+2n
=7I58
-----END PGP SIGNATURE-----

--nextPart10401435.EWoVr1z79d--


--===============5846293850100563684==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5846293850100563684==--
