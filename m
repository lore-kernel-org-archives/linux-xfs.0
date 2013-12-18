Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E4C287F3F
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 17:29:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47502AC005
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 15:29:59 -0800 (PST)
Received: from mail-ve0-f182.google.com (mail-ve0-f182.google.com
	[209.85.128.182]) by cuda.sgi.com with ESMTP id
	i2PFR7YbWO86g1Z5 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Dec 2013 15:29:57 -0800 (PST)
Received: by mail-ve0-f182.google.com with SMTP id jy13so225615veb.13
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 15:29:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131218213434.GK31386@dastard>
References: <CAG97raf61XGnTakrYjcfv9cjM6CTVdEEB3wQK+wOBvpowWO3Cw@mail.gmail.com>
	<20131216000141.GU31386@dastard>
	<CAG97radg3xd8-G2qChh2BOfH8R6N4kWH3qn3ivukxrkFVrt=rA@mail.gmail.com>
	<20131216030537.GX31386@dastard>
	<CAG97racd-UhUqhVLcsbjqZt51iTEaHKaQNMkvQFnznH8X8wOUQ@mail.gmail.com>
	<20131216125402.GB10988@dastard>
	<CAG97raeP-0QEhhYjDX_DDxzS3TN_brRSU6G+j-+V3KEuJ7Ym6Q@mail.gmail.com>
	<CAG97raf7Na5UwzREJ_C9nYJ64r7PPwkhp_qcPiGVnKqu+ujAgw@mail.gmail.com>
	<20131218213434.GK31386@dastard>
Date: Wed, 18 Dec 2013 21:29:56 -0200
Message-ID: <CAG97racrjJUJAepGZh3WK52izzudM_D-zEgs3j5SThwBzyVUCg@mail.gmail.com>
Subject: Re: XFS_REPAIR on LVM partition
From: Rafael Weingartner <rafaelweingartner@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6186770566126736102=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============6186770566126736102==
Content-Type: multipart/alternative; boundary=089e0115f0443d0c4e04edd76c44

--089e0115f0443d0c4e04edd76c44
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

>
> [ cc'd the XFS list again - please keep problem triage on the public
> lists so that more than one person can help you. ]


My bad, I am sorry, sometimes I forget to press the reply to all button.

It's still possible to recover, but more info is needed first.
> Can you get xfs_db to dump the primary and a couple of secondary
> superblocks?


I am glad to hear that, I have actually already extracted the files that I
needed using UFS explorer, but I still would like to restore the filesystem
if it is possible.

Output of "xfs_db -c "sb 0" -c p -c "sb 2" -c p -c "sb 7" -c p <dev>"

xfs_db: cannot init perag data (117)
> magicnum =3D 0x58465342
> blocksize =3D 4096
> dblocks =3D 131072000
> rblocks =3D 0
> rextents =3D 0
> uuid =3D 430d1253-0d52-401b-b6bd-42e23bb56bc3
> logstart =3D 67108868
> rootino =3D 128
> rbmino =3D 129
> rsumino =3D 130
> rextsize =3D 1
> agblocks =3D 32768000
> agcount =3D 4
> rbmblocks =3D 0
> logblocks =3D 64000
> versionnum =3D 0xb4a4
> sectsize =3D 512
> inodesize =3D 256
> inopblock =3D 16
> fname =3D "\000\000\000\000\000\000\000\000\000\000\000\000"
> blocklog =3D 12
> sectlog =3D 9
> inodelog =3D 8
> inopblog =3D 4
> agblklog =3D 25
> rextslog =3D 0
> inprogress =3D 0
> imax_pct =3D 25
> icount =3D 256
> ifree =3D 200
> fdblocks =3D 127617831
> frextents =3D 0
> uquotino =3D 0
> gquotino =3D 0
> qflags =3D 0
> flags =3D 0
> shared_vn =3D 0
> inoalignmt =3D 2
> unit =3D 0
> width =3D 0
> dirblklog =3D 0
> logsectlog =3D 0
> logsectsize =3D 0
> logsunit =3D 1
> features2 =3D 0xa
> bad_features2 =3D 0xa
> magicnum =3D 0x58465350
> blocksize =3D 4096
> dblocks =3D 7566328849834176030
> rblocks =3D 70481084416
> rextents =3D 5638878729879945216
> uuid =3D 5de3e560-0f52-401b-854a-acfc3bb56bfb
> logstart =3D 7566047375040578052
> rootino =3D 18374686479671613439
> rbmino =3D 18446744071377518559
> rsumino =3D null
> rextsize =3D 1
> agblocks =3D 32768000
> agcount =3D 4
> rbmblocks =3D 1073782799
> logblocks =3D 64000
> versionnum =3D 0xa4a4
> sectsize =3D 512
> inodesize =3D 267
> inopblock =3D 16
> fname =3D "3\367\356\036\000\000\000`i\000\000\000"
> blocklog =3D 66
> sectlog =3D 64
> inodelog =3D 190
> inopblog =3D 133
> agblklog =3D 27
> rextslog =3D 3
> inprogress =3D 1
> imax_pct =3D 25
> icount =3D 0
> ifree =3D 72057594037927936
> fdblocks =3D 131054064
> frextents =3D 5891388165771235349
> uquotino =3D 13746228866238942976
> gquotino =3D 13746228866238942976
> qflags =3D 0xd0de
> flags =3D 0x17
> shared_vn =3D 97
> inoalignmt =3D 33554434
> unit =3D 418391552
> width =3D 0
> dirblklog =3D 0
> logsectlog =3D 0
> logsectsize =3D 0
> logsunit =3D 506003457
> features2 =3D 0x8
> bad_features2 =3D 0xa
> bad allocation group number 7
> magicnum =3D 0x58465350
> blocksize =3D 4096
> dblocks =3D 7566328849834176030
> rblocks =3D 70481084416
> rextents =3D 5638878729879945216
> uuid =3D 5de3e560-0f52-401b-854a-acfc3bb56bfb
> logstart =3D 7566047375040578052
> rootino =3D 18374686479671613439
> rbmino =3D 18446744071377518559
> rsumino =3D null
> rextsize =3D 1
> agblocks =3D 32768000
> agcount =3D 4
> rbmblocks =3D 1073782799
> logblocks =3D 64000
> versionnum =3D 0xa4a4
> sectsize =3D 512
> inodesize =3D 267
> inopblock =3D 16
> fname =3D "3\367\356\036\000\000\000`i\000\000\000"
> blocklog =3D 66
> sectlog =3D 64
> inodelog =3D 190
> inopblog =3D 133
> agblklog =3D 27
> rextslog =3D 3
> inprogress =3D 1
> imax_pct =3D 25
> icount =3D 0
> ifree =3D 72057594037927936
> fdblocks =3D 131054064
> frextents =3D 5891388165771235349
> uquotino =3D 13746228866238942976
> gquotino =3D 13746228866238942976
> qflags =3D 0xd0de
> flags =3D 0x17
> shared_vn =3D 97
> inoalignmt =3D 33554434
> unit =3D 418391552
> width =3D 0
> dirblklog =3D 0
> logsectlog =3D 0
> logsectsize =3D 0
> logsunit =3D 506003457
> features2 =3D 0x8
> bad_features2 =3D 0xa




On Wed, Dec 18, 2013 at 7:34 PM, Dave Chinner <david@fromorbit.com> wrote:

> [ cc'd the XFS list again - please keep problem triage on the public
> lists so that more than one person can help you. ]
>
> On Mon, Dec 16, 2013 at 02:53:03PM -0200, Rafael Weingartner wrote:
> > Today, I let the command xfs_repair /dev/... ran till it finished, I go=
t
> > the following messages:
> >
> > Phase 1 - Find and verify superblock ....
> > > Could not verify primary superblock - not enough secondary superblock=
s
> > > with matching geometry!!
>
> The primary superblock dump looked valid, but it it couldn't find
> matching secondary superblocks from the contents of the primary that
> it found.
>
> > > attempting to find a secondary superblock.....
> > > ...
> > > ..
> > > ...
> > > ...
> > > found candidate secondary superblock....
> > > unable to verify superblock, continuing....
>
> And it found blocks with the correct superbloc magic numbers, but
> they don't match the primary superblock that was found.
>
> > > found candidate secondary superblock....
> > > unable to verify superblock, continuing...
> > > ...
> > > ...
> > >
> .........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
........................Sorry,
> > > could not find valid secondary superblock
> > > Exiting now.
> >
> >
> > Should I upgrade the xfsprogs and try to run the xfs_repair again?
> > Or does that message mean that there is no way of recovering the
> filesystem?
>
> It's still possible to recover, but more info is needed first.
> Can you get xfs_db to dump the primary and a couple of secondary
> superblocks?
>
> # xfs_db -c "sb 0" -c p -c "sb 2" -c p -c "sb 7" -c p <dev>
>
> And post the output?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>



--=20
Rafael Weing=E4rtner

--089e0115f0443d0c4e04edd76c44
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px =
0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-l=
eft-style:solid;padding-left:1ex"><span style=3D"color:rgb(0,0,0);font-fami=
ly:arial,sans-serif;font-size:13px">[ cc&#39;d the XFS list again - please =
keep problem triage on the public</span><br style=3D"color:rgb(0,0,0);font-=
family:arial,sans-serif;font-size:13px">
<span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif;font-size:13px=
">lists so that more than one person can help you. ]</span></blockquote><di=
v><br></div><div>My bad, I am sorry, sometimes I forget to press the reply =
to all button.=A0</div>
<div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-lef=
t-style:solid;padding-left:1ex"><span style=3D"color:rgb(0,0,0);font-family=
:arial,sans-serif;font-size:13px">It&#39;s still possible to recover, but m=
ore info is needed first.<br>
</span><span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif;font-si=
ze:13px">Can you get xfs_db to dump the primary and a couple of secondary<b=
r></span><span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif;font-=
size:13px">superblocks?</span></blockquote>
<div><br></div><div>I am glad to hear that, I have actually already extract=
ed the files that I needed using=A0<span style=3D"background-color:rgb(249,=
249,249);color:rgb(0,0,0);font-family:verdana,arial,sans-serif;font-size:11=
px">UFS explorer, but I still would like to restore the filesystem if it is=
 possible.</span>=A0</div>
<div><br></div><div>Output of &quot;<span style=3D"color:rgb(0,0,0);font-fa=
mily:arial,sans-serif;font-size:13px">xfs_db -c &quot;sb 0&quot; -c p -c &q=
uot;sb 2&quot; -c p -c &quot;sb 7&quot; -c p &lt;dev&gt;&quot;</span></div>
<div><span style=3D"color:rgb(0,0,0);font-family:arial,sans-serif;font-size=
:13px"><br></span></div><div><span style=3D"color:rgb(0,0,0);font-family:ar=
ial,sans-serif;font-size:13px"><blockquote class=3D"gmail_quote" style=3D"m=
argin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204=
,204);border-left-style:solid;padding-left:1ex">
xfs_db: cannot init perag data (117)<br>magicnum =3D 0x58465342<br>blocksiz=
e =3D 4096<br>dblocks =3D 131072000<br>rblocks =3D 0<br>rextents =3D 0<br>u=
uid =3D 430d1253-0d52-401b-b6bd-42e23bb56bc3<br>logstart =3D 67108868<br>ro=
otino =3D 128<br>
rbmino =3D 129<br>rsumino =3D 130<br>rextsize =3D 1<br>agblocks =3D 3276800=
0<br>agcount =3D 4<br>rbmblocks =3D 0<br>logblocks =3D 64000<br>versionnum =
=3D 0xb4a4<br>sectsize =3D 512<br>inodesize =3D 256<br>inopblock =3D 16<br>=
fname =3D &quot;\000\000\000\000\000\000\000\000\000\000\000\000&quot;<br>
blocklog =3D 12<br>sectlog =3D 9<br>inodelog =3D 8<br>inopblog =3D 4<br>agb=
lklog =3D 25<br>rextslog =3D 0<br>inprogress =3D 0<br>imax_pct =3D 25<br>ic=
ount =3D 256<br>ifree =3D 200<br>fdblocks =3D 127617831<br>frextents =3D 0<=
br>uquotino =3D 0<br>gquotino =3D 0<br>
qflags =3D 0<br>flags =3D 0<br>shared_vn =3D 0<br>inoalignmt =3D 2<br>unit =
=3D 0<br>width =3D 0<br>dirblklog =3D 0<br>logsectlog =3D 0<br>logsectsize =
=3D 0<br>logsunit =3D 1<br>features2 =3D 0xa<br>bad_features2 =3D 0xa<br>ma=
gicnum =3D 0x58465350<br>
blocksize =3D 4096<br>dblocks =3D 7566328849834176030<br>rblocks =3D 704810=
84416<br>rextents =3D 5638878729879945216<br>uuid =3D 5de3e560-0f52-401b-85=
4a-acfc3bb56bfb<br>logstart =3D 7566047375040578052<br>rootino =3D 18374686=
479671613439<br>
rbmino =3D 18446744071377518559<br>rsumino =3D null<br>rextsize =3D 1<br>ag=
blocks =3D 32768000<br>agcount =3D 4<br>rbmblocks =3D 1073782799<br>logbloc=
ks =3D 64000<br>versionnum =3D 0xa4a4<br>sectsize =3D 512<br>inodesize =3D =
267<br>inopblock =3D 16<br>
fname =3D &quot;3\367\356\036\000\000\000`i\000\000\000&quot;<br>blocklog =
=3D 66<br>sectlog =3D 64<br>inodelog =3D 190<br>inopblog =3D 133<br>agblklo=
g =3D 27<br>rextslog =3D 3<br>inprogress =3D 1<br>imax_pct =3D 25<br>icount=
 =3D 0<br>ifree =3D 72057594037927936<br>
fdblocks =3D 131054064<br>frextents =3D 5891388165771235349<br>uquotino =3D=
 13746228866238942976<br>gquotino =3D 13746228866238942976<br>qflags =3D 0x=
d0de<br>flags =3D 0x17<br>shared_vn =3D 97<br>inoalignmt =3D 33554434<br>un=
it =3D 418391552<br>
width =3D 0<br>dirblklog =3D 0<br>logsectlog =3D 0<br>logsectsize =3D 0<br>=
logsunit =3D 506003457<br>features2 =3D 0x8<br>bad_features2 =3D 0xa<br>bad=
 allocation group number 7<br>magicnum =3D 0x58465350<br>blocksize =3D 4096=
<br>dblocks =3D 7566328849834176030<br>
rblocks =3D 70481084416<br>rextents =3D 5638878729879945216<br>uuid =3D 5de=
3e560-0f52-401b-854a-acfc3bb56bfb<br>logstart =3D 7566047375040578052<br>ro=
otino =3D 18374686479671613439<br>rbmino =3D 18446744071377518559<br>rsumin=
o =3D null<br>
rextsize =3D 1<br>agblocks =3D 32768000<br>agcount =3D 4<br>rbmblocks =3D 1=
073782799<br>logblocks =3D 64000<br>versionnum =3D 0xa4a4<br>sectsize =3D 5=
12<br>inodesize =3D 267<br>inopblock =3D 16<br>fname =3D &quot;3\367\356\03=
6\000\000\000`i\000\000\000&quot;<br>
blocklog =3D 66<br>sectlog =3D 64<br>inodelog =3D 190<br>inopblog =3D 133<b=
r>agblklog =3D 27<br>rextslog =3D 3<br>inprogress =3D 1<br>imax_pct =3D 25<=
br>icount =3D 0<br>ifree =3D 72057594037927936<br>fdblocks =3D 131054064<br=
>frextents =3D 5891388165771235349<br>
uquotino =3D 13746228866238942976<br>gquotino =3D 13746228866238942976<br>q=
flags =3D 0xd0de<br>flags =3D 0x17<br>shared_vn =3D 97<br>inoalignmt =3D 33=
554434<br>unit =3D 418391552<br>width =3D 0<br>dirblklog =3D 0<br>logsectlo=
g =3D 0<br>logsectsize =3D 0<br>
logsunit =3D 506003457<br>features2 =3D 0x8<br>bad_features2 =3D 0xa</block=
quote></span></div><div><br></div></div><div class=3D"gmail_extra"><br><br>=
<div class=3D"gmail_quote">On Wed, Dec 18, 2013 at 7:34 PM, Dave Chinner <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank=
">david@fromorbit.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">[ cc&#39;d the XFS list again - please keep =
problem triage on the public<br>
lists so that more than one person can help you. ]<br>
<div class=3D"im"><br>
On Mon, Dec 16, 2013 at 02:53:03PM -0200, Rafael Weingartner wrote:<br>
&gt; Today, I let the command xfs_repair /dev/... ran till it finished, I g=
ot<br>
&gt; the following messages:<br>
&gt;<br>
&gt; Phase 1 - Find and verify superblock ....<br>
&gt; &gt; Could not verify primary superblock - not enough secondary superb=
locks<br>
&gt; &gt; with matching geometry!!<br>
<br>
</div>The primary superblock dump looked valid, but it it couldn&#39;t find=
<br>
matching secondary superblocks from the contents of the primary that<br>
it found.<br>
<div class=3D"im"><br>
&gt; &gt; attempting to find a secondary superblock.....<br>
&gt; &gt; ...<br>
&gt; &gt; ..<br>
&gt; &gt; ...<br>
&gt; &gt; ...<br>
&gt; &gt; found candidate secondary superblock....<br>
&gt; &gt; unable to verify superblock, continuing....<br>
<br>
</div>And it found blocks with the correct superbloc magic numbers, but<br>
they don&#39;t match the primary superblock that was found.<br>
<div class=3D"im"><br>
&gt; &gt; found candidate secondary superblock....<br>
&gt; &gt; unable to verify superblock, continuing...<br>
&gt; &gt; ...<br>
&gt; &gt; ...<br>
&gt; &gt; .................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
...........................................................................=
................................Sorry,<br>

&gt; &gt; could not find valid secondary superblock<br>
&gt; &gt; Exiting now.<br>
&gt;<br>
&gt;<br>
&gt; Should I upgrade the xfsprogs and try to run the xfs_repair again?<br>
&gt; Or does that message mean that there is no way of recovering the files=
ystem?<br>
<br>
</div>It&#39;s still possible to recover, but more info is needed first.<br=
>
Can you get xfs_db to dump the primary and a couple of secondary<br>
superblocks?<br>
<br>
# xfs_db -c &quot;sb 0&quot; -c p -c &quot;sb 2&quot; -c p -c &quot;sb 7&qu=
ot; -c p &lt;dev&gt;<br>
<br>
And post the output?<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<div dir=3D"ltr">Rafael Weing=E4rtner</div>
</div>

--089e0115f0443d0c4e04edd76c44--


--===============6186770566126736102==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6186770566126736102==--
