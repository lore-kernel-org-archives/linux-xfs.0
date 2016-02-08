Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2E6EE29DF5
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 09:13:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0FB12304051
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 07:13:13 -0800 (PST)
Received: from mail-yk0-f175.google.com (mail-yk0-f175.google.com
	[209.85.160.175]) by cuda.sgi.com with ESMTP id
	fHPdeoGWbXHTIHSO (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 07:13:07 -0800 (PST)
Received: by mail-yk0-f175.google.com with SMTP id r207so88205632ykd.2
	for <xfs@oss.sgi.com>; Mon, 08 Feb 2016 07:13:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160208143531.GA19597@bfoster.bfoster>
References: <CAAgKQi+AOZO_K9Garmz3G6C1X8TuTRxrfF1MP2HPEZ3JkdE41w@mail.gmail.com>
	<20160205223023.GL459@dastard>
	<CAAgKQiJ17XKu-k-Gufk0O_EgXcZvebzCEO4STGdAkszoZxAqfw@mail.gmail.com>
	<20160208143531.GA19597@bfoster.bfoster>
Date: Mon, 8 Feb 2016 16:13:06 +0100
Message-ID: <CAAgKQi+AnDXQKVBe4aC=0iHv2_W44f-Fx4KJRvQRMMWo3weKkg@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============7169826349842314778=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

--===============7169826349842314778==
Content-Type: multipart/alternative; boundary=001a113c5fc05aedbd052b43a3c7

--001a113c5fc05aedbd052b43a3c7
Content-Type: text/plain; charset=UTF-8

2016-02-08 15:35 GMT+01:00 Brian Foster <bfoster@redhat.com>:

> On Mon, Feb 08, 2016 at 02:09:15PM +0100, Michel Verbraak wrote:
> > 2016-02-05 23:30 GMT+01:00 Dave Chinner <david@fromorbit.com>:
> >
> > > On Fri, Feb 05, 2016 at 02:13:00PM +0100, Michel Verbraak wrote:
> > > > All,
> > > >
> > > > Recently we ran into a problem where our filesystem (300GB in size)
> > > > reported 'no space left on device' (ENOSPC) but when we looked at
> disk
> > > > space usage and inode usage it was around 52% for disk space and 11%
> for
> > > .......
> >
> >
> > >
> > > > Store 03 (root@server):~# xfs_db -c freesp /dev/sdb
> > > >    from      to extents  blocks    pct
> > > >       1       1 3282633 3282633   9.03
> > > >       2       3 3416223 8372325  23.03
> > > >       4       7 6175009 24700036  67.94
> > >
> > > Yup, no more aligned 4 block extents in the filesystem.
> > >
> > > Dave Thank you for your answer but are you able to explain a bit more
> on
> > how you determine there are no aligned 4 block extends available?
> > It apparently is not the 'from 4 to 7' line telling there are at least
> > continuous extents of 4 blocks big. Or is it because 24700036 divided
> > by 6175009
> > is exactly 4 and not a bit more?
> > When I calculate the ratio between the individual AG freesp they were all
> > four exactly 4.
> >
>
> I'm not sure there is a way to determine whether these extents are
> aligned or not short of walking the free space btree structures with
> ..<snip>



> BTW, a metadump of your fs while it's in this ENOSPC state would be
> useful towards testing something like that, if you'd be willing to
> provide one. Note that xfs_metadump has obfuscation that hides filenames
> and whatnot for privacy purposes.
>
> If we do run into problem again, we do hope not as it is on a production
system, we will create the xfs_metadump and provide it to this list.

Thank you for the extra explanation.

Cheers Michel.


> Brian
>
> > As said we would like to detect this problem from happening again. And we
> > would like this detection to be done by our monitoring service.
> > One of my colleagues mentions the following calculation to find out if
> > there are enough aligned 4 block extents:
> >
> > Starting from line "from 4 to 7" calculate: <blocks-column> - (4 *
> > <extents-column>) > 0. When not there is not enough free space for new
> > inodes.
> >
> > On another system we have which does not see these problems yet we have:
> >
> >    from      to extents  blocks    pct
> >       1       1 3483987 3483987   7.83
> >       2       3 3560607 8709838  19.58
> >       4       7 6402893 26486634  59.55
> >       8      15  418450 5799206  13.04
> >
> > 26486634 / 6402893 = 4.136666 and
> > 26486634 - (4 * 6402893) = 875062 > 0 and
> > 5799205 - (4 * 418450) = 4125405 > 0
> >
> >
> > > into this condition.
> > >
> > > Cheers,
> > >
> > > Dave.
> > > --
> > > Dave Chinner
> > > david@fromorbit.com
> > >
> >
> > Michel.
>
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
>

--001a113c5fc05aedbd052b43a3c7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">2016-02-08 15:35 GMT+01:00 Brian Foster <span dir=3D"ltr">&lt;<a href=
=3D"mailto:bfoster@redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt;=
</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0=
.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><div><span cl=
ass=3D"">On Mon, Feb 08, 2016 at 02:09:15PM +0100, Michel Verbraak wrote:<b=
r>
&gt; 2016-02-05 23:30 GMT+01:00 Dave Chinner &lt;<a href=3D"mailto:david@fr=
omorbit.com">david@fromorbit.com</a>&gt;:<br>
&gt;<br>
&gt; &gt; On Fri, Feb 05, 2016 at 02:13:00PM +0100, Michel Verbraak wrote:<=
br>
&gt; &gt; &gt; All,<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Recently we ran into a problem where our filesystem (300GB i=
n size)<br>
&gt; &gt; &gt; reported &#39;no space left on device&#39; (ENOSPC) but when=
 we looked at disk<br>
&gt; &gt; &gt; space usage and inode usage it was around 52% for disk space=
 and 11% for<br>
&gt; &gt; .......<br>
&gt;<br>
&gt;<br>
&gt; &gt;<br>
&gt; &gt; &gt; Store 03 (root@server):~# xfs_db -c freesp /dev/sdb<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 from=C2=A0 =C2=A0 =C2=A0 to extents=C2=A0 block=
s=C2=A0 =C2=A0 pct<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A01=C2=A0 =C2=A0 =C2=A0 =C2=A01 3282=
633 3282633=C2=A0 =C2=A09.03<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A02=C2=A0 =C2=A0 =C2=A0 =C2=A03 3416=
223 8372325=C2=A0 23.03<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A04=C2=A0 =C2=A0 =C2=A0 =C2=A07 6175=
009 24700036=C2=A0 67.94<br>
&gt; &gt;<br>
&gt; &gt; Yup, no more aligned 4 block extents in the filesystem.<br>
&gt; &gt;<br>
&gt; &gt; Dave Thank you for your answer but are you able to explain a bit =
more on<br>
&gt; how you determine there are no aligned 4 block extends available?<br>
&gt; It apparently is not the &#39;from 4 to 7&#39; line telling there are =
at least<br>
&gt; continuous extents of 4 blocks big. Or is it because 24700036 divided<=
br>
&gt; by 6175009<br>
&gt; is exactly 4 and not a bit more?<br>
&gt; When I calculate the ratio between the individual AG freesp they were =
all<br>
&gt; four exactly 4.<br>
&gt;<br>
<br>
</span>I&#39;m not sure there is a way to determine whether these extents a=
re<br>
aligned or not short of walking the free space btree structures with<br></d=
iv>
..&lt;snip&gt;=C2=A0</blockquote><div>=C2=A0</div><blockquote class=3D"gmai=
l_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,20=
4,204);padding-left:1ex"><div>
BTW, a metadump of your fs while it&#39;s in this ENOSPC state would be<br>
useful towards testing something like that, if you&#39;d be willing to<br>
provide one. Note that xfs_metadump has obfuscation that hides filenames<br=
>
and whatnot for privacy purposes.<br>
<br></div></blockquote><div>If we do run into problem again, we do hope not=
 as it is on a production system, we will create the xfs_metadump and provi=
de it to this list.<br><br></div><div>Thank you for the extra explanation.<=
br><br></div><div>Cheers Michel.<br>=C2=A0<br></div><blockquote class=3D"gm=
ail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,=
204,204);padding-left:1ex"><div>
Brian<br>
<span class=3D""><br>
&gt; As said we would like to detect this problem from happening again. And=
 we<br>
&gt; would like this detection to be done by our monitoring service.<br>
&gt; One of my colleagues mentions the following calculation to find out if=
<br>
&gt; there are enough aligned 4 block extents:<br>
&gt;<br>
&gt; Starting from line &quot;from 4 to 7&quot; calculate: &lt;blocks-colum=
n&gt; - (4 *<br>
&gt; &lt;extents-column&gt;) &gt; 0. When not there is not enough free spac=
e for new<br>
&gt; inodes.<br>
&gt;<br>
&gt; On another system we have which does not see these problems yet we hav=
e:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 from=C2=A0 =C2=A0 =C2=A0 to extents=C2=A0 blocks=C2=A0 =
=C2=A0 pct<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A01=C2=A0 =C2=A0 =C2=A0 =C2=A01 3483987 348398=
7=C2=A0 =C2=A07.83<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A02=C2=A0 =C2=A0 =C2=A0 =C2=A03 3560607 870983=
8=C2=A0 19.58<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A04=C2=A0 =C2=A0 =C2=A0 =C2=A07 6402893 264866=
34=C2=A0 59.55<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 15=C2=A0 418450 579920=
6=C2=A0 13.04<br>
&gt;<br>
&gt; 26486634 / 6402893 =3D 4.136666 and<br>
&gt; 26486634 - (4 * 6402893) =3D 875062 &gt; 0 and<br>
&gt; 5799205 - (4 * 418450) =3D 4125405 &gt; 0<br>
&gt;<br>
&gt;<br>
&gt; &gt; into this condition.<br>
&gt; &gt;<br>
&gt; &gt; Cheers,<br>
&gt; &gt;<br>
&gt; &gt; Dave.<br>
&gt; &gt; --<br>
&gt; &gt; Dave Chinner<br>
&gt; &gt; <a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br=
>
&gt; &gt;<br>
&gt;<br>
&gt; Michel.<br>
<br>
</span>&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"noreferrer"=
 target=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<br>
</div></blockquote></div><br></div></div>

--001a113c5fc05aedbd052b43a3c7--


--===============7169826349842314778==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7169826349842314778==--
