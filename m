Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6KB0SbU072585 for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 06:00:29 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC4B412A5998
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 04:09:10 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id 2bcaeVauDjIPY1RW for
	<xfs@oss.sgi.com>; Mon, 20 Jul 2009 04:09:10 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (h081217106033.dyn.cm.kabsi.at
	[81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id E16B54DAF
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 13:01:38 +0200 (CEST)
Received: from saturn.localnet (unknown [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id E7B8A40017E
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 13:01:05 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Write barriers and hardware RAID
Date: Mon, 20 Jul 2009 13:01:01 +0200
References: <alpine.LRH.1.10.0907171259590.8586@pcuf.fi>
In-Reply-To: <alpine.LRH.1.10.0907171259590.8586@pcuf.fi>
MIME-Version: 1.0
Message-Id: <200907201301.05472@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8465699804007772246=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8465699804007772246==
Content-Type: multipart/signed;
  boundary="nextPart2903107.zRqvKR97H9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2903107.zRqvKR97H9
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I wrote that sections of the FAQ, so I should answer:

On Freitag 17 Juli 2009 J P=E4lve wrote:
> - The XFS FAQ states that with battery backup'd RAID hardware, both
> write barriers and individual disk cache should be turned off.
> However, I'm getting better benchmark results with both turned on.

I guess it's only the "hard disk cache" turned on leading to better=20
performance. But that is a very, very dangerous setup: If you use a RAID=20
with 16 hard disks, each having 32MB cache, on a power fail you can=20
loose up to 16*32 =3D 512MB of data, as on a power outage hard disks=20
simply drop their caches. And chances are *very* big that a significant=20
amount of filesystem metadata is in there, trashing your filesystem=20
badly. Never turn this on if you care about your data.

=46or write barriers, the performance should be a little bit lower if ON=20
instead OFF.

> What I'm wondering is, will write barriers work as intended when used
> with hardware RAID controller (PERC 6/E)? Googling only turned up
> results relating to software RAID.

No. RAID controllers simulate written data by telling the host that a=20
disk block has been written while it's only in the controller's cache.=20
The controller will write it later, when he has time. So basically=20
barriers only generate extra I/O there. This is valid if the controller=20
has writes "write back". If set to "write through", the RAID controller=20
simply does not cache writes, and directly writes them to disk, and only=20
afterwards tell the host that data has been written. This will drop your=20
write performance very significantly, on a server with much I/O you=20
don't want to use write through (aka write cache off).

> - The XFS FAQ also states that virtualization products prevent write
> barriers from working correctly. Is this still the case (specifically
> with ESXi 3.5 and later) and is there anything that can be done about
> it? Does VMFS somehow work around this, or is the problem then just
> "out of sight, out of mind"?

I found an entry for the ".vmx" config file:
scsi0:0.writeThrough =3D "TRUE"

That should do the desired "do not cache this disk", but I didn't test=20
it so far.
I wonder if someone knows of such a setting for XenServer?

If someone has a solution to "VM disk writes cached", I'd be happy to=20
hear how to do that.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart2903107.zRqvKR97H9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkpkTnEACgkQzhSR9xwSCbTDegCgovqblhdjq/2E6YNXtqZCkNgK
NuoAoOiysou7agqkCFRthpES8S7OJ6hD
=MxEg
-----END PGP SIGNATURE-----

--nextPart2903107.zRqvKR97H9--


--===============8465699804007772246==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8465699804007772246==--
