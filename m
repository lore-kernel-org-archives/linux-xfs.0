Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3G8fJAl235819 for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 03:41:19 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E4BD71487129
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 01:43:13 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id QGDu3eGg3hoEGVBT for
	<xfs@oss.sgi.com>; Fri, 16 Apr 2010 01:43:13 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 1E7B680018B
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 10:43:12 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id B2E6083C804
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 10:43:11 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: xfs_fsr question for improvement
Date: Fri, 16 Apr 2010 10:43:10 +0200
MIME-Version: 1.0
Message-Id: <201004161043.11243@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1434799213610243234=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1434799213610243234==
Content-Type: multipart/signed;
  boundary="nextPart1693377.dv3LgzN7rc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1693377.dv3LgzN7rc
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=46rom the man page I read that a file is defragmented by copying it to a=20
free space big enough to place it in one extent.

Now I have a 4TB filesystem, where all files written are at least 1GB,=20
average 5GB, up to 30GB each. I just xfs_growfs'd that filesystem to=20
6TB, as it was 97% full (150GB free). Every night a xfs_fsr runs and=20
finished to defragment everything, except during the last days where it=20
didn't find enough free space in a row to defragment.

Could it be that the defragmentation did it's job but in the end the=20
file layout was like this:
file 1GB
freespace 900M
file 1GB
freespace 900M
file 1GB
freespace 900M
That, while being an "almost worst case" scenario, would mean that once=20
the filesystem is about 50% full, new 1GB files will be fragmented all=20
the time.
To prevent this, xfs_fsr should do a "compress" phase after=20
defragmentation finished, in order to move all the files behind each=20
other:
file 1GB
file 1GB
file 1GB
file 1GB
freespace 3600M
That would also help fill the filesystem from front to end, reducing=20
disk head moves.


Another thing, but related to xfs_fsr, is that I did an xfs_repair on=20
that filesystem once, and I could see there were a lot of small I/Os=20
done, with almost no throughput. The disks are 7.200rpm 2TB disks, so=20
random disk access is horribly slow, and it looked like the disks were=20
doing nothing else but seeking.
Would it be possible xfs_fsr defrags the meta data in a way that they=20
are all together so seeks are faster?
Currently, when I do "find /this_big_fs -inum 1234", it takes *ages* for=20
a run, while there are not so many files on it:
# iostat -kx 5 555
Device:         r/s     rkB/s    avgrq-sz avgqu-sz   await  svctm  %util
xvdb              23,20    92,80     8,00     0,42   15,28  18,17  42,16
xvdc              20,20    84,00     8,32     0,57   28,40  28,36  57,28
(I edited the output to remove "writes" columns, as they are 0)
This is a RAID-5 over 7 disks, and 2 TB volumes are used with LVM=20
concatenated. As I only added the 3rd 2TB volume today, no seeks on that=20
new place.
So I get 43 reads/second at 100% utilization. Well I can see up to=20
150r/s, but still that's no "wow". A single run to find an inode takes a=20
very long time.
# df -i
=46ilesystem            Inodes         IUsed          IFree      IUse%
mybigstore            1258291200  765684 1257525516    1%

So only 765.684 files, and it takes about 8 minutes for a "find" pass.
Maybe an xfs_fsr over metadata could help here?


=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1693377.dv3LgzN7rc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkvIIx8ACgkQzhSR9xwSCbTc/gCg3mI7SB9s2TGtdCJgfJWItzeR
ZK0AoN/GF9snUrK+TASPgve+BdLyElvm
=Ie/j
-----END PGP SIGNATURE-----

--nextPart1693377.dv3LgzN7rc--


--===============1434799213610243234==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1434799213610243234==--
