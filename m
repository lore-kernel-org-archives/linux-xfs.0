Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9QNNV5s113673 for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 18:23:31 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1281512F8EDC
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 16:40:22 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 3JwFkiyuLDbcnGUs for
	<xfs@oss.sgi.com>; Tue, 26 Oct 2010 16:40:22 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
Date: Wed, 27 Oct 2010 01:23:35 +0200
References: <4CC67450.9020602@profihost.ag> <4CC6B56B.7020007@profihost.ag>
	<20101026132505.6af29d5d@harpe.intellique.com>
In-Reply-To: <20101026132505.6af29d5d@harpe.intellique.com>
MIME-Version: 1.0
Message-Id: <201010270124.44846@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3508364567735620763=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

--===============3508364567735620763==
Content-Type: multipart/signed;
  boundary="nextPart1748547.aCDJPPrNKi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1748547.aCDJPPrNKi
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 26. Oktober 2010 Emmanuel Florac wrote:
> echo "noop" > /sys/block/sdc/queue/scheduler
> echo 512 > /sys/block/sdc/queue/nr_requests
> blockdev --setra 4096 /dev/sdc

How about this small script in /etc/init.d/boot.local?

for i in /dev/xvd? /dev/sd? ; do
   if test "$i" =3D=3D "${i%\?}" ; then
      echo i=3D$i
      blockdev --setra 1024 $i
      j=3D${i#/dev/}
      echo j=3D$j
      echo noop >/sys/block/$j/queue/scheduler
      echo 512 >/sys/block/$j/queue/nr_requests
   fi
done

This works for VMs within XenServer (/dev/xvda) and real servers=20
(/dev/sda), and sets some values for all drives.

BTW: any recommendations for these tuning knobs on VM-ized servers? What=20
should be set in the VMs and what on the host? Has someone got tested=20
numbers? I'm currently testing things, but it's so damn hard to get any=20
useful, reliable results.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Radiointerview zum Thema Spam ******
http://www.it-podcast.at/archiv.html#podcast-100716

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1748547.aCDJPPrNKi
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzHYzwACgkQzhSR9xwSCbRFWgCeJu3k5L4oPnRq4NyaoAJitoaC
s18AoOrGFHsQZ4l5WWYzP8x/G9zoze8D
=KfH4
-----END PGP SIGNATURE-----

--nextPart1748547.aCDJPPrNKi--


--===============3508364567735620763==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3508364567735620763==--
