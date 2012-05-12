Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4C498bd148366 for <xfs@oss.sgi.com>; Fri, 11 May 2012 23:09:09 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id OLJl9ixwSlVSg67u for <xfs@oss.sgi.com>;
	Fri, 11 May 2012 21:09:07 -0700 (PDT)
Message-ID: <4FADE262.7010606@sandeen.net>
Date: Fri, 11 May 2012 23:09:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Strange problems with xfs an SLESS11 SP2
References: <CBD2D5A5.7C6B%Marcus.Hammer@auma.com>
In-Reply-To: <CBD2D5A5.7C6B%Marcus.Hammer@auma.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Hammer, Marcus" <Marcus.Hammer@auma.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 5/11/12 7:41 AM, Hammer, Marcus wrote:
> Hello,
> =

> We have upgraded from SLES11 SP1 to SLES11 SP2. We use an exotic ERP
> System, which stores the data in CISAM Files, which we store on
> several mounted xfs filesystems ( /disk2, /disk3, /disk4, /disk5 and
> /disk6)
> The machine is a DELL R910 with 256 GB RAM and installed SLES11 SP2
> (before we used SLES11 SP1). So we also got the new 3.0 kernel after
> the upgrade. The xfs mounts are LUNs on a netapp storage mapped via
> fibre channel to the
> Linux host. Also we use multipathd to have several paths to the
> netapp storage LUNs.
> =

> Now after the upgrade to SLES11 SP2 we encountered a strange change on th=
e xfs filesystem /disk5:
> =

> The /disk5 is a frequent accessed xfs filesystem by the ERP system.
> The disk usage increased from 53% to 76-78%. =


as measured by df?  This probably is the somewhat aggressive preallocation,=
 as
Stefan suggested in another email.

> But only the disk usage,
> the size of the files are completely the same. The defragmentation
> increased to 96%
> =

> linuxsrv1:/disk4/ifax/0000 # xfs_db -c frag -r /dev/mapper/360a98000486e5=
9384b34497248694170
> actual 56156, ideal 2014, fragmentation factor 96.41%

so on average, about 28 extents per file.  And what was it before?

See also http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_=
says_I.27m_over_50.25.__Is_that_bad.3F

> linuxsrv1:/disk4/ifax/0000 # xfs_info /dev/mapper/360a98000486e59384b3449=
7248694170
> meta-data=3D/dev/mapper/360a98000486e59384b34497248694170 isize=3D256    =
agcount=3D21, agsize=3D3276800 blks
>          =3D                       sectsz=3D512   attr=3D0
> data     =3D                       bsize=3D4096   blocks=3D68157440, imax=
pct=3D25
>          =3D                       sunit=3D0      swidth=3D0 blks
> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
> log      =3Dinternal               bsize=3D4096   blocks=3D25600, version=
=3D1
>          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-co=
unt=3D0
> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0

Ben, with logv1 and 21 AGs it must be an older, migrated fs :)

> =

> The fstab for xfs mounts are without any special options or optimizations=
, here is the snipped from /etc/fstab:
> =

> /dev/mapper/360a98000486e59384b3449714a47336c   /disk2  xfs     defaults =
       0 2
> /dev/mapper/360a98000486e59384b34497247514a56   /disk3  xfs     defaults =
       0 2
> /dev/mapper/360a98000486e59384b34497248694170   /disk4  xfs     defaults =
       0 2
> /dev/mapper/360a98000486e59384b344972486f6d4e   /disk5  xfs     defaults =
       0 2
> /dev/mapper/360a98000486e59384b3449724e6f4266   /disk6  xfs     defaults =
       0 2
> /dev/mapper/360a98000486e59384b3449724f326662   /opt/usr        xfs     d=
efaults        0 2
> =

> But something must have been changed in xfs, because now the metadata
> increased so massive, we never had this before with SLES11 SP1.

How are you measuring "the metadata increase?" - I'm not sure what you mean=
 by this.

> I did a defragmentation with xfs_fsr and the metadata and usage
> decreased to 53%. But after 1 hour in production we are agin on
> 76-78% disk usage and this defragmentation
> =

> So my question is what has changed from 2.6 kernels 3.0 kernels,
> which can explain this massive increase of metadata. (I did a defrag
> and we had sometimes over 140.000 extends to one inode).

How are the files being written?  Do they grow, are they sparse, direct IO
or buffered, etc?

> I am completely confused and do now know how to handle this. Perhaps
> somebody can help me to fix this problem or to understand what
> happens here=85.
> I also talked with some netapp engineers and they said, I should ask
> at xfs.org.
> =

> One the filesystem are about 727 CISAM Files (IDX -> Index Files and
> DAT =96> DATA Files). There are ten 15 GB Files on which some small
> content is often changed by the ERP system. The rest of the files are
> lower than 400 MB.
> We encounter this problem since the upgrade to SLES11 SP2 and the new
> kernel 3.0. (By the way we had to disable the transparent hugepages
> support in kernel 3.0, because of kernel crashes ;) - but this is a
> different story=85 )

You can defeat the speculative preallocation by mounting with the
allocsize option, if you want to test that theory.

-Eric

> --
> Mit freundlichen Gr=FC=DFen/Kind regards
> =

> M.  Hammer
> System administration
> Information Technology
> =

> AUMA Riester GmbH & Co. KG
> Aumastr. 1 =95 79379 Muellheim/Germany
> Tel/Phone +49 7631 809-1620 =95 Fax +49 7631 809-71620
> HammerM@auma.com<mailto:hammerm@auma.com> =95 www.auma.com<http://www.aum=
a.com/>
> =

> Sitz: M=FCllheim, Registergericht Freiburg HRA 300276
> phG: AUMA Riester Verwaltungsgesellschaft mbH, Sitz: M=FCllheim, Register=
gericht Freiburg HRB 300424
> Gesch=E4ftsf=FChrer: Matthias Dinse, Henrik Newerla
> =

> Registered Office: Muellheim, court of registration: Freiburg HRA 300276
> phG: Riester Verwaltungsgesellschaft mbH Registered Office: Muellheim, co=
urt of registration: Freiburg HRB 300424
> Managing Directors: Matthias Dinse, Henrik Newerla
> =

> =

> =

> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
