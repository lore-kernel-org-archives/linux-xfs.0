Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8LFnwUV227431 for <xfs@oss.sgi.com>; Fri, 21 Sep 2012 10:49:58 -0500
Received: from mail-qa0-f46.google.com (mail-qa0-f46.google.com
	[209.85.216.46]) by cuda.sgi.com with ESMTP id 3rZUpwdmtgkQe4Ak
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 21 Sep 2012 08:51:10 -0700 (PDT)
Received: by qaas11 with SMTP id s11so1604321qaa.5
	for <xfs@oss.sgi.com>; Fri, 21 Sep 2012 08:51:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <505BF45D.5050909@sandeen.net>
References: <CAHt31_9K_vrzoqwSVsz-6VNVmMUzMyGCFEZfviRV-xPcUqv8-w@mail.gmail.com>
	<505BF45D.5050909@sandeen.net>
Date: Fri, 21 Sep 2012 09:51:10 -0600
Message-ID: <CAHt31__x6VbmO-8GJvPesKEXXmRGEfYt-TeRk-9GFJt1HjPPvA@mail.gmail.com>
Subject: Re: xfs_repair deleting realtime files.
From: Anand Tiwari <tiwarikanand@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1125842329911518211=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============1125842329911518211==
Content-Type: multipart/alternative; boundary=00248c6a66c26e4d3a04ca38356e

--00248c6a66c26e4d3a04ca38356e
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Sep 20, 2012 at 11:00 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 9/20/12 7:40 PM, Anand Tiwari wrote:
> > Hi All,
> >
> > I have been looking into an issue with xfs_repair with realtime sub
> volume. some times while running xfs_repair I see following errors
> >
> > ----------------------------
> > data fork in rt inode 134 claims used rt block 19607
> > bad data fork in inode 134
> > would have cleared inode 134
> > data fork in rt inode 135 claims used rt block 29607
> > bad data fork in inode 135
> > would have cleared inode 135
> >         - agno = 1
> >         - agno = 2
> >         - agno = 3
> >         - process newly discovered inodes...
> > Phase 4 - check for duplicate blocks...
> >         - setting up duplicate extent list...
> >         - check for inodes claiming duplicate blocks...
> >         - agno = 0
> >         - agno = 1
> >         - agno = 2
> >         - agno = 3
> > entry "test-011" in shortform directory 128 references free inode 134
> > would have junked entry "test-011" in directory inode 128
> > entry "test-0" in shortform directory 128 references free inode 135
> > would have junked entry "test-0" in directory inode 128
> > data fork in rt ino 134 claims dup rt extent,off - 0, start - 7942144,
> count 2097000
> > bad data fork in inode 134
> > would have cleared inode 134
> > data fork in rt ino 135 claims dup rt extent,off - 0, start - 13062144,
> count 2097000
> > bad data fork in inode 135
> > would have cleared inode 135
> > No modify flag set, skipping phase 5
> > ------------------------
> >
> > Here is the bmap for both inodes.
> >
> > xfs_db> inode 135
> > xfs_db> bmap
> > data offset 0 startblock 13062144 (12/479232) count 2097000 flag 0
> > data offset 2097000 startblock 15159144 (14/479080) count 2097000 flag 0
> > data offset 4194000 startblock 17256144 (16/478928) count 2097000 flag 0
> > data offset 6291000 startblock 19353144 (18/478776) count 2097000 flag 0
> > data offset 8388000 startblock 21450144 (20/478624) count 2097000 flag 0
> > data offset 10485000 startblock 23547144 (22/478472) count 2097000 flag 0
> > data offset 12582000 startblock 25644144 (24/478320) count 2097000 flag 0
> > data offset 14679000 startblock 27741144 (26/478168) count 2097000 flag 0
> > data offset 16776000 startblock 29838144 (28/478016) count 2097000 flag 0
> > data offset 18873000 startblock 31935144 (30/477864) count 1607000 flag 0
> > xfs_db> inode 134
> > xfs_db> bmap
> > data offset 0 startblock 7942144 (7/602112) count 2097000 flag 0
> > data offset 2097000 startblock 10039144 (9/601960) count 2097000 flag 0
> > data offset 4194000 startblock 12136144 (11/601808) count 926000 flag 0
>
> It's been a while since I thought about realtime, but -
>
> That all seems fine, I don't see anything overlapping there, they are
> all perfectly adjacent, though of interesting size.
>
> >
> > by looking into xfs_repair code, it looks like repair does not handle
> > a case where we have more than one extent in a real-time extent.
> > following is code from repair/dinode.c: process_rt_rec
>
> "more than one extent in a real-time extent?"  I'm not sure what that
> means.
>
> Every extent above is length 2097000 blocks, and they are adjacent.
> But you say your realtime extent size is 512 blocks ... which doesn't go
> into 2097000 evenly.   So that's odd, at least.
>
>
well, lets look at first extent
> data offset 0 startblock 13062144 (12/479232) count 2097000 flag 0
> data offset 2097000 startblock 15159144 (14/479080) count 2097000 flag 0
startblock is aligned and rtext is 25512,  since the blockcount is not
multiple of 512, last realtime extent ( 25512 + 4095) is partially used,
360 blks
second extent start from realtime extent 29607 (ie 25512 + 4095).  so, yes,
extents are not overlapping, but 29607 realtime extent is shared by two
extents.
Now once xfs_repair detects this case in phase 2, it bails out and clears
that inode. I think  search for duplicate extent is done in phase 4, but
inode is marked already.


Can you provide your xfs_info output for this fs?
> Or maybe better yet an xfs_metadump image.
>
>
I will do it soon.  The other  thing I noticed is if I try to delete this
file (inode 135),  I get following assertion failure.

[75669.291000] Assertion failed: prev.br_state == XFS_EXT_NORM, file:
fs/xfs/xfs_bmap.c, line:
5187

[75669.300000] [<8024dc44>]
assfail+0x28/0x2c

[75669.300000] [<801d8864>]
xfs_bunmapi+0x1288/0x14e4

[75669.300000] [<8020aff4>]
xfs_itruncate_finish+0x344/0x738

[75669.300000] [<802363b0>]
xfs_inactive+0x4a8/0x51c

[75669.300000] [<80109124>]
evict+0x28/0xd0

[75669.300000] [<80109c14>]
iput+0x19c/0x2d8

[75669.300000] [<800fe58c>]
do_unlinkat+0x10c/0x19c

[75669.300000] [<80011b7c>] stack_done+0x20/0x40



> > -----
> >      for (b = irec->br_startblock; b < irec->br_startblock +
> >                         irec->br_blockcount; b += mp->m_sb.sb_rextsize)
>  {
> >                 ext = (xfs_drtbno_t) b / mp->m_sb.sb_rextsize;
> >                 pwe = xfs_sb_version_hasextflgbit(&mp->m_sb) &&
> >                                 irec->br_state == XFS_EXT_UNWRITTEN &&
> >                                 (b % mp->m_sb.sb_rextsize != 0);
> > -----
> >
> > In my case rextsize is 512 (512 * 4096 = 2mb). So we have multiple
> > extents (written extents to be precise, thanks dchinner for that),
> > value of "ext" will be same for all of them and xfs_repair does not
> > like it. thus the error message ""data fork in rt inode XX claims
> > used rt block XX".
>
> "ext" should not be the same for all of them; ext is the realtime extent
> number in the fs, based on the physical start, br_startblock,
> divided by the rt extent size.  There shouldn't be duplicate values
> of "ext" based on the bmaps above.
>
> The error comes from search_rt_dup_extent() which looks for overlaps
> elsewhere in the fs...
>
> If you can provide a metadump of the fs it might be easier to see what's
> going on.
>
> -Eric
>
> > If I ignore this failure condition, xfs_repairs seems to be happy.
> > (FYI: this file-system is cleanly umounted) But in my opinion, its
> > not good as these multiple extents can overlap too.
>
> > Should we be using XR_E_MULT to flag and keep track of duplicated
> > real-time extents. (maybe use the present API for adding/detecting
> > duplicate extents)
> >
> > I am open of suggestion or comments on how to fix this.
> >
> > xfs_repair version is 3.1.8 and kernel 2.6.37.
> >
> > thanks,
> > Anand
> >
> >
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> >
>
>

--00248c6a66c26e4d3a04ca38356e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Thu, Sep 20, 2012 at 11:00 PM, Eric S=
andeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=
=3D"_blank">sandeen@sandeen.net</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">
<div class=3D"HOEnZb"><div class=3D"h5">On 9/20/12 7:40 PM, Anand Tiwari wr=
ote:<br>
&gt; Hi All,<br>
&gt;<br>
&gt; I have been looking into an issue with xfs_repair with realtime sub vo=
lume. some times while running xfs_repair I see following errors<br>
&gt;<br>
&gt; ----------------------------<br>
&gt; data fork in rt inode 134 claims used rt block 19607<br>
&gt; bad data fork in inode 134<br>
&gt; would have cleared inode 134<br>
&gt; data fork in rt inode 135 claims used rt block 29607<br>
&gt; bad data fork in inode 135<br>
&gt; would have cleared inode 135<br>
&gt; =A0 =A0 =A0 =A0 - agno =3D 1<br>
&gt; =A0 =A0 =A0 =A0 - agno =3D 2<br>
&gt; =A0 =A0 =A0 =A0 - agno =3D 3<br>
&gt; =A0 =A0 =A0 =A0 - process newly discovered inodes...<br>
&gt; Phase 4 - check for duplicate blocks...<br>
&gt; =A0 =A0 =A0 =A0 - setting up duplicate extent list...<br>
&gt; =A0 =A0 =A0 =A0 - check for inodes claiming duplicate blocks...<br>
&gt; =A0 =A0 =A0 =A0 - agno =3D 0<br>
&gt; =A0 =A0 =A0 =A0 - agno =3D 1<br>
&gt; =A0 =A0 =A0 =A0 - agno =3D 2<br>
&gt; =A0 =A0 =A0 =A0 - agno =3D 3<br>
&gt; entry &quot;test-011&quot; in shortform directory 128 references free =
inode 134<br>
&gt; would have junked entry &quot;test-011&quot; in directory inode 128<br=
>
&gt; entry &quot;test-0&quot; in shortform directory 128 references free in=
ode 135<br>
&gt; would have junked entry &quot;test-0&quot; in directory inode 128<br>
&gt; data fork in rt ino 134 claims dup rt extent,off - 0, start - 7942144,=
 count 2097000<br>
&gt; bad data fork in inode 134<br>
&gt; would have cleared inode 134<br>
&gt; data fork in rt ino 135 claims dup rt extent,off - 0, start - 13062144=
, count 2097000<br>
&gt; bad data fork in inode 135<br>
&gt; would have cleared inode 135<br>
&gt; No modify flag set, skipping phase 5<br>
&gt; ------------------------<br>
&gt;<br>
&gt; Here is the bmap for both inodes.<br>
&gt;<br>
&gt; xfs_db&gt; inode 135<br>
&gt; xfs_db&gt; bmap<br>
&gt; data offset 0 startblock 13062144 (12/479232) count 2097000 flag 0<br>
&gt; data offset 2097000 startblock 15159144 (14/479080) count 2097000 flag=
 0<br>
&gt; data offset 4194000 startblock 17256144 (16/478928) count 2097000 flag=
 0<br>
&gt; data offset 6291000 startblock 19353144 (18/478776) count 2097000 flag=
 0<br>
&gt; data offset 8388000 startblock 21450144 (20/478624) count 2097000 flag=
 0<br>
&gt; data offset 10485000 startblock 23547144 (22/478472) count 2097000 fla=
g 0<br>
&gt; data offset 12582000 startblock 25644144 (24/478320) count 2097000 fla=
g 0<br>
&gt; data offset 14679000 startblock 27741144 (26/478168) count 2097000 fla=
g 0<br>
&gt; data offset 16776000 startblock 29838144 (28/478016) count 2097000 fla=
g 0<br>
&gt; data offset 18873000 startblock 31935144 (30/477864) count 1607000 fla=
g 0<br>
&gt; xfs_db&gt; inode 134<br>
&gt; xfs_db&gt; bmap<br>
&gt; data offset 0 startblock 7942144 (7/602112) count 2097000 flag 0<br>
&gt; data offset 2097000 startblock 10039144 (9/601960) count 2097000 flag =
0<br>
&gt; data offset 4194000 startblock 12136144 (11/601808) count 926000 flag =
0<br>
<br>
</div></div>It&#39;s been a while since I thought about realtime, but -<br>
<br>
That all seems fine, I don&#39;t see anything overlapping there, they are<b=
r>
all perfectly adjacent, though of interesting size.<br>
<div class=3D"im"><br>
&gt;<br>
&gt; by looking into xfs_repair code, it looks like repair does not handle<=
br>
&gt; a case where we have more than one extent in a real-time extent.<br>
&gt; following is code from repair/dinode.c: process_rt_rec<br>
<br>
</div>&quot;more than one extent in a real-time extent?&quot; =A0I&#39;m no=
t sure what that means.<br>
<br>
Every extent above is length 2097000 blocks, and they are adjacent.<br>
But you say your realtime extent size is 512 blocks ... which doesn&#39;t g=
o<br>
into 2097000 evenly. =A0 So that&#39;s odd, at least.<br>
<br></blockquote><div><br>well, lets look at first extent<br>&gt; data offs=
et 0 startblock 13062144 (12/479232) count 2097000 flag 0<br>
&gt; data offset 2097000 startblock 15159144 (14/479080) count 2097000 flag=
 0<br>startblock is aligned and rtext is 25512,=A0 since the blockcount is =
not multiple of 512, last realtime extent ( 25512 + 4095) is partially used=
, 360 blks<br>
second extent start from realtime extent 29607 (ie 25512 + 4095).=A0 so, ye=
s, extents are not overlapping, but 29607 realtime extent is shared by two =
extents.<br>Now once xfs_repair detects this case in phase 2, it bails out =
and clears that inode. I think=A0 search for duplicate extent is done in ph=
ase 4, but inode is marked already. <br>
<br><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;=
border-left:1px #ccc solid;padding-left:1ex">
Can you provide your xfs_info output for this fs?<br>
Or maybe better yet an xfs_metadump image.<br>
<div class=3D"im"><br></div></blockquote><div><br>I will do it soon.=A0 The=
 other=A0 thing I noticed is if I try to delete this file (inode 135),=A0 I=
 get following assertion failure. <br><br>[75669.291000] Assertion failed: =
prev.br_state =3D=3D XFS_EXT_NORM, file: fs/xfs/xfs_bmap.c, line: 5187=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 <br>
[75669.300000] [&lt;8024dc44&gt;] assfail+0x28/0x2c=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 <br>[756=
69.300000] [&lt;801d8864&gt;] xfs_bunmapi+0x1288/0x14e4=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 <br>
[75669.300000] [&lt;8020aff4&gt;] xfs_itruncate_finish+0x344/0x738=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 <br>[75669.300000] [&lt;802363b0&gt;] =
xfs_inactive+0x4a8/0x51c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 <br>
[75669.300000] [&lt;80109124&gt;] evict+0x28/0xd0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 <b=
r>[75669.300000] [&lt;80109c14&gt;] iput+0x19c/0x2d8=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 <b=
r>
[75669.300000] [&lt;800fe58c&gt;] do_unlinkat+0x10c/0x19c=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 <br>[75669.300000] [=
&lt;80011b7c&gt;] stack_done+0x20/0x40=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 <br>
<br>=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;b=
order-left:1px #ccc solid;padding-left:1ex"><div class=3D"im">
&gt; -----<br>
&gt; =A0 =A0 =A0for (b =3D irec-&gt;br_startblock; b &lt; irec-&gt;br_start=
block +<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 irec-&gt;br_blockcount=
; b +=3D mp-&gt;m_sb.sb_rextsize) =A0{<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext =3D (xfs_drtbno_t) b / mp-&gt;m_sb=
.sb_rextsize;<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pwe =3D xfs_sb_version_hasextflgbit(&a=
mp;mp-&gt;m_sb) &amp;&amp;<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 irec-&=
gt;br_state =3D=3D XFS_EXT_UNWRITTEN &amp;&amp;<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (b % m=
p-&gt;m_sb.sb_rextsize !=3D 0);<br>
&gt; -----<br>
&gt;<br>
&gt; In my case rextsize is 512 (512 * 4096 =3D 2mb). So we have multiple<b=
r>
&gt; extents (written extents to be precise, thanks dchinner for that),<br>
&gt; value of &quot;ext&quot; will be same for all of them and xfs_repair d=
oes not<br>
&gt; like it. thus the error message &quot;&quot;data fork in rt inode XX c=
laims<br>
&gt; used rt block XX&quot;.<br>
<br>
</div>&quot;ext&quot; should not be the same for all of them; ext is the re=
altime extent<br>
number in the fs, based on the physical start, br_startblock,<br>
divided by the rt extent size. =A0There shouldn&#39;t be duplicate values<b=
r>
of &quot;ext&quot; based on the bmaps above.<br>
<br>
The error comes from search_rt_dup_extent() which looks for overlaps<br>
elsewhere in the fs...<br>
<br>
If you can provide a metadump of the fs it might be easier to see what&#39;=
s going on.<br>
<br>
-Eric<br>
<div class=3D"im"><br>
&gt; If I ignore this failure condition, xfs_repairs seems to be happy.<br>
&gt; (FYI: this file-system is cleanly umounted) But in my opinion, its<br>
&gt; not good as these multiple extents can overlap too.<br>
<br>
&gt; Should we be using XR_E_MULT to flag and keep track of duplicated<br>
&gt; real-time extents. (maybe use the present API for adding/detecting<br>
&gt; duplicate extents)<br>
&gt;<br>
&gt; I am open of suggestion or comments on how to fix this.<br>
&gt;<br>
&gt; xfs_repair version is 3.1.8 and kernel 2.6.37.<br>
&gt;<br>
&gt; thanks,<br>
&gt; Anand<br>
&gt;<br>
&gt;<br>
&gt;<br>
</div>&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
&gt;<br>
<br>
</blockquote></div><br>

--00248c6a66c26e4d3a04ca38356e--


--===============1125842329911518211==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1125842329911518211==--
