Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F5507F5F
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 04:28:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 86FAC304032
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 02:28:02 -0700 (PDT)
Received: from mail-oa0-f47.google.com (mail-oa0-f47.google.com
	[209.85.219.47]) by cuda.sgi.com with ESMTP id nwLMSxUrIWo1bCmo
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 Sep 2013 02:28:01 -0700 (PDT)
Received: by mail-oa0-f47.google.com with SMTP id i1so368979oag.6
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 02:28:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5243FCD6.4000701@hardwarefreak.com>
References: <CAE3v2EaODFud_S_BzuSjtwGwuNBXhvL0RiPB1P5QroF45Obwbw@mail.gmail.com>
	<52435327.9080607@hardwarefreak.com>
	<2F959FD9-EF28-4495-9D0B-59B93D89C820@colorremedies.com>
	<20130925215713.GH26872@dastard>
	<CAE3v2EYVnXiWq1n8AJ0+Y2eifZyhV08S4uLwf6B6mXXWAzBzRA@mail.gmail.com>
	<5243FCD6.4000701@hardwarefreak.com>
Date: Thu, 26 Sep 2013 10:28:00 +0100
Message-ID: <CAE3v2EZp-A2CokEGQWvGZG7rd=tJU=tEW=L_JePTjMygEqQkKg@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============6749973853986984018=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: Chris Murphy <lists@colorremedies.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============6749973853986984018==
Content-Type: multipart/alternative; boundary=001a11c23696710c8a04e745fcf3

--001a11c23696710c8a04e745fcf3
Content-Type: text/plain; charset=ISO-8859-1

Understood,

My workload is primarily reads (about 80%+ read operations) - so defaults
will most likely
be best suited on this occasion.

I was simply trying to follow the guidelines on the XFS wiki to
the best of my ability, and felt I didn't understand the impact of using
this via LVM.

Now I feel I understand enough to continue in what I need to do.

Thanks again


On 26 September 2013 10:22, Stan Hoeppner <stan@hardwarefreak.com> wrote:

> On 9/26/2013 3:55 AM, Stewart Webb wrote:
> > Thanks for all this info Stan and Dave,
> >
> >> "Stripe size" is a synonym of XFS sw, which is su * #disks.  This is the
> >> amount of data written across the full RAID stripe (excluding parity).
> >
> > The reason I stated Stripe size is because in this instance, I have 3ware
> > RAID controllers, which refer to
> > this value as "Stripe" in their tw_cli software (god bless manufacturers
> > renaming everything)
> >
> > I do, however, have a follow-on question:
> > On other systems, I have similar hardware:
> > 3x Raid Controllers
> > 1 of them has 10 disks as RAID 6 that I would like to add to a logical
> > volume
> > 2 of them have 12 disks as a RAID 6 that I would like to add to the same
> > logical volume
> >
> > All have the same "Stripe" or "Strip Size" of 512 KB
> >
> > So if I where going to make 3 seperate xfs volumes, I would do the
> > following:
> > mkfs.xfs -d su=512k sw=8 /dev/sda
> > mkfs.xfs -d su=512k sw=10 /dev/sdb
> > mkfs.xfs -d su=512k sw=10 /dev/sdc
> >
> > I assume, If I where going to bring them all into 1 logical volume, it
> > would be best placed to have the sw value set
> > to a value that is divisible by both 8 and 10 - in this case 2?
>
> No.  In this case you do NOT stripe align XFS to the storage, because
> it's impossible--the RAID stripes are dissimilar.  In this case you use
> the default 4KB write out, as if this is a single disk drive.
>
> As Dave stated, if you format a concatenated device with XFS and you
> desire to align XFS, then all constituent arrays must have the same
> geometry.
>
> Two things to be aware of here:
>
> 1.  With a decent hardware write caching RAID controller, having XFS
> alined to the RAID geometry is a small optimization WRT overall write
> performance, because the controller is going to be doing the optimizing
> of final writeback to the drives.
>
> 2. Alignment does not affect read performance.
>
> 3.  XFS only performs aligned writes during allocation.  I.e. this only
> occurs when creating a new file, new inode, etc.  For append and
> modify-in-place operations, there is no write alignment.  So again,
> stripe alignment to the hardware geometry is merely an optimization, and
> only affect some types of writes.
>
> What really makes a difference as to whether alignment will be of
> benefit to you, and how often, is your workload.  So at this point, you
> need to describe the primary workload(s) of your systems we're discussing.
>
> --
> Stan
>
>


-- 
Stewart Webb

--001a11c23696710c8a04e745fcf3
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Understood,<div><br></div><div>My workload is primarily re=
ads (about 80%+ read operations) - so defaults will most likely</div><div>b=
e best suited on this occasion.</div><div><br></div><div>I was simply tryin=
g to follow the guidelines on the XFS wiki to</div>
<div>the best of my ability, and felt I didn&#39;t understand the impact of=
 using this via LVM.</div><div><br></div><div>Now I feel I understand enoug=
h to continue in what I need to do.</div><div><br></div><div>Thanks again</=
div>
</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On 26 S=
eptember 2013 10:22, Stan Hoeppner <span dir=3D"ltr">&lt;<a href=3D"mailto:=
stan@hardwarefreak.com" target=3D"_blank">stan@hardwarefreak.com</a>&gt;</s=
pan> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On 9/26/2013 3:55 AM, Stew=
art Webb wrote:<br>
&gt; Thanks for all this info Stan and Dave,<br>
&gt;<br>
&gt;&gt; &quot;Stripe size&quot; is a synonym of XFS sw, which is su * #dis=
ks. =A0This is the<br>
&gt;&gt; amount of data written across the full RAID stripe (excluding pari=
ty).<br>
&gt;<br>
&gt; The reason I stated Stripe size is because in this instance, I have 3w=
are<br>
&gt; RAID controllers, which refer to<br>
&gt; this value as &quot;Stripe&quot; in their tw_cli software (god bless m=
anufacturers<br>
&gt; renaming everything)<br>
&gt;<br>
&gt; I do, however, have a follow-on question:<br>
&gt; On other systems, I have similar hardware:<br>
&gt; 3x Raid Controllers<br>
&gt; 1 of them has 10 disks as RAID 6 that I would like to add to a logical=
<br>
&gt; volume<br>
&gt; 2 of them have 12 disks as a RAID 6 that I would like to add to the sa=
me<br>
&gt; logical volume<br>
&gt;<br>
&gt; All have the same &quot;Stripe&quot; or &quot;Strip Size&quot; of 512 =
KB<br>
&gt;<br>
&gt; So if I where going to make 3 seperate xfs volumes, I would do the<br>
&gt; following:<br>
&gt; mkfs.xfs -d su=3D512k sw=3D8 /dev/sda<br>
&gt; mkfs.xfs -d su=3D512k sw=3D10 /dev/sdb<br>
&gt; mkfs.xfs -d su=3D512k sw=3D10 /dev/sdc<br>
&gt;<br>
&gt; I assume, If I where going to bring them all into 1 logical volume, it=
<br>
&gt; would be best placed to have the sw value set<br>
&gt; to a value that is divisible by both 8 and 10 - in this case 2?<br>
<br>
</div>No. =A0In this case you do NOT stripe align XFS to the storage, becau=
se<br>
it&#39;s impossible--the RAID stripes are dissimilar. =A0In this case you u=
se<br>
the default 4KB write out, as if this is a single disk drive.<br>
<br>
As Dave stated, if you format a concatenated device with XFS and you<br>
desire to align XFS, then all constituent arrays must have the same<br>
geometry.<br>
<br>
Two things to be aware of here:<br>
<br>
1. =A0With a decent hardware write caching RAID controller, having XFS<br>
alined to the RAID geometry is a small optimization WRT overall write<br>
performance, because the controller is going to be doing the optimizing<br>
of final writeback to the drives.<br>
<br>
2. Alignment does not affect read performance.<br>
<br>
3. =A0XFS only performs aligned writes during allocation. =A0I.e. this only=
<br>
occurs when creating a new file, new inode, etc. =A0For append and<br>
modify-in-place operations, there is no write alignment. =A0So again,<br>
stripe alignment to the hardware geometry is merely an optimization, and<br=
>
only affect some types of writes.<br>
<br>
What really makes a difference as to whether alignment will be of<br>
benefit to you, and how often, is your workload. =A0So at this point, you<b=
r>
need to describe the primary workload(s) of your systems we&#39;re discussi=
ng.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
Stan<br>
<br>
</font></span></blockquote></div><br><br clear=3D"all"><div><br></div>-- <b=
r><div dir=3D"ltr"><div></div>Stewart Webb<br></div>
</div>

--001a11c23696710c8a04e745fcf3--


--===============6749973853986984018==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6749973853986984018==--
