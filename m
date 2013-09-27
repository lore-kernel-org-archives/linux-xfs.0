Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BB1287F52
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 08:29:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 78B03304064
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 06:29:11 -0700 (PDT)
Received: from mail-we0-f179.google.com (mail-we0-f179.google.com
	[74.125.82.179]) by cuda.sgi.com with ESMTP id PCxEwglyssep7wQE
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 27 Sep 2013 06:29:08 -0700 (PDT)
Received: by mail-we0-f179.google.com with SMTP id x55so2612210wes.24
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 06:29:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <524583A4.9050207@hardwarefreak.com>
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
Date: Fri, 27 Sep 2013 14:29:07 +0100
Message-ID: <CAE3v2EZb3j0a8b2iEKdCVtUCqx42LFH8wAe=SR7qCuv0iFuTHg@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============6017392540248252046=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: Chris Murphy <lists@colorremedies.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============6017392540248252046==
Content-Type: multipart/alternative; boundary=e89a8f3b9da98a614304e75d7861

--e89a8f3b9da98a614304e75d7861
Content-Type: text/plain; charset=ISO-8859-1

Hi Stan,

Apologies for not directly answering -
I was aiming at filling gaps in my knowledge that I could not find in the
xfs.org wiki.

My workload for the storage is mainly reads of single large files (ranging
for 20GB to 100GB each)
These reads are mainly linear (video playback, although not always as the
end user may be jumping to different points in the video)
There are concurrent reads required, estimated at 2 to 8, any more would be
a bonus.
The challenge of this would be that the reads need to be "real-time"
operations as they are interacted with by a person, and each
read operation would have to consistently have a low latency and obtain
speeds of over 50Mb/s

Disk write speeds are not *as* important for me - as they these files are
copied to location before they are required (in this case
using rsync or scp) and these operations do not require as much "real-time"
interaction.


On 27 September 2013 14:09, Stan Hoeppner <stan@hardwarefreak.com> wrote:

> On 9/27/2013 7:23 AM, Stewart Webb wrote:
> >> Right, and it does so not only to improve write performance, but to
> >> also maximise sequential read performance of the data that is
> >> written, especially when multiple files are being read
> >> simultaneously and IO latency is important to keep low (e.g.
> >> realtime video ingest and playout).
> >
> > So does this mean that I should avoid having devices in RAID with a
> > differing amount of spindles (or non-parity disks)
> > If I would like to use Linear concatenation LVM? Or is there a best
> > practice if this instance is not
> > avoidable?
>
> Above, Dave was correcting my oversight, not necessarily informing you,
> per se.  It seems clear from your follow up question that you didn't
> really grasp what he was saying.  Let's back up a little bit.
>
> What you need to concentrate on right now is the following which we
> stated previously in the thread, but which you did not reply to:
>
> >>>> What really makes a difference as to whether alignment will be of
> >>>> benefit to you, and how often, is your workload.  So at this point,
> you
> >>>> need to describe the primary workload(s) of your systems we're
> >> discussing.
> >>>
> >>> Yup, my thoughts exactly...
>
> This means you need to describe in detail how you are writing your
> files, and how you are reading them back.  I.e. what application are you
> using, what does it do, etc.  You stated IIRC that your workload is 80%
> read.  What types of files is it reading?  Small, large?  Is it reading
> multiple files in parallel?  How are these files originally written
> before being read?  Etc, etc.
>
> You may not understand why this is relevant, but it is the only thing
> that is relevant, at this point.  Spindles, RAID level, alignment, no
> alignment...none of this matters if it doesn't match up with how your
> application(s) do their IO.
>
> Rule #1 of storage architecture:  Always build your storage stack (i.e.
> disks, controller, driver, filesystem, etc) to fit the workload(s), not
> the other way around.
>
> >
> > On 27 September 2013 02:10, Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
> >
> >> On 9/26/2013 4:58 PM, Dave Chinner wrote:
> >>> On Thu, Sep 26, 2013 at 04:22:30AM -0500, Stan Hoeppner wrote:
> >>>> On 9/26/2013 3:55 AM, Stewart Webb wrote:
> >>>>> Thanks for all this info Stan and Dave,
> >>>>>
> >>>>>> "Stripe size" is a synonym of XFS sw, which is su * #disks.  This is
> >> the
> >>>>>> amount of data written across the full RAID stripe (excluding
> parity).
> >>>>>
> >>>>> The reason I stated Stripe size is because in this instance, I have
> >> 3ware
> >>>>> RAID controllers, which refer to
> >>>>> this value as "Stripe" in their tw_cli software (god bless
> >> manufacturers
> >>>>> renaming everything)
> >>>>>
> >>>>> I do, however, have a follow-on question:
> >>>>> On other systems, I have similar hardware:
> >>>>> 3x Raid Controllers
> >>>>> 1 of them has 10 disks as RAID 6 that I would like to add to a
> logical
> >>>>> volume
> >>>>> 2 of them have 12 disks as a RAID 6 that I would like to add to the
> >> same
> >>>>> logical volume
> >>>>>
> >>>>> All have the same "Stripe" or "Strip Size" of 512 KB
> >>>>>
> >>>>> So if I where going to make 3 seperate xfs volumes, I would do the
> >>>>> following:
> >>>>> mkfs.xfs -d su=512k sw=8 /dev/sda
> >>>>> mkfs.xfs -d su=512k sw=10 /dev/sdb
> >>>>> mkfs.xfs -d su=512k sw=10 /dev/sdc
> >>>>>
> >>>>> I assume, If I where going to bring them all into 1 logical volume,
> it
> >>>>> would be best placed to have the sw value set
> >>>>> to a value that is divisible by both 8 and 10 - in this case 2?
> >>>>
> >>>> No.  In this case you do NOT stripe align XFS to the storage, because
> >>>> it's impossible--the RAID stripes are dissimilar.  In this case you
> use
> >>>> the default 4KB write out, as if this is a single disk drive.
> >>>>
> >>>> As Dave stated, if you format a concatenated device with XFS and you
> >>>> desire to align XFS, then all constituent arrays must have the same
> >>>> geometry.
> >>>>
> >>>> Two things to be aware of here:
> >>>>
> >>>> 1.  With a decent hardware write caching RAID controller, having XFS
> >>>> alined to the RAID geometry is a small optimization WRT overall write
> >>>> performance, because the controller is going to be doing the
> optimizing
> >>>> of final writeback to the drives.
> >>>>
> >>>> 2. Alignment does not affect read performance.
> >>>
> >>> Ah, but it does...
> >>>
> >>>> 3.  XFS only performs aligned writes during allocation.
> >>>
> >>> Right, and it does so not only to improve write performance, but to
> >>> also maximise sequential read performance of the data that is
> >>> written, especially when multiple files are being read
> >>> simultaneously and IO latency is important to keep low (e.g.
> >>> realtime video ingest and playout).
> >>
> >> Absolutely correct, as Dave always is.  As my workloads are mostly
> >> random, as are those of others I consult in other fora, I sometimes
> >> forget the [multi]streaming case.  Which is not good, as many folks
> >> choose XFS specifically for [multi]streaming workloads.  My remarks to
> >> this audience should always reflect that.  Apologies for my oversight on
> >> this occasion.
> >>
> >>>> What really makes a difference as to whether alignment will be of
> >>>> benefit to you, and how often, is your workload.  So at this point,
> you
> >>>> need to describe the primary workload(s) of your systems we're
> >> discussing.
> >>>
> >>> Yup, my thoughts exactly...
> >>>
> >>> Cheers,
> >>>
> >>> Dave.
> >>>
> >>
> >> --
> >> Stan
> >>
> >>
> >
> >
>
>


-- 
Stewart Webb

--e89a8f3b9da98a614304e75d7861
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Stan,<div><br></div><div>Apologies for not directly ans=
wering -=A0</div><div>I was aiming at filling gaps in my knowledge that I c=
ould not find in the <a href=3D"http://xfs.org">xfs.org</a> wiki.</div><div=
><br>
</div><div>My workload for the storage is mainly reads of single large file=
s (ranging for 20GB to 100GB each)</div><div>These reads are mainly linear =
(video playback, although not always as the end user may be jumping to diff=
erent points in the video)</div>
<div>There are concurrent reads required, estimated at 2 to 8, any more wou=
ld be a bonus.</div><div>The challenge of this would be that the reads need=
 to be &quot;real-time&quot; operations as they are interacted with by a pe=
rson, and each</div>
<div>read operation would have to consistently have a low latency and obtai=
n speeds of over 50Mb/s</div><div><br></div><div>Disk write speeds are not =
<i>as</i> important for me - as they these files are copied to location bef=
ore they are required (in this case</div>
<div>using rsync or scp) and these operations do not require as much &quot;=
real-time&quot; interaction.</div></div><div class=3D"gmail_extra"><br><br>=
<div class=3D"gmail_quote">On 27 September 2013 14:09, Stan Hoeppner <span =
dir=3D"ltr">&lt;<a href=3D"mailto:stan@hardwarefreak.com" target=3D"_blank"=
>stan@hardwarefreak.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On 9/27/2013 7:23 AM, Stew=
art Webb wrote:<br>
&gt;&gt; Right, and it does so not only to improve write performance, but t=
o<br>
&gt;&gt; also maximise sequential read performance of the data that is<br>
&gt;&gt; written, especially when multiple files are being read<br>
&gt;&gt; simultaneously and IO latency is important to keep low (e.g.<br>
&gt;&gt; realtime video ingest and playout).<br>
&gt;<br>
&gt; So does this mean that I should avoid having devices in RAID with a<br=
>
&gt; differing amount of spindles (or non-parity disks)<br>
&gt; If I would like to use Linear concatenation LVM? Or is there a best<br=
>
&gt; practice if this instance is not<br>
&gt; avoidable?<br>
<br>
</div>Above, Dave was correcting my oversight, not necessarily informing yo=
u,<br>
per se. =A0It seems clear from your follow up question that you didn&#39;t<=
br>
really grasp what he was saying. =A0Let&#39;s back up a little bit.<br>
<br>
What you need to concentrate on right now is the following which we<br>
stated previously in the thread, but which you did not reply to:<br>
<div class=3D"im"><br>
&gt;&gt;&gt;&gt; What really makes a difference as to whether alignment wil=
l be of<br>
&gt;&gt;&gt;&gt; benefit to you, and how often, is your workload. =A0So at =
this point, you<br>
&gt;&gt;&gt;&gt; need to describe the primary workload(s) of your systems w=
e&#39;re<br>
&gt;&gt; discussing.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Yup, my thoughts exactly...<br>
<br>
</div>This means you need to describe in detail how you are writing your<br=
>
files, and how you are reading them back. =A0I.e. what application are you<=
br>
using, what does it do, etc. =A0You stated IIRC that your workload is 80%<b=
r>
read. =A0What types of files is it reading? =A0Small, large? =A0Is it readi=
ng<br>
multiple files in parallel? =A0How are these files originally written<br>
before being read? =A0Etc, etc.<br>
<br>
You may not understand why this is relevant, but it is the only thing<br>
that is relevant, at this point. =A0Spindles, RAID level, alignment, no<br>
alignment...none of this matters if it doesn&#39;t match up with how your<b=
r>
application(s) do their IO.<br>
<br>
Rule #1 of storage architecture: =A0Always build your storage stack (i.e.<b=
r>
disks, controller, driver, filesystem, etc) to fit the workload(s), not<br>
the other way around.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt;<br>
&gt; On 27 September 2013 02:10, Stan Hoeppner &lt;<a href=3D"mailto:stan@h=
ardwarefreak.com">stan@hardwarefreak.com</a>&gt; wrote:<br>
&gt;<br>
&gt;&gt; On 9/26/2013 4:58 PM, Dave Chinner wrote:<br>
&gt;&gt;&gt; On Thu, Sep 26, 2013 at 04:22:30AM -0500, Stan Hoeppner wrote:=
<br>
&gt;&gt;&gt;&gt; On 9/26/2013 3:55 AM, Stewart Webb wrote:<br>
&gt;&gt;&gt;&gt;&gt; Thanks for all this info Stan and Dave,<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt; &quot;Stripe size&quot; is a synonym of XFS sw, wh=
ich is su * #disks. =A0This is<br>
&gt;&gt; the<br>
&gt;&gt;&gt;&gt;&gt;&gt; amount of data written across the full RAID stripe=
 (excluding parity).<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; The reason I stated Stripe size is because in this ins=
tance, I have<br>
&gt;&gt; 3ware<br>
&gt;&gt;&gt;&gt;&gt; RAID controllers, which refer to<br>
&gt;&gt;&gt;&gt;&gt; this value as &quot;Stripe&quot; in their tw_cli softw=
are (god bless<br>
&gt;&gt; manufacturers<br>
&gt;&gt;&gt;&gt;&gt; renaming everything)<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; I do, however, have a follow-on question:<br>
&gt;&gt;&gt;&gt;&gt; On other systems, I have similar hardware:<br>
&gt;&gt;&gt;&gt;&gt; 3x Raid Controllers<br>
&gt;&gt;&gt;&gt;&gt; 1 of them has 10 disks as RAID 6 that I would like to =
add to a logical<br>
&gt;&gt;&gt;&gt;&gt; volume<br>
&gt;&gt;&gt;&gt;&gt; 2 of them have 12 disks as a RAID 6 that I would like =
to add to the<br>
&gt;&gt; same<br>
&gt;&gt;&gt;&gt;&gt; logical volume<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; All have the same &quot;Stripe&quot; or &quot;Strip Si=
ze&quot; of 512 KB<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; So if I where going to make 3 seperate xfs volumes, I =
would do the<br>
&gt;&gt;&gt;&gt;&gt; following:<br>
&gt;&gt;&gt;&gt;&gt; mkfs.xfs -d su=3D512k sw=3D8 /dev/sda<br>
&gt;&gt;&gt;&gt;&gt; mkfs.xfs -d su=3D512k sw=3D10 /dev/sdb<br>
&gt;&gt;&gt;&gt;&gt; mkfs.xfs -d su=3D512k sw=3D10 /dev/sdc<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; I assume, If I where going to bring them all into 1 lo=
gical volume, it<br>
&gt;&gt;&gt;&gt;&gt; would be best placed to have the sw value set<br>
&gt;&gt;&gt;&gt;&gt; to a value that is divisible by both 8 and 10 - in thi=
s case 2?<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; No. =A0In this case you do NOT stripe align XFS to the sto=
rage, because<br>
&gt;&gt;&gt;&gt; it&#39;s impossible--the RAID stripes are dissimilar. =A0I=
n this case you use<br>
&gt;&gt;&gt;&gt; the default 4KB write out, as if this is a single disk dri=
ve.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; As Dave stated, if you format a concatenated device with X=
FS and you<br>
&gt;&gt;&gt;&gt; desire to align XFS, then all constituent arrays must have=
 the same<br>
&gt;&gt;&gt;&gt; geometry.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Two things to be aware of here:<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; 1. =A0With a decent hardware write caching RAID controller=
, having XFS<br>
&gt;&gt;&gt;&gt; alined to the RAID geometry is a small optimization WRT ov=
erall write<br>
&gt;&gt;&gt;&gt; performance, because the controller is going to be doing t=
he optimizing<br>
&gt;&gt;&gt;&gt; of final writeback to the drives.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; 2. Alignment does not affect read performance.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Ah, but it does...<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; 3. =A0XFS only performs aligned writes during allocation.<=
br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Right, and it does so not only to improve write performance, b=
ut to<br>
&gt;&gt;&gt; also maximise sequential read performance of the data that is<=
br>
&gt;&gt;&gt; written, especially when multiple files are being read<br>
&gt;&gt;&gt; simultaneously and IO latency is important to keep low (e.g.<b=
r>
&gt;&gt;&gt; realtime video ingest and playout).<br>
&gt;&gt;<br>
&gt;&gt; Absolutely correct, as Dave always is. =A0As my workloads are most=
ly<br>
&gt;&gt; random, as are those of others I consult in other fora, I sometime=
s<br>
&gt;&gt; forget the [multi]streaming case. =A0Which is not good, as many fo=
lks<br>
&gt;&gt; choose XFS specifically for [multi]streaming workloads. =A0My rema=
rks to<br>
&gt;&gt; this audience should always reflect that. =A0Apologies for my over=
sight on<br>
&gt;&gt; this occasion.<br>
&gt;&gt;<br>
&gt;&gt;&gt;&gt; What really makes a difference as to whether alignment wil=
l be of<br>
&gt;&gt;&gt;&gt; benefit to you, and how often, is your workload. =A0So at =
this point, you<br>
&gt;&gt;&gt;&gt; need to describe the primary workload(s) of your systems w=
e&#39;re<br>
&gt;&gt; discussing.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Yup, my thoughts exactly...<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Cheers,<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Dave.<br>
&gt;&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; --<br>
&gt;&gt; Stan<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;<br>
&gt;<br>
<br>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<div dir=3D"ltr"><div></div>Stewart Webb<br></div>
</div>

--e89a8f3b9da98a614304e75d7861--


--===============6017392540248252046==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6017392540248252046==--
