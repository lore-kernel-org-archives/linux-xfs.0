Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C525B29DF5
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2015 20:36:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8C9148F8039
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2015 18:36:04 -0800 (PST)
Received: from mail-yk0-f171.google.com (mail-yk0-f171.google.com
	[209.85.160.171]) by cuda.sgi.com with ESMTP id
	tvNXmcp5SyonE8pj (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 Dec 2015 18:36:02 -0800 (PST)
Received: by mail-yk0-f171.google.com with SMTP id p130so211703348yka.1
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2015 18:36:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g1eHgm8oUvxFaJkRD-T7jAyw95FQ-q3_GC2JU_kkU-Kg@mail.gmail.com>
References: <CAM=YXF-aXxp19=uFDExUswpEfKXNN6LJScxAB-7-u-AgRiXJ2g@mail.gmail.com>
	<CAPcyv4gYHuSWuugnELSO6B1rye+b89io3zJVUXwRt0wE1ZfPrA@mail.gmail.com>
	<94D0CD8314A33A4D9D801C0FE68B40295BEC985F@G9W0745.americas.hpqcorp.net>
	<20151224000021.GU19802@dastard>
	<CAM=YXF9Dt-BuY9yM7d023a16gp=edGHeCDVTCwV-AEotj6sbFg@mail.gmail.com>
	<CAPcyv4g1eHgm8oUvxFaJkRD-T7jAyw95FQ-q3_GC2JU_kkU-Kg@mail.gmail.com>
Date: Thu, 24 Dec 2015 10:36:01 +0800
Message-ID: <CAM=YXF-wZEhodxVRN8nqyH9Vg7t85ut2-0PnEn9OvhpG_jX3mA@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============1182287056083597788=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ted Tso <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>

--===============1182287056083597788==
Content-Type: multipart/alternative; boundary=001a114fa8ac1d1a9b05279bb37a

--001a114fa8ac1d1a9b05279bb37a
Content-Type: text/plain; charset=UTF-8

>
> xfs will silently disable dax when the fs block size is too small,
> i.e. your mmap() operations are backed by page cache in this case.
> Currently the only indication of whether a mapping is DAX backed or
> not is the presence of the VM_MIXEDMAP flag ("mm" in the VmFlags field
> of /proc/<pid>/smaps)


Did you mean that I should make the blocksize bigger until the mount
command tell me that dax is enabled?

I have tried to set blocksize to 2048/4096/8192. When 2048/4096 the mount
command remained silent, when 8192 it prompted:

$ sudo mkfs.xfs -f -b size=8192 /dev/pmem0
meta-data=/dev/pmem0             isize=512    agcount=4, agsize=4096 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1
data     =                       bsize=8192   blocks=16384, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=8192   ascii-ci=0 ftype=1
log      =internal log           bsize=8192   blocks=558, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=8192   blocks=0, rtextents=0

$ sudo mount -o dax /dev/pmem0 /mnt/mem
mount: mount /dev/pmem0 on /mnt/mem failed: Function not implemented

2015-12-24 8:58 GMT+08:00 Dan Williams <dan.j.williams@intel.com>:

> On Wed, Dec 23, 2015 at 4:34 PM, Cholerae Hu <choleraehyq@gmail.com>
> wrote:
> > The block size is 1024.
> > # dumpe2fs -h /dev/pmem0 | grep "Block size"
> > dumpe2fs 1.42.13 (17-May-2015)
> > Block size:               1024
> >
> > I tried it out on xfs and I succeeded. There are the prompting messages:
> > # mkfs.xfs -f -b size=1024 /dev/pmem0
> > meta-data=/dev/pmem0             isize=512    agcount=4, agsize=32768
> blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=1
> > data     =                       bsize=1024   blocks=131072, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > log      =internal log           bsize=1024   blocks=2571, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > # mount -o dax /dev/pmem0 /mnt/mem
> >
> > The mount command doesn't return any message, and I can successfully
> read or
> > write files in /mnt/mem.
> >
>
> xfs will silently disable dax when the fs block size is too small,
> i.e. your mmap() operations are backed by page cache in this case.
> Currently the only indication of whether a mapping is DAX backed or
> not is the presence of the VM_MIXEDMAP flag ("mm" in the VmFlags field
> of /proc/<pid>/smaps)
>

--001a114fa8ac1d1a9b05279bb37a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px =
0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-l=
eft-style:solid;padding-left:1ex"><span style=3D"font-size:14px">xfs will s=
ilently disable dax when the fs block size is too small,<br></span><span st=
yle=3D"font-size:14px">i.e. your mmap() operations are backed by page cache=
 in this case.<br></span><span style=3D"font-size:14px">Currently the only =
indication of whether a mapping is DAX backed or<br></span><span style=3D"f=
ont-size:14px">not is the presence of the VM_MIXEDMAP flag (&quot;mm&quot; =
in the VmFlags field<br></span><span style=3D"font-size:14px">of /proc/&lt;=
pid&gt;/smaps)</span></blockquote><div><br></div>Did you mean that I should=
 make the blocksize bigger until the mount command tell me that dax is enab=
led?<div><br></div><div>I have tried to set blocksize to 2048/4096/8192. Wh=
en 2048/4096 the mount command remained silent, when 8192 it prompted:</div=
><div><br></div><div><div>$ sudo mkfs.xfs -f -b size=3D8192 /dev/pmem0</div=
><div>meta-data=3D/dev/pmem0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 isiz=
e=3D512 =C2=A0 =C2=A0agcount=3D4, agsize=3D4096 blks</div><div>=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 attr=3D2, projid32bit=
=3D1</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 crc=3D1 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0finobt=3D1</div><div>data =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D8192=
 =C2=A0 blocks=3D16384, imaxpct=3D25</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 sunit=3D0 =C2=A0 =C2=A0 =C2=A0swidth=3D0 blks</div><div>namin=
g =C2=A0 =3Dversion 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bsize=
=3D8192 =C2=A0 ascii-ci=3D0 ftype=3D1</div><div>log =C2=A0 =C2=A0 =C2=A0=3D=
internal log =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D8192 =C2=A0 blocks=
=3D558, version=3D2</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sects=
z=3D512 =C2=A0 sunit=3D0 blks, lazy-count=3D1</div><div>realtime =3Dnone =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 extsz=3D8192=
 =C2=A0 blocks=3D0, rtextents=3D0</div><div><br></div><div>$ sudo mount -o =
dax /dev/pmem0 /mnt/mem</div><div>mount: mount /dev/pmem0 on /mnt/mem faile=
d: Function not implemented</div></div></div><div class=3D"gmail_extra"><br=
><div class=3D"gmail_quote">2015-12-24 8:58 GMT+08:00 Dan Williams <span di=
r=3D"ltr">&lt;<a href=3D"mailto:dan.j.williams@intel.com" target=3D"_blank"=
>dan.j.williams@intel.com</a>&gt;</span>:<br><blockquote class=3D"gmail_quo=
te" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"=
><span class=3D"">On Wed, Dec 23, 2015 at 4:34 PM, Cholerae Hu &lt;<a href=
=3D"mailto:choleraehyq@gmail.com">choleraehyq@gmail.com</a>&gt; wrote:<br>
&gt; The block size is 1024.<br>
&gt; # dumpe2fs -h /dev/pmem0 | grep &quot;Block size&quot;<br>
&gt; dumpe2fs 1.42.13 (17-May-2015)<br>
&gt; Block size:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01024=
<br>
&gt;<br>
&gt; I tried it out on xfs and I succeeded. There are the prompting message=
s:<br>
&gt; # mkfs.xfs -f -b size=3D1024 /dev/pmem0<br>
&gt; meta-data=3D/dev/pmem0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
isize=3D512=C2=A0 =C2=A0 agcount=3D4, agsize=3D32768 blks<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sectsz=3D512=C2=A0 =C2=
=A0attr=3D2, projid32bit=3D1<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0crc=3D1=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 finobt=3D1<br>
&gt; data=C2=A0 =C2=A0 =C2=A0=3D=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bsize=3D1024=C2=A0 =C2=A0blocks=3D=
131072, imaxpct=3D25<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sunit=3D0=C2=A0 =C2=A0 =
=C2=A0 swidth=3D0 blks<br>
&gt; naming=C2=A0 =C2=A0=3Dversion 2=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 bsize=3D4096=C2=A0 =C2=A0ascii-ci=3D0 ftype=3D1<br>
&gt; log=C2=A0 =C2=A0 =C2=A0 =3Dinternal log=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0bsize=3D1024=C2=A0 =C2=A0blocks=3D2571, version=3D2<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sectsz=3D512=C2=A0 =C2=
=A0sunit=3D0 blks, lazy-count=3D1<br>
&gt; realtime =3Dnone=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0extsz=3D4096=C2=A0 =C2=A0blocks=3D0, rtextents=3D0<br>
&gt; # mount -o dax /dev/pmem0 /mnt/mem<br>
&gt;<br>
&gt; The mount command doesn&#39;t return any message, and I can successful=
ly read or<br>
&gt; write files in /mnt/mem.<br>
&gt;<br>
<br>
</span>xfs will silently disable dax when the fs block size is too small,<b=
r>
i.e. your mmap() operations are backed by page cache in this case.<br>
Currently the only indication of whether a mapping is DAX backed or<br>
not is the presence of the VM_MIXEDMAP flag (&quot;mm&quot; in the VmFlags =
field<br>
of /proc/&lt;pid&gt;/smaps)<br>
</blockquote></div><br></div>

--001a114fa8ac1d1a9b05279bb37a--


--===============1182287056083597788==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1182287056083597788==--
