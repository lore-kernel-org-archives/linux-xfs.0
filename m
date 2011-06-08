Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p588X7sq081287 for <xfs@oss.sgi.com>; Wed, 8 Jun 2011 03:33:07 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BDA261D7183F
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2011 01:33:05 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id e3rA9S4dkwh6aW57 for
	<xfs@oss.sgi.com>; Wed, 08 Jun 2011 01:33:05 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: I/O hang, possibly XFS, possibly general
Date: Wed, 8 Jun 2011 10:32:58 +0200
References: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
	<201106060929.06814@zmi.at>
	<19950.12549.541440.285348@tree.ty.sabi.co.UK>
In-Reply-To: <19950.12549.541440.285348@tree.ty.sabi.co.UK>
MIME-Version: 1.0
Message-Id: <201106081033.02900@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0420094581678032140=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Peter Grandi <pg_mh@sabi.co.uk>

--===============0420094581678032140==
Content-Type: multipart/signed;
  boundary="nextPart1948516.1BBM6IlfF9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1948516.1BBM6IlfF9
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 7. Juni 2011 Peter Grandi wrote:
>   * A file that is written out at speed, say 100-500MB/s. 2-4s
>     means that there is an opportunity to allocate 200MB-2GB
>     contiguous extents, and with any luck much larger ones.
>     Conversely any larger intervals means potentially losing
>     200MB-2GB of data. Sure, if they did not want to lose the
>     data the user process should be doing 'fdatasync()', but XFS
>     in particular is sort of pretty good at doing a mild version
>     of 'O_PONIES' where there is a balance between going as fast
>     as possible (buffer a lot in memory) and offering some
>     level of safety (as shown in the tests I did for a fair
>     comparison with 'ext3').

On a PC, that "loosing 2GB of data" is loosing a single file under=20
normal use. It's quite seldom that people are copying data around. And=20
even if, when the crash happens they usually know what they just did,=20
and restart the copy after a crash.

If we speak about a server normally there should be a HW RAID card in it=20
with good cache, and then it's true you should limit Linux write cache=20
and flush early and often, as the card has BBWC and therefore data is=20
protected once in the RAID card. People tend to forget to set writeback=20
lower when using RAID controllers + BBWC, and it's almost nowhere=20
documented. Maybe good for a FAQ entry on XFS, even if it's not XFS=20
specific?

I wonder if there is a good document for "best practise" on VMs? I've=20
never seen someone testing a VMware/XEN host with 20 Linux VMs, and what=20
the settings should be for vm.dirty* and net.ipv4.* values. I've seen=20
crashes on VM servers, where afterwards databases in VMs were broken=20
despite using a RAID card +BBWC...
=20
>   * A file that is written slowly in small chunks. Well,
>     nothing will help that except preallocate or space
>     reservations.

Now for a common webserver we use, as a guideline there are about 8=20
uploads parallel all the time. Most of them are slow, as people are on=20
ADSL. If you sync quite often, you're lucky when using XFS to get=20
preallocation and all that. Otherwise, you'd have chunks of all files=20
scattered on disk.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart1948516.1BBM6IlfF9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk3vM74ACgkQzhSR9xwSCbTeDQCfUehyWAWBegb+FsTXHAozMu2/
uwcAnjLetDaQzKxYK9UCFk3RUDzGZeng
=xQSp
-----END PGP SIGNATURE-----

--nextPart1948516.1BBM6IlfF9--


--===============0420094581678032140==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0420094581678032140==--
