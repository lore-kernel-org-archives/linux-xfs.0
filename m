Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 135317F52
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 07:24:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 62A39AC003
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 05:24:00 -0700 (PDT)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
	[209.85.212.181]) by cuda.sgi.com with ESMTP id
	35PFTUMikLJaF27m (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Sep 2013 05:23:58 -0700 (PDT)
Received: by mail-wi0-f181.google.com with SMTP id ex4so733224wid.8
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 05:23:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5244DB1B.7000908@hardwarefreak.com>
References: <CAE3v2EaODFud_S_BzuSjtwGwuNBXhvL0RiPB1P5QroF45Obwbw@mail.gmail.com>
	<52435327.9080607@hardwarefreak.com>
	<2F959FD9-EF28-4495-9D0B-59B93D89C820@colorremedies.com>
	<20130925215713.GH26872@dastard>
	<CAE3v2EYVnXiWq1n8AJ0+Y2eifZyhV08S4uLwf6B6mXXWAzBzRA@mail.gmail.com>
	<5243FCD6.4000701@hardwarefreak.com>
	<20130926215806.GQ26872@dastard>
	<5244DB1B.7000908@hardwarefreak.com>
Date: Fri, 27 Sep 2013 13:23:56 +0100
Message-ID: <CAE3v2Eb8hsCZxrV6_qwpC+9BpbYZ4bgigcUxm_zoK=B9SeDAZA@mail.gmail.com>
Subject: Re: xfs hardware RAID alignment over linear lvm
From: Stewart Webb <stew@messeduphare.co.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6153476337415391568=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: Chris Murphy <lists@colorremedies.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============6153476337415391568==
Content-Type: multipart/alternative; boundary=f46d04428cc47adf9f04e75c8f89

--f46d04428cc47adf9f04e75c8f89
Content-Type: text/plain; charset=ISO-8859-1

>Right, and it does so not only to improve write performance, but to
>also maximise sequential read performance of the data that is
>written, especially when multiple files are being read
>simultaneously and IO latency is important to keep low (e.g.
>realtime video ingest and playout).

So does this mean that I should avoid having devices in RAID with a
differing amount of spindles (or non-parity disks)
If I would like to use Linear concatenation LVM? Or is there a best
practice if this instance is not
avoidable?

Regards


On 27 September 2013 02:10, Stan Hoeppner <stan@hardwarefreak.com> wrote:

> On 9/26/2013 4:58 PM, Dave Chinner wrote:
> > On Thu, Sep 26, 2013 at 04:22:30AM -0500, Stan Hoeppner wrote:
> >> On 9/26/2013 3:55 AM, Stewart Webb wrote:
> >>> Thanks for all this info Stan and Dave,
> >>>
> >>>> "Stripe size" is a synonym of XFS sw, which is su * #disks.  This is
> the
> >>>> amount of data written across the full RAID stripe (excluding parity).
> >>>
> >>> The reason I stated Stripe size is because in this instance, I have
> 3ware
> >>> RAID controllers, which refer to
> >>> this value as "Stripe" in their tw_cli software (god bless
> manufacturers
> >>> renaming everything)
> >>>
> >>> I do, however, have a follow-on question:
> >>> On other systems, I have similar hardware:
> >>> 3x Raid Controllers
> >>> 1 of them has 10 disks as RAID 6 that I would like to add to a logical
> >>> volume
> >>> 2 of them have 12 disks as a RAID 6 that I would like to add to the
> same
> >>> logical volume
> >>>
> >>> All have the same "Stripe" or "Strip Size" of 512 KB
> >>>
> >>> So if I where going to make 3 seperate xfs volumes, I would do the
> >>> following:
> >>> mkfs.xfs -d su=512k sw=8 /dev/sda
> >>> mkfs.xfs -d su=512k sw=10 /dev/sdb
> >>> mkfs.xfs -d su=512k sw=10 /dev/sdc
> >>>
> >>> I assume, If I where going to bring them all into 1 logical volume, it
> >>> would be best placed to have the sw value set
> >>> to a value that is divisible by both 8 and 10 - in this case 2?
> >>
> >> No.  In this case you do NOT stripe align XFS to the storage, because
> >> it's impossible--the RAID stripes are dissimilar.  In this case you use
> >> the default 4KB write out, as if this is a single disk drive.
> >>
> >> As Dave stated, if you format a concatenated device with XFS and you
> >> desire to align XFS, then all constituent arrays must have the same
> >> geometry.
> >>
> >> Two things to be aware of here:
> >>
> >> 1.  With a decent hardware write caching RAID controller, having XFS
> >> alined to the RAID geometry is a small optimization WRT overall write
> >> performance, because the controller is going to be doing the optimizing
> >> of final writeback to the drives.
> >>
> >> 2. Alignment does not affect read performance.
> >
> > Ah, but it does...
> >
> >> 3.  XFS only performs aligned writes during allocation.
> >
> > Right, and it does so not only to improve write performance, but to
> > also maximise sequential read performance of the data that is
> > written, especially when multiple files are being read
> > simultaneously and IO latency is important to keep low (e.g.
> > realtime video ingest and playout).
>
> Absolutely correct, as Dave always is.  As my workloads are mostly
> random, as are those of others I consult in other fora, I sometimes
> forget the [multi]streaming case.  Which is not good, as many folks
> choose XFS specifically for [multi]streaming workloads.  My remarks to
> this audience should always reflect that.  Apologies for my oversight on
> this occasion.
>
> >> What really makes a difference as to whether alignment will be of
> >> benefit to you, and how often, is your workload.  So at this point, you
> >> need to describe the primary workload(s) of your systems we're
> discussing.
> >
> > Yup, my thoughts exactly...
> >
> > Cheers,
> >
> > Dave.
> >
>
> --
> Stan
>
>


-- 
Stewart Webb

--f46d04428cc47adf9f04e75c8f89
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">&gt;<span style=3D"font-family:arial,sans-serif;font-size:=
13px">Right, and it does so not only to improve write performance, but to</=
span><br style=3D"font-family:arial,sans-serif;font-size:13px"><span style=
=3D"font-family:arial,sans-serif;font-size:13px">&gt;also maximise sequenti=
al read performance of the data that is</span><br style=3D"font-family:aria=
l,sans-serif;font-size:13px">
<span style=3D"font-family:arial,sans-serif;font-size:13px">&gt;written, es=
pecially when multiple files are being read</span><br style=3D"font-family:=
arial,sans-serif;font-size:13px"><span style=3D"font-family:arial,sans-seri=
f;font-size:13px">&gt;simultaneously and IO latency is important to keep lo=
w (e.g.</span><br style=3D"font-family:arial,sans-serif;font-size:13px">
<span style=3D"font-family:arial,sans-serif;font-size:13px">&gt;realtime vi=
deo ingest and playout).</span><div><span style=3D"font-family:arial,sans-s=
erif;font-size:13px"><br></span></div><div><span style=3D"font-family:arial=
,sans-serif;font-size:13px">So does this mean that I should avoid having de=
vices in RAID with a differing amount of spindles (or non-parity disks)</sp=
an></div>
<div><span style=3D"font-size:13px;font-family:arial,sans-serif">If I would=
 like to use=A0</span><span style=3D"font-size:13px;font-family:arial,sans-=
serif">Linear=A0</span><font face=3D"arial, sans-serif">concatenation=A0</f=
ont><span style=3D"font-family:arial,sans-serif;font-size:13px">LVM? Or is =
there a best practice if this instance is not</span></div>
<div><span style=3D"font-family:arial,sans-serif;font-size:13px">avoidable?=
</span></div><div><span style=3D"font-family:arial,sans-serif;font-size:13p=
x"><br></span></div><div><span style=3D"font-family:arial,sans-serif;font-s=
ize:13px">Regards</span></div>
</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On 27 S=
eptember 2013 02:10, Stan Hoeppner <span dir=3D"ltr">&lt;<a href=3D"mailto:=
stan@hardwarefreak.com" target=3D"_blank">stan@hardwarefreak.com</a>&gt;</s=
pan> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On 9=
/26/2013 4:58 PM, Dave Chinner wrote:<br>
&gt; On Thu, Sep 26, 2013 at 04:22:30AM -0500, Stan Hoeppner wrote:<br>
&gt;&gt; On 9/26/2013 3:55 AM, Stewart Webb wrote:<br>
&gt;&gt;&gt; Thanks for all this info Stan and Dave,<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; &quot;Stripe size&quot; is a synonym of XFS sw, which is s=
u * #disks. =A0This is the<br>
&gt;&gt;&gt;&gt; amount of data written across the full RAID stripe (exclud=
ing parity).<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; The reason I stated Stripe size is because in this instance, I=
 have 3ware<br>
&gt;&gt;&gt; RAID controllers, which refer to<br>
&gt;&gt;&gt; this value as &quot;Stripe&quot; in their tw_cli software (god=
 bless manufacturers<br>
&gt;&gt;&gt; renaming everything)<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; I do, however, have a follow-on question:<br>
&gt;&gt;&gt; On other systems, I have similar hardware:<br>
&gt;&gt;&gt; 3x Raid Controllers<br>
&gt;&gt;&gt; 1 of them has 10 disks as RAID 6 that I would like to add to a=
 logical<br>
&gt;&gt;&gt; volume<br>
&gt;&gt;&gt; 2 of them have 12 disks as a RAID 6 that I would like to add t=
o the same<br>
&gt;&gt;&gt; logical volume<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; All have the same &quot;Stripe&quot; or &quot;Strip Size&quot;=
 of 512 KB<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; So if I where going to make 3 seperate xfs volumes, I would do=
 the<br>
&gt;&gt;&gt; following:<br>
&gt;&gt;&gt; mkfs.xfs -d su=3D512k sw=3D8 /dev/sda<br>
&gt;&gt;&gt; mkfs.xfs -d su=3D512k sw=3D10 /dev/sdb<br>
&gt;&gt;&gt; mkfs.xfs -d su=3D512k sw=3D10 /dev/sdc<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; I assume, If I where going to bring them all into 1 logical vo=
lume, it<br>
&gt;&gt;&gt; would be best placed to have the sw value set<br>
&gt;&gt;&gt; to a value that is divisible by both 8 and 10 - in this case 2=
?<br>
&gt;&gt;<br>
&gt;&gt; No. =A0In this case you do NOT stripe align XFS to the storage, be=
cause<br>
&gt;&gt; it&#39;s impossible--the RAID stripes are dissimilar. =A0In this c=
ase you use<br>
&gt;&gt; the default 4KB write out, as if this is a single disk drive.<br>
&gt;&gt;<br>
&gt;&gt; As Dave stated, if you format a concatenated device with XFS and y=
ou<br>
&gt;&gt; desire to align XFS, then all constituent arrays must have the sam=
e<br>
&gt;&gt; geometry.<br>
&gt;&gt;<br>
&gt;&gt; Two things to be aware of here:<br>
&gt;&gt;<br>
&gt;&gt; 1. =A0With a decent hardware write caching RAID controller, having=
 XFS<br>
&gt;&gt; alined to the RAID geometry is a small optimization WRT overall wr=
ite<br>
&gt;&gt; performance, because the controller is going to be doing the optim=
izing<br>
&gt;&gt; of final writeback to the drives.<br>
&gt;&gt;<br>
&gt;&gt; 2. Alignment does not affect read performance.<br>
&gt;<br>
&gt; Ah, but it does...<br>
&gt;<br>
&gt;&gt; 3. =A0XFS only performs aligned writes during allocation.<br>
&gt;<br>
&gt; Right, and it does so not only to improve write performance, but to<br=
>
&gt; also maximise sequential read performance of the data that is<br>
&gt; written, especially when multiple files are being read<br>
&gt; simultaneously and IO latency is important to keep low (e.g.<br>
&gt; realtime video ingest and playout).<br>
<br>
</div></div>Absolutely correct, as Dave always is. =A0As my workloads are m=
ostly<br>
random, as are those of others I consult in other fora, I sometimes<br>
forget the [multi]streaming case. =A0Which is not good, as many folks<br>
choose XFS specifically for [multi]streaming workloads. =A0My remarks to<br=
>
this audience should always reflect that. =A0Apologies for my oversight on<=
br>
this occasion.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt;&gt; What really makes a difference as to whether alignment will be of<=
br>
&gt;&gt; benefit to you, and how often, is your workload. =A0So at this poi=
nt, you<br>
&gt;&gt; need to describe the primary workload(s) of your systems we&#39;re=
 discussing.<br>
&gt;<br>
&gt; Yup, my thoughts exactly...<br>
&gt;<br>
&gt; Cheers,<br>
&gt;<br>
&gt; Dave.<br>
&gt;<br>
<br>
--<br>
</div></div><span class=3D"HOEnZb"><font color=3D"#888888">Stan<br>
<br>
</font></span></blockquote></div><br><br clear=3D"all"><div><br></div>-- <b=
r><div dir=3D"ltr"><div></div>Stewart Webb<br></div>
</div>

--f46d04428cc47adf9f04e75c8f89--


--===============6153476337415391568==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6153476337415391568==--
