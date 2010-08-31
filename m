Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7VNU50X089332 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 18:30:05 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C1D844028E
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 16:30:43 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 8Ylvf7Eo3WmId7O8 for
	<xfs@oss.sgi.com>; Tue, 31 Aug 2010 16:30:43 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 67A60616
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 01:30:42 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 0FB18401C2F
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 01:30:42 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: deleting 2TB lots of files with delaylog: sync helps?
Date: Wed, 1 Sep 2010 01:30:41 +0200
MIME-Version: 1.0
Message-Id: <201009010130.41500@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1441228570261391164=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1441228570261391164==
Content-Type: multipart/signed;
  boundary="nextPart75489676.hYA5ozuBjL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart75489676.hYA5ozuBjL
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I'm just trying the delaylog mount option on a filesystem (LVM over=20
2x 2TB 4K sector drives), and I see this while running 8 processes=20
of "rm -r * & 2>/dev/null":

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sdc               2,80    33,40  125,00   64,60   720,00   939,30    17,50 =
    0,55    2,91   1,71  32,40
sdd               0,00    25,60  122,80   63,40   662,40   874,40    16,51 =
    0,52    2,77   1,96  36,54
dm-0              0,00     0,00  250,60  123,00  1382,40  1941,70    17,79 =
    1,64    4,39   1,74  65,08

Then I issue "sync", and utilisation increases:
Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sdc               0,00     0,20   15,80  175,40    84,00  2093,30    22,78 =
    0,62    3,26   2,93  55,94
sdd               0,00     1,00   13,40  177,60    79,20  2114,10    22,97 =
    0,69    3,63   3,34  63,80
dm-0              0,00     0,00   29,20  101,20   163,20  4207,40    67,03 =
    1,11    8,51   7,56  98,60

This is reproducible. Now it can be that the sync just causes more writes a=
nd stalls reads
so overall it's slower, but I'm wondering why none of the devices says "100=
% util", which
should be the case on deletes? Or is this again the "mistake" of the utiliz=
ation calculation
that writes do not really show up there?

I know I should have benchmarked and tested, I just wanted to raise eyes on=
 this as it=20
could be possible there's something to optimize.

Another strange thing: After the 8 "rm -r" finished, there were some subdir=
s left over=20
that hadn't been deleted - running one "rm -r" cleaned them out then. Could=
 that be
a problem with "delaylog"? Or can that happen when several "rm" compete in =
the same=20
dirs?

This is kernel 2.6.35.4

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart75489676.hYA5ozuBjL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkx9kKEACgkQzhSR9xwSCbTS/QCfcJ1ZMkYwVK9Y5E16+pF9ciP0
DCAAnRONr2448sAG0z24BsT3m+kQqVK6
=edj/
-----END PGP SIGNATURE-----

--nextPart75489676.hYA5ozuBjL--


--===============1441228570261391164==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1441228570261391164==--
