Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 625837F4E
	for <xfs@oss.sgi.com>; Mon, 30 Sep 2013 03:49:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D7CAAAC001
	for <xfs@oss.sgi.com>; Mon, 30 Sep 2013 01:49:02 -0700 (PDT)
Received: from mail-we0-f174.google.com (mail-we0-f174.google.com
	[74.125.82.174]) by cuda.sgi.com with ESMTP id shMgbZbFL8DBDG4r
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 Sep 2013 01:48:59 -0700 (PDT)
Received: by mail-we0-f174.google.com with SMTP id q58so5133146wes.5
	for <xfs@oss.sgi.com>; Mon, 30 Sep 2013 01:48:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5246EDA4.3040300@hardwarefreak.com>
References: <CAE3v2EaODFud_S_BzuSjtwGwuNBXhvL0RiPB1P5QroF45Obwbw@mail.gmail.com>
	<52435327.9080607@hardwarefreak.com>
	<2F959FD9-EF28-4495-9D0B-59B93D89C820@colorremedies.com>
	<20130925215713.GH26872@dastard>
	<CAE3v2EYVnXiWq1n8AJ0+Y2eifZyhV08S4uLwf6B6mXXWAzBzRA@mail.gmail.com>
	<5243FCD6.4000701@hardwarefreak.com>
	<20130926215806.GQ26872@dastard>
	<5244DB1B.7000908@hardwarefreak.com>
	<CAE3v2Eb8hsCZxrV6_qwpC+9BpbYZ4bgigcUxm_zoK=B9SeDAZA@mail.gmail.com>
	<524583A4.9050207@hardwarefreak.com>
	<CAE3v2EZb3j0a8b2iEKdCVtUCqx42LFH8wAe=SR7qCuv0iFuTHg@mail.gmail.com>
	<5246EDA4.3040300@hardwarefreak.com>
Date: Mon, 30 Sep 2013 09:48:58 +0100
Message-ID: <CAE3v2EZ5KAe7L6s6sUNiPVGS9a0up2Vq3aeekhC4yUAsTwgKCg@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============2415266042971550704=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: Chris Murphy <lists@colorremedies.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============2415266042971550704==
Content-Type: multipart/alternative; boundary=e89a8f3b9da93176a104e795e8c7

--e89a8f3b9da93176a104e795e8c7
Content-Type: text/plain; charset=ISO-8859-1

Ok,

Thanks Stan
Much appreciated


On 28 September 2013 15:54, Stan Hoeppner <stan@hardwarefreak.com> wrote:

> On 9/27/2013 8:29 AM, Stewart Webb wrote:
> > Hi Stan,
> >
> > Apologies for not directly answering -
>
> No problem, sorry for the late reply.
>
> > I was aiming at filling gaps in my knowledge that I could not find in the
> > xfs.org wiki.
>
> Hopefully this is occurring. :)
>
> > My workload for the storage is mainly reads of single large files
> (ranging
> > for 20GB to 100GB each)
> > These reads are mainly linear (video playback, although not always as the
> > end user may be jumping to different points in the video)
> > There are concurrent reads required, estimated at 2 to 8, any more would
> be
> > a bonus.
>
> This is the type of workload Dave described previously that should
> exhibit an increase in read performance if the files are written with
> alignment, especially with concurrent readers, which you describe as
> 2-8, maybe more.  The number of "maybe more" is dictated by whether
> you're aligned.  I.e. with alignment your odds of successfully serving
> more readers is much greater.
>
> Thus, if you need to stitch arrays together with LVM concatenation,
> you'd definitely benefit from making the geometry of all arrays
> identical, and aligning the filesystem to that geometry.  I.e. same
> number of disks, same RAID level, same RAID stripe unit (data per non
> parity disk), and stripe width (#non parity disks).
>
> > The challenge of this would be that the reads need to be "real-time"
> > operations as they are interacted with by a person, and each
> > read operation would have to consistently have a low latency and obtain
> > speeds of over 50Mb/s
> >
> > Disk write speeds are not *as* important for me - as they these files are
> > copied to location before they are required (in this case
> > using rsync or scp) and these operations do not require as much
> "real-time"
> > interaction.
> >
> >
> > On 27 September 2013 14:09, Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
> >
> >> On 9/27/2013 7:23 AM, Stewart Webb wrote:
> >>>> Right, and it does so not only to improve write performance, but to
> >>>> also maximise sequential read performance of the data that is
> >>>> written, especially when multiple files are being read
> >>>> simultaneously and IO latency is important to keep low (e.g.
> >>>> realtime video ingest and playout).
> >>>
> >>> So does this mean that I should avoid having devices in RAID with a
> >>> differing amount of spindles (or non-parity disks)
> >>> If I would like to use Linear concatenation LVM? Or is there a best
> >>> practice if this instance is not
> >>> avoidable?
> >>
> >> Above, Dave was correcting my oversight, not necessarily informing you,
> >> per se.  It seems clear from your follow up question that you didn't
> >> really grasp what he was saying.  Let's back up a little bit.
> >>
> >> What you need to concentrate on right now is the following which we
> >> stated previously in the thread, but which you did not reply to:
> >>
> >>>>>> What really makes a difference as to whether alignment will be of
> >>>>>> benefit to you, and how often, is your workload.  So at this point,
> >> you
> >>>>>> need to describe the primary workload(s) of your systems we're
> >>>> discussing.
> >>>>>
> >>>>> Yup, my thoughts exactly...
> >>
> >> This means you need to describe in detail how you are writing your
> >> files, and how you are reading them back.  I.e. what application are you
> >> using, what does it do, etc.  You stated IIRC that your workload is 80%
> >> read.  What types of files is it reading?  Small, large?  Is it reading
> >> multiple files in parallel?  How are these files originally written
> >> before being read?  Etc, etc.
> >>
> >> You may not understand why this is relevant, but it is the only thing
> >> that is relevant, at this point.  Spindles, RAID level, alignment, no
> >> alignment...none of this matters if it doesn't match up with how your
> >> application(s) do their IO.
> >>
> >> Rule #1 of storage architecture:  Always build your storage stack (i.e.
> >> disks, controller, driver, filesystem, etc) to fit the workload(s), not
> >> the other way around.
> >>
> >>>
> >>> On 27 September 2013 02:10, Stan Hoeppner <stan@hardwarefreak.com>
> >> wrote:
> >>>
> >>>> On 9/26/2013 4:58 PM, Dave Chinner wrote:
> >>>>> On Thu, Sep 26, 2013 at 04:22:30AM -0500, Stan Hoeppner wrote:
> >>>>>> On 9/26/2013 3:55 AM, Stewart Webb wrote:
> >>>>>>> Thanks for all this info Stan and Dave,
> >>>>>>>
> >>>>>>>> "Stripe size" is a synonym of XFS sw, which is su * #disks.  This
> is
> >>>> the
> >>>>>>>> amount of data written across the full RAID stripe (excluding
> >> parity).
> >>>>>>>
> >>>>>>> The reason I stated Stripe size is because in this instance, I have
> >>>> 3ware
> >>>>>>> RAID controllers, which refer to
> >>>>>>> this value as "Stripe" in their tw_cli software (god bless
> >>>> manufacturers
> >>>>>>> renaming everything)
> >>>>>>>
> >>>>>>> I do, however, have a follow-on question:
> >>>>>>> On other systems, I have similar hardware:
> >>>>>>> 3x Raid Controllers
> >>>>>>> 1 of them has 10 disks as RAID 6 that I would like to add to a
> >> logical
> >>>>>>> volume
> >>>>>>> 2 of them have 12 disks as a RAID 6 that I would like to add to the
> >>>> same
> >>>>>>> logical volume
> >>>>>>>
> >>>>>>> All have the same "Stripe" or "Strip Size" of 512 KB
> >>>>>>>
> >>>>>>> So if I where going to make 3 seperate xfs volumes, I would do the
> >>>>>>> following:
> >>>>>>> mkfs.xfs -d su=512k sw=8 /dev/sda
> >>>>>>> mkfs.xfs -d su=512k sw=10 /dev/sdb
> >>>>>>> mkfs.xfs -d su=512k sw=10 /dev/sdc
> >>>>>>>
> >>>>>>> I assume, If I where going to bring them all into 1 logical volume,
> >> it
> >>>>>>> would be best placed to have the sw value set
> >>>>>>> to a value that is divisible by both 8 and 10 - in this case 2?
> >>>>>>
> >>>>>> No.  In this case you do NOT stripe align XFS to the storage,
> because
> >>>>>> it's impossible--the RAID stripes are dissimilar.  In this case you
> >> use
> >>>>>> the default 4KB write out, as if this is a single disk drive.
> >>>>>>
> >>>>>> As Dave stated, if you format a concatenated device with XFS and you
> >>>>>> desire to align XFS, then all constituent arrays must have the same
> >>>>>> geometry.
> >>>>>>
> >>>>>> Two things to be aware of here:
> >>>>>>
> >>>>>> 1.  With a decent hardware write caching RAID controller, having XFS
> >>>>>> alined to the RAID geometry is a small optimization WRT overall
> write
> >>>>>> performance, because the controller is going to be doing the
> >> optimizing
> >>>>>> of final writeback to the drives.
> >>>>>>
> >>>>>> 2. Alignment does not affect read performance.
> >>>>>
> >>>>> Ah, but it does...
> >>>>>
> >>>>>> 3.  XFS only performs aligned writes during allocation.
> >>>>>
> >>>>> Right, and it does so not only to improve write performance, but to
> >>>>> also maximise sequential read performance of the data that is
> >>>>> written, especially when multiple files are being read
> >>>>> simultaneously and IO latency is important to keep low (e.g.
> >>>>> realtime video ingest and playout).
> >>>>
> >>>> Absolutely correct, as Dave always is.  As my workloads are mostly
> >>>> random, as are those of others I consult in other fora, I sometimes
> >>>> forget the [multi]streaming case.  Which is not good, as many folks
> >>>> choose XFS specifically for [multi]streaming workloads.  My remarks to
> >>>> this audience should always reflect that.  Apologies for my oversight
> on
> >>>> this occasion.
> >>>>
> >>>>>> What really makes a difference as to whether alignment will be of
> >>>>>> benefit to you, and how often, is your workload.  So at this point,
> >> you
> >>>>>> need to describe the primary workload(s) of your systems we're
> >>>> discussing.
> >>>>>
> >>>>> Yup, my thoughts exactly...
> >>>>>
> >>>>> Cheers,
> >>>>>
> >>>>> Dave.
> >>>>>
> >>>>
> >>>> --
> >>>> Stan
>
>


-- 
Stewart Webb

--e89a8f3b9da93176a104e795e8c7
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Ok,<div><br></div><div>Thanks Stan</div><div>Much apprecia=
ted</div></div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote=
">On 28 September 2013 15:54, Stan Hoeppner <span dir=3D"ltr">&lt;<a href=
=3D"mailto:stan@hardwarefreak.com" target=3D"_blank">stan@hardwarefreak.com=
</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On 9/27/2013 8:29 AM, Stew=
art Webb wrote:<br>
&gt; Hi Stan,<br>
&gt;<br>
&gt; Apologies for not directly answering -<br>
<br>
</div>No problem, sorry for the late reply.<br>
<div class=3D"im"><br>
&gt; I was aiming at filling gaps in my knowledge that I could not find in =
the<br>
&gt; <a href=3D"http://xfs.org" target=3D"_blank">xfs.org</a> wiki.<br>
<br>
</div>Hopefully this is occurring. :)<br>
<div class=3D"im"><br>
&gt; My workload for the storage is mainly reads of single large files (ran=
ging<br>
&gt; for 20GB to 100GB each)<br>
&gt; These reads are mainly linear (video playback, although not always as =
the<br>
&gt; end user may be jumping to different points in the video)<br>
&gt; There are concurrent reads required, estimated at 2 to 8, any more wou=
ld be<br>
&gt; a bonus.<br>
<br>
</div>This is the type of workload Dave described previously that should<br=
>
exhibit an increase in read performance if the files are written with<br>
alignment, especially with concurrent readers, which you describe as<br>
2-8, maybe more. =A0The number of &quot;maybe more&quot; is dictated by whe=
ther<br>
you&#39;re aligned. =A0I.e. with alignment your odds of successfully servin=
g<br>
more readers is much greater.<br>
<br>
Thus, if you need to stitch arrays together with LVM concatenation,<br>
you&#39;d definitely benefit from making the geometry of all arrays<br>
identical, and aligning the filesystem to that geometry. =A0I.e. same<br>
number of disks, same RAID level, same RAID stripe unit (data per non<br>
parity disk), and stripe width (#non parity disks).<br>
<div class=3D"im"><br>
&gt; The challenge of this would be that the reads need to be &quot;real-ti=
me&quot;<br>
&gt; operations as they are interacted with by a person, and each<br>
&gt; read operation would have to consistently have a low latency and obtai=
n<br>
&gt; speeds of over 50Mb/s<br>
&gt;<br>
</div>&gt; Disk write speeds are not *as* important for me - as they these =
files are<br>
<div class=3D"HOEnZb"><div class=3D"h5">&gt; copied to location before they=
 are required (in this case<br>
&gt; using rsync or scp) and these operations do not require as much &quot;=
real-time&quot;<br>
&gt; interaction.<br>
&gt;<br>
&gt;<br>
&gt; On 27 September 2013 14:09, Stan Hoeppner &lt;<a href=3D"mailto:stan@h=
ardwarefreak.com">stan@hardwarefreak.com</a>&gt; wrote:<br>
&gt;<br>
&gt;&gt; On 9/27/2013 7:23 AM, Stewart Webb wrote:<br>
&gt;&gt;&gt;&gt; Right, and it does so not only to improve write performanc=
e, but to<br>
&gt;&gt;&gt;&gt; also maximise sequential read performance of the data that=
 is<br>
&gt;&gt;&gt;&gt; written, especially when multiple files are being read<br>
&gt;&gt;&gt;&gt; simultaneously and IO latency is important to keep low (e.=
g.<br>
&gt;&gt;&gt;&gt; realtime video ingest and playout).<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; So does this mean that I should avoid having devices in RAID w=
ith a<br>
&gt;&gt;&gt; differing amount of spindles (or non-parity disks)<br>
&gt;&gt;&gt; If I would like to use Linear concatenation LVM? Or is there a=
 best<br>
&gt;&gt;&gt; practice if this instance is not<br>
&gt;&gt;&gt; avoidable?<br>
&gt;&gt;<br>
&gt;&gt; Above, Dave was correcting my oversight, not necessarily informing=
 you,<br>
&gt;&gt; per se. =A0It seems clear from your follow up question that you di=
dn&#39;t<br>
&gt;&gt; really grasp what he was saying. =A0Let&#39;s back up a little bit=
.<br>
&gt;&gt;<br>
&gt;&gt; What you need to concentrate on right now is the following which w=
e<br>
&gt;&gt; stated previously in the thread, but which you did not reply to:<b=
r>
&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt; What really makes a difference as to whether align=
ment will be of<br>
&gt;&gt;&gt;&gt;&gt;&gt; benefit to you, and how often, is your workload. =
=A0So at this point,<br>
&gt;&gt; you<br>
&gt;&gt;&gt;&gt;&gt;&gt; need to describe the primary workload(s) of your s=
ystems we&#39;re<br>
&gt;&gt;&gt;&gt; discussing.<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; Yup, my thoughts exactly...<br>
&gt;&gt;<br>
&gt;&gt; This means you need to describe in detail how you are writing your=
<br>
&gt;&gt; files, and how you are reading them back. =A0I.e. what application=
 are you<br>
&gt;&gt; using, what does it do, etc. =A0You stated IIRC that your workload=
 is 80%<br>
&gt;&gt; read. =A0What types of files is it reading? =A0Small, large? =A0Is=
 it reading<br>
&gt;&gt; multiple files in parallel? =A0How are these files originally writ=
ten<br>
&gt;&gt; before being read? =A0Etc, etc.<br>
&gt;&gt;<br>
&gt;&gt; You may not understand why this is relevant, but it is the only th=
ing<br>
&gt;&gt; that is relevant, at this point. =A0Spindles, RAID level, alignmen=
t, no<br>
&gt;&gt; alignment...none of this matters if it doesn&#39;t match up with h=
ow your<br>
&gt;&gt; application(s) do their IO.<br>
&gt;&gt;<br>
&gt;&gt; Rule #1 of storage architecture: =A0Always build your storage stac=
k (i.e.<br>
&gt;&gt; disks, controller, driver, filesystem, etc) to fit the workload(s)=
, not<br>
&gt;&gt; the other way around.<br>
&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; On 27 September 2013 02:10, Stan Hoeppner &lt;<a href=3D"mailt=
o:stan@hardwarefreak.com">stan@hardwarefreak.com</a>&gt;<br>
&gt;&gt; wrote:<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; On 9/26/2013 4:58 PM, Dave Chinner wrote:<br>
&gt;&gt;&gt;&gt;&gt; On Thu, Sep 26, 2013 at 04:22:30AM -0500, Stan Hoeppne=
r wrote:<br>
&gt;&gt;&gt;&gt;&gt;&gt; On 9/26/2013 3:55 AM, Stewart Webb wrote:<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; Thanks for all this info Stan and Dave,<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt; &quot;Stripe size&quot; is a synonym of XF=
S sw, which is su * #disks. =A0This is<br>
&gt;&gt;&gt;&gt; the<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt; amount of data written across the full RAI=
D stripe (excluding<br>
&gt;&gt; parity).<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; The reason I stated Stripe size is because in =
this instance, I have<br>
&gt;&gt;&gt;&gt; 3ware<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; RAID controllers, which refer to<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; this value as &quot;Stripe&quot; in their tw_c=
li software (god bless<br>
&gt;&gt;&gt;&gt; manufacturers<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; renaming everything)<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; I do, however, have a follow-on question:<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; On other systems, I have similar hardware:<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; 3x Raid Controllers<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; 1 of them has 10 disks as RAID 6 that I would =
like to add to a<br>
&gt;&gt; logical<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; volume<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; 2 of them have 12 disks as a RAID 6 that I wou=
ld like to add to the<br>
&gt;&gt;&gt;&gt; same<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; logical volume<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; All have the same &quot;Stripe&quot; or &quot;=
Strip Size&quot; of 512 KB<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; So if I where going to make 3 seperate xfs vol=
umes, I would do the<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; following:<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; mkfs.xfs -d su=3D512k sw=3D8 /dev/sda<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; mkfs.xfs -d su=3D512k sw=3D10 /dev/sdb<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; mkfs.xfs -d su=3D512k sw=3D10 /dev/sdc<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; I assume, If I where going to bring them all i=
nto 1 logical volume,<br>
&gt;&gt; it<br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; would be best placed to have the sw value set<=
br>
&gt;&gt;&gt;&gt;&gt;&gt;&gt; to a value that is divisible by both 8 and 10 =
- in this case 2?<br>
&gt;&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt; No. =A0In this case you do NOT stripe align XFS to=
 the storage, because<br>
&gt;&gt;&gt;&gt;&gt;&gt; it&#39;s impossible--the RAID stripes are dissimil=
ar. =A0In this case you<br>
&gt;&gt; use<br>
&gt;&gt;&gt;&gt;&gt;&gt; the default 4KB write out, as if this is a single =
disk drive.<br>
&gt;&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt; As Dave stated, if you format a concatenated devic=
e with XFS and you<br>
&gt;&gt;&gt;&gt;&gt;&gt; desire to align XFS, then all constituent arrays m=
ust have the same<br>
&gt;&gt;&gt;&gt;&gt;&gt; geometry.<br>
&gt;&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt; Two things to be aware of here:<br>
&gt;&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt; 1. =A0With a decent hardware write caching RAID co=
ntroller, having XFS<br>
&gt;&gt;&gt;&gt;&gt;&gt; alined to the RAID geometry is a small optimizatio=
n WRT overall write<br>
&gt;&gt;&gt;&gt;&gt;&gt; performance, because the controller is going to be=
 doing the<br>
&gt;&gt; optimizing<br>
&gt;&gt;&gt;&gt;&gt;&gt; of final writeback to the drives.<br>
&gt;&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt; 2. Alignment does not affect read performance.<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; Ah, but it does...<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt; 3. =A0XFS only performs aligned writes during allo=
cation.<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; Right, and it does so not only to improve write perfor=
mance, but to<br>
&gt;&gt;&gt;&gt;&gt; also maximise sequential read performance of the data =
that is<br>
&gt;&gt;&gt;&gt;&gt; written, especially when multiple files are being read=
<br>
&gt;&gt;&gt;&gt;&gt; simultaneously and IO latency is important to keep low=
 (e.g.<br>
&gt;&gt;&gt;&gt;&gt; realtime video ingest and playout).<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Absolutely correct, as Dave always is. =A0As my workloads =
are mostly<br>
&gt;&gt;&gt;&gt; random, as are those of others I consult in other fora, I =
sometimes<br>
&gt;&gt;&gt;&gt; forget the [multi]streaming case. =A0Which is not good, as=
 many folks<br>
&gt;&gt;&gt;&gt; choose XFS specifically for [multi]streaming workloads. =
=A0My remarks to<br>
&gt;&gt;&gt;&gt; this audience should always reflect that. =A0Apologies for=
 my oversight on<br>
&gt;&gt;&gt;&gt; this occasion.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt; What really makes a difference as to whether align=
ment will be of<br>
&gt;&gt;&gt;&gt;&gt;&gt; benefit to you, and how often, is your workload. =
=A0So at this point,<br>
&gt;&gt; you<br>
&gt;&gt;&gt;&gt;&gt;&gt; need to describe the primary workload(s) of your s=
ystems we&#39;re<br>
&gt;&gt;&gt;&gt; discussing.<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; Yup, my thoughts exactly...<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; Cheers,<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; Dave.<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; --<br>
&gt;&gt;&gt;&gt; Stan<br>
<br>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<div dir=3D"ltr"><div></div>Stewart Webb<br></div>
</div>

--e89a8f3b9da93176a104e795e8c7--


--===============2415266042971550704==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2415266042971550704==--
