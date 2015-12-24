Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4223F29DF5
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2015 18:34:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F06CB30404E
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2015 16:34:47 -0800 (PST)
Received: from mail-yk0-f172.google.com (mail-yk0-f172.google.com
	[209.85.160.172]) by cuda.sgi.com with ESMTP id
	x12HeOHpFTOqPwtg (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 Dec 2015 16:34:45 -0800 (PST)
Received: by mail-yk0-f172.google.com with SMTP id x184so211597921yka.3
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2015 16:34:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151224000021.GU19802@dastard>
References: <CAM=YXF-aXxp19=uFDExUswpEfKXNN6LJScxAB-7-u-AgRiXJ2g@mail.gmail.com>
	<CAPcyv4gYHuSWuugnELSO6B1rye+b89io3zJVUXwRt0wE1ZfPrA@mail.gmail.com>
	<94D0CD8314A33A4D9D801C0FE68B40295BEC985F@G9W0745.americas.hpqcorp.net>
	<20151224000021.GU19802@dastard>
Date: Thu, 24 Dec 2015 08:34:45 +0800
Message-ID: <CAM=YXF9Dt-BuY9yM7d023a16gp=edGHeCDVTCwV-AEotj6sbFg@mail.gmail.com>
Subject: Re: A blocksize problem about dax and ext4
From: Cholerae Hu <choleraehyq@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6367235618738791190=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Ted Tso <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, Dan Williams <dan.j.williams@intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>

--===============6367235618738791190==
Content-Type: multipart/alternative; boundary=001a114fa8ac61858805279a01a1

--001a114fa8ac61858805279a01a1
Content-Type: text/plain; charset=UTF-8

The block size is 1024.
# dumpe2fs -h /dev/pmem0 | grep "Block size"
dumpe2fs 1.42.13 (17-May-2015)
Block size:               1024

I tried it out on xfs and I succeeded. There are the prompting messages:
# mkfs.xfs -f -b size=1024 /dev/pmem0
meta-data=/dev/pmem0             isize=512    agcount=4, agsize=32768 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1
data     =                       bsize=1024   blocks=131072, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=1024   blocks=2571, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# mount -o dax /dev/pmem0 /mnt/mem

The mount command doesn't return any message, and I can successfully read
or write files in /mnt/mem.

2015-12-24 8:00 GMT+08:00 Dave Chinner <david@fromorbit.com>:

> On Wed, Dec 23, 2015 at 09:18:05PM +0000, Elliott, Robert (Persistent
> Memory) wrote:
> >
> > > -----Original Message-----
> > > From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On
> Behalf Of
> > > Dan Williams
> > > Sent: Wednesday, December 23, 2015 11:16 AM
> > > To: Cholerae Hu <choleraehyq@gmail.com>
> > > Cc: linux-nvdimm@lists.01.org
> > > Subject: Re: A blocksize problem about dax and ext4
> > >
> > > On Wed, Dec 23, 2015 at 4:03 AM, Cholerae Hu <choleraehyq@gmail.com>
> > > wrote:
> > ...
> > > > [root@localhost cholerae]# mount -o dax /dev/pmem0 /mnt/mem
> > > > mount: wrong fs type, bad option, bad superblock on /dev/pmem0,
> > > >        missing codepage or helper program, or other error
> > > >
> > > >        In some cases useful info is found in syslog - try
> > > >        dmesg | tail or so.
> > > > [root@localhost cholerae]# dmesg | tail
> > ...
> > > > [   81.779582] EXT4-fs (pmem0): error: unsupported blocksize for dax
> > ...
> >
> > > What's the fs block size?  For example:
> > > # dumpe2fs -h /dev/pmem0  | grep "Block size"
> > > dumpe2fs 1.42.9 (28-Dec-2013)
> > > Block size:               4096
> > > Depending on the size of /dev/pmem0 it may have automatically set it
> > > to a block size less than 4 KiB which is incompatible with "-o dax".
> >
> > I noticed a few things while trying that out on both ext4 and xfs.
> >
> > $ sudo mkfs.ext4 -F -b 1024 /dev/pmem0
> > $ sudo mount -o dax /dev/pmem0 /mnt/ext4-pmem0
> > $ sudo mkfs.xfs -f -b size=1024 /dev/pmem0
> > $ sudo mount -o dax /dev/pmem0 /mnt/xfs-pmem0
> >
> > [  199.679195] EXT4-fs (pmem0): DAX enabled. Warning: EXPERIMENTAL, use
> at your own risk
> > [  199.724931] EXT4-fs (pmem0): error: unsupported block size 1024 for
> dax
> > [  859.077766] XFS (pmem0): DAX enabled. Warning: EXPERIMENTAL, use at
> your own risk
> > [  859.118106] XFS (pmem0): Filesystem block size invalid for DAX
> Turning DAX off.
> > [  859.156950] XFS (pmem0): Mounting V4 Filesystem
> > [  859.183626] XFS (pmem0): Ending clean mount
> >
> > 1. ext4 fails to mount the filesystem, while xfs just disables DAX.
> > It seems like they should they be the same.
>
> I don't really care what is done to ext4 here, but I'm not changing
> XFS behaviour. I'm expecting mixed dax/non-dax fileystems to be a
> thing, with DAX turned on by an inode flag on disk. Indeed, I see
> the mount option going away permanently for XFS, and DAX being
> controlled completely from on-disk flags. E.g. ext4 encrypted files
> need to turn off DAX, while clear text files can be accessed using
> DAX. This should happen completely transparently to the user....
>
> In the situation of block size < page size, there's things we can do
> to ensure that XFS will allocate page size aligned/sized extents
> (extent size hints FTW). This is the same mechanism that we'll use
> to ensure that extents are aligned/sized for reliable huge page
> mappings. Hence while DAX /as a global option/ needs to be turned
> off for sub-page block size filesystems, there's no reason why we
> can't turn DAX on for files that will always allocate blocks
> according to DAX constraints.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--001a114fa8ac61858805279a01a1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>The block size is 1024.</div><div># dumpe2fs -h /dev/=
pmem0 | grep &quot;Block size&quot;</div><div>dumpe2fs 1.42.13 (17-May-2015=
)</div><div>Block size: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 10=
24</div><div><br></div><div>I tried it out on xfs and I succeeded. There ar=
e the prompting messages:<br></div><div><div># mkfs.xfs -f -b size=3D1024 /=
dev/pmem0</div><div>meta-data=3D/dev/pmem0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 isize=3D512 =C2=A0 =C2=A0agcount=3D4, agsize=3D32768 blks</div><=
div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 attr=3D2,=
 projid32bit=3D1</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 crc=3D1 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0finobt=3D1</div><div>data =C2=A0 =C2=A0 =3D =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 b=
size=3D1024 =C2=A0 blocks=3D131072, imaxpct=3D25</div><div>=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 sunit=3D0 =C2=A0 =C2=A0 =C2=A0swidth=3D0 blks</=
div><div>naming =C2=A0 =3Dversion 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0bsize=3D4096 =C2=A0 ascii-ci=3D0 ftype=3D1</div><div>log =C2=A0 =
=C2=A0 =C2=A0=3Dinternal log =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D102=
4 =C2=A0 blocks=3D2571, version=3D2</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 sectsz=3D512 =C2=A0 sunit=3D0 blks, lazy-count=3D1</div><div>=
realtime =3Dnone =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 extsz=3D4096 =C2=A0 blocks=3D0, rtextents=3D0</div></div><div># moun=
t -o dax /dev/pmem0 /mnt/mem<br></div><div><br></div><div>The mount command=
 doesn&#39;t return any message, and I can successfully read or write files=
 in /mnt/mem.</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail=
_quote">2015-12-24 8:00 GMT+08:00 Dave Chinner <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&=
gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex=
;border-left:1px #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div cl=
ass=3D"h5">On Wed, Dec 23, 2015 at 09:18:05PM +0000, Elliott, Robert (Persi=
stent Memory) wrote:<br>
&gt;<br>
&gt; &gt; -----Original Message-----<br>
&gt; &gt; From: Linux-nvdimm [mailto:<a href=3D"mailto:linux-nvdimm-bounces=
@lists.01.org">linux-nvdimm-bounces@lists.01.org</a>] On Behalf Of<br>
&gt; &gt; Dan Williams<br>
&gt; &gt; Sent: Wednesday, December 23, 2015 11:16 AM<br>
&gt; &gt; To: Cholerae Hu &lt;<a href=3D"mailto:choleraehyq@gmail.com">chol=
eraehyq@gmail.com</a>&gt;<br>
&gt; &gt; Cc: <a href=3D"mailto:linux-nvdimm@lists.01.org">linux-nvdimm@lis=
ts.01.org</a><br>
&gt; &gt; Subject: Re: A blocksize problem about dax and ext4<br>
&gt; &gt;<br>
&gt; &gt; On Wed, Dec 23, 2015 at 4:03 AM, Cholerae Hu &lt;<a href=3D"mailt=
o:choleraehyq@gmail.com">choleraehyq@gmail.com</a>&gt;<br>
&gt; &gt; wrote:<br>
&gt; ...<br>
&gt; &gt; &gt; [root@localhost cholerae]# mount -o dax /dev/pmem0 /mnt/mem<=
br>
&gt; &gt; &gt; mount: wrong fs type, bad option, bad superblock on /dev/pme=
m0,<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 missing codepage or helper progra=
m, or other error<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 In some cases useful info is foun=
d in syslog - try<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 dmesg | tail or so.<br>
&gt; &gt; &gt; [root@localhost cholerae]# dmesg | tail<br>
&gt; ...<br>
&gt; &gt; &gt; [=C2=A0 =C2=A081.779582] EXT4-fs (pmem0): error: unsupported=
 blocksize for dax<br>
&gt; ...<br>
&gt;<br>
&gt; &gt; What&#39;s the fs block size?=C2=A0 For example:<br>
&gt; &gt; # dumpe2fs -h /dev/pmem0=C2=A0 | grep &quot;Block size&quot;<br>
&gt; &gt; dumpe2fs 1.42.9 (28-Dec-2013)<br>
&gt; &gt; Block size:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A04096<br>
&gt; &gt; Depending on the size of /dev/pmem0 it may have automatically set=
 it<br>
&gt; &gt; to a block size less than 4 KiB which is incompatible with &quot;=
-o dax&quot;.<br>
&gt;<br>
&gt; I noticed a few things while trying that out on both ext4 and xfs.<br>
&gt;<br>
&gt; $ sudo mkfs.ext4 -F -b 1024 /dev/pmem0<br>
&gt; $ sudo mount -o dax /dev/pmem0 /mnt/ext4-pmem0<br>
&gt; $ sudo mkfs.xfs -f -b size=3D1024 /dev/pmem0<br>
&gt; $ sudo mount -o dax /dev/pmem0 /mnt/xfs-pmem0<br>
&gt;<br>
&gt; [=C2=A0 199.679195] EXT4-fs (pmem0): DAX enabled. Warning: EXPERIMENTA=
L, use at your own risk<br>
&gt; [=C2=A0 199.724931] EXT4-fs (pmem0): error: unsupported block size 102=
4 for dax<br>
&gt; [=C2=A0 859.077766] XFS (pmem0): DAX enabled. Warning: EXPERIMENTAL, u=
se at your own risk<br>
&gt; [=C2=A0 859.118106] XFS (pmem0): Filesystem block size invalid for DAX=
 Turning DAX off.<br>
&gt; [=C2=A0 859.156950] XFS (pmem0): Mounting V4 Filesystem<br>
&gt; [=C2=A0 859.183626] XFS (pmem0): Ending clean mount<br>
&gt;<br>
&gt; 1. ext4 fails to mount the filesystem, while xfs just disables DAX.<br=
>
&gt; It seems like they should they be the same.<br>
<br>
</div></div>I don&#39;t really care what is done to ext4 here, but I&#39;m =
not changing<br>
XFS behaviour. I&#39;m expecting mixed dax/non-dax fileystems to be a<br>
thing, with DAX turned on by an inode flag on disk. Indeed, I see<br>
the mount option going away permanently for XFS, and DAX being<br>
controlled completely from on-disk flags. E.g. ext4 encrypted files<br>
need to turn off DAX, while clear text files can be accessed using<br>
DAX. This should happen completely transparently to the user....<br>
<br>
In the situation of block size &lt; page size, there&#39;s things we can do=
<br>
to ensure that XFS will allocate page size aligned/sized extents<br>
(extent size hints FTW). This is the same mechanism that we&#39;ll use<br>
to ensure that extents are aligned/sized for reliable huge page<br>
mappings. Hence while DAX /as a global option/ needs to be turned<br>
off for sub-page block size filesystems, there&#39;s no reason why we<br>
can&#39;t turn DAX on for files that will always allocate blocks<br>
according to DAX constraints.<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div>

--001a114fa8ac61858805279a01a1--


--===============6367235618738791190==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6367235618738791190==--
