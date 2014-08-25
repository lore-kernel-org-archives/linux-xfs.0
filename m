Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 541267F4E
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 03:47:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 42234304051
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 01:47:46 -0700 (PDT)
Received: from mail-lb0-f172.google.com (mail-lb0-f172.google.com
	[209.85.217.172]) by cuda.sgi.com with ESMTP id
	BrxRARjFF4ij8UkX (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Aug 2014 01:47:43 -0700 (PDT)
Received: by mail-lb0-f172.google.com with SMTP id z11so12038477lbi.3
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 01:47:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140825051801.GY26465@dastard>
References: <CAKEtwsWxZseS8M+O7vSR2FRXr4gjVQ0RDO8ok+jMPWq-8jPEeA@mail.gmail.com>
	<20140825051801.GY26465@dastard>
Date: Mon, 25 Aug 2014 16:47:39 +0800
Message-ID: <CAKEtwsXiVKTWAW+YszjNnFnD4_Ld7g2qXEvw48A-SitYSGyXHA@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============6565765678956240336=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============6565765678956240336==
Content-Type: multipart/alternative; boundary=001a11c353fa3fce430501703d36

--001a11c353fa3fce430501703d36
Content-Type: text/plain; charset=UTF-8

I have checked icount and ifree, but I found there are about 11.8 percent
free, so the free inode should not be too few.

Here's the detail log, any new clue?

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



2014-08-25 13:18 GMT+08:00 Dave Chinner <david@fromorbit.com>:

> On Mon, Aug 25, 2014 at 11:34:34AM +0800, Zhang Qiang wrote:
> > Dear XFS community & developers,
> >
> > I am using CentOS 6.3 and xfs as base file system and use RAID5 as
> hardware
> > storage.
> >
> > Detail environment as follow:
> >    OS: CentOS 6.3
> >    Kernel: kernel-2.6.32-279.el6.x86_64
> >    XFS option info(df output): /dev/sdb1 on /data type xfs
> > (rw,noatime,nodiratime,nobarrier)
> >
> > Detail phenomenon:
> >
> >     # df
> >     Filesystem            Size  Used Avail Use% Mounted on
> >     /dev/sda1              29G   17G   11G  61% /
> >     /dev/sdb1             893G  803G   91G  90% /data
> >     /dev/sda4             2.2T  1.6T  564G  75% /data1
> >
> >     # time touch /data1/1111
> >     real    0m23.043s
> >     user    0m0.001s
> >     sys     0m0.349s
> >
> >     # perf top
> >     Events: 6K cycles
> >      16.96%  [xfs]                     [k] xfs_inobt_get_rec
> >      11.95%  [xfs]                     [k] xfs_btree_increment
> >      11.16%  [xfs]                     [k] xfs_btree_get_rec
> >       7.39%  [xfs]                     [k] xfs_btree_get_block
> >       5.02%  [xfs]                     [k] xfs_dialloc
> >       4.87%  [xfs]                     [k] xfs_btree_rec_offset
> >       4.33%  [xfs]                     [k] xfs_btree_readahead
> >       4.13%  [xfs]                     [k] _xfs_buf_find
> >       4.05%  [kernel]                  [k] intel_idle
> >       2.89%  [xfs]                     [k] xfs_btree_rec_addr
> >       1.04%  [kernel]                  [k] kmem_cache_free
> >
> >
> > It seems that some xfs kernel function spend much time
> (xfs_inobt_get_rec,
> > xfs_btree_increment, etc.)
> >
> > I found a bug in bugzilla [1], is that is the same issue like this?
>
> No.
>
> > It's very greatly appreciated if you can give constructive suggestion
> about
> > this issue, as It's really hard to reproduce from another system and it's
> > not possible to do upgrade on that online machine.
>
> You've got very few free inodes, widely distributed in the allocated
> inode btree. The CPU time above is the btree search for the next
> free inode.
>
> This is the issue solved by this series of recent commits to add a
> new on-disk free inode btree index:
>
> 53801fd xfs: enable the finobt feature on v5 superblocks
> 0c153c1 xfs: report finobt status in fs geometry
> a3fa516 xfs: add finobt support to growfs
> 3efa4ff xfs: update the finobt on inode free
> 2b64ee5 xfs: refactor xfs_difree() inobt bits into xfs_difree_inobt()
> helper
> 6dd8638 xfs: use and update the finobt on inode allocation
> 0aa0a75 xfs: insert newly allocated inode chunks into the finobt
> 9d43b18 xfs: update inode allocation/free transaction reservations for
> finobt
> aafc3c2 xfs: support the XFS_BTNUM_FINOBT free inode btree type
> 8e2c84d xfs: reserve v5 superblock read-only compat. feature bit for finobt
> 57bd3db xfs: refactor xfs_ialloc_btree.c to support multiple inobt numbers
>
> Which is of no help to you, however, because it's not available in
> any CentOS kernel.
>
> There's really not much you can do to avoid the problem once you've
> punched random freespace holes in the allocated inode btree. IT
> generally doesn't affect many people; those that it does affect are
> normally using XFS as an object store indexed by a hard link farm
> (e.g. various backup programs do this).
>
> If you dump the superblock via xfs_db, the difference between icount
> and ifree will give you idea of how much "needle in a haystack"
> searching is going on. You can probably narrow it down to a specific
> AG by dumping the AGI headers and checking the same thing. filling
> in all the holes (by creating a bunch of zero length files in the
> appropriate AGs) might take some time, but it should make the
> problem go away until you remove more filesystem and create random
> free inode holes again...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--001a11c353fa3fce430501703d36
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I have checked icount and ifree, but I found there are abo=
ut 11.8 percent free, so the free inode should not be too few.<div><br></di=
v><div>Here&#39;s the detail log, any new clue?=C2=A0</div><div><br></div><=
div>
<div># mount /dev/sda4 /data1/</div><div># xfs_info /data1/</div><div>meta-=
data=3D/dev/sda4 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0isize=3D25=
6 =C2=A0 =C2=A0agcount=3D4, agsize=3D142272384 blks</div><div>=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 attr=3D2, projid32bit=3D0</=
div>
<div>data =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D569089536, ima=
xpct=3D5</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sunit=3D0 =C2=
=A0 =C2=A0 =C2=A0swidth=3D0 blks</div><div>naming =C2=A0 =3Dversion 2 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bsize=3D4096 =C2=A0 ascii-ci=
=3D0</div>
<div>log =C2=A0 =C2=A0 =C2=A0=3Dinternal =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D277875, version=3D2</div><div>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 sunit=3D0 blk=
s, lazy-count=3D1</div><div>realtime =3Dnone =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 extsz=3D4096 =C2=A0 blocks=3D0, rtextent=
s=3D0</div>
<div># umount /dev/sda4</div><div># xfs_db /dev/sda4</div><div>xfs_db&gt; s=
b 0</div><div>xfs_db&gt; p</div><div>magicnum =3D 0x58465342</div><div>bloc=
ksize =3D 4096</div><div>dblocks =3D 569089536</div><div>rblocks =3D 0</div=
><div>
rextents =3D 0</div><div>uuid =3D 13ecf47b-52cf-4944-9a71-885bddc5e008</div=
><div>logstart =3D 536870916</div><div>rootino =3D 128</div><div>rbmino =3D=
 129</div><div>rsumino =3D 130</div><div>rextsize =3D 1</div><div>agblocks =
=3D 142272384</div>
<div>agcount =3D 4</div><div>rbmblocks =3D 0</div><div>logblocks =3D 277875=
</div><div>versionnum =3D 0xb4a4</div><div>sectsize =3D 512</div><div>inode=
size =3D 256</div><div>inopblock =3D 16</div><div>fname =3D &quot;\000\000\=
000\000\000\000\000\000\000\000\000\000&quot;</div>
<div>blocklog =3D 12</div><div>sectlog =3D 9</div><div>inodelog =3D 8</div>=
<div>inopblog =3D 4</div><div>agblklog =3D 28</div><div>rextslog =3D 0</div=
><div>inprogress =3D 0</div><div>imax_pct =3D 5</div><div>icount =3D 220619=
904</div><div>
ifree =3D 26202919</div><div>fdblocks =3D 147805479</div><div>frextents =3D=
 0</div><div>uquotino =3D 0</div><div>gquotino =3D 0</div><div>qflags =3D 0=
</div><div>flags =3D 0</div><div>shared_vn =3D 0</div><div>inoalignmt =3D 2=
</div><div>unit =3D 0</div>
<div>width =3D 0</div><div>dirblklog =3D 0</div><div>logsectlog =3D 0</div>=
<div>logsectsize =3D 0</div><div>logsunit =3D 1</div><div>features2 =3D 0xa=
</div><div>bad_features2 =3D 0xa</div><div>xfs_db&gt; sb 1</div><div>xfs_db=
&gt; p</div>
<div>magicnum =3D 0x58465342</div><div>blocksize =3D 4096</div><div>dblocks=
 =3D 569089536</div><div>rblocks =3D 0</div><div>rextents =3D 0</div><div>u=
uid =3D 13ecf47b-52cf-4944-9a71-885bddc5e008</div><div>logstart =3D 5368709=
16</div><div>
rootino =3D 128</div><div>rbmino =3D null</div><div>rsumino =3D null</div><=
div>rextsize =3D 1</div><div>agblocks =3D 142272384</div><div>agcount =3D 4=
</div><div>rbmblocks =3D 0</div><div>logblocks =3D 277875</div><div>version=
num =3D 0xb4a4</div>
<div>sectsize =3D 512</div><div>inodesize =3D 256</div><div>inopblock =3D 1=
6</div><div>fname =3D &quot;\000\000\000\000\000\000\000\000\000\000\000\00=
0&quot;</div><div>blocklog =3D 12</div><div>sectlog =3D 9</div><div>inodelo=
g =3D 8</div>
<div>inopblog =3D 4</div><div>agblklog =3D 28</div><div>rextslog =3D 0</div=
><div>inprogress =3D 1</div><div>imax_pct =3D 5</div><div>icount =3D 0</div=
><div>ifree =3D 0</div><div>fdblocks =3D 568811645</div><div>frextents =3D =
0</div><div>uquotino =3D 0</div>
<div>gquotino =3D 0</div><div>qflags =3D 0</div><div>flags =3D 0</div><div>=
shared_vn =3D 0</div><div>inoalignmt =3D 2</div><div>unit =3D 0</div><div>w=
idth =3D 0</div><div>dirblklog =3D 0</div><div>logsectlog =3D 0</div><div>l=
ogsectsize =3D 0</div>
<div>logsunit =3D 1</div><div>features2 =3D 0xa</div><div>bad_features2 =3D=
 0xa</div><div>xfs_db&gt; sb 2</div><div>xfs_db&gt; p</div><div>magicnum =
=3D 0x58465342</div><div>blocksize =3D 4096</div><div>dblocks =3D 569089536=
</div><div>
rblocks =3D 0</div><div>rextents =3D 0</div><div>uuid =3D 13ecf47b-52cf-494=
4-9a71-885bddc5e008</div><div>logstart =3D 536870916</div><div>rootino =3D =
null</div><div>rbmino =3D null</div><div>rsumino =3D null</div><div>rextsiz=
e =3D 1</div>
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
s2 =3D 0xa</div><div>xfs_db&gt; sb 3</div><div>xfs_db&gt; p</div><div>magic=
num =3D 0x58465342</div>
<div>blocksize =3D 4096</div><div>dblocks =3D 569089536</div><div>rblocks =
=3D 0</div><div>rextents =3D 0</div><div>uuid =3D 13ecf47b-52cf-4944-9a71-8=
85bddc5e008</div><div>logstart =3D 536870916</div><div>rootino =3D 128</div=
><div>rbmino =3D null</div>
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
<div>bad_features2 =3D 0xa</div></div><div><br></div></div><div class=3D"gm=
ail_extra"><br><br><div class=3D"gmail_quote">2014-08-25 13:18 GMT+08:00 Da=
ve Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" tar=
get=3D"_blank">david@fromorbit.com</a>&gt;</span>:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On M=
on, Aug 25, 2014 at 11:34:34AM +0800, Zhang Qiang wrote:<br>
&gt; Dear XFS community &amp; developers,<br>
&gt;<br>
&gt; I am using CentOS 6.3 and xfs as base file system and use RAID5 as har=
dware<br>
&gt; storage.<br>
&gt;<br>
&gt; Detail environment as follow:<br>
&gt;=C2=A0 =C2=A0 OS: CentOS 6.3<br>
&gt;=C2=A0 =C2=A0 Kernel: kernel-2.6.32-279.el6.x86_64<br>
&gt;=C2=A0 =C2=A0 XFS option info(df output): /dev/sdb1 on /data type xfs<b=
r>
&gt; (rw,noatime,nodiratime,nobarrier)<br>
&gt;<br>
&gt; Detail phenomenon:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0# df<br>
&gt;=C2=A0 =C2=A0 =C2=A0Filesystem=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 Size=C2=A0 Used Avail Use% Mounted on<br>
&gt;=C2=A0 =C2=A0 =C2=A0/dev/sda1=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 29G=C2=A0 =C2=A017G=C2=A0 =C2=A011G=C2=A0 61% /<br>
&gt;=C2=A0 =C2=A0 =C2=A0/dev/sdb1=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0893G=C2=A0 803G=C2=A0 =C2=A091G=C2=A0 90% /data<br>
&gt;=C2=A0 =C2=A0 =C2=A0/dev/sda4=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A02.2T=C2=A0 1.6T=C2=A0 564G=C2=A0 75% /data1<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0# time touch /data1/1111<br>
&gt;=C2=A0 =C2=A0 =C2=A0real=C2=A0 =C2=A0 0m23.043s<br>
&gt;=C2=A0 =C2=A0 =C2=A0user=C2=A0 =C2=A0 0m0.001s<br>
&gt;=C2=A0 =C2=A0 =C2=A0sys=C2=A0 =C2=A0 =C2=A00m0.349s<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0# perf top<br>
&gt;=C2=A0 =C2=A0 =C2=A0Events: 6K cycles<br>
&gt;=C2=A0 =C2=A0 =C2=A0 16.96%=C2=A0 [xfs]=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_inobt_get_rec<br>
&gt;=C2=A0 =C2=A0 =C2=A0 11.95%=C2=A0 [xfs]=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_btree_increment<br>
&gt;=C2=A0 =C2=A0 =C2=A0 11.16%=C2=A0 [xfs]=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_btree_get_rec<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A07.39%=C2=A0 [xfs]=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_btree_get_block<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A05.02%=C2=A0 [xfs]=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_dialloc<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A04.87%=C2=A0 [xfs]=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_btree_rec_offset<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A04.33%=C2=A0 [xfs]=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_btree_readahead<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A04.13%=C2=A0 [xfs]=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] _xfs_buf_find<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A04.05%=C2=A0 [kernel]=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 [k] intel_idle<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A02.89%=C2=A0 [xfs]=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] xfs_btree_rec_addr<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A01.04%=C2=A0 [kernel]=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 [k] kmem_cache_free<br>
&gt;<br>
&gt;<br>
&gt; It seems that some xfs kernel function spend much time (xfs_inobt_get_=
rec,<br>
&gt; xfs_btree_increment, etc.)<br>
&gt;<br>
&gt; I found a bug in bugzilla [1], is that is the same issue like this?<br=
>
<br>
</div></div>No.<br>
<div class=3D""><br>
&gt; It&#39;s very greatly appreciated if you can give constructive suggest=
ion about<br>
&gt; this issue, as It&#39;s really hard to reproduce from another system a=
nd it&#39;s<br>
&gt; not possible to do upgrade on that online machine.<br>
<br>
</div>You&#39;ve got very few free inodes, widely distributed in the alloca=
ted<br>
inode btree. The CPU time above is the btree search for the next<br>
free inode.<br>
<br>
This is the issue solved by this series of recent commits to add a<br>
new on-disk free inode btree index:<br>
<br>
53801fd xfs: enable the finobt feature on v5 superblocks<br>
0c153c1 xfs: report finobt status in fs geometry<br>
a3fa516 xfs: add finobt support to growfs<br>
3efa4ff xfs: update the finobt on inode free<br>
2b64ee5 xfs: refactor xfs_difree() inobt bits into xfs_difree_inobt() helpe=
r<br>
6dd8638 xfs: use and update the finobt on inode allocation<br>
0aa0a75 xfs: insert newly allocated inode chunks into the finobt<br>
9d43b18 xfs: update inode allocation/free transaction reservations for fino=
bt<br>
aafc3c2 xfs: support the XFS_BTNUM_FINOBT free inode btree type<br>
8e2c84d xfs: reserve v5 superblock read-only compat. feature bit for finobt=
<br>
57bd3db xfs: refactor xfs_ialloc_btree.c to support multiple inobt numbers<=
br>
<br>
Which is of no help to you, however, because it&#39;s not available in<br>
any CentOS kernel.<br>
<br>
There&#39;s really not much you can do to avoid the problem once you&#39;ve=
<br>
punched random freespace holes in the allocated inode btree. IT<br>
generally doesn&#39;t affect many people; those that it does affect are<br>
normally using XFS as an object store indexed by a hard link farm<br>
(e.g. various backup programs do this).<br>
<br>
If you dump the superblock via xfs_db, the difference between icount<br>
and ifree will give you idea of how much &quot;needle in a haystack&quot;<b=
r>
searching is going on. You can probably narrow it down to a specific<br>
AG by dumping the AGI headers and checking the same thing. filling<br>
in all the holes (by creating a bunch of zero length files in the<br>
appropriate AGs) might take some time, but it should make the<br>
problem go away until you remove more filesystem and create random<br>
free inode holes again...<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div>

--001a11c353fa3fce430501703d36--


--===============6565765678956240336==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6565765678956240336==--
