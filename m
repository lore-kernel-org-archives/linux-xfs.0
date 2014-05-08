Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3FB907F52
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 04:12:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D49EFAC003
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 02:12:36 -0700 (PDT)
Received: from mail-oa0-f52.google.com (mail-oa0-f52.google.com
	[209.85.219.52]) by cuda.sgi.com with ESMTP id 682CI4d33qIYK3jF
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 08 May 2014 02:12:33 -0700 (PDT)
Received: by mail-oa0-f52.google.com with SMTP id eb12so2740408oac.11
	for <xfs@oss.sgi.com>; Thu, 08 May 2014 02:12:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <536AEBB9.3020807@hardwarefreak.com>
References: <CAPrERe02bfrW6+5c+oZPgd9c_7AUx=BEUcAOAj2dT_iYn=P_1w@mail.gmail.com>
	<536AEBB9.3020807@hardwarefreak.com>
Date: Thu, 8 May 2014 11:12:32 +0200
Message-ID: <CAPrERe3v_1mPy6ABAKj4TxTmy1FB2=ipi6Vn3N6dZ7w8B9DeZA@mail.gmail.com>
Subject: Re: Alignment: XFS + LVM2
From: Marc Caubet <mcaubet@pic.es>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4605301930375238212=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

--===============4605301930375238212==
Content-Type: multipart/alternative; boundary=001a11c3001897f62304f8dfe1ee

--001a11c3001897f62304f8dfe1ee
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Stan,

thanks for your answer.

Everything begins and ends with the workload.
>
> On 5/7/2014 7:43 AM, Marc Caubet wrote:
> > Hi all,
> >
> > I am trying to setup a storage pool with correct disk alignment and I
> hope
> > somebody can help me to understand some unclear parts to me when
> > configuring XFS over LVM2.
>
> I'll try.  But to be honest, after my first read of your post, a few
> things jump out as breaking traditional rules.
>
> The first thing you need to consider is your workload and the type of
> read/write patterns it will generate.  This document is unfinished, and
> unformatted, but reading what is there should be informative:
>
> http://www.hardwarefreak.com/xfs/storage-arch.txt
>

Basically we are moving a lot of data :) It means, parallel large files
(GBs) are being written and read all the time. Basically we have a batch
farm with 3,5k cores processing jobs that are constantly reading and
writing to the storage pools (4PBs). Only few pools (~5% of the total)
contain small files (and only small files).

>
> > Actually we have few storage pools with the following settings each:
> >
> > - LSI Controller with 3xRAID6
> > - Each RAID6 is configured with 10 data disks + 2 for double-parity.
> > - Each disk has a capacity of 4TB, 512e and physical sector size of 4K.
>
> 512e drives may cause data loss.  See:
> http://docs.oracle.com/cd/E26502_01/html/E28978/gmkgj.html#gmlfz
>

Haven't experienced this yet. But good to know thanks :)  On the other
hand, we do not use zfs


> > - 3x(10+2) configuration was considered in order to gain best performan=
ce
> > and data safety (less disks per RAID less probability of data corruptio=
n)
>
> RAID6 is the worst performer of all the RAID levels but gives the best
> resilience to multiple drive failure.  The reason for using fewer drives
> per array has less to do with probability of corruption, but
>
> 1. Limiting RMW operations to as few drives as possible, especially for
> controllers that do full stripe scrubbing on RMW
>
> 2.  Lowering bandwidth and time required to rebuild a dead drive, fewer
> drives tied up during a rebuild
>

> > From the O.S. side we see:
> >
> > [root@stgpool01 ~]# fdisk -l /dev/sda /dev/sdb /dev/sdc
> ...
>
> You omitted crucial information.  What is the stripe unit size of each
> RAID6?
>

Actually the stripe size for each RAID6 is 256KB but we plan to increase
some pools to 1MB for all their RAIDs. It will be in order to compare
performance for pools containing large files and if this improves, we will
apply it to the other systems in the future.


> > The idea is to aggregate the above devices and show only 1 storage spac=
e.
> > We did as follows:
> >
> > vgcreate dcvg_a /dev/sda /dev/sdb /dev/sdc
> > lvcreate -i 3 -I 4096 -n dcpool -l 100%FREE -v dcvg_a
>
> You've told LVM that its stripe unit is 4MB, and thus the stripe width
> of each RAID6 is 4MB.  This is not possible with 10 data spindles.
> Again, show the RAID geometry from the LSI tools.
>
When creating a nested stripe, the stripe unit of the outer stripe (LVM)
> must equal the stripe width of eachinner stripe (RAID6).
>

Great. Hence, if the RAID6 stripe size is 256k then the LVM should be
defined with 256k as well, isn't it?

> Hence, stripe of the 3 RAID6 in a LV.
>
> Each RAID6 has ~1.3GB/s of throughput.  By striping the 3 arrays into a
> nested RAID60 this suggests you need single file throughput greater than
> 1.3GB/s and that all files are very large.  If not, you'd be better off
> using a concatenation, and using md to accomplish that instead of LVM.
>
> > And here is my first question: How can I check if the storage and the L=
V
> > are correctly aligned?
>
> Answer is above.  But the more important question is whether your
> workload wants a stripe or a concatenation.
>
> > On the other hand, I have formatted XFS as follows:
> >
> > mkfs.xfs -d su=3D256k,sw=3D10 -l size=3D128m,lazy-count=3D1 /dev/dcvg_a=
/dcpool
>
> This alignment is not correct.  XFS must be aligned to the LVM stripe
> geometry.  Here you apparently aligned XFS to the RAID6 geometry
> instead.  Why are you manually specifying a 128M log?  If you knew your
> workload that well, you would not have made these other mistakes.
>

We receive several parallel writes all the time, and afaik filesystems with
such write load benenfit from a larger log. 128M is the maximum log size.

So how XFS should be formatted then? As you specify, should be aligned with
the LVM stripe, as we have a LV with 3 stripes then 256k*3 and sw=3D30?

Thanks a lot,
--=20
Marc Caubet Serrabou
PIC (Port d'Informaci=C3=B3 Cient=C3=ADfica)
Campus UAB, Edificio D
E-08193 Bellaterra, Barcelona
Tel: +34 93 581 33 22
Fax: +34 93 581 41 10
http://www.pic.es
Avis - Aviso - Legal Notice: http://www.ifae.es/legal.html

--001a11c3001897f62304f8dfe1ee
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Stan, <br><br>thanks for your answer.<br><div class=3D"=
gmail_extra"><br><div class=3D"gmail_quote"><blockquote class=3D"gmail_quot=
e" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204)=
;padding-left:1ex">
Everything begins and ends with the workload.<br>
<div class=3D""><br>
On 5/7/2014 7:43 AM, Marc Caubet wrote:<br>
&gt; Hi all,<br>
&gt;<br>
&gt; I am trying to setup a storage pool with correct disk alignment and I =
hope<br>
&gt; somebody can help me to understand some unclear parts to me when<br>
&gt; configuring XFS over LVM2.<br>
<br>
</div>I&#39;ll try. =C2=A0But to be honest, after my first read of your pos=
t, a few<br>
things jump out as breaking traditional rules.<br>
<br>
The first thing you need to consider is your workload and the type of<br>
read/write patterns it will generate. =C2=A0This document is unfinished, an=
d<br>
unformatted, but reading what is there should be informative:<br>
<br>
<a href=3D"http://www.hardwarefreak.com/xfs/storage-arch.txt" target=3D"_bl=
ank">http://www.hardwarefreak.com/xfs/storage-arch.txt</a><br></blockquote>=
<div><br></div><div>Basically we are moving a lot of data :) It means, para=
llel large files (GBs) are being written and read all the time. Basically w=
e have a batch farm with 3,5k cores processing jobs that are constantly rea=
ding and writing to the storage pools (4PBs). Only few pools (~5% of the to=
tal) contain small files (and only small files).<br>
</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;b=
order-left:1px solid rgb(204,204,204);padding-left:1ex">
<div class=3D""><br>
&gt; Actually we have few storage pools with the following settings each:<b=
r>
&gt;<br>
&gt; - LSI Controller with 3xRAID6<br>
&gt; - Each RAID6 is configured with 10 data disks + 2 for double-parity.<b=
r>
&gt; - Each disk has a capacity of 4TB, 512e and physical sector size of 4K=
.<br>
<br>
</div>512e drives may cause data loss. =C2=A0See:<br>
<a href=3D"http://docs.oracle.com/cd/E26502_01/html/E28978/gmkgj.html#gmlfz=
" target=3D"_blank">http://docs.oracle.com/cd/E26502_01/html/E28978/gmkgj.h=
tml#gmlfz</a><br></blockquote><div><br></div><div>Haven&#39;t experienced t=
his yet. But good to know thanks :)=C2=A0 On the other hand, we do not use =
zfs<br>
<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8=
ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><br><div class=
=3D"">
&gt; - 3x(10+2) configuration was considered in order to gain best performa=
nce<br>
&gt; and data safety (less disks per RAID less probability of data corrupti=
on)<br>
<br>
</div>RAID6 is the worst performer of all the RAID levels but gives the bes=
t<br>
resilience to multiple drive failure. =C2=A0The reason for using fewer driv=
es<br>
per array has less to do with probability of corruption, but<br>
<br>
1. Limiting RMW operations to as few drives as possible, especially for<br>
controllers that do full stripe scrubbing on RMW<br>
<br>
2. =C2=A0Lowering bandwidth and time required to rebuild a dead drive, fewe=
r<br>
drives tied up during a rebuild <br></blockquote><blockquote class=3D"gmail=
_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204=
,204);padding-left:1ex">
<div class=3D""><br>
&gt; From the O.S. side we see:<br>
&gt;<br>
&gt; [root@stgpool01 ~]# fdisk -l /dev/sda /dev/sdb /dev/sdc<br>
</div>...<br>
<br>
You omitted crucial information. =C2=A0What is the stripe unit size of each=
<br>
RAID6?<br></blockquote><div><br></div><div>Actually the stripe size for eac=
h RAID6 is 256KB but we plan to increase some pools to 1MB for all their RA=
IDs. It will be in order to compare performance for pools containing large =
files and if this improves, we will apply it to the other systems in the fu=
ture.<br>
</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0p=
x 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">&g=
t; The idea is to aggregate the above devices and show only 1 storage space=
.<br>
<div class=3D"">
&gt; We did as follows:<br>
&gt;<br>
&gt; vgcreate dcvg_a /dev/sda /dev/sdb /dev/sdc<br>
&gt; lvcreate -i 3 -I 4096 -n dcpool -l 100%FREE -v dcvg_a<br>
<br>
</div>You&#39;ve told LVM that its stripe unit is 4MB, and thus the stripe =
width<br>
of each RAID6 is 4MB. =C2=A0This is not possible with 10 data spindles.<br>
Again, show the RAID geometry from the LSI tools. <br></blockquote><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px=
 solid rgb(204,204,204);padding-left:1ex">
When creating a nested stripe, the stripe unit of the outer stripe (LVM)<br=
>
must equal the stripe width of eachinner stripe (RAID6).<br></blockquote><d=
iv><br></div><div>Great. Hence, if the RAID6 stripe size is 256k then the L=
VM should be defined with 256k as well, isn&#39;t it? <br><br></div><blockq=
uote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1p=
x solid rgb(204,204,204);padding-left:1ex">
<div class=3D"">
&gt; Hence, stripe of the 3 RAID6 in a LV.<br>
<br>
</div>Each RAID6 has ~1.3GB/s of throughput. =C2=A0By striping the 3 arrays=
 into a<br>
nested RAID60 this suggests you need single file throughput greater than<br=
>
1.3GB/s and that all files are very large. =C2=A0If not, you&#39;d be bette=
r off<br>
using a concatenation, and using md to accomplish that instead of LVM.<br>
<div class=3D""><br>
&gt; And here is my first question: How can I check if the storage and the =
LV<br>
&gt; are correctly aligned?<br>
<br>
</div>Answer is above. =C2=A0But the more important question is whether you=
r<br>
workload wants a stripe or a concatenation.<br>
<div class=3D""><br>
&gt; On the other hand, I have formatted XFS as follows:<br>
&gt;<br>
&gt; mkfs.xfs -d su=3D256k,sw=3D10 -l size=3D128m,lazy-count=3D1 /dev/dcvg_=
a/dcpool<br>
<br>
</div>This alignment is not correct. =C2=A0XFS must be aligned to the LVM s=
tripe<br>
geometry. =C2=A0Here you apparently aligned XFS to the RAID6 geometry<br>
instead. =C2=A0Why are you manually specifying a 128M log? =C2=A0If you kne=
w your<br>
workload that well, you would not have made these other mistakes.<br></bloc=
kquote><div><br></div><div>We receive several parallel writes all the time,=
 and afaik filesystems with such write load benenfit from a larger log. 128=
M is the maximum log size.<br>
<br>So how XFS should be formatted then? As you specify, should be aligned =
with the LVM stripe, as we have a LV with 3 stripes then 256k*3 and sw=3D30=
? <br></div></div><br>Thanks a lot,<br>-- <br>Marc Caubet Serrabou<br>PIC (=
Port d&#39;Informaci=C3=B3 Cient=C3=ADfica)<br>
Campus UAB, Edificio D<br>E-08193 Bellaterra, Barcelona<br>Tel: +34 93 581 =
33 22<br>Fax: +34 93 581 41 10<br><a href=3D"http://www.pic.es" target=3D"_=
blank">http://www.pic.es</a><br>Avis - Aviso - Legal Notice: <a href=3D"htt=
p://www.ifae.es/legal.html" target=3D"_blank">http://www.ifae.es/legal.html=
</a>
</div></div>

--001a11c3001897f62304f8dfe1ee--


--===============4605301930375238212==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4605301930375238212==--
