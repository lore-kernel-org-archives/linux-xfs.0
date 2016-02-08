Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6D77229DF5
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 07:09:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4D554304032
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 05:09:18 -0800 (PST)
Received: from mail-yw0-f174.google.com (mail-yw0-f174.google.com
	[209.85.161.174]) by cuda.sgi.com with ESMTP id
	kLBj5ccDxu5txF1l (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 05:09:16 -0800 (PST)
Received: by mail-yw0-f174.google.com with SMTP id q190so101116996ywd.3
	for <xfs@oss.sgi.com>; Mon, 08 Feb 2016 05:09:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160205223023.GL459@dastard>
References: <CAAgKQi+AOZO_K9Garmz3G6C1X8TuTRxrfF1MP2HPEZ3JkdE41w@mail.gmail.com>
	<20160205223023.GL459@dastard>
Date: Mon, 8 Feb 2016 14:09:15 +0100
Message-ID: <CAAgKQiJ17XKu-k-Gufk0O_EgXcZvebzCEO4STGdAkszoZxAqfw@mail.gmail.com>
Subject: Re: Question about continous blocks for inode due to 'no space left
	on device' problem
From: Michel Verbraak <info1stsetup@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5728875979708889824=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============5728875979708889824==
Content-Type: multipart/alternative; boundary=001a114054466c2058052b41e8ef

--001a114054466c2058052b41e8ef
Content-Type: text/plain; charset=UTF-8

2016-02-05 23:30 GMT+01:00 Dave Chinner <david@fromorbit.com>:

> On Fri, Feb 05, 2016 at 02:13:00PM +0100, Michel Verbraak wrote:
> > All,
> >
> > Recently we ran into a problem where our filesystem (300GB in size)
> > reported 'no space left on device' (ENOSPC) but when we looked at disk
> > space usage and inode usage it was around 52% for disk space and 11% for
> .......


>
> > Store 03 (root@server):~# xfs_db -c freesp /dev/sdb
> >    from      to extents  blocks    pct
> >       1       1 3282633 3282633   9.03
> >       2       3 3416223 8372325  23.03
> >       4       7 6175009 24700036  67.94
>
> Yup, no more aligned 4 block extents in the filesystem.
>
> Dave Thank you for your answer but are you able to explain a bit more on
how you determine there are no aligned 4 block extends available?
It apparently is not the 'from 4 to 7' line telling there are at least
continuous extents of 4 blocks big. Or is it because 24700036 divided
by 6175009
is exactly 4 and not a bit more?
When I calculate the ratio between the individual AG freesp they were all
four exactly 4.

As said we would like to detect this problem from happening again. And we
would like this detection to be done by our monitoring service.
One of my colleagues mentions the following calculation to find out if
there are enough aligned 4 block extents:

Starting from line "from 4 to 7" calculate: <blocks-column> - (4 *
<extents-column>) > 0. When not there is not enough free space for new
inodes.

On another system we have which does not see these problems yet we have:

   from      to extents  blocks    pct
      1       1 3483987 3483987   7.83
      2       3 3560607 8709838  19.58
      4       7 6402893 26486634  59.55
      8      15  418450 5799206  13.04

26486634 / 6402893 = 4.136666 and
26486634 - (4 * 6402893) = 875062 > 0 and
5799205 - (4 * 418450) = 4125405 > 0


> into this condition.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

Michel.

--001a114054466c2058052b41e8ef
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">2016-02-05 23:30 GMT+01:00 Dave Chinner <span dir=3D"ltr">&lt;<a href=
=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&g=
t;</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px=
 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><span class=
=3D"">On Fri, Feb 05, 2016 at 02:13:00PM +0100, Michel Verbraak wrote:<br>
&gt; All,<br>
&gt;<br>
&gt; Recently we ran into a problem where our filesystem (300GB in size)<br=
>
&gt; reported &#39;no space left on device&#39; (ENOSPC) but when we looked=
 at disk<br>
&gt; space usage and inode usage it was around 52% for disk space and 11% f=
or<br>
.......</span></blockquote><div><br></div><blockquote class=3D"gmail_quote"=
 style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);p=
adding-left:1ex"><span class=3D"">&gt;<br>
&gt; Store 03 (root@server):~# xfs_db -c freesp /dev/sdb<br>
&gt;=C2=A0 =C2=A0 from=C2=A0 =C2=A0 =C2=A0 to extents=C2=A0 blocks=C2=A0 =
=C2=A0 pct<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A01=C2=A0 =C2=A0 =C2=A0 =C2=A01 3282633 328263=
3=C2=A0 =C2=A09.03<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A02=C2=A0 =C2=A0 =C2=A0 =C2=A03 3416223 837232=
5=C2=A0 23.03<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A04=C2=A0 =C2=A0 =C2=A0 =C2=A07 6175009 247000=
36=C2=A0 67.94<br>
<br>
</span>Yup, no more aligned 4 block extents in the filesystem.<br>
<br>
</blockquote><div>Dave Thank you for your answer but are you able to explai=
n a bit more on how you determine there are no aligned 4 block extends avai=
lable?<br></div><div>It apparently is not the &#39;from 4 to 7&#39; line te=
lling there are at least continuous extents of 4 blocks big. Or is it becau=
se <span class=3D"">24700036 divided by </span><span class=3D"">6175009 is =
exactly 4 and not a bit more?<br></span></div><div><span class=3D"">When I =
calculate the ratio between the individual AG freesp they were all four exa=
ctly 4.<br></span></div><div><span class=3D""><br></span></div><div><span c=
lass=3D"">As said we would like to detect this problem from happening again=
. And we would like this detection to be done by our monitoring service.<br=
></span></div><div><span class=3D"">One of my colleagues mentions the follo=
wing calculation to find out if there are enough aligned 4 block extents:<b=
r><br></span></div><div><span class=3D"">Starting from line &quot;from 4 to=
 7&quot; calculate: &lt;blocks-column&gt; - (4 * &lt;extents-column&gt;) &g=
t; 0. When not there is not enough free space for new inodes.<br><br></span=
></div><div><span class=3D"">On another system we have which does not see t=
hese problems yet we have:<br><br>=C2=A0=C2=A0 from=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 to extents=C2=A0 blocks=C2=A0=C2=A0=C2=A0 pct<br>=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1 3483987 3483987=C2=A0=
=C2=A0 7.83<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 3 3560607 8709838=C2=A0 19.58<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 7 6402893 26486634=C2=A0 59.55<br>=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 15=C2=A0 418450=
 5799206=C2=A0 13.04<br><br></span></div><div><span class=3D"">26486634 / <=
/span><span class=3D"">6402893 =3D 4.136666 and <br></span></div><div><span=
 class=3D"">26486634 - (4 * </span><span class=3D"">6402893) =3D 875062 &gt=
; 0 and<br>5799205 - (4 * 418450) =3D 4125405 &gt; 0<br></span></div><div>=
=C2=A0<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0=
px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">into this=
 condition.<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D""><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div><div class=3D"gmail_extra">Miche=
l.<br></div></div>

--001a114054466c2058052b41e8ef--


--===============5728875979708889824==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5728875979708889824==--
