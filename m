Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4BCfjg9008249 for <xfs@oss.sgi.com>; Fri, 11 May 2012 07:41:45 -0500
Received: from mail.auma.com (mail.auma.com [62.153.90.116]) by cuda.sgi.com
	with ESMTP id cWvWm41luarDhgQz for <xfs@oss.sgi.com>;
	Fri, 11 May 2012 05:41:44 -0700 (PDT)
From: "Hammer, Marcus" <Marcus.Hammer@auma.com>
Date: Fri, 11 May 2012 14:41:41 +0200
Subject: Strange problems with xfs an SLESS11 SP2
Message-ID: <CBD2D5A5.7C6B%Marcus.Hammer@auma.com>
Content-Language: de-DE
MIME-Version: 1.0
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hello,

We have upgraded from SLES11 SP1 to SLES11 SP2. We use an exotic ERP System=
, which stores the data in CISAM Files, which we store on several mounted x=
fs filesystems ( /disk2, /disk3, /disk4, /disk5 and /disk6)
The machine is a DELL R910 with 256 GB RAM and installed SLES11 SP2 (before=
 we used SLES11 SP1). So we also got the new 3.0 kernel after the upgrade. =
The xfs mounts are LUNs on a netapp storage mapped via fibre channel to the
Linux host. Also we use multipathd to have several paths to the netapp stor=
age LUNs.

Now after the upgrade to SLES11 SP2 we encountered a strange change on the =
xfs filesystem /disk5:

The /disk5 is a frequent accessed xfs filesystem by the ERP system. The dis=
k usage increased from 53% to 76-78%. But only the disk usage, the size of =
the files are completely the same. The defragmentation increased to 96%

linuxsrv1:/disk4/ifax/0000 # xfs_db -c frag -r /dev/mapper/360a98000486e593=
84b34497248694170
actual 56156, ideal 2014, fragmentation factor 96.41%

linuxsrv1:/disk4/ifax/0000 # xfs_info /dev/mapper/360a98000486e59384b344972=
48694170
meta-data=3D/dev/mapper/360a98000486e59384b34497248694170 isize=3D256    ag=
count=3D21, agsize=3D3276800 blks
         =3D                       sectsz=3D512   attr=3D0
data     =3D                       bsize=3D4096   blocks=3D68157440, imaxpc=
t=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D25600, version=
=3D1
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D0
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0


The fstab for xfs mounts are without any special options or optimizations, =
here is the snipped from /etc/fstab:

/dev/mapper/360a98000486e59384b3449714a47336c   /disk2  xfs     defaults   =
     0 2
/dev/mapper/360a98000486e59384b34497247514a56   /disk3  xfs     defaults   =
     0 2
/dev/mapper/360a98000486e59384b34497248694170   /disk4  xfs     defaults   =
     0 2
/dev/mapper/360a98000486e59384b344972486f6d4e   /disk5  xfs     defaults   =
     0 2
/dev/mapper/360a98000486e59384b3449724e6f4266   /disk6  xfs     defaults   =
     0 2
/dev/mapper/360a98000486e59384b3449724f326662   /opt/usr        xfs     def=
aults        0 2

But something must have been changed in xfs, because now the metadata incre=
ased so massive, we never had this before with SLES11 SP1.

I did a defragmentation with xfs_fsr and the metadata and usage decreased t=
o 53%. But after 1 hour in production we are agin on 76-78% disk usage and =
this defragmentation

So my question is what has changed from 2.6 kernels 3.0 kernels, which can =
explain this massive increase of metadata. (I did a defrag and we had somet=
imes over 140.000 extends to one inode).

I am completely confused and do now know how to handle this. Perhaps somebo=
dy can help me to fix this problem or to understand what happens here=85.
I also talked with some netapp engineers and they said,  I should ask at xf=
s.org.

One the filesystem are about 727 CISAM Files (IDX -> Index Files and DAT =
=96> DATA Files). There are ten 15 GB Files on which some small content is =
often changed by the ERP system. The rest of the files are lower than 400 M=
B.
We encounter this problem since the upgrade to SLES11 SP2 and the new kerne=
l 3.0. (By the way we had to disable the transparent hugepages support in k=
ernel 3.0, because of kernel crashes ;) - but this is a different story=85 )

--
Mit freundlichen Gr=FC=DFen/Kind regards

M.  Hammer
System administration
Information Technology

AUMA Riester GmbH & Co. KG
Aumastr. 1 =95 79379 Muellheim/Germany
Tel/Phone +49 7631 809-1620 =95 Fax +49 7631 809-71620
HammerM@auma.com<mailto:hammerm@auma.com> =95 www.auma.com<http://www.auma.=
com/>

Sitz: M=FCllheim, Registergericht Freiburg HRA 300276
phG: AUMA Riester Verwaltungsgesellschaft mbH, Sitz: M=FCllheim, Registerge=
richt Freiburg HRB 300424
Gesch=E4ftsf=FChrer: Matthias Dinse, Henrik Newerla

Registered Office: Muellheim, court of registration: Freiburg HRA 300276
phG: Riester Verwaltungsgesellschaft mbH Registered Office: Muellheim, cour=
t of registration: Freiburg HRB 300424
Managing Directors: Matthias Dinse, Henrik Newerla




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
