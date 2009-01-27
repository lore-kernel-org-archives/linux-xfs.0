Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0R8TFAC031343 for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 02:29:15 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50ED0BC8DD
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 00:28:30 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id NLGtuEXAUe03j4nT for
	<xfs@oss.sgi.com>; Tue, 27 Jan 2009 00:28:30 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 53BC92B32
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 09:28:29 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 954F240016B
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 09:28:29 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: xfs open questions
Date: Tue, 27 Jan 2009 09:28:23 +0100
MIME-Version: 1.0
Message-Id: <200901270928.29215@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1708324522948711885=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============1708324522948711885==
Content-Type: multipart/signed;
  boundary="nextPart1543269.X2EgIuhjkV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit


--nextPart1543269.X2EgIuhjkV
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Dear list,

I'm new here, experienced admin, trying to understand XFS correctly.=20
I've read=20
http://xfs.org/index.php/XFS_Status_Updates
http://oss.sgi.com/projects/xfs/training/index.html
http://en.wikipedia.org/wiki/Xfs
and still have some xfs questions, which I guess should be in the FAQ=20
also because they were the first questions I raised when trying XFS. I=20
hope this is the correct list to ask this, and hope this very long first=20
mail isn't too intrusive:

- Stripe Alignment
It's very nice to have the FS understand where it runs on, and that you=20
can optimize for it. But the documentation on how to do that correctly=20
is incomplete.
http://oss.sgi.com/projects/xfs/training/xfs_slides_04_mkfs.pdf
On page 5 is an example an an "8+1 RAID". Does it mean "9 disks in=20
RAID-5"? So 8 are data and 1 is parity, and for XFS only the data disks=20
are important?
If so, when I have a 8 disks RAID 6 (where 2 are parity, 6 data) and a 8=20
disks RAID-50 (again 2 parity, 6 data) would be the same?
Let's say I have 64k stripe size on the RAID controller, with above 8=20
disks RAID 6. So best performance would be
mkfs -d su=3D64k,sw=3D$((64*6))k
is that correct? It would be good if there's clearer documentation with=20
more examples.

- 64bit Inodes
On the allocator's slides=20
http://oss.sgi.com/projects/xfs/training/xfs_slides_06_allocators.pdf
it's said that if the volume is >1TB, 32bit Inodes make the FS suffer,=20
and that 64bit Inodes should be used. Is that a safe function?=20
Documentation says some backup tools can't handle 64bit Inodes, are=20
there problems with other programs as well? Is the system fully=20
supporting 64bit Inodes? 64bit Linux kernel needed I guess?
And if I already created a FS >1TB with 32bit Inodes, it would be better=20
to recreate it with 64bit Inodes and restore all data then?

- Allocation Groups
When I create a XFS with 2TB, and I know it will be growing as we expand=20
the RAID later, how do I optimize the AG's? If I now start with=20
agcount=3D16, and later expand the RAID +1TB so having 3 instead 2TB, what=
=20
happens to the agcount? Is it increased, or are existing AGs expanded so=20
you still have 16 AGs? I guess that new AG's are created, but it's=20
nowhere documented.

- mkfs warnings about stripe width multiples
For a RAID 5 with 4 disks having 2,4TB on LVM I did:
# mkfs.xfs -f -L oriondata -b size=3D4096 -d su=3D65536,sw=3D3,agcount=3D40=
 -i=20
attr=3D2 -l lazy-count=3D1,su=3D65536 /dev/p3u_data/data1
Warning: AG size is a multiple of stripe width.  This can cause=20
performance problems by aligning all AGs on the same disk.  To avoid=20
this, run mkfs with an AG size that is one stripe unit smaller, for=20
example 13762544.
meta-data=3D/dev/p3u_data/data1    isize=3D256    agcount=3D40,=20
agsize=3D13762560 blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D550502400,=20
imaxpct=3D5
         =3D                       sunit=3D16     swidth=3D48 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal log           bsize=3D4096   blocks=3D32768, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D16 blks, lazy-
count=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

and so I did it again with
# mkfs.xfs -f -L oriondata -b size=3D4096 -d=20
su=3D65536,sw=3D3,agsize=3D13762544b -i attr=3D2 -l lazy-count=3D1,su=3D655=
36=20
/dev/p3u_data/data1
meta-data=3D/dev/p3u_data/data1    isize=3D256    agcount=3D40,=20
agsize=3D13762544 blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D550501760,=20
imaxpct=3D5
         =3D                       sunit=3D16     swidth=3D48 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal log           bsize=3D4096   blocks=3D32768, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D16 blks, lazy-
count=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

It would be good if mkfs would correctly says "... run mkfs with an AG=20
size that is one stripe unit smaller, for example 13762544b". The "b" at=20
the end is very important, that cost me a lot of search in the=20
beginning.
Is there a limit on the number of AG's? Theoretical and practical? Is=20
there a guideline how many AGs to use? Depending on CPU cores, or number=20
of parallel users, or spindles, or something else? Page 4 of the mkfs=20
docs (link above) says "too few or too many AG's should be avoided", but=20
what numbers are "few" and "many"?

- PostgreSQL
The PostgreSQL database creates a directory per DB. From the docs I read=20
that this creates all Inodes within the same AG. But wouldn't it be=20
better for performance to have each table on a different AG? This could=20
be manually achieved manually, but I'd like to hear if that's better or=20
not.
Or are there other tweaks to remember when using PostgreSQL on XFS? This=20
question was raised on the PostgreSQL admin list, and if there are good=20
guidelines I'm happy to post them there.

mfg zmi
--=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart1543269.X2EgIuhjkV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkl+xawACgkQzhSR9xwSCbRm+ACg6K46gnHnM9qiYhJ4LCDVRGqp
lhkAoLF6FJV6w1Ewvt8o9bechow++H5q
=N3cr
-----END PGP SIGNATURE-----

--nextPart1543269.X2EgIuhjkV--


--===============1708324522948711885==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1708324522948711885==--
