Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 54B257F4E
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 04:05:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 42DF38F8033
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 02:05:37 -0700 (PDT)
Received: from mail-la0-f51.google.com (mail-la0-f51.google.com
	[209.85.215.51]) by cuda.sgi.com with ESMTP id HVpFJ7tcUnIDWV6Y
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Aug 2014 02:05:34 -0700 (PDT)
Received: by mail-la0-f51.google.com with SMTP id pn19so12235804lab.24
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 02:05:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140825085616.GD20518@dastard>
References: <CAKEtwsWxZseS8M+O7vSR2FRXr4gjVQ0RDO8ok+jMPWq-8jPEeA@mail.gmail.com>
	<20140825051801.GY26465@dastard>
	<CAKEtwsWWoJ4QK1Od4WUT+hx7iFeX2bKfXk3QF9f2yG6vJ+TgxQ@mail.gmail.com>
	<20140825085616.GD20518@dastard>
Date: Mon, 25 Aug 2014 17:05:33 +0800
Message-ID: <CAKEtwsWWx_hH-Fkx4E23f67Qn1Oq8SYY25NM51=XgrJLnj8jwA@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============7552721042803464716=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============7552721042803464716==
Content-Type: multipart/alternative; boundary=001a11c34b184411fe0501707d35

--001a11c34b184411fe0501707d35
Content-Type: text/plain; charset=UTF-8

Great, thank you.

>From my xfs_db debug, I found I have icount and ifree as follow:

icount = 220619904
ifree = 26202919

So the number of free inode take about 10%, so that's not so few.

So, are you still sure the patches can fix this issue?

Here's the detail xfs_db info:

# mount /dev/sda4 /data1/
# xfs_info /data1/
meta-data=/dev/sda4              isize=256    agcount=4, agsize=142272384
blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=569089536, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=277875, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# umount /dev/sda4
# xfs_db /dev/sda4
xfs_db> sb 0
xfs_db> p
magicnum = 0x58465342
blocksize = 4096
dblocks = 569089536
rblocks = 0
rextents = 0
uuid = 13ecf47b-52cf-4944-9a71-885bddc5e008
logstart = 536870916
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 1
agblocks = 142272384
agcount = 4
rbmblocks = 0
logblocks = 277875
versionnum = 0xb4a4
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 28
rextslog = 0
inprogress = 0
imax_pct = 5
icount = 220619904
ifree = 26202919
fdblocks = 147805479
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 1
features2 = 0xa
bad_features2 = 0xa
xfs_db> sb 1
xfs_db> p
magicnum = 0x58465342
blocksize = 4096
dblocks = 569089536
rblocks = 0
rextents = 0
uuid = 13ecf47b-52cf-4944-9a71-885bddc5e008
logstart = 536870916
rootino = 128
rbmino = null
rsumino = null
rextsize = 1
agblocks = 142272384
agcount = 4
rbmblocks = 0
logblocks = 277875
versionnum = 0xb4a4
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 28
rextslog = 0
inprogress = 1
imax_pct = 5
icount = 0
ifree = 0
fdblocks = 568811645
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 1
features2 = 0xa
bad_features2 = 0xa
xfs_db> sb 2
xfs_db> p
magicnum = 0x58465342
blocksize = 4096
dblocks = 569089536
rblocks = 0
rextents = 0
uuid = 13ecf47b-52cf-4944-9a71-885bddc5e008
logstart = 536870916
rootino = null
rbmino = null
rsumino = null
rextsize = 1
agblocks = 142272384
agcount = 4
rbmblocks = 0
logblocks = 277875
versionnum = 0xb4a4
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 28
rextslog = 0
inprogress = 1
imax_pct = 5
icount = 0
ifree = 0
fdblocks = 568811645
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 1
features2 = 0xa
bad_features2 = 0xa
xfs_db> sb 3
xfs_db> p
magicnum = 0x58465342
blocksize = 4096
dblocks = 569089536
rblocks = 0
rextents = 0
uuid = 13ecf47b-52cf-4944-9a71-885bddc5e008
logstart = 536870916
rootino = 128
rbmino = null
rsumino = null
rextsize = 1
agblocks = 142272384
agcount = 4
rbmblocks = 0
logblocks = 277875
versionnum = 0xb4a4
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 28
rextslog = 0
inprogress = 1
imax_pct = 5
icount = 0
ifree = 0
fdblocks = 568811645
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 1
features2 = 0xa
bad_features2 = 0xa


Thanks
Qiang



2014-08-25 16:56 GMT+08:00 Dave Chinner <david@fromorbit.com>:

> On Mon, Aug 25, 2014 at 04:09:05PM +0800, Zhang Qiang wrote:
> > Thanks for your quick and clear response. Some comments bellow:
> >
> >
> > 2014-08-25 13:18 GMT+08:00 Dave Chinner <david@fromorbit.com>:
> >
> > > On Mon, Aug 25, 2014 at 11:34:34AM +0800, Zhang Qiang wrote:
> > > > Dear XFS community & developers,
> > > >
> > > > I am using CentOS 6.3 and xfs as base file system and use RAID5 as
> > > hardware
> > > > storage.
> > > >
> > > > Detail environment as follow:
> > > >    OS: CentOS 6.3
> > > >    Kernel: kernel-2.6.32-279.el6.x86_64
> > > >    XFS option info(df output): /dev/sdb1 on /data type xfs
> > > > (rw,noatime,nodiratime,nobarrier)
> ....
>
> > > > It's very greatly appreciated if you can give constructive suggestion
> > > about
> > > > this issue, as It's really hard to reproduce from another system and
> it's
> > > > not possible to do upgrade on that online machine.
> > >
> > > You've got very few free inodes, widely distributed in the allocated
> > > inode btree. The CPU time above is the btree search for the next
> > > free inode.
> > >
> > > This is the issue solved by this series of recent commits to add a
> > > new on-disk free inode btree index:
> > >
> > [Qiang] This meas that if I want to fix this issue, I have to apply the
> > following patches and build my own kernel.
>
> Yes. Good luck, even I wouldn't attempt to do that.
>
> And then use xfsprogs 3.2.1, and make a new filesystem that enables
> metadata CRCs and the free inode btree feature.
>
> > As the on-disk structure has been changed, so should I also re-create xfs
> > filesystem again?
>
> Yes, you need to download the latest xfsprogs (3.2.1) to be able to
> make it with the necessary feature bits set.
>
> > is there any user space tools to convert old disk
> > filesystem to new one, and don't need to backup and restore currently
> data?
>
> No, we don't write utilities to mangle on disk formats. dump, mkfs
> and restore is far more reliable than any "in-place conversion" code
> we could write. It will probably be faster, too.
>
> > > Which is of no help to you, however, because it's not available in
> > > any CentOS kernel.
> > >
> > [Qiang] Do you think if it's possible to just backport these patches to
> > kernel  6.2.32 (CentOS 6.3) to fix this issue?
> >
> > Or it's better to backport to 3.10 kernel, used in CentOS 7.0?
>
> You can try, but if you break it you get to keep all the pieces
> yourself. Eventually someone who maintains the RHEL code will do a
> backport that will trickle down to CentOS. If you need it any
> sooner, then you'll need to do it yourself, or upgrade to RHEL
> and ask your support contact for it to be included in RHEL 7.1....
>
> > > There's really not much you can do to avoid the problem once you've
> > > punched random freespace holes in the allocated inode btree. IT
> > > generally doesn't affect many people; those that it does affect are
> > > normally using XFS as an object store indexed by a hard link farm
> > > (e.g. various backup programs do this).
> > >
> > OK, I see.
> >
> > Could you please guide me to reproduce this issue easily? as I have tried
> > to use a 500G xfs partition, and use about 98 % spaces, but still can't
> > reproduce this issue. Is there any easy way from your mind?
>
> Search the archives for the test cases that were used for the patch
> set. There's a performance test case documented in the review
> discussions.
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

--001a11c34b184411fe0501707d35
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Great, thank you.<div><br></div><div>From my xfs_db debug,=
 I found I have icount and ifree as follow:</div><div><br></div><div><div>i=
count =3D 220619904</div><div>ifree =3D 26202919</div><div><br></div><div>S=
o the number of free inode take about 10%, so that&#39;s not so few.</div>
<div><br></div><div>So, are you still sure the patches can fix this issue?<=
/div><div><br></div><div>Here&#39;s the detail xfs_db info:</div><div><br><=
/div><div><div># mount /dev/sda4 /data1/</div><div># xfs_info /data1/</div>
<div>meta-data=3D/dev/sda4 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
isize=3D256 =C2=A0 =C2=A0agcount=3D4, agsize=3D142272384 blks</div><div>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 attr=3D2, projid=
32bit=3D0</div><div>data =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D=
569089536, imaxpct=3D5</div>
<div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sunit=3D0 =C2=A0 =C2=A0 =C2=
=A0swidth=3D0 blks</div><div>naming =C2=A0 =3Dversion 2 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bsize=3D4096 =C2=A0 ascii-ci=3D0</div><div>l=
og =C2=A0 =C2=A0 =C2=A0=3Dinternal =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D277875, version=3D2</div><div>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 sunit=3D0 blk=
s, lazy-count=3D1</div><div>realtime =3Dnone =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 extsz=3D4096 =C2=A0 blocks=3D0, rtextent=
s=3D0</div><div># umount /dev/sda4</div><div># xfs_db /dev/sda4</div><div>x=
fs_db&gt; sb 0</div>
<div>xfs_db&gt; p</div><div>magicnum =3D 0x58465342</div><div>blocksize =3D=
 4096</div><div>dblocks =3D 569089536</div><div>rblocks =3D 0</div><div>rex=
tents =3D 0</div><div>uuid =3D 13ecf47b-52cf-4944-9a71-885bddc5e008</div><d=
iv>logstart =3D 536870916</div>
<div>rootino =3D 128</div><div>rbmino =3D 129</div><div>rsumino =3D 130</di=
v><div>rextsize =3D 1</div><div>agblocks =3D 142272384</div><div>agcount =
=3D 4</div><div>rbmblocks =3D 0</div><div>logblocks =3D 277875</div><div>ve=
rsionnum =3D 0xb4a4</div>
<div>sectsize =3D 512</div><div>inodesize =3D 256</div><div>inopblock =3D 1=
6</div><div>fname =3D &quot;\000\000\000\000\000\000\000\000\000\000\000\00=
0&quot;</div><div>blocklog =3D 12</div><div>sectlog =3D 9</div><div>inodelo=
g =3D 8</div>
<div>inopblog =3D 4</div><div>agblklog =3D 28</div><div>rextslog =3D 0</div=
><div>inprogress =3D 0</div><div>imax_pct =3D 5</div><div>icount =3D 220619=
904</div><div>ifree =3D 26202919</div><div>fdblocks =3D 147805479</div><div=
>frextents =3D 0</div>
<div>uquotino =3D 0</div><div>gquotino =3D 0</div><div>qflags =3D 0</div><d=
iv>flags =3D 0</div><div>shared_vn =3D 0</div><div>inoalignmt =3D 2</div><d=
iv>unit =3D 0</div><div>width =3D 0</div><div>dirblklog =3D 0</div><div>log=
sectlog =3D 0</div>
<div>logsectsize =3D 0</div><div>logsunit =3D 1</div><div>features2 =3D 0xa=
</div><div>bad_features2 =3D 0xa</div><div>xfs_db&gt; sb 1</div><div>xfs_db=
&gt; p</div><div>magicnum =3D 0x58465342</div><div>blocksize =3D 4096</div>=
<div>dblocks =3D 569089536</div>
<div>rblocks =3D 0</div><div>rextents =3D 0</div><div>uuid =3D 13ecf47b-52c=
f-4944-9a71-885bddc5e008</div><div>logstart =3D 536870916</div><div>rootino=
 =3D 128</div><div>rbmino =3D null</div><div>rsumino =3D null</div><div>rex=
tsize =3D 1</div>
<div>agblocks =3D 142272384</div><div>agcount =3D 4</div><div>rbmblocks =3D=
 0</div><div>logblocks =3D 277875</div><div>versionnum =3D 0xb4a4</div><div=
>sectsize =3D 512</div><div>inodesize =3D 256</div><div>inopblock =3D 16</d=
iv><div>fname =3D &quot;\000\000\000\000\000\000\000\000\000\000\000\000&qu=
ot;</div>
<div>blocklog =3D 12</div><div>sectlog =3D 9</div><div>inodelog =3D 8</div>=
<div>inopblog =3D 4</div><div>agblklog =3D 28</div><div>rextslog =3D 0</div=
><div>inprogress =3D 1</div><div>imax_pct =3D 5</div><div>icount =3D 0</div=
><div>ifree =3D 0</div>
<div>fdblocks =3D 568811645</div><div>frextents =3D 0</div><div>uquotino =
=3D 0</div><div>gquotino =3D 0</div><div>qflags =3D 0</div><div>flags =3D 0=
</div><div>shared_vn =3D 0</div><div>inoalignmt =3D 2</div><div>unit =3D 0<=
/div><div>width =3D 0</div>
<div>dirblklog =3D 0</div><div>logsectlog =3D 0</div><div>logsectsize =3D 0=
</div><div>logsunit =3D 1</div><div>features2 =3D 0xa</div><div>bad_feature=
s2 =3D 0xa</div><div>xfs_db&gt; sb 2</div><div>xfs_db&gt; p</div><div>magic=
num =3D 0x58465342</div>
<div>blocksize =3D 4096</div><div>dblocks =3D 569089536</div><div>rblocks =
=3D 0</div><div>rextents =3D 0</div><div>uuid =3D 13ecf47b-52cf-4944-9a71-8=
85bddc5e008</div><div>logstart =3D 536870916</div><div>rootino =3D null</di=
v><div>rbmino =3D null</div>
<div>rsumino =3D null</div><div>rextsize =3D 1</div><div>agblocks =3D 14227=
2384</div><div>agcount =3D 4</div><div>rbmblocks =3D 0</div><div>logblocks =
=3D 277875</div><div>versionnum =3D 0xb4a4</div><div>sectsize =3D 512</div>=
<div>inodesize =3D 256</div>
<div>inopblock =3D 16</div><div>fname =3D &quot;\000\000\000\000\000\000\00=
0\000\000\000\000\000&quot;</div><div>blocklog =3D 12</div><div>sectlog =3D=
 9</div><div>inodelog =3D 8</div><div>inopblog =3D 4</div><div>agblklog =3D=
 28</div><div>
rextslog =3D 0</div><div>inprogress =3D 1</div><div>imax_pct =3D 5</div><di=
v>icount =3D 0</div><div>ifree =3D 0</div><div>fdblocks =3D 568811645</div>=
<div>frextents =3D 0</div><div>uquotino =3D 0</div><div>gquotino =3D 0</div=
><div>qflags =3D 0</div>
<div>flags =3D 0</div><div>shared_vn =3D 0</div><div>inoalignmt =3D 2</div>=
<div>unit =3D 0</div><div>width =3D 0</div><div>dirblklog =3D 0</div><div>l=
ogsectlog =3D 0</div><div>logsectsize =3D 0</div><div>logsunit =3D 1</div><=
div>features2 =3D 0xa</div>
<div>bad_features2 =3D 0xa</div><div>xfs_db&gt; sb 3</div><div>xfs_db&gt; p=
</div><div>magicnum =3D 0x58465342</div><div>blocksize =3D 4096</div><div>d=
blocks =3D 569089536</div><div>rblocks =3D 0</div><div>rextents =3D 0</div>=
<div>uuid =3D 13ecf47b-52cf-4944-9a71-885bddc5e008</div>
<div>logstart =3D 536870916</div><div>rootino =3D 128</div><div>rbmino =3D =
null</div><div>rsumino =3D null</div><div>rextsize =3D 1</div><div>agblocks=
 =3D 142272384</div><div>agcount =3D 4</div><div>rbmblocks =3D 0</div><div>=
logblocks =3D 277875</div>
<div>versionnum =3D 0xb4a4</div><div>sectsize =3D 512</div><div>inodesize =
=3D 256</div><div>inopblock =3D 16</div><div>fname =3D &quot;\000\000\000\0=
00\000\000\000\000\000\000\000\000&quot;</div><div>blocklog =3D 12</div><di=
v>sectlog =3D 9</div>
<div>inodelog =3D 8</div><div>inopblog =3D 4</div><div>agblklog =3D 28</div=
><div>rextslog =3D 0</div><div>inprogress =3D 1</div><div>imax_pct =3D 5</d=
iv><div>icount =3D 0</div><div>ifree =3D 0</div><div>fdblocks =3D 568811645=
</div><div>frextents =3D 0</div>
<div>uquotino =3D 0</div><div>gquotino =3D 0</div><div>qflags =3D 0</div><d=
iv>flags =3D 0</div><div>shared_vn =3D 0</div><div>inoalignmt =3D 2</div><d=
iv>unit =3D 0</div><div>width =3D 0</div><div>dirblklog =3D 0</div><div>log=
sectlog =3D 0</div>
<div>logsectsize =3D 0</div><div>logsunit =3D 1</div><div>features2 =3D 0xa=
</div><div>bad_features2 =3D 0xa</div></div><div><br></div><div><br></div><=
div>Thanks</div><div>Qiang</div><div><br></div><div class=3D"gmail_extra"><=
br><br>
<div class=3D"gmail_quote">2014-08-25 16:56 GMT+08:00 Dave Chinner <span di=
r=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">davi=
d@fromorbit.com</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(20=
4,204,204);border-left-style:solid;padding-left:1ex">
<div class=3D"">On Mon, Aug 25, 2014 at 04:09:05PM +0800, Zhang Qiang wrote=
:<br>
&gt; Thanks for your quick and clear response. Some comments bellow:<br>
&gt;<br>
&gt;<br>
&gt; 2014-08-25 13:18 GMT+08:00 Dave Chinner &lt;<a href=3D"mailto:david@fr=
omorbit.com">david@fromorbit.com</a>&gt;:<br>
&gt;<br>
&gt; &gt; On Mon, Aug 25, 2014 at 11:34:34AM +0800, Zhang Qiang wrote:<br>
&gt; &gt; &gt; Dear XFS community &amp; developers,<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; I am using CentOS 6.3 and xfs as base file system and use RA=
ID5 as<br>
&gt; &gt; hardware<br>
&gt; &gt; &gt; storage.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Detail environment as follow:<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 OS: CentOS 6.3<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 Kernel: kernel-2.6.32-279.el6.x86_64<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 XFS option info(df output): /dev/sdb1 on /data =
type xfs<br>
&gt; &gt; &gt; (rw,noatime,nodiratime,nobarrier)<br>
</div>....<br>
<div class=3D""><br>
&gt; &gt; &gt; It&#39;s very greatly appreciated if you can give constructi=
ve suggestion<br>
&gt; &gt; about<br>
&gt; &gt; &gt; this issue, as It&#39;s really hard to reproduce from anothe=
r system and it&#39;s<br>
&gt; &gt; &gt; not possible to do upgrade on that online machine.<br>
&gt; &gt;<br>
&gt; &gt; You&#39;ve got very few free inodes, widely distributed in the al=
located<br>
&gt; &gt; inode btree. The CPU time above is the btree search for the next<=
br>
&gt; &gt; free inode.<br>
&gt; &gt;<br>
&gt; &gt; This is the issue solved by this series of recent commits to add =
a<br>
&gt; &gt; new on-disk free inode btree index:<br>
&gt; &gt;<br>
&gt; [Qiang] This meas that if I want to fix this issue, I have to apply th=
e<br>
&gt; following patches and build my own kernel.<br>
<br>
</div>Yes. Good luck, even I wouldn&#39;t attempt to do that.<br>
<br>
And then use xfsprogs 3.2.1, and make a new filesystem that enables<br>
metadata CRCs and the free inode btree feature.<br>
<div class=3D""><br>
&gt; As the on-disk structure has been changed, so should I also re-create =
xfs<br>
&gt; filesystem again?<br>
<br>
</div>Yes, you need to download the latest xfsprogs (3.2.1) to be able to<b=
r>
make it with the necessary feature bits set.<br>
<div class=3D""><br>
&gt; is there any user space tools to convert old disk<br>
&gt; filesystem to new one, and don&#39;t need to backup and restore curren=
tly data?<br>
<br>
</div>No, we don&#39;t write utilities to mangle on disk formats. dump, mkf=
s<br>
and restore is far more reliable than any &quot;in-place conversion&quot; c=
ode<br>
we could write. It will probably be faster, too.<br>
<div class=3D""><br>
&gt; &gt; Which is of no help to you, however, because it&#39;s not availab=
le in<br>
&gt; &gt; any CentOS kernel.<br>
&gt; &gt;<br>
&gt; [Qiang] Do you think if it&#39;s possible to just backport these patch=
es to<br>
&gt; kernel=C2=A0 6.2.32 (CentOS 6.3) to fix this issue?<br>
&gt;<br>
&gt; Or it&#39;s better to backport to 3.10 kernel, used in CentOS 7.0?<br>
<br>
</div>You can try, but if you break it you get to keep all the pieces<br>
yourself. Eventually someone who maintains the RHEL code will do a<br>
backport that will trickle down to CentOS. If you need it any<br>
sooner, then you&#39;ll need to do it yourself, or upgrade to RHEL<br>
and ask your support contact for it to be included in RHEL 7.1....<br>
<div class=3D""><br>
&gt; &gt; There&#39;s really not much you can do to avoid the problem once =
you&#39;ve<br>
&gt; &gt; punched random freespace holes in the allocated inode btree. IT<b=
r>
&gt; &gt; generally doesn&#39;t affect many people; those that it does affe=
ct are<br>
&gt; &gt; normally using XFS as an object store indexed by a hard link farm=
<br>
&gt; &gt; (e.g. various backup programs do this).<br>
&gt; &gt;<br>
&gt; OK, I see.<br>
&gt;<br>
&gt; Could you please guide me to reproduce this issue easily? as I have tr=
ied<br>
&gt; to use a 500G xfs partition, and use about 98 % spaces, but still can&=
#39;t<br>
&gt; reproduce this issue. Is there any easy way from your mind?<br>
<br>
</div>Search the archives for the test cases that were used for the patch<b=
r>
set. There&#39;s a performance test case documented in the review<br>
discussions.<br>
<div class=3D""><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
<br>
</div>_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/listinfo/xfs</a><br>
</blockquote></div><br></div></div></div>

--001a11c34b184411fe0501707d35--


--===============7552721042803464716==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7552721042803464716==--
