Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o436li6G138376 for <xfs@oss.sgi.com>; Mon, 3 May 2010 01:47:45 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D8CA1B06074
	for <xfs@oss.sgi.com>; Sun,  2 May 2010 23:49:49 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id M7WuN8CD1DHF54Qy for
	<xfs@oss.sgi.com>; Sun, 02 May 2010 23:49:49 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 57769800187
	for <xfs@oss.sgi.com>; Mon,  3 May 2010 08:49:48 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 1A76D83C823
	for <xfs@oss.sgi.com>; Mon,  3 May 2010 08:49:48 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_fsr question for improvement
Date: Mon, 3 May 2010 08:49:43 +0200
References: <201004161043.11243@zmi.at> <20100417012415.GE2493@dastard>
In-Reply-To: <20100417012415.GE2493@dastard>
MIME-Version: 1.0
Message-Id: <201005030849.47591@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3095642776653278884=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3095642776653278884==
Content-Type: multipart/signed;
  boundary="nextPart15342380.VbRfVO0Erk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart15342380.VbRfVO0Erk
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Samstag, 17. April 2010 Dave Chinner wrote:
> They have thousands of extents in them and they are all between
> 8-10GB in size, and IO from my VMs are stiall capable of saturating
> the disks backing these files. While I'd normally consider these
> files fragmented and candidates for running fsr on tme, the number
> of extents is not actually a performance limiting factor and so
> there's no point in defragmenting them. Especially as that requires
> shutting down the VMs...

I personally care less about file fragmentation than about=20
metadata/inode/directory fragmentation. This server gets accesses from=20
numerous people,

# time find /mountpoint/ -inum 107901420
/mountpoint/some/dir/ectory/path/x.iso

real    7m50.732s
user    0m0.152s
sys     0m2.376s

It took nearly 8 minutes to search through that mount point, which is=20
6TB big on a RAID-5 striped over 7 2TB disks, so search speed should be=20
high. Especially as there are only 765.000 files on that disk:
=46ilesystem            Inodes   IUsed   IFree IUse%
/mountpoint           1258291200  765659 1257525541    1%

Wouldn't you say an 8 minutes search over just 765.000 files is slow,=20
even when only using 7x 2TB 7200rpm disks in RAID-5?

> > Would it be possible xfs_fsr defrags the meta data in a way that
> > they are all together so seeks are faster?
>=20
> It's not related to fsr because fsr does not defragment metadata.
> Some metadata cannot be defragmented (e.g. inodes cannot be moved),
> some metadata cannot be manipulated directly (e.g. free space
> btrees), and some is just difficult to do (e.g. directory
> defragmentation) so hasn't ever been done.

I see. On this particular server I know it would be good for performance=20
to have the metadata defrag'ed, but that's not the aim of xfs_fsr.
But maybe some developer is bored once and finds a way to optimize the=20
search&find of files on an aged filesystem, i.e. metadata defrag :-)

I tried this two times:
# time find /mountpoint/ -inum 107901420
real    8m17.316s
user    0m0.148s=20
sys     0m1.964s=20

# time find /mountpoint/ -inum 107901420
real    0m30.113s
user    0m0.540s=20
sys     0m9.813s=20

Caching helps the 2nd time :-)
=20
> > Currently, when I do "find /this_big_fs -inum 1234", it takes
> > *ages* for a run, while there are not so many files on it:
> > # iostat -kx 5 555
> > Device:         r/s     rkB/s    avgrq-sz avgqu-sz   await  svctm=20
> > %util xvdb              23,20    92,80     8,00     0,42   15,28=20
> > 18,17  42,16 xvdc              20,20    84,00     8,32     0,57 =20
> > 28,40  28,36  57,28
>=20
> Well, it's not XFS's fault that each read IO is taking 20-30ms. You
> can only do 30-50 IOs a second per drive at that rate, so:
>=20
> [...]
>=20
> > So I get 43 reads/second at 100% utilization. Well I can see up to
>=20
> This is right on the money - it's going as fast a your (slow) RAID-5
> volume will allow it to....
>=20
> > 150r/s, but still that's no "wow". A single run to find an inode
> > takes a very long time.
>=20
> Raid 5/6 generally provides the same IOPS performance as a single
> spindle, regardless of the width of the RAID stripe. A 2TB sata
> drive might be able to do 150-200 IOPS, so a RAID5 array made up of
> these drives will tend to max out at roughly the same....

Running xfs_fsr, I can see up to 1200r+1200w=3D2400I/Os per second:

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-
sz avgqu-sz   await  svctm  %util
xvdc              0,00     0,00    0,00 1191,42     0,00 52320,16   =20
87,83   121,23   96,77   0,71  84,63
xvde              0,00     0,00 1226,35    0,00 52324,15     0,00   =20
85,33     0,77    0,62   0,13  15,33

But on average it's about 600-700 read plus writes per second, so=20
1200-1400 IOPS.=20
Both "disks" are 2TB LVM volumes on the same raidset, I just had to=20
split it as XEN doesn't allow to create >2TB volumes.

So, the badly slow I/O I see during "find" are not happening during fsr.=20
How can that be?

I'm just running another "find" on a fresh remounted xfs, and I can see=20
the reads are happening on 2 of the 3 2TB volumes parallel:
Device:         r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await =20
svctm  %util
xvdb              103,20    0,00   476,80     0,00     9,24     0,46   =20
4,52   4,50  46,40
xvdc              97,80    0,00   455,20     0,00     9,31     0,52   =20
5,29   5,30  51,84

When I created that XFS, I took two 2TB partitions, did pvcreate,=20
vgcreate and lvcreate. Could it be that lvcreate automatically thought=20
it should do a RAID-0? Because all reads are equally split between the=20
two volumes. After a while, I added the 3rd 2TB volume, and I can't see=20
that behaviour there. So maybe this is the source of all evil.

BTW: I changed mount options "atime,diratime" to "relatime,reldiratime"=20
now and "find" runtime went from 8 minutes down to 7m14s.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart15342380.VbRfVO0Erk
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkvecgsACgkQzhSR9xwSCbSnEwCg36nlQTOc1VcH55khyOmjHQqx
SLcAoNuGv6TZjgAx5rxovG5apfwZsdwq
=EGIU
-----END PGP SIGNATURE-----

--nextPart15342380.VbRfVO0Erk--


--===============3095642776653278884==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3095642776653278884==--
