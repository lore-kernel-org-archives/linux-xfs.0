Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAD9udT1032012 for <xfs@oss.sgi.com>; Thu, 13 Nov 2008 01:56:40 -0800
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71E9215560C1
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2008 01:56:37 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id aL4OykGzLc9hfQ1C for
	<xfs@oss.sgi.com>; Thu, 13 Nov 2008 01:56:37 -0800 (PST)
Received: from shambhala.lichtvoll.local
	(DSL01.83.171.153.255.ip-pool.NEFkom.net [83.171.153.255])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id E62935AE3D
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2008 10:48:01 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Date: Thu, 13 Nov 2008 10:48:00 +0100
References: <20081112224109.GC18990@pixar.com> <491B83E5.4030002@sandeen.net>
	<20081113015503.GN18990@pixar.com>
	(sfid-20081113_094602_308627_96E6041F)
In-Reply-To: <20081113015503.GN18990@pixar.com>
MIME-Version: 1.0
Message-Id: <200811131048.00612.Martin@lichtvoll.de>
Subject: Re: [xfs] last xfs_repair time?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5074378488574978779=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5074378488574978779==
Content-Type: multipart/signed;
  boundary="nextPart1958601.lkQLzcu0mD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1958601.lkQLzcu0mD
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


Hi!

Lets see whether MailMan lets GPG signature unmangled or whether it is=20
something else that mangles it.

Am Donnerstag 13 November 2008 schrieb Lars Damerow:
> From Eric Sandeen <sandeen@sandeen.net>, Wed, Nov 12, 2008 at=20
07:33:25PM -0600:
> > So, for what it's worth, power loss should not necessarily require a
> > repair; as long as you have barriers enabled and/or you're not losing
> > log writes to a volatile write cache, power loss should never corrupt
> > the filesystem metadata; that is what the log is for, after all...
>
> Our disks are partitioned with LVM, so we don't have write barriers. We
> just recently disabled write caching, though, so our future should be
> brighter than it's been. :)

I really hope that LVM gets write barrier support for write barrier=20
capable targets. Unless it does my notebook will use plain partitions for=
=20
anything but testing filesystems. Otherwise with 2.6.16 back then I=20
hardly felt a difference in XFS speed after turning off write caches.

If you like add your vote here:
http://bugzilla.kernel.org/show_bug.cgi?id=3D9554

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1958601.lkQLzcu0mD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkb99AACgkQmRvqrKWZhMelWgCfQFPfUifaWsSNDpqmoMq/PIZZ
WHAAn0A/qW8ciGOYy2tr2ce6kExum1bN
=z3tM
-----END PGP SIGNATURE-----

--nextPart1958601.lkQLzcu0mD--


--===============5074378488574978779==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5074378488574978779==--
