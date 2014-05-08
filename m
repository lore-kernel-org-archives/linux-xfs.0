Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5FDE37F56
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 08:52:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1A8A08F8037
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 06:52:14 -0700 (PDT)
Received: from mail-oa0-f45.google.com (mail-oa0-f45.google.com
	[209.85.219.45]) by cuda.sgi.com with ESMTP id iEW9d6rftam5UZ2A
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 08 May 2014 06:52:10 -0700 (PDT)
Received: by mail-oa0-f45.google.com with SMTP id l6so3121901oag.32
	for <xfs@oss.sgi.com>; Thu, 08 May 2014 06:52:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <536B80E0.9000406@hardwarefreak.com>
References: <CAPrERe02bfrW6+5c+oZPgd9c_7AUx=BEUcAOAj2dT_iYn=P_1w@mail.gmail.com>
	<536AEBB9.3020807@hardwarefreak.com>
	<CAPrERe3v_1mPy6ABAKj4TxTmy1FB2=ipi6Vn3N6dZ7w8B9DeZA@mail.gmail.com>
	<536B80E0.9000406@hardwarefreak.com>
Date: Thu, 8 May 2014 15:52:09 +0200
Message-ID: <CAPrERe2K=DhR2frozaranf3JWgrFi81o5bhBF-BhmWcrW=4L=g@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============3248662103561385197=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

--===============3248662103561385197==
Content-Type: multipart/alternative; boundary=047d7b41791d91acac04f8e3c928

--047d7b41791d91acac04f8e3c928
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Stan,

once again, thanks for your answer.

> Hi Stan,
> >
> > thanks for your answer.
> >
> > Everything begins and ends with the workload.
> >>
> >> On 5/7/2014 7:43 AM, Marc Caubet wrote:
> >>> Hi all,
> >>>
> >>> I am trying to setup a storage pool with correct disk alignment and I
> >> hope
> >>> somebody can help me to understand some unclear parts to me when
> >>> configuring XFS over LVM2.
> >>
> >> I'll try.  But to be honest, after my first read of your post, a few
> >> things jump out as breaking traditional rules.
> >>
> >> The first thing you need to consider is your workload and the type of
> >> read/write patterns it will generate.  This document is unfinished, an=
d
> >> unformatted, but reading what is there should be informative:
> >>
> >> http://www.hardwarefreak.com/xfs/storage-arch.txt
> >>
> >
> > Basically we are moving a lot of data :) It means, parallel large files
> > (GBs) are being written and read all the time. Basically we have a batc=
h
> > farm with 3,5k cores processing jobs that are constantly reading and
> > writing to the storage pools (4PBs). Only few pools (~5% of the total)
> > contain small files (and only small files).
>
> And these pools are tied together with?  Gluster?  Ceph?
>

We are using dCache (http://www.dcache.org/), where a file is written in a
single pool instead of spreading parts among pools as Ceph or Hadoop do. So
large files go entirely to a pool.


> >>> Actually we have few storage pools with the following settings each:
> >>>
> >>> - LSI Controller with 3xRAID6
> >>> - Each RAID6 is configured with 10 data disks + 2 for double-parity.
> >>> - Each disk has a capacity of 4TB, 512e and physical sector size of 4=
K.
> >>
> >> 512e drives may cause data loss.  See:
> >> http://docs.oracle.com/cd/E26502_01/html/E28978/gmkgj.html#gmlfz
> >>
> >
> > Haven't experienced this yet. But good to know thanks :)  On the other
> > hand, we do not use zfs
>
> This problem affects all filesystems.  If the drive loses power during
> an RMW cycle the physical sector is corrupted.  As noted, not all 512e
> drives may have this problem.  And for the bulk of your workload this
> shouldn't be an issue.  If you have sufficient and properly functioning
> UPS it shouldn't be an issue either.
>

 Actually all LSI controllers have batteries so I hope it will not happen.
This problems is good to have this in mind when we purchase new storage
machines so thanks :)


>
> >>> - 3x(10+2) configuration was considered in order to gain best
> performance
> >>> and data safety (less disks per RAID less probability of data
> corruption)
> >>
> >> RAID6 is the worst performer of all the RAID levels but gives the best
> >> resilience to multiple drive failure.  The reason for using fewer driv=
es
> >> per array has less to do with probability of corruption, but
> >>
> >> 1. Limiting RMW operations to as few drives as possible, especially fo=
r
> >> controllers that do full stripe scrubbing on RMW
> >>
> >> 2.  Lowering bandwidth and time required to rebuild a dead drive, fewe=
r
> >> drives tied up during a rebuild
> >>
> >
> >>> From the O.S. side we see:
> >>>
> >>> [root@stgpool01 ~]# fdisk -l /dev/sda /dev/sdb /dev/sdc
> >> ...
> >>
> >> You omitted crucial information.  What is the stripe unit size of each
> >> RAID6?
> >>
> >
> > Actually the stripe size for each RAID6 is 256KB but we plan to increas=
e
> > some pools to 1MB for all their RAIDs. It will be in order to compare
> > performance for pools containing large files and if this improves, we
> will
> > apply it to the other systems in the future.
>
> So currently you have a 2.5MB stripe width per RAID6 and you plan to
> test with a 10MB stripe width.
>

> >>> The idea is to aggregate the above devices and show only 1 storage
> space.
> >>> We did as follows:
> >>>
> >>> vgcreate dcvg_a /dev/sda /dev/sdb /dev/sdc
> >>> lvcreate -i 3 -I 4096 -n dcpool -l 100%FREE -v dcvg_a
> >>
> >> You've told LVM that its stripe unit is 4MB, and thus the stripe width
> >> of each RAID6 is 4MB.  This is not possible with 10 data spindles.
> >> Again, show the RAID geometry from the LSI tools.
> >>
> > When creating a nested stripe, the stripe unit of the outer stripe (LVM=
)
> >> must equal the stripe width of eachinner stripe (RAID6).
> >>
> >
> > Great. Hence, if the RAID6 stripe size is 256k then the LVM should be
> > defined with 256k as well, isn't it?
>
> No.  And according to lvcreate(8) you cannot use LVM for the outer
> stripe because you have 10 data spindles per RAID6.  "StripeSize" is
> limited to power of 2 values.  Your RAID6 stripe width is 2560 KB which
> is not a power of 2 value.  So you must use md.  See mdadm(8).
>

Great thanks, this is exactly what I needed and I think I am starting to
understand then :) So a RAID6 of 16+2 disks, stripe width of 256KB will
have a stripe width of 256*16=3D4096 which is a power of 2. Then in this ca=
se
LVM2 can be used. Am I correct? Then seems clear to me that new purchases
will go in this way (we have planned a new purchase in the next month and I
am trying to understand this)


> And be careful with terminology.  "Stripe unit" is per disk, called
> "chunk" by mdadm.  "Stripe width" is per array.  "Stripe size" is
> ambiguous.
>

Yes correct, sorry for the wrong terminology is something that I don't use
to manage :)


>
> When nesting stripes, the "stripe width" of the RAID6 becomes the
> "stripe unit" of the outer stripe of the resulting RAID60.  In essence,
> each RAID6 is treated as a "drive" in the outer stripe.  For example:
>
> RAID6  stripe unit  =3D  256 KB
> RAID6  stripe width =3D 2560 KB
> RAID60 stripe unit  =3D 2560 KB
> RAID60 stripe width =3D 7680 KB
>
> For RAID6 w/1MB stripe unit
>
> RAID6  stripe unit  =3D  1 MB
> RAID6  stripe width =3D 10 MB
> RAID60 stripe unit  =3D 10 MB
> RAID60 stripe width =3D 30 MB
>
> This is assuming your stated configuration of 12 drives per RAID6, 10
> data spindles, and 3 RAID6 arrays per nested stripe.
>
> >> Hence, stripe of the 3 RAID6 in a LV.
> >>
> >> Each RAID6 has ~1.3GB/s of throughput.  By striping the 3 arrays into =
a
> >> nested RAID60 this suggests you need single file throughput greater th=
an
> >> 1.3GB/s and that all files are very large.  If not, you'd be better of=
f
> >> using a concatenation, and using md to accomplish that instead of LVM.
> >>
> >>> And here is my first question: How can I check if the storage and the
> LV
> >>> are correctly aligned?
> >>
> >> Answer is above.  But the more important question is whether your
> >> workload wants a stripe or a concatenation.
> >>
> >>> On the other hand, I have formatted XFS as follows:
> >>>
> >>> mkfs.xfs -d su=3D256k,sw=3D10 -l size=3D128m,lazy-count=3D1 /dev/dcvg=
_a/dcpool
>
> lazy-count=3D1 is the default.  No need to specify it.
>

Ok thanks :)


>
> >> This alignment is not correct.  XFS must be aligned to the LVM stripe
> >> geometry.  Here you apparently aligned XFS to the RAID6 geometry
> >> instead.  Why are you manually specifying a 128M log?  If you knew you=
r
> >> workload that well, you would not have made these other mistakes.
> >>
> >
> > We receive several parallel writes all the time, and afaik filesystems
> with
> > such write load benenfit from a larger log. 128M is the maximum log siz=
e.
>
> Metadata is journaled, file data is not.  Filesystems experiencing a
> large amount of metadata modification may benefit from a larger journal
> log, however writing many large files in parallel typically doesn't
> generate much metadata modification.  In addition, with delayed logging
> now the default, the amount of data written to the journal is much less
> than it used to be.  So specifying a log size should not be necessary
> with your workload.
>

Ok. Then I'll try to remove that.


> > So how XFS should be formatted then? As you specify, should be aligned
> with
> > the LVM stripe, as we have a LV with 3 stripes then 256k*3 and sw=3D30?
>
> It must be aligned to the outer stripe in the nest, which would be the
> LVM geometry if it could work.  However, as stated, it appears you
> cannot use lvcreate to make the outer stripe because it does not allow a
> 2560 KiB StripeSize.  Destroy the LVM volume and create an md RAID0
> device of the 3 RAID6 devices, eg:
>
> $ mdadm -C /dev/md0 --raid_devices=3D3 --chunk=3D2560 --level=3D0 /dev/sd=
[abc]
>
> For making the filesystem and aligning it to the md nested stripe
> RAID60, this is all that is required:
>
> $ mkfs.xfs -d su=3D2560k,sw=3D3 /dev/md0
>

Perfect! I'll try this with the current server having 3xRAID6(10+2). You
really helped me with that.

Just one final question, if I had 3*RAID6(16+2) the Stripe Width should be
4096 (256KB*16) and when applying this to LVM2 should be:

lvcreate -i 3 -I 4096 -n dcpool -l 100%FREE -v dcvg_a

And then the XFS format should be:

mkfs.xfs -d su=3D4096k, sw=3D3 /dev/dcvg_a/dcpool

Is it correct?

Thanks a lot for your help,
--=20
Marc Caubet Serrabou
PIC (Port d'Informaci=C3=B3 Cient=C3=ADfica)
Campus UAB, Edificio D
E-08193 Bellaterra, Barcelona
Tel: +34 93 581 33 22
Fax: +34 93 581 41 10
http://www.pic.es
Avis - Aviso - Legal Notice: http://www.ifae.es/legal.html

--047d7b41791d91acac04f8e3c928
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Stan,<br><br></div>once again, thanks for your ans=
wer.<br><br><div class=3D"gmail_extra"><div class=3D"gmail_quote"><blockquo=
te class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px =
solid rgb(204,204,204);padding-left:1ex">
<div class=3D"">
&gt; Hi Stan,<br>
&gt;<br>
&gt; thanks for your answer.<br>
&gt;<br>
&gt; Everything begins and ends with the workload.<br>
&gt;&gt;<br>
&gt;&gt; On 5/7/2014 7:43 AM, Marc Caubet wrote:<br>
&gt;&gt;&gt; Hi all,<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; I am trying to setup a storage pool with correct disk alignmen=
t and I<br>
&gt;&gt; hope<br>
&gt;&gt;&gt; somebody can help me to understand some unclear parts to me wh=
en<br>
&gt;&gt;&gt; configuring XFS over LVM2.<br>
&gt;&gt;<br>
&gt;&gt; I&#39;ll try. =C2=A0But to be honest, after my first read of your =
post, a few<br>
&gt;&gt; things jump out as breaking traditional rules.<br>
&gt;&gt;<br>
&gt;&gt; The first thing you need to consider is your workload and the type=
 of<br>
&gt;&gt; read/write patterns it will generate. =C2=A0This document is unfin=
ished, and<br>
&gt;&gt; unformatted, but reading what is there should be informative:<br>
&gt;&gt;<br>
&gt;&gt; <a href=3D"http://www.hardwarefreak.com/xfs/storage-arch.txt" targ=
et=3D"_blank">http://www.hardwarefreak.com/xfs/storage-arch.txt</a><br>
&gt;&gt;<br>
&gt;<br>
&gt; Basically we are moving a lot of data :) It means, parallel large file=
s<br>
&gt; (GBs) are being written and read all the time. Basically we have a bat=
ch<br>
&gt; farm with 3,5k cores processing jobs that are constantly reading and<b=
r>
&gt; writing to the storage pools (4PBs). Only few pools (~5% of the total)=
<br>
&gt; contain small files (and only small files).<br>
<br>
</div>And these pools are tied together with? =C2=A0Gluster? =C2=A0Ceph?<br=
></blockquote><div><br></div><div>We are using dCache (<a href=3D"http://ww=
w.dcache.org/">http://www.dcache.org/</a>), where a file is written in a si=
ngle pool instead of spreading parts among pools as Ceph or Hadoop do. So l=
arge files go entirely to a pool.<br>
</div><div>=C2=A0<br></div><blockquote class=3D"gmail_quote" style=3D"margi=
n:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex=
"><div class=3D"">
&gt;&gt;&gt; Actually we have few storage pools with the following settings=
 each:<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; - LSI Controller with 3xRAID6<br>
&gt;&gt;&gt; - Each RAID6 is configured with 10 data disks + 2 for double-p=
arity.<br>
&gt;&gt;&gt; - Each disk has a capacity of 4TB, 512e and physical sector si=
ze of 4K.<br>
&gt;&gt;<br>
&gt;&gt; 512e drives may cause data loss. =C2=A0See:<br>
&gt;&gt; <a href=3D"http://docs.oracle.com/cd/E26502_01/html/E28978/gmkgj.h=
tml#gmlfz" target=3D"_blank">http://docs.oracle.com/cd/E26502_01/html/E2897=
8/gmkgj.html#gmlfz</a><br>
&gt;&gt;<br>
&gt;<br>
&gt; Haven&#39;t experienced this yet. But good to know thanks :) =C2=A0On =
the other<br>
&gt; hand, we do not use zfs<br>
<br>
</div>This problem affects all filesystems. =C2=A0If the drive loses power =
during<br>
an RMW cycle the physical sector is corrupted. =C2=A0As noted, not all 512e=
<br>
drives may have this problem. =C2=A0And for the bulk of your workload this<=
br>
shouldn&#39;t be an issue. =C2=A0If you have sufficient and properly functi=
oning<br>
UPS it shouldn&#39;t be an issue either.<br></blockquote><div><br></div><di=
v>=C2=A0Actually all LSI controllers have batteries so I hope it will not h=
appen. This problems is good to have this in mind when we purchase new stor=
age machines so thanks :)<br>
</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0p=
x 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
<div class=3D""><br>
&gt;&gt;&gt; - 3x(10+2) configuration was considered in order to gain best =
performance<br>
&gt;&gt;&gt; and data safety (less disks per RAID less probability of data =
corruption)<br>
&gt;&gt;<br>
&gt;&gt; RAID6 is the worst performer of all the RAID levels but gives the =
best<br>
&gt;&gt; resilience to multiple drive failure. =C2=A0The reason for using f=
ewer drives<br>
&gt;&gt; per array has less to do with probability of corruption, but<br>
&gt;&gt;<br>
&gt;&gt; 1. Limiting RMW operations to as few drives as possible, especiall=
y for<br>
&gt;&gt; controllers that do full stripe scrubbing on RMW<br>
&gt;&gt;<br>
&gt;&gt; 2. =C2=A0Lowering bandwidth and time required to rebuild a dead dr=
ive, fewer<br>
&gt;&gt; drives tied up during a rebuild<br>
&gt;&gt;<br>
&gt;<br>
&gt;&gt;&gt; From the O.S. side we see:<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; [root@stgpool01 ~]# fdisk -l /dev/sda /dev/sdb /dev/sdc<br>
&gt;&gt; ...<br>
&gt;&gt;<br>
&gt;&gt; You omitted crucial information. =C2=A0What is the stripe unit siz=
e of each<br>
&gt;&gt; RAID6?<br>
&gt;&gt;<br>
&gt;<br>
&gt; Actually the stripe size for each RAID6 is 256KB but we plan to increa=
se<br>
&gt; some pools to 1MB for all their RAIDs. It will be in order to compare<=
br>
&gt; performance for pools containing large files and if this improves, we =
will<br>
&gt; apply it to the other systems in the future.<br>
<br>
</div>So currently you have a 2.5MB stripe width per RAID6 and you plan to<=
br>
test with a 10MB stripe width.<br></blockquote><blockquote class=3D"gmail_q=
uote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,2=
04);padding-left:1ex">
<div class=3D""><br>
&gt;&gt;&gt; The idea is to aggregate the above devices and show only 1 sto=
rage space.<br>
&gt;&gt;&gt; We did as follows:<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; vgcreate dcvg_a /dev/sda /dev/sdb /dev/sdc<br>
&gt;&gt;&gt; lvcreate -i 3 -I 4096 -n dcpool -l 100%FREE -v dcvg_a<br>
&gt;&gt;<br>
&gt;&gt; You&#39;ve told LVM that its stripe unit is 4MB, and thus the stri=
pe width<br>
&gt;&gt; of each RAID6 is 4MB. =C2=A0This is not possible with 10 data spin=
dles.<br>
&gt;&gt; Again, show the RAID geometry from the LSI tools.<br>
&gt;&gt;<br>
&gt; When creating a nested stripe, the stripe unit of the outer stripe (LV=
M)<br>
&gt;&gt; must equal the stripe width of eachinner stripe (RAID6).<br>
&gt;&gt;<br>
&gt;<br>
&gt; Great. Hence, if the RAID6 stripe size is 256k then the LVM should be<=
br>
&gt; defined with 256k as well, isn&#39;t it?<br>
<br>
</div>No. =C2=A0And according to lvcreate(8) you cannot use LVM for the out=
er<br>
stripe because you have 10 data spindles per RAID6. =C2=A0&quot;StripeSize&=
quot; is<br>
limited to power of 2 values. =C2=A0Your RAID6 stripe width is 2560 KB whic=
h<br>
is not a power of 2 value. =C2=A0So you must use md. =C2=A0See mdadm(8).<br=
></blockquote><div><br></div><div>Great thanks, this is exactly what I need=
ed and I think I am starting to understand then :) So a RAID6 of 16+2 disks=
, stripe width of 256KB will have a stripe width of 256*16=3D4096 which is =
a power of 2. Then in this case LVM2 can be used. Am I correct? Then seems =
clear to me that new purchases will go in this way (we have planned a new p=
urchase in the next month and I am trying to understand this)<br>
</div><div>=C2=A0<br></div><blockquote class=3D"gmail_quote" style=3D"margi=
n:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex=
">
And be careful with terminology. =C2=A0&quot;Stripe unit&quot; is per disk,=
 called<br>
&quot;chunk&quot; by mdadm. =C2=A0&quot;Stripe width&quot; is per array. =
=C2=A0&quot;Stripe size&quot; is ambiguous.<br></blockquote><div><br></div>=
<div>Yes correct, sorry for the wrong terminology is something that I don&#=
39;t use to manage :)<br>
</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0p=
x 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
<br>
When nesting stripes, the &quot;stripe width&quot; of the RAID6 becomes the=
<br>
&quot;stripe unit&quot; of the outer stripe of the resulting RAID60. =C2=A0=
In essence,<br>
each RAID6 is treated as a &quot;drive&quot; in the outer stripe. =C2=A0For=
 example:<br>
<br>
RAID6 =C2=A0stripe unit =C2=A0=3D =C2=A0256 KB<br>
RAID6 =C2=A0stripe width =3D 2560 KB<br>
RAID60 stripe unit =C2=A0=3D 2560 KB<br>
RAID60 stripe width =3D 7680 KB<br>
<br>
For RAID6 w/1MB stripe unit<br>
<br>
RAID6 =C2=A0stripe unit =C2=A0=3D =C2=A01 MB<br>
RAID6 =C2=A0stripe width =3D 10 MB<br>
RAID60 stripe unit =C2=A0=3D 10 MB<br>
RAID60 stripe width =3D 30 MB<br>
<br>
This is assuming your stated configuration of 12 drives per RAID6, 10<br>
data spindles, and 3 RAID6 arrays per nested stripe.<br>
<div class=3D""><br>
&gt;&gt; Hence, stripe of the 3 RAID6 in a LV.<br>
&gt;&gt;<br>
&gt;&gt; Each RAID6 has ~1.3GB/s of throughput. =C2=A0By striping the 3 arr=
ays into a<br>
&gt;&gt; nested RAID60 this suggests you need single file throughput greate=
r than<br>
&gt;&gt; 1.3GB/s and that all files are very large. =C2=A0If not, you&#39;d=
 be better off<br>
&gt;&gt; using a concatenation, and using md to accomplish that instead of =
LVM.<br>
&gt;&gt;<br>
&gt;&gt;&gt; And here is my first question: How can I check if the storage =
and the LV<br>
&gt;&gt;&gt; are correctly aligned?<br>
&gt;&gt;<br>
&gt;&gt; Answer is above. =C2=A0But the more important question is whether =
your<br>
&gt;&gt; workload wants a stripe or a concatenation.<br>
&gt;&gt;<br>
&gt;&gt;&gt; On the other hand, I have formatted XFS as follows:<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; mkfs.xfs -d su=3D256k,sw=3D10 -l size=3D128m,lazy-count=3D1 /d=
ev/dcvg_a/dcpool<br>
<br>
</div>lazy-count=3D1 is the default. =C2=A0No need to specify it.<br></bloc=
kquote><div><br></div><div>Ok thanks :)<br></div><div>=C2=A0</div><blockquo=
te class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px =
solid rgb(204,204,204);padding-left:1ex">

<div class=3D""><br>
&gt;&gt; This alignment is not correct. =C2=A0XFS must be aligned to the LV=
M stripe<br>
&gt;&gt; geometry. =C2=A0Here you apparently aligned XFS to the RAID6 geome=
try<br>
&gt;&gt; instead. =C2=A0Why are you manually specifying a 128M log? =C2=A0I=
f you knew your<br>
&gt;&gt; workload that well, you would not have made these other mistakes.<=
br>
&gt;&gt;<br>
&gt;<br>
&gt; We receive several parallel writes all the time, and afaik filesystems=
 with<br>
&gt; such write load benenfit from a larger log. 128M is the maximum log si=
ze.<br>
<br>
</div>Metadata is journaled, file data is not. =C2=A0Filesystems experienci=
ng a<br>
large amount of metadata modification may benefit from a larger journal<br>
log, however writing many large files in parallel typically doesn&#39;t<br>
generate much metadata modification. =C2=A0In addition, with delayed loggin=
g<br>
now the default, the amount of data written to the journal is much less<br>
than it used to be. =C2=A0So specifying a log size should not be necessary<=
br>
with your workload.<br></blockquote><div><br></div><div>Ok. Then I&#39;ll t=
ry to remove that.<br>=C2=A0<br></div><blockquote class=3D"gmail_quote" sty=
le=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);paddi=
ng-left:1ex">
<div class=3D"">
&gt; So how XFS should be formatted then? As you specify, should be aligned=
 with<br>
&gt; the LVM stripe, as we have a LV with 3 stripes then 256k*3 and sw=3D30=
?<br>
<br>
</div>It must be aligned to the outer stripe in the nest, which would be th=
e<br>
LVM geometry if it could work. =C2=A0However, as stated, it appears you<br>
cannot use lvcreate to make the outer stripe because it does not allow a<br=
>
2560 KiB StripeSize. =C2=A0Destroy the LVM volume and create an md RAID0<br=
>
device of the 3 RAID6 devices, eg:<br>
<br>
$ mdadm -C /dev/md0 --raid_devices=3D3 --chunk=3D2560 --level=3D0 /dev/sd[a=
bc]<br>
<br>
For making the filesystem and aligning it to the md nested stripe<br>
RAID60, this is all that is required:<br>
<br>
$ mkfs.xfs -d su=3D2560k,sw=3D3 /dev/md0<br></blockquote><div><br></div><di=
v>Perfect! I&#39;ll try this with the current server having 3xRAID6(10+2). =
You really helped me with that.<br><br></div><div>Just one final question, =
if I had 3*RAID6(16+2) the Stripe Width should be 4096 (256KB*16) and when =
applying this to LVM2 should be:<br>
<br> lvcreate -i 3 -I 4096 -n dcpool -l 100%FREE -v dcvg_a<br><br></div><di=
v></div><div>And then the XFS format should be:<br><br>mkfs.xfs -d su=3D409=
6k, sw=3D3 /dev/dcvg_a/dcpool<br><br></div><div>Is it correct?<br></div>
</div><br></div><div class=3D"gmail_extra">Thanks a lot for your help,<br>-=
- <br>Marc Caubet Serrabou<br>PIC (Port d&#39;Informaci=C3=B3 Cient=C3=ADfi=
ca)<br>Campus UAB, Edificio D<br>E-08193 Bellaterra, Barcelona<br>Tel: +34 =
93 581 33 22<br>
Fax: +34 93 581 41 10<br><a href=3D"http://www.pic.es" target=3D"_blank">ht=
tp://www.pic.es</a><br>Avis - Aviso - Legal Notice: <a href=3D"http://www.i=
fae.es/legal.html" target=3D"_blank">http://www.ifae.es/legal.html</a>
</div></div>

--047d7b41791d91acac04f8e3c928--


--===============3248662103561385197==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3248662103561385197==--
