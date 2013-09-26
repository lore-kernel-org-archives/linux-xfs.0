Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 422557F5F
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 03:55:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2C2AB8F804C
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 01:55:41 -0700 (PDT)
Received: from mail-ob0-f174.google.com (mail-ob0-f174.google.com
	[209.85.214.174]) by cuda.sgi.com with ESMTP id
	oii8Y0j290CGaNc3 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Sep 2013 01:55:39 -0700 (PDT)
Received: by mail-ob0-f174.google.com with SMTP id uz6so1488092obc.5
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 01:55:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130925215713.GH26872@dastard>
References: <CAE3v2EaODFud_S_BzuSjtwGwuNBXhvL0RiPB1P5QroF45Obwbw@mail.gmail.com>
	<52435327.9080607@hardwarefreak.com>
	<2F959FD9-EF28-4495-9D0B-59B93D89C820@colorremedies.com>
	<20130925215713.GH26872@dastard>
Date: Thu, 26 Sep 2013 09:55:38 +0100
Message-ID: <CAE3v2EYVnXiWq1n8AJ0+Y2eifZyhV08S4uLwf6B6mXXWAzBzRA@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============2058832271009849611=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Murphy <lists@colorremedies.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============2058832271009849611==
Content-Type: multipart/alternative; boundary=089e01228a48b1255804e74588d6

--089e01228a48b1255804e74588d6
Content-Type: text/plain; charset=ISO-8859-1

Thanks for all this info Stan and Dave,

> "Stripe size" is a synonym of XFS sw, which is su * #disks.  This is the
> amount of data written across the full RAID stripe (excluding parity).

The reason I stated Stripe size is because in this instance, I have 3ware
RAID controllers, which refer to
this value as "Stripe" in their tw_cli software (god bless manufacturers
renaming everything)

I do, however, have a follow-on question:
On other systems, I have similar hardware:
3x Raid Controllers
1 of them has 10 disks as RAID 6 that I would like to add to a logical
volume
2 of them have 12 disks as a RAID 6 that I would like to add to the same
logical volume

All have the same "Stripe" or "Strip Size" of 512 KB

So if I where going to make 3 seperate xfs volumes, I would do the
following:
mkfs.xfs -d su=512k sw=8 /dev/sda
mkfs.xfs -d su=512k sw=10 /dev/sdb
mkfs.xfs -d su=512k sw=10 /dev/sdc

I assume, If I where going to bring them all into 1 logical volume, it
would be best placed to have the sw value set
to a value that is divisible by both 8 and 10 - in this case 2?

Obviously, this is not an ideal situation, and I will most likely modify
the hardware to better suite.
But I'd really like to fully understand this.

Thanks for any insight you are able to give

Regards


On 25 September 2013 22:57, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Sep 25, 2013 at 03:34:01PM -0600, Chris Murphy wrote:
> >
> > On Sep 25, 2013, at 3:18 PM, Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
> >
> > > On 9/25/2013 7:56 AM, Stewart Webb wrote:
> > >> Hi All,
> > >
> > > Hi Stewart,
> > >
> > >> I am trying to do the following:
> > >> 3 x Hardware RAID Cards each with a raid 6 volume of 12 disks
> presented to
> > >> the OS
> > >> all raid units have a "stripe size" of 512 KB
> > >
> > > Just for future reference so you're using correct terminology, a value
> > > of 512KB is surely your XFS su value, also called a "strip" in LSI
> > > terminology, or a "chunk" in Linux software md/RAID terminology.  This
> > > is the amount of data written to each data spindle (excluding parity)
> in
> > > the array.
> > >
> > > "Stripe size" is a synonym of XFS sw, which is su * #disks.  This is
> the
> > > amount of data written across the full RAID stripe (excluding parity).
> > >
> > >> so given the info on the xfs.org wiki - I sould give each filesystem
> a
> > >> sunit of 512 KB and a swidth of 10 (because RAID 6 has 2 parity disks)
> > >
> > > Partially correct.  If you format each /dev/[device] presented by the
> > > RAID controller with an XFS filesystem, 3 filesystems total, then your
> > > values above are correct.  EXCEPT you must use the su/sw parameters in
> > > mkfs.xfs if using BYTE values.  See mkfs.xfs(8)
> > >
> > >> all well and good
> > >>
> > >> But - I would like to use Linear LVM to bring all 3 cards into 1
> logical
> > >> volume -
> > >> here is where my question crops up:
> > >> Does this effect how I need to align the filesystem?
> > >
> > > In the case of a concatenation, which is what LVM linear is, you should
> > > use an XFS alignment identical to that for a single array as above.
>                                                  ^^^^^^
> > So keeping the example, 3 arrays x 10 data disks, would this be su=512k
> and sw=30?
>
> No, the alignment should match that of a *single* 10 disk array,
> so su=512k,sw=10.
>
> Linear concatentation looks like this:
>
> offset          volume                          array
> 0               +-D1-+-D2-+.....+-Dn-+          0       # first sw
> .....
> X-sw            +-D1-+-D2-+.....+-Dn-+          0
> X               +-E1-+-E2-+.....+-En-+          1       # first sw
> .....
> 2X-sw           +-E1-+-E2-+.....+-En-+          1
> 2X              +-F1-+-F2-+.....+-Fn-+          2       # first sw
> .....
> 3X-sw           +-F1-+-F2-+.....+-Fn-+          2
>
> Where:
>         D1...Dn are the disks in the first array
>         E1...En are the disks in the second array
>         F1...Fn are the disks in the third array
>         X is the size of the each array
>         sw = su * number of data disks in array
>
> As you can see, all the volumes are arranged in a single column -
> identical to a larger single array of the same size.  Hence the
> exposed alignment of a single array is what the filesystem should be
> aligned to, as that is how the linear concat behaves.
>
> You also might note here that if you want the second and subsequent
> arrays to be correctly aligned to the initial array in the linear
> concat (and you do want that), the arrays must be sized to be an
> exact multiple of the stripe width.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>



-- 
Stewart Webb

--089e01228a48b1255804e74588d6
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks for all this info Stan and Dave,<div><span style=3D=
"font-family:arial,sans-serif;font-size:13px"><br></span></div><div><span s=
tyle=3D"font-family:arial,sans-serif;font-size:13px">&gt; &quot;Stripe size=
&quot; is a synonym of XFS sw, which is su * #disks. =A0This is the</span><=
br style=3D"font-family:arial,sans-serif;font-size:13px">
<span style=3D"font-family:arial,sans-serif;font-size:13px">&gt; amount of =
data written across the full RAID stripe (excluding parity).</span><br></di=
v><div><br></div><div>The reason I stated Stripe size is because in this in=
stance, I have 3ware RAID controllers, which refer to</div>
<div>this value as &quot;Stripe&quot; in their tw_cli software (god bless m=
anufacturers renaming everything)</div><div><br></div><div>I do, however, h=
ave a follow-on question:</div><div>On other systems, I have similar hardwa=
re:</div>
<div>3x Raid Controllers</div><div>1 of them has 10 disks as RAID 6 that I =
would like to add to a logical volume</div><div>2 of them have 12 disks as =
a RAID 6 that I would like to add to the same logical volume</div><div>
<br></div><div>All have the same &quot;Stripe&quot; or &quot;Strip Size&quo=
t; of 512 KB</div><div><br></div><div>So if I where going to make 3 seperat=
e xfs volumes, I would do the following:</div><div>mkfs.xfs -d su=3D512k sw=
=3D8 /dev/sda</div>
<div>mkfs.xfs -d su=3D512k sw=3D10 /dev/sdb</div><div>mkfs.xfs -d su=3D512k=
 sw=3D10 /dev/sdc</div><div><br></div><div>I assume, If I where going to br=
ing them all into 1 logical volume, it would be best placed to have the sw =
value set</div>
<div>to a value that is divisible by both 8 and 10 - in this case 2?</div><=
div><br></div><div>Obviously, this is not an ideal situation, and I will mo=
st likely modify the hardware to better suite.</div><div>But I&#39;d really=
 like to fully understand this.</div>
<div><br></div><div>Thanks for any insight you are able to give</div><div><=
br></div><div>Regards</div></div><div class=3D"gmail_extra"><br><br><div cl=
ass=3D"gmail_quote">On 25 September 2013 22:57, Dave Chinner <span dir=3D"l=
tr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@from=
orbit.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On W=
ed, Sep 25, 2013 at 03:34:01PM -0600, Chris Murphy wrote:<br>
&gt;<br>
&gt; On Sep 25, 2013, at 3:18 PM, Stan Hoeppner &lt;<a href=3D"mailto:stan@=
hardwarefreak.com">stan@hardwarefreak.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; On 9/25/2013 7:56 AM, Stewart Webb wrote:<br>
&gt; &gt;&gt; Hi All,<br>
&gt; &gt;<br>
&gt; &gt; Hi Stewart,<br>
&gt; &gt;<br>
&gt; &gt;&gt; I am trying to do the following:<br>
&gt; &gt;&gt; 3 x Hardware RAID Cards each with a raid 6 volume of 12 disks=
 presented to<br>
&gt; &gt;&gt; the OS<br>
&gt; &gt;&gt; all raid units have a &quot;stripe size&quot; of 512 KB<br>
&gt; &gt;<br>
&gt; &gt; Just for future reference so you&#39;re using correct terminology=
, a value<br>
&gt; &gt; of 512KB is surely your XFS su value, also called a &quot;strip&q=
uot; in LSI<br>
&gt; &gt; terminology, or a &quot;chunk&quot; in Linux software md/RAID ter=
minology. =A0This<br>
&gt; &gt; is the amount of data written to each data spindle (excluding par=
ity) in<br>
&gt; &gt; the array.<br>
&gt; &gt;<br>
&gt; &gt; &quot;Stripe size&quot; is a synonym of XFS sw, which is su * #di=
sks. =A0This is the<br>
&gt; &gt; amount of data written across the full RAID stripe (excluding par=
ity).<br>
&gt; &gt;<br>
&gt; &gt;&gt; so given the info on the <a href=3D"http://xfs.org" target=3D=
"_blank">xfs.org</a> wiki - I sould give each filesystem a<br>
&gt; &gt;&gt; sunit of 512 KB and a swidth of 10 (because RAID 6 has 2 pari=
ty disks)<br>
&gt; &gt;<br>
&gt; &gt; Partially correct. =A0If you format each /dev/[device] presented =
by the<br>
&gt; &gt; RAID controller with an XFS filesystem, 3 filesystems total, then=
 your<br>
&gt; &gt; values above are correct. =A0EXCEPT you must use the su/sw parame=
ters in<br>
&gt; &gt; mkfs.xfs if using BYTE values. =A0See mkfs.xfs(8)<br>
&gt; &gt;<br>
&gt; &gt;&gt; all well and good<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; But - I would like to use Linear LVM to bring all 3 cards int=
o 1 logical<br>
&gt; &gt;&gt; volume -<br>
&gt; &gt;&gt; here is where my question crops up:<br>
&gt; &gt;&gt; Does this effect how I need to align the filesystem?<br>
&gt; &gt;<br>
&gt; &gt; In the case of a concatenation, which is what LVM linear is, you =
should<br>
&gt; &gt; use an XFS alignment identical to that for a single array as abov=
e.<br>
</div></div>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^<br>
<div class=3D"im">&gt; So keeping the example, 3 arrays x 10 data disks, wo=
uld this be su=3D512k and sw=3D30?<br>
<br>
</div>No, the alignment should match that of a *single* 10 disk array,<br>
so su=3D512k,sw=3D10.<br>
<br>
Linear concatentation looks like this:<br>
<br>
offset =A0 =A0 =A0 =A0 =A0volume =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0array<br>
0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 +-D1-+-D2-+.....+-Dn-+ =A0 =A0 =A0 =A0 =A00 =
=A0 =A0 =A0 # first sw<br>
.....<br>
X-sw =A0 =A0 =A0 =A0 =A0 =A0+-D1-+-D2-+.....+-Dn-+ =A0 =A0 =A0 =A0 =A00<br>
X =A0 =A0 =A0 =A0 =A0 =A0 =A0 +-E1-+-E2-+.....+-En-+ =A0 =A0 =A0 =A0 =A01 =
=A0 =A0 =A0 # first sw<br>
.....<br>
2X-sw =A0 =A0 =A0 =A0 =A0 +-E1-+-E2-+.....+-En-+ =A0 =A0 =A0 =A0 =A01<br>
2X =A0 =A0 =A0 =A0 =A0 =A0 =A0+-F1-+-F2-+.....+-Fn-+ =A0 =A0 =A0 =A0 =A02 =
=A0 =A0 =A0 # first sw<br>
.....<br>
3X-sw =A0 =A0 =A0 =A0 =A0 +-F1-+-F2-+.....+-Fn-+ =A0 =A0 =A0 =A0 =A02<br>
<br>
Where:<br>
=A0 =A0 =A0 =A0 D1...Dn are the disks in the first array<br>
=A0 =A0 =A0 =A0 E1...En are the disks in the second array<br>
=A0 =A0 =A0 =A0 F1...Fn are the disks in the third array<br>
=A0 =A0 =A0 =A0 X is the size of the each array<br>
=A0 =A0 =A0 =A0 sw =3D su * number of data disks in array<br>
<br>
As you can see, all the volumes are arranged in a single column -<br>
identical to a larger single array of the same size. =A0Hence the<br>
exposed alignment of a single array is what the filesystem should be<br>
aligned to, as that is how the linear concat behaves.<br>
<br>
You also might note here that if you want the second and subsequent<br>
arrays to be correctly aligned to the initial array in the linear<br>
concat (and you do want that), the arrays must be sized to be an<br>
exact multiple of the stripe width.<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/listinfo/xfs</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<div dir=3D"ltr"><div></div>Stewart Webb<br></div>
</div>

--089e01228a48b1255804e74588d6--


--===============2058832271009849611==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2058832271009849611==--
