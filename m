Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA96mQYv082038 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 00:48:26 -0600
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
	[209.85.212.173]) by cuda.sgi.com with ESMTP id
	A3DDMoXRAvcbuL7U (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 22:50:24 -0800 (PST)
Received: by mail-wi0-f173.google.com with SMTP id hm2so52795wib.14
	for <xfs@oss.sgi.com>; Thu, 08 Nov 2012 22:50:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121109030829.GZ6434@dastard>
References: <CANS6a=D4SMMqhGJVMLbr-BWqLb-Z4L4LnofzfhqChBvE9dEtPQ@mail.gmail.com>
	<20121107031952.GA6434@dastard>
	<CANS6a=DpNTtnV1aLjX1TW_2dNSvwi-nPOB+EiQ=gyg9jwr81oA@mail.gmail.com>
	<20121109030829.GZ6434@dastard>
From: huubby zhou <huubby1@gmail.com>
Date: Fri, 9 Nov 2012 14:50:02 +0800
Message-ID: <CANS6a=Dinis6oPMew9K+=QmEvWwS50eGTtxFm6BevpG4c78U0A@mail.gmail.com>
Subject: Re: How to reserve disk space in XFS to make the blocks over many
	files continuous?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1270939195628955567=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============1270939195628955567==
Content-Type: multipart/alternative; boundary=0016e6db7c6fa94b3604ce0a5d22

--0016e6db7c6fa94b3604ce0a5d22
Content-Type: text/plain; charset=UTF-8

By "According to your advice...", I mean what your demonstrated.

I mount with inode64, and everything is working perfectly.
Many thanks, really appreciate!


On Fri, Nov 9, 2012 at 11:08 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Fri, Nov 09, 2012 at 10:04:57AM +0800, huubby zhou wrote:
> > Hi, Dave,
> >
> > Thanks for the answer, it's great, and I apologize for the terrible
> format.
> >
> > >You can't, directly. If you have enough contiguous free space in the
> > >AG that you are allocating in, then you will get contiguous files if
> > >the allocation size lines up with the filesystem geometry:
> > >
> > >$ for i in `seq 1 10` ; do sudo xfs_io -f -c "truncate 512m" -c "resvsp
> 0
> > 512m" foo.$i ; done
> > >$ sudo xfs_bmap -vp foo.[1-9] foo.10 |grep " 0:"
> > > EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> > > sudo xfs_bmap -vp foo.[1-9] foo.10 |grep " 0:"
> > >   0: [0..1048575]:    8096..1056671     0 (8096..1056671)  1048576
> 10000
> > >   0: [0..1048575]:    1056672..2105247  0 (1056672..2105247) 1048576
> 10000
> > >   0: [0..1048575]:    2105248..3153823  0 (2105248..3153823) 1048576
> 10000
> > >   0: [0..1048575]:    3153824..4202399  0 (3153824..4202399) 1048576
> 10000
> > >   0: [0..1048575]:    4202400..5250975  0 (4202400..5250975) 1048576
> 10000
> > >   0: [0..1048575]:    5250976..6299551  0 (5250976..6299551) 1048576
> 10000
> > >   0: [0..1048575]:    6299552..7348127  0 (6299552..7348127) 1048576
> 10000
> > >   0: [0..1048575]:    7348128..8396703  0 (7348128..8396703) 1048576
> 10000
> > >   0: [0..1048575]:    8396704..9445279  0 (8396704..9445279) 1048576
> 10000
> > >   0: [0..1048575]:    9445280..10493855  0 (9445280..10493855) 1048576
> > 10000
> > >
> > >So all those files are contiguous both internally and externally. If
> > >there isn't sufficient contiguous freespace, or there is allocator
> > >contention, this won't happen - it's best effort behaviour....
> >
> > I believe you got these in a single AG, but I do the allocation in
> > filesystem
> > with multi-AGs, specifically, it is a 6T storage space, and I run the
> > mkfs.xfs
> > without setting the AG number/size, it ends up with 32 AGs.
> > My files layout:
> >     - 0                         - dir
> >     | - 0                       - dir
> >     | | - 1                     - file
> >     | | - 2                     - file
> >     | | - 3                     - file
> >     | | - 4                     - file
> >     | | - 5                     - file
> >     | | - ...                   - file
> >     | | - 128                   - file
> >     | - 1                       - dir
> >     | | - 1                     - file
> >     | | - 2                     - file
> >     | | - 3                     - file
> >     | | - 4                     - file
> >     | | - 5                     - file
> >     | | - ...                   - file
> >     | | - 128                   - file
> >     | - ...                     - dir
> > Every file is 512MB, every directory holds 512MB*128=64GB.
>
> Yup, that's exactly by design. That's how the inode64 allocation
> policy is supposed to work.
>
> > According to your advice and XFS document, I tried to set the AG size to
> > 64GB,
>
> What advice might that be? I don't thikn I've ever recommended
> anyone use 96*64GB AGs. Unless you have 96 allocations all occurring
> at the same time (very rare, in my experience), there is no need for
> some many AGs.
>
>
> > for avoiding the allocator contention and keeping all files in single
> > directory
> > fall in the same AG, but it didn't work. The files are still in different
> > AGs.
> > My xfs_info:
> > meta-data=/dev/sdc2              isize=256    agcount=96, agsize=16777216
> > blks
> >          =                       sectsz=512   attr=0
> > data     =                       bsize=4096   blocks=1610116329,
> imaxpct=25
> >          =                       sunit=0      swidth=0 blks, unwritten=1
> > naming   =version 2              bsize=4096
> > log      =internal log           bsize=4096   blocks=32768, version=1
> >          =                       sectsz=512   sunit=0 blks, lazy-count=0
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> >
> > The files:
> > $ for i in `seq 1 10` ; do sudo xfs_io -f -c "truncate 512m" -c "resvsp 0
> > 512m" foo.$i ; done
> > $ sudo xfs_bmap -vp *| grep " 0:"
> >    0: [0..1048575]:    2147483712..2148532287 16 (64..1048639)    1048576
> > 10000
> >    0: [0..1048575]:    3355443264..3356491839 25 (64..1048639)    1048576
> > 10000
> >    0: [0..1048575]:    2281701440..2282750015 17 (64..1048639)    1048576
> > 10000
> >    0: [0..1048575]:    2415919168..2416967743 18 (64..1048639)    1048576
> > 10000
> >    0: [0..1048575]:    2550136896..2551185471 19 (64..1048639)    1048576
> > 10000
> >    0: [0..1048575]:    2684354624..2685403199 20 (64..1048639)    1048576
> > 10000
> >    0: [0..1048575]:    2818572352..2819620927 21 (64..1048639)    1048576
> > 10000
> >    0: [0..1048575]:    2952790080..2953838655 22 (64..1048639)    1048576
> > 10000
> >    0: [0..1048575]:    3087007808..3088056383 23 (64..1048639)    1048576
> > 10000
> >    0: [0..1048575]:    3221225536..3222274111 24 (64..1048639)    1048576
> > 10000
>
> That's inode32 allocator behaviour (rotoring each new allocation
> across a different AG). Mount with inode64 - it's the default in the
> latest kernels - and it will behave as I demonstrated.
>
> Cheers,
>
> Dave.
>
> --
> Dave Chinner
> david@fromorbit.com
>

--0016e6db7c6fa94b3604ce0a5d22
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

By &quot;<span style=3D"color:rgb(80,0,80);font-family:arial,sans-serif;fon=
t-size:13px">According to your advice...</span>&quot;, I mean what your dem=
onstrated.<div><br></div><div>I mount with inode64, and everything is worki=
ng perfectly.</div>

<div>Many thanks, really appreciate!<br><div class=3D"gmail_extra"><br><br>=
<div class=3D"gmail_quote">On Fri, Nov 9, 2012 at 11:08 AM, Dave Chinner <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank=
">david@fromorbit.com</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex"><div class=3D""><div class=3D"h5">On Fri, Nov 09, 2012 at =
10:04:57AM +0800, huubby zhou wrote:<br>


&gt; Hi, Dave,<br>
&gt;<br>
&gt; Thanks for the answer, it&#39;s great, and I apologize for the terribl=
e format.<br>
&gt;<br>
&gt; &gt;You can&#39;t, directly. If you have enough contiguous free space =
in the<br>
&gt; &gt;AG that you are allocating in, then you will get contiguous files =
if<br>
&gt; &gt;the allocation size lines up with the filesystem geometry:<br>
&gt; &gt;<br>
&gt; &gt;$ for i in `seq 1 10` ; do sudo xfs_io -f -c &quot;truncate 512m&q=
uot; -c &quot;resvsp 0<br>
&gt; 512m&quot; foo.$i ; done<br>
&gt; &gt;$ sudo xfs_bmap -vp foo.[1-9] foo.10 |grep &quot; 0:&quot;<br>
&gt; &gt; EXT: FILE-OFFSET =C2=A0 =C2=A0 =C2=A0BLOCK-RANGE =C2=A0 =C2=A0 =
=C2=A0AG AG-OFFSET =C2=A0 =C2=A0 =C2=A0 =C2=A0TOTAL FLAGS<br>
&gt; &gt; sudo xfs_bmap -vp foo.[1-9] foo.10 |grep &quot; 0:&quot;<br>
&gt; &gt; =C2=A0 0: [0..1048575]: =C2=A0 =C2=A08096..1056671 =C2=A0 =C2=A0 =
0 (8096..1056671) =C2=A01048576 10000<br>
&gt; &gt; =C2=A0 0: [0..1048575]: =C2=A0 =C2=A01056672..2105247 =C2=A00 (10=
56672..2105247) 1048576 10000<br>
&gt; &gt; =C2=A0 0: [0..1048575]: =C2=A0 =C2=A02105248..3153823 =C2=A00 (21=
05248..3153823) 1048576 10000<br>
&gt; &gt; =C2=A0 0: [0..1048575]: =C2=A0 =C2=A03153824..4202399 =C2=A00 (31=
53824..4202399) 1048576 10000<br>
&gt; &gt; =C2=A0 0: [0..1048575]: =C2=A0 =C2=A04202400..5250975 =C2=A00 (42=
02400..5250975) 1048576 10000<br>
&gt; &gt; =C2=A0 0: [0..1048575]: =C2=A0 =C2=A05250976..6299551 =C2=A00 (52=
50976..6299551) 1048576 10000<br>
&gt; &gt; =C2=A0 0: [0..1048575]: =C2=A0 =C2=A06299552..7348127 =C2=A00 (62=
99552..7348127) 1048576 10000<br>
&gt; &gt; =C2=A0 0: [0..1048575]: =C2=A0 =C2=A07348128..8396703 =C2=A00 (73=
48128..8396703) 1048576 10000<br>
&gt; &gt; =C2=A0 0: [0..1048575]: =C2=A0 =C2=A08396704..9445279 =C2=A00 (83=
96704..9445279) 1048576 10000<br>
&gt; &gt; =C2=A0 0: [0..1048575]: =C2=A0 =C2=A09445280..10493855 =C2=A00 (9=
445280..10493855) 1048576<br>
&gt; 10000<br>
&gt; &gt;<br>
&gt; &gt;So all those files are contiguous both internally and externally. =
If<br>
&gt; &gt;there isn&#39;t sufficient contiguous freespace, or there is alloc=
ator<br>
&gt; &gt;contention, this won&#39;t happen - it&#39;s best effort behaviour=
....<br>
&gt;<br>
&gt; I believe you got these in a single AG, but I do the allocation in<br>
&gt; filesystem<br>
&gt; with multi-AGs, specifically, it is a 6T storage space, and I run the<=
br>
&gt; mkfs.xfs<br>
&gt; without setting the AG number/size, it ends up with 32 AGs.<br>
&gt; My files layout:<br>
&gt; =C2=A0 =C2=A0 - 0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - dir<br>
&gt; =C2=A0 =C2=A0 | - 0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 - dir<br>
&gt; =C2=A0 =C2=A0 | | - 1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 - file<br>
&gt; =C2=A0 =C2=A0 | | - 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 - file<br>
&gt; =C2=A0 =C2=A0 | | - 3 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 - file<br>
&gt; =C2=A0 =C2=A0 | | - 4 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 - file<br>
&gt; =C2=A0 =C2=A0 | | - 5 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 - file<br>
&gt; =C2=A0 =C2=A0 | | - ... =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 - file<br>
&gt; =C2=A0 =C2=A0 | | - 128 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 - file<br>
&gt; =C2=A0 =C2=A0 | - 1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 - dir<br>
&gt; =C2=A0 =C2=A0 | | - 1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 - file<br>
&gt; =C2=A0 =C2=A0 | | - 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 - file<br>
&gt; =C2=A0 =C2=A0 | | - 3 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 - file<br>
&gt; =C2=A0 =C2=A0 | | - 4 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 - file<br>
&gt; =C2=A0 =C2=A0 | | - 5 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 - file<br>
&gt; =C2=A0 =C2=A0 | | - ... =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 - file<br>
&gt; =C2=A0 =C2=A0 | | - 128 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 - file<br>
&gt; =C2=A0 =C2=A0 | - ... =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 - dir<br>
&gt; Every file is 512MB, every directory holds 512MB*128=3D64GB.<br>
<br>
</div></div>Yup, that&#39;s exactly by design. That&#39;s how the inode64 a=
llocation<br>
policy is supposed to work.<br>
<div class=3D"im"><br>
&gt; According to your advice and XFS document, I tried to set the AG size =
to<br>
&gt; 64GB,<br>
<br>
</div>What advice might that be? I don&#39;t thikn I&#39;ve ever recommende=
d<br>
anyone use 96*64GB AGs. Unless you have 96 allocations all occurring<br>
at the same time (very rare, in my experience), there is no need for<br>
some many AGs.<br>
<div><div class=3D"h5"><br>
<br>
&gt; for avoiding the allocator contention and keeping all files in single<=
br>
&gt; directory<br>
&gt; fall in the same AG, but it didn&#39;t work. The files are still in di=
fferent<br>
&gt; AGs.<br>
&gt; My xfs_info:<br>
&gt; meta-data=3D/dev/sdc2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
isize=3D256 =C2=A0 =C2=A0agcount=3D96, agsize=3D16777216<br>
&gt; blks<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 attr=3D0<=
br>
&gt; data =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D1610116329, im=
axpct=3D25<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sunit=3D0 =C2=A0 =C2=A0 =C2=
=A0swidth=3D0 blks, unwritten=3D1<br>
&gt; naming =C2=A0 =3Dversion 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0bsize=3D4096<br>
&gt; log =C2=A0 =C2=A0 =C2=A0=3Dinternal log =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 bsize=3D4096 =C2=A0 blocks=3D32768, version=3D1<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 sunit=3D0=
 blks, lazy-count=3D0<br>
&gt; realtime =3Dnone =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 extsz=3D4096 =C2=A0 blocks=3D0, rtextents=3D0<br>
&gt;<br>
&gt; The files:<br>
&gt; $ for i in `seq 1 10` ; do sudo xfs_io -f -c &quot;truncate 512m&quot;=
 -c &quot;resvsp 0<br>
&gt; 512m&quot; foo.$i ; done<br>
&gt; $ sudo xfs_bmap -vp *| grep &quot; 0:&quot;<br>
&gt; =C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A02147483712..2148532287 16 (=
64..1048639) =C2=A0 =C2=A01048576<br>
&gt; 10000<br>
&gt; =C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A03355443264..3356491839 25 (=
64..1048639) =C2=A0 =C2=A01048576<br>
&gt; 10000<br>
&gt; =C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A02281701440..2282750015 17 (=
64..1048639) =C2=A0 =C2=A01048576<br>
&gt; 10000<br>
&gt; =C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A02415919168..2416967743 18 (=
64..1048639) =C2=A0 =C2=A01048576<br>
&gt; 10000<br>
&gt; =C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A02550136896..2551185471 19 (=
64..1048639) =C2=A0 =C2=A01048576<br>
&gt; 10000<br>
&gt; =C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A02684354624..2685403199 20 (=
64..1048639) =C2=A0 =C2=A01048576<br>
&gt; 10000<br>
&gt; =C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A02818572352..2819620927 21 (=
64..1048639) =C2=A0 =C2=A01048576<br>
&gt; 10000<br>
&gt; =C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A02952790080..2953838655 22 (=
64..1048639) =C2=A0 =C2=A01048576<br>
&gt; 10000<br>
&gt; =C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A03087007808..3088056383 23 (=
64..1048639) =C2=A0 =C2=A01048576<br>
&gt; 10000<br>
&gt; =C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A03221225536..3222274111 24 (=
64..1048639) =C2=A0 =C2=A01048576<br>
&gt; 10000<br>
<br>
</div></div>That&#39;s inode32 allocator behaviour (rotoring each new alloc=
ation<br>
across a different AG). Mount with inode64 - it&#39;s the default in the<br=
>
latest kernels - and it will behave as I demonstrated.<br>
<div class=3D""><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div></div>

--0016e6db7c6fa94b3604ce0a5d22--


--===============1270939195628955567==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1270939195628955567==--
