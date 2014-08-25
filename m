Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 11F6B7F4E
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 05:31:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0085930404E
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 03:31:13 -0700 (PDT)
Received: from mail-lb0-f170.google.com (mail-lb0-f170.google.com
	[209.85.217.170]) by cuda.sgi.com with ESMTP id
	zH70WNAbnS14FOc9 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Aug 2014 03:31:12 -0700 (PDT)
Received: by mail-lb0-f170.google.com with SMTP id l4so11994952lbv.1
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 03:31:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140825090843.GE20518@dastard>
References: <CAKEtwsWxZseS8M+O7vSR2FRXr4gjVQ0RDO8ok+jMPWq-8jPEeA@mail.gmail.com>
	<20140825051801.GY26465@dastard>
	<CAKEtwsXiVKTWAW+YszjNnFnD4_Ld7g2qXEvw48A-SitYSGyXHA@mail.gmail.com>
	<20140825090843.GE20518@dastard>
Date: Mon, 25 Aug 2014 18:31:10 +0800
Message-ID: <CAKEtwsU4gywG7fVVMVU1Y_TG9Pgg_-sFV0=SPg_7Ob5EV6FTew@mail.gmail.com>
Subject: Re: bad performance on touch/cp file on XFS system
From: Zhang Qiang <zhangqiang.buaa@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0163909182590317069=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============0163909182590317069==
Content-Type: multipart/alternative; boundary=089e0112c0b08270ac050171af03

--089e0112c0b08270ac050171af03
Content-Type: text/plain; charset=UTF-8

2014-08-25 17:08 GMT+08:00 Dave Chinner <david@fromorbit.com>:

> On Mon, Aug 25, 2014 at 04:47:39PM +0800, Zhang Qiang wrote:
> > I have checked icount and ifree, but I found there are about 11.8 percent
> > free, so the free inode should not be too few.
> >
> > Here's the detail log, any new clue?
> >
> > # mount /dev/sda4 /data1/
> > # xfs_info /data1/
> > meta-data=/dev/sda4              isize=256    agcount=4, agsize=142272384
>
> 4 AGs
>
Yes.

>
> > icount = 220619904
> > ifree = 26202919
>
> And 220 million inodes. There's your problem - that's an average
> of 55 million inodes per AGI btree assuming you are using inode64.
> If you are using inode32, then the inodes will be in 2 btrees, or
> maybe even only one.
>

You are right, all inodes stay on one AG.

BTW, why i allocate 4 AGs, and all inodes stay in one AG for inode32?,
sorry as I am not familiar with xfs currently.


>
> Anyway you look at it, searching btrees with tens of millions of
> entries is going to consume a *lot* of CPU time. So, really, the
> state your fs is in is probably unfixable without mkfs. And really,
> that's probably pushing the boundaries of what xfsdump and
> xfs-restore can support - it's going to take a long tiem to dump and
> restore that data....
>

 Thanks reasonable.



> With that many inodes, I'd be considering moving to 32 or 64 AGs to
> keep the btree size down to a more manageable size. The free inode

btree would also help, but, really, 220M inodes in a 2TB filesystem
> is really pushing the boundaries of sanity.....
>

So the better inodes size in one AG is about 5M, is there any documents
about these options I can learn more?

I will spend more time to learn how to use xfs, and the internal of xfs,
and try to contribute code.

Thanks for your help.



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

--089e0112c0b08270ac050171af03
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><br><div class=3D"gmail=
_quote">2014-08-25 17:08 GMT+08:00 Dave Chinner <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>=
&gt;</span>:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"">On Mon, Aug 25, 2014 at 04:4=
7:39PM +0800, Zhang Qiang wrote:<br>
&gt; I have checked icount and ifree, but I found there are about 11.8 perc=
ent<br>
&gt; free, so the free inode should not be too few.<br>
&gt;<br>
&gt; Here&#39;s the detail log, any new clue?<br>
&gt;<br>
&gt; # mount /dev/sda4 /data1/<br>
&gt; # xfs_info /data1/<br>
&gt; meta-data=3D/dev/sda4=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
isize=3D256=C2=A0 =C2=A0 agcount=3D4, agsize=3D142272384<br>
<br>
</div>4 AGs<br></blockquote><div>Yes.=C2=A0</div><blockquote class=3D"gmail=
_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:=
1ex">
<div class=3D""><br>
&gt; icount =3D 220619904<br>
&gt; ifree =3D 26202919<br>
<br>
</div>And 220 million inodes. There&#39;s your problem - that&#39;s an aver=
age<br>
of 55 million inodes per AGI btree assuming you are using inode64.<br>
If you are using inode32, then the inodes will be in 2 btrees, or<br>
maybe even only one.<br></blockquote><div>=C2=A0</div><div>You are right, a=
ll inodes stay on one AG.</div><div><br></div><div>BTW, why i allocate 4 AG=
s, and all inodes stay in one AG for inode32?, sorry as I am not familiar w=
ith xfs currently.</div>
<div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8=
ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
Anyway you look at it, searching btrees with tens of millions of<br>
entries is going to consume a *lot* of CPU time. So, really, the<br>
state your fs is in is probably unfixable without mkfs. And really,<br>
that&#39;s probably pushing the boundaries of what xfsdump and<br>
xfs-restore can support - it&#39;s going to take a long tiem to dump and<br=
>
restore that data....<br></blockquote><div>=C2=A0</div><div>=C2=A0Thanks re=
asonable.</div><div><br></div><div><br></div><blockquote class=3D"gmail_quo=
te" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"=
>
<br>
With that many inodes, I&#39;d be considering moving to 32 or 64 AGs to<br>
keep the btree size down to a more manageable size. The free inode=C2=A0</b=
lockquote><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bord=
er-left:1px #ccc solid;padding-left:1ex">
btree would also help, but, really, 220M inodes in a 2TB filesystem<br>
is really pushing the boundaries of sanity.....<br></blockquote><div>=C2=A0=
</div><div>So the better inodes size in one AG is about 5M, is there any do=
cuments about these options I can learn more?</div><div><br></div><div>I wi=
ll spend more time to learn how to use xfs, and the internal of xfs, and tr=
y to contribute code.</div>
<div><br></div><div>Thanks for your help.</div><div><br></div><div><br></di=
v><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:=
1px #ccc solid;padding-left:1ex">
<div class=3D"im HOEnZb"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
<br>
</div><div class=3D"HOEnZb"><div class=3D"h5">_____________________________=
__________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/listinfo/xfs</a><br>
</div></div></blockquote></div><br></div></div>

--089e0112c0b08270ac050171af03--


--===============0163909182590317069==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0163909182590317069==--
