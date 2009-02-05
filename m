Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n158N01Q203881 for <xfs@oss.sgi.com>; Thu, 5 Feb 2009 02:23:01 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 069EB18CA525
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2009 00:22:19 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id iHePZGUocfz8cKLI for
	<xfs@oss.sgi.com>; Thu, 05 Feb 2009 00:22:19 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id B78023D94
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2009 09:22:18 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id AB413400172
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2009 09:22:18 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_force_shutdown after Raid crash
Date: Thu, 5 Feb 2009 09:22:09 +0100
References: <498376CF.8020806@renderforce.de>
	<20090204153322.GC15454@theco.de> <200902041718.15836@zmi.at>
In-Reply-To: <200902041718.15836@zmi.at>
MIME-Version: 1.0
Message-Id: <200902050922.18307@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2902509983118032887=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2902509983118032887==
Content-Type: multipart/signed;
  boundary="nextPart1521488.HW3kj7joOj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1521488.HW3kj7joOj
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Mittwoch 04 Februar 2009 Michael Monnerie wrote:
> > =A0 - if a RAID controller does not turn off the disks write cache,
> > the controller cannot know if previous writes have made it to the
> > disk.
>
> The controller could keep in-transfer blocks in it's cache, waiting
> for a confirm from the disk that the blocks are on the media, and
> only afterwards remove it from cache. I don't know if controllers do
> that actually. I'll ask Areca support on that.

I have an answer from Areca support:
*******************************************************
as soon as the hard drive firmware response command completed, the data=20
will be remove from controller cache. so controller will not known the=20
data had been trully write into disks or remain in hard drive cache=20
only.

by controller default setting, if controller have battery module=20
connected, it will automatically disable the hard drive cache for best=20
data protection. as you known, controller can't protect the data remain=20
in hard drive cache while power outage occured.

but this setting is configure-able, some customer may forece enable the=20
hard drive cacne for better performance. beucase hard drive without=20
cache enabled have quite poor performance.
*******************************************************
So I'd say they have a very sensible default:=20
If you use a BBM (battery backup module) then disk write caches will be=20
off, because you care about your data.=20
If you dont use a BBM anyway, they let disk write cache on because your=20
data is not save at all, so why care? 8-) And as most magazines will=20
test without a BBM, it improves speed up to the max, which is good for=20
benchmarks :-)

I'll put a section with RAID controllers into the wiki, if someone has=20
objections we can remove it again.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart1521488.HW3kj7joOj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmKoboACgkQzhSR9xwSCbSDkACg6n3+h5z4YiSiD8lA9QW+Ubv2
RNYAniZgrCM2YXhc5LABsfaho7uBcn1r
=KnPh
-----END PGP SIGNATURE-----

--nextPart1521488.HW3kj7joOj--


--===============2902509983118032887==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2902509983118032887==--
