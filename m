Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA923L78052333 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 20:03:22 -0600
Received: from mail-we0-f181.google.com (mail-we0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id ytyJGifXdDsz5rLC
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 08 Nov 2012 18:05:19 -0800 (PST)
Received: by mail-we0-f181.google.com with SMTP id u54so1711727wey.26
	for <xfs@oss.sgi.com>; Thu, 08 Nov 2012 18:05:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121107031952.GA6434@dastard>
References: <CANS6a=D4SMMqhGJVMLbr-BWqLb-Z4L4LnofzfhqChBvE9dEtPQ@mail.gmail.com>
	<20121107031952.GA6434@dastard>
From: huubby zhou <huubby1@gmail.com>
Date: Fri, 9 Nov 2012 10:04:57 +0800
Message-ID: <CANS6a=DpNTtnV1aLjX1TW_2dNSvwi-nPOB+EiQ=gyg9jwr81oA@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============4036352453116340656=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============4036352453116340656==
Content-Type: multipart/alternative; boundary=0016e6db7c6f1ac8b204ce066287

--0016e6db7c6f1ac8b204ce066287
Content-Type: text/plain; charset=UTF-8

Hi, Dave,

Thanks for the answer, it's great, and I apologize for the terrible format.

>You can't, directly. If you have enough contiguous free space in the
>AG that you are allocating in, then you will get contiguous files if
>the allocation size lines up with the filesystem geometry:
>
>$ for i in `seq 1 10` ; do sudo xfs_io -f -c "truncate 512m" -c "resvsp 0
512m" foo.$i ; done
>$ sudo xfs_bmap -vp foo.[1-9] foo.10 |grep " 0:"
> EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> sudo xfs_bmap -vp foo.[1-9] foo.10 |grep " 0:"
>   0: [0..1048575]:    8096..1056671     0 (8096..1056671)  1048576 10000
>   0: [0..1048575]:    1056672..2105247  0 (1056672..2105247) 1048576 10000
>   0: [0..1048575]:    2105248..3153823  0 (2105248..3153823) 1048576 10000
>   0: [0..1048575]:    3153824..4202399  0 (3153824..4202399) 1048576 10000
>   0: [0..1048575]:    4202400..5250975  0 (4202400..5250975) 1048576 10000
>   0: [0..1048575]:    5250976..6299551  0 (5250976..6299551) 1048576 10000
>   0: [0..1048575]:    6299552..7348127  0 (6299552..7348127) 1048576 10000
>   0: [0..1048575]:    7348128..8396703  0 (7348128..8396703) 1048576 10000
>   0: [0..1048575]:    8396704..9445279  0 (8396704..9445279) 1048576 10000
>   0: [0..1048575]:    9445280..10493855  0 (9445280..10493855) 1048576
10000
>
>So all those files are contiguous both internally and externally. If
>there isn't sufficient contiguous freespace, or there is allocator
>contention, this won't happen - it's best effort behaviour....

I believe you got these in a single AG, but I do the allocation in
filesystem
with multi-AGs, specifically, it is a 6T storage space, and I run the
mkfs.xfs
without setting the AG number/size, it ends up with 32 AGs.
My files layout:
    - 0                         - dir
    | - 0                       - dir
    | | - 1                     - file
    | | - 2                     - file
    | | - 3                     - file
    | | - 4                     - file
    | | - 5                     - file
    | | - ...                   - file
    | | - 128                   - file
    | - 1                       - dir
    | | - 1                     - file
    | | - 2                     - file
    | | - 3                     - file
    | | - 4                     - file
    | | - 5                     - file
    | | - ...                   - file
    | | - 128                   - file
    | - ...                     - dir
Every file is 512MB, every directory holds 512MB*128=64GB.

According to your advice and XFS document, I tried to set the AG size to
64GB,
for avoiding the allocator contention and keeping all files in single
directory
fall in the same AG, but it didn't work. The files are still in different
AGs.

My xfs_info:
meta-data=/dev/sdc2              isize=256    agcount=96, agsize=16777216
blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=1610116329, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

The files:
$ for i in `seq 1 10` ; do sudo xfs_io -f -c "truncate 512m" -c "resvsp 0
512m" foo.$i ; done
$ sudo xfs_bmap -vp *| grep " 0:"
   0: [0..1048575]:    2147483712..2148532287 16 (64..1048639)    1048576
10000
   0: [0..1048575]:    3355443264..3356491839 25 (64..1048639)    1048576
10000
   0: [0..1048575]:    2281701440..2282750015 17 (64..1048639)    1048576
10000
   0: [0..1048575]:    2415919168..2416967743 18 (64..1048639)    1048576
10000
   0: [0..1048575]:    2550136896..2551185471 19 (64..1048639)    1048576
10000
   0: [0..1048575]:    2684354624..2685403199 20 (64..1048639)    1048576
10000
   0: [0..1048575]:    2818572352..2819620927 21 (64..1048639)    1048576
10000
   0: [0..1048575]:    2952790080..2953838655 22 (64..1048639)    1048576
10000
   0: [0..1048575]:    3087007808..3088056383 23 (64..1048639)    1048576
10000
   0: [0..1048575]:    3221225536..3222274111 24 (64..1048639)    1048576
10000

Any way I can specify which AG a file should be allocated?

Again, Thanks for your time.


On Wed, Nov 7, 2012 at 11:19 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Nov 07, 2012 at 09:02:11AM +0800, huubby zhou wrote:
> > Hi, folks,
> >
> > I'm using *CentOS5.8*, with *XFS* filesystem extend storage disks. What I
> > want to do is, pre-allocating many files, with continuous blocks in
> > filesystem, both single file and crossing files. That is the start block
> ID
> > of the next file is following the end block ID of current file.
> >
> > I could do space pre-allocation by *posix_allocate()*, problem is the API
> > zeros all disk space, I can't afford time consuming(I'm not sure if this
> > API could make the blocks continuous).
>
> it doesn't on more recent releases - it uses fallocate() in the back
> end, which does the same as:
>
> > then I tried
> > *xfsctl()*<http://linux.die.net/man/3/xfsctl>,
> > with *XFS_IOC_RESVSP* flag, I can reserve space faster.
>
> This command.
>
> > The problem with *xfsctl()* is, it could make the blocks continuous for
> > individual file, but the blocks over files are *not* continuous. For
> > example, 10 files, a/b/c/d/e/f... reserved. After I do the real writing
> to
> > these files, it turns out the file 'b' isn't next to file 'a', and some
> > file could be far from both previous one and next one, though other files
> > may be neighboring with each other, rarely.
> >
> > I use the following code to do the pre-allocation:
> >
> > ftruncate(fd, FILE_SIZE);
> >
> > xfs_flock_t flag = {0};
> > flag.l_whence = SEEK_SET;
> > flag.l_start  = 0;
> > flag.l_len    = 512*1024*1024;
> > xfsctl(fileName, fd, XFS_IOC_RESVSP64, &flag);
> >
> > My question is, how can I guarantee the file system blocks over files
> > continuous? Thanks for your time and appreciate your answer.
>
> You can't, directly. If you have enough contiguous free space in the
> AG that you are allocating in, then you will get contiguous files if
> the allocation size lines up with the filesystem geometry:
>
> $ for i in `seq 1 10` ; do sudo xfs_io -f -c "truncate 512m" -c "resvsp 0
> 512m" foo.$i ; done
> $ sudo xfs_bmap -vp foo.[1-9] foo.10 |grep " 0:"
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
>  sudo xfs_bmap -vp foo.[1-9] foo.10 |grep " 0:"
>    0: [0..1048575]:    8096..1056671     0 (8096..1056671)  1048576 10000
>    0: [0..1048575]:    1056672..2105247  0 (1056672..2105247) 1048576 10000
>    0: [0..1048575]:    2105248..3153823  0 (2105248..3153823) 1048576 10000
>    0: [0..1048575]:    3153824..4202399  0 (3153824..4202399) 1048576 10000
>    0: [0..1048575]:    4202400..5250975  0 (4202400..5250975) 1048576 10000
>    0: [0..1048575]:    5250976..6299551  0 (5250976..6299551) 1048576 10000
>    0: [0..1048575]:    6299552..7348127  0 (6299552..7348127) 1048576 10000
>    0: [0..1048575]:    7348128..8396703  0 (7348128..8396703) 1048576 10000
>    0: [0..1048575]:    8396704..9445279  0 (8396704..9445279) 1048576 10000
>    0: [0..1048575]:    9445280..10493855  0 (9445280..10493855) 1048576
> 10000
>
> So all those files are contiguous both internally and externally. If
> there isn't sufficient contiguous freespace, or there is allocator
> contention, this won't happen - it's best effort behaviour....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--0016e6db7c6f1ac8b204ce066287
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div>Hi, Dave,</div><div><br></div><div>Thanks for the answer, it&#39;s gre=
at, and I apologize for the terrible format.</div><div><br></div><div>&gt;Y=
ou can&#39;t, directly. If you have enough contiguous free space in the</di=
v>

<div>&gt;AG that you are allocating in, then you will get contiguous files =
if</div><div>&gt;the allocation size lines up with the filesystem geometry:=
</div><div>&gt;</div><div>&gt;$ for i in `seq 1 10` ; do sudo xfs_io -f -c =
&quot;truncate 512m&quot; -c &quot;resvsp 0 512m&quot; foo.$i ; done</div>

<div>&gt;$ sudo xfs_bmap -vp foo.[1-9] foo.10 |grep &quot; 0:&quot;</div><d=
iv>&gt; EXT: FILE-OFFSET =C2=A0 =C2=A0 =C2=A0BLOCK-RANGE =C2=A0 =C2=A0 =C2=
=A0AG AG-OFFSET =C2=A0 =C2=A0 =C2=A0 =C2=A0TOTAL FLAGS</div><div>&gt; sudo =
xfs_bmap -vp foo.[1-9] foo.10 |grep &quot; 0:&quot;</div>

<div>&gt; =C2=A0 0: [0..1048575]: =C2=A0 =C2=A08096..1056671 =C2=A0 =C2=A0 =
0 (8096..1056671) =C2=A01048576 10000</div><div>&gt; =C2=A0 0: [0..1048575]=
: =C2=A0 =C2=A01056672..2105247 =C2=A00 (1056672..2105247) 1048576 10000</d=
iv><div>&gt; =C2=A0 0: [0..1048575]: =C2=A0 =C2=A02105248..3153823 =C2=A00 =
(2105248..3153823) 1048576 10000</div>

<div>&gt; =C2=A0 0: [0..1048575]: =C2=A0 =C2=A03153824..4202399 =C2=A00 (31=
53824..4202399) 1048576 10000</div><div>&gt; =C2=A0 0: [0..1048575]: =C2=A0=
 =C2=A04202400..5250975 =C2=A00 (4202400..5250975) 1048576 10000</div><div>=
&gt; =C2=A0 0: [0..1048575]: =C2=A0 =C2=A05250976..6299551 =C2=A00 (5250976=
..6299551) 1048576 10000</div>

<div>&gt; =C2=A0 0: [0..1048575]: =C2=A0 =C2=A06299552..7348127 =C2=A00 (62=
99552..7348127) 1048576 10000</div><div>&gt; =C2=A0 0: [0..1048575]: =C2=A0=
 =C2=A07348128..8396703 =C2=A00 (7348128..8396703) 1048576 10000</div><div>=
&gt; =C2=A0 0: [0..1048575]: =C2=A0 =C2=A08396704..9445279 =C2=A00 (8396704=
..9445279) 1048576 10000</div>

<div>&gt; =C2=A0 0: [0..1048575]: =C2=A0 =C2=A09445280..10493855 =C2=A00 (9=
445280..10493855) 1048576 10000</div><div>&gt;</div><div>&gt;So all those f=
iles are contiguous both internally and externally. If</div><div>&gt;there =
isn&#39;t sufficient contiguous freespace, or there is allocator</div>

<div>&gt;contention, this won&#39;t happen - it&#39;s best effort behaviour=
....</div><div><br></div><div>I believe you got these in a single AG, but I=
 do the allocation in filesystem=C2=A0</div><div>with multi-AGs, specifical=
ly, it is a 6T storage space, and I run the mkfs.xfs=C2=A0</div>

<div>without setting the AG number/size, it ends up with 32 AGs.</div><div>=
My files layout:</div><div>=C2=A0 =C2=A0 - 0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - dir</div><div>=C2=
=A0 =C2=A0 | - 0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 - dir</div><div>=C2=A0 =C2=A0 | | - 1 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - file</div>

<div>=C2=A0 =C2=A0 | | - 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 - file</div><div>=C2=A0 =C2=A0 | | - 3 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - file</div><div>=
=C2=A0 =C2=A0 | | - 4 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 - file</div><div>=C2=A0 =C2=A0 | | - 5 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - file</div><div>=C2=
=A0 =C2=A0 | | - ... =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 - file</div>

<div>=C2=A0 =C2=A0 | | - 128 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 - file</div><div>=C2=A0 =C2=A0 | - 1 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - dir</div><div>=
=C2=A0 =C2=A0 | | - 1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 - file</div><div>=C2=A0 =C2=A0 | | - 2 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - file</div><div>=C2=
=A0 =C2=A0 | | - 3 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 - file</div>

<div>=C2=A0 =C2=A0 | | - 4 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 - file</div><div>=C2=A0 =C2=A0 | | - 5 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - file</div><div>=
=C2=A0 =C2=A0 | | - ... =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 - file</div><div>=C2=A0 =C2=A0 | | - 128 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - file</div><div>=C2=A0 =C2=A0 |=
 - ... =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 - dir</div>

<div>Every file is 512MB, every directory holds 512MB*128=3D64GB.=C2=A0</di=
v><div><br></div><div>According to your advice and XFS document, I tried to=
 set the AG size to 64GB,=C2=A0</div><div>for avoiding the allocator conten=
tion and keeping all files in single directory=C2=A0</div>

<div>fall in the same AG, but it didn&#39;t work. The files are still in di=
fferent AGs.</div><div><br></div><div>My xfs_info:</div><div>meta-data=3D/d=
ev/sdc2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0isize=3D256 =C2=A0 =
=C2=A0agcount=3D96, agsize=3D16777216 blks</div>
<div>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 attr=3D0</div=
><div>data =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D1610116329, im=
axpct=3D25</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sunit=3D0 =
=C2=A0 =C2=A0 =C2=A0swidth=3D0 blks, unwritten=3D1</div>

<div>naming =C2=A0 =3Dversion 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0bsize=3D4096</div><div>log =C2=A0 =C2=A0 =C2=A0=3Dinternal log =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D32768, version=3D=
1</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 su=
nit=3D0 blks, lazy-count=3D0</div><div>

realtime =3Dnone =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 extsz=3D4096 =C2=A0 blocks=3D0, rtextents=3D0</div><div><br></div><d=
iv>The files:</div><div>$ for i in `seq 1 10` ; do sudo xfs_io -f -c &quot;=
truncate 512m&quot; -c &quot;resvsp 0 512m&quot; foo.$i ; done</div>

<div>$ sudo xfs_bmap -vp *| grep &quot; 0:&quot;</div><div>=C2=A0 =C2=A00: =
[0..1048575]: =C2=A0 =C2=A02147483712..2148532287 16 (64..1048639) =C2=A0 =
=C2=A01048576 10000</div><div>=C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A033=
55443264..3356491839 25 (64..1048639) =C2=A0 =C2=A01048576 10000</div>

<div>=C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A02281701440..2282750015 17 (=
64..1048639) =C2=A0 =C2=A01048576 10000</div><div>=C2=A0 =C2=A00: [0..10485=
75]: =C2=A0 =C2=A02415919168..2416967743 18 (64..1048639) =C2=A0 =C2=A01048=
576 10000</div><div>=C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A02550136896..=
2551185471 19 (64..1048639) =C2=A0 =C2=A01048576 10000</div>

<div>=C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A02684354624..2685403199 20 (=
64..1048639) =C2=A0 =C2=A01048576 10000</div><div>=C2=A0 =C2=A00: [0..10485=
75]: =C2=A0 =C2=A02818572352..2819620927 21 (64..1048639) =C2=A0 =C2=A01048=
576 10000</div><div>=C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A02952790080..=
2953838655 22 (64..1048639) =C2=A0 =C2=A01048576 10000</div>

<div>=C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A03087007808..3088056383 23 (=
64..1048639) =C2=A0 =C2=A01048576 10000</div><div>=C2=A0 =C2=A00: [0..10485=
75]: =C2=A0 =C2=A03221225536..3222274111 24 (64..1048639) =C2=A0 =C2=A01048=
576 10000</div><div><br></div><div>Any way I can specify which AG a file sh=
ould be allocated?=C2=A0</div>

<div><br></div><div>Again, Thanks for your time.</div>



<div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Wed, Nov 7=
, 2012 at 11:19 AM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:da=
vid@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span> wro=
te:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On Wed, Nov 07, 2012 at 09=
:02:11AM +0800, huubby zhou wrote:<br>
&gt; Hi, folks,<br>
&gt;<br>
</div>&gt; I&#39;m using *CentOS5.8*, with *XFS* filesystem extend storage =
disks. What I<br>
<div class=3D"im">&gt; want to do is, pre-allocating many files, with conti=
nuous blocks in<br>
&gt; filesystem, both single file and crossing files. That is the start blo=
ck ID<br>
&gt; of the next file is following the end block ID of current file.<br>
&gt;<br>
</div>&gt; I could do space pre-allocation by *posix_allocate()*, problem i=
s the API<br>
<div class=3D"im">&gt; zeros all disk space, I can&#39;t afford time consum=
ing(I&#39;m not sure if this<br>
&gt; API could make the blocks continuous).<br>
<br>
</div>it doesn&#39;t on more recent releases - it uses fallocate() in the b=
ack<br>
end, which does the same as:<br>
<br>
&gt; then I tried<br>
&gt; *xfsctl()*&lt;<a href=3D"http://linux.die.net/man/3/xfsctl" target=3D"=
_blank">http://linux.die.net/man/3/xfsctl</a>&gt;,<br>
&gt; with *XFS_IOC_RESVSP* flag, I can reserve space faster.<br>
<br>
This command.<br>
<br>
&gt; The problem with *xfsctl()* is, it could make the blocks continuous fo=
r<br>
&gt; individual file, but the blocks over files are *not* continuous. For<b=
r>
<div class=3D"im">&gt; example, 10 files, a/b/c/d/e/f... reserved. After I =
do the real writing to<br>
&gt; these files, it turns out the file &#39;b&#39; isn&#39;t next to file =
&#39;a&#39;, and some<br>
&gt; file could be far from both previous one and next one, though other fi=
les<br>
&gt; may be neighboring with each other, rarely.<br>
&gt;<br>
&gt; I use the following code to do the pre-allocation:<br>
&gt;<br>
&gt; ftruncate(fd, FILE_SIZE);<br>
&gt;<br>
&gt; xfs_flock_t flag =3D {0};<br>
&gt; flag.l_whence =3D SEEK_SET;<br>
&gt; flag.l_start =C2=A0=3D 0;<br>
&gt; flag.l_len =C2=A0 =C2=A0=3D 512*1024*1024;<br>
&gt; xfsctl(fileName, fd, XFS_IOC_RESVSP64, &amp;flag);<br>
&gt;<br>
&gt; My question is, how can I guarantee the file system blocks over files<=
br>
&gt; continuous? Thanks for your time and appreciate your answer.<br>
<br>
</div>You can&#39;t, directly. If you have enough contiguous free space in =
the<br>
AG that you are allocating in, then you will get contiguous files if<br>
the allocation size lines up with the filesystem geometry:<br>
<br>
$ for i in `seq 1 10` ; do sudo xfs_io -f -c &quot;truncate 512m&quot; -c &=
quot;resvsp 0 512m&quot; foo.$i ; done<br>
$ sudo xfs_bmap -vp foo.[1-9] foo.10 |grep &quot; 0:&quot;<br>
=C2=A0EXT: FILE-OFFSET =C2=A0 =C2=A0 =C2=A0BLOCK-RANGE =C2=A0 =C2=A0 =C2=A0=
AG AG-OFFSET =C2=A0 =C2=A0 =C2=A0 =C2=A0TOTAL FLAGS<br>
=C2=A0sudo xfs_bmap -vp foo.[1-9] foo.10 |grep &quot; 0:&quot;<br>
=C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A08096..1056671 =C2=A0 =C2=A0 0 (8=
096..1056671) =C2=A01048576 10000<br>
=C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A01056672..2105247 =C2=A00 (105667=
2..2105247) 1048576 10000<br>
=C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A02105248..3153823 =C2=A00 (210524=
8..3153823) 1048576 10000<br>
=C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A03153824..4202399 =C2=A00 (315382=
4..4202399) 1048576 10000<br>
=C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A04202400..5250975 =C2=A00 (420240=
0..5250975) 1048576 10000<br>
=C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A05250976..6299551 =C2=A00 (525097=
6..6299551) 1048576 10000<br>
=C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A06299552..7348127 =C2=A00 (629955=
2..7348127) 1048576 10000<br>
=C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A07348128..8396703 =C2=A00 (734812=
8..8396703) 1048576 10000<br>
=C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A08396704..9445279 =C2=A00 (839670=
4..9445279) 1048576 10000<br>
=C2=A0 =C2=A00: [0..1048575]: =C2=A0 =C2=A09445280..10493855 =C2=A00 (94452=
80..10493855) 1048576 10000<br>
<br>
So all those files are contiguous both internally and externally. If<br>
there isn&#39;t sufficient contiguous freespace, or there is allocator<br>
contention, this won&#39;t happen - it&#39;s best effort behaviour....<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div>

--0016e6db7c6f1ac8b204ce066287--


--===============4036352453116340656==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4036352453116340656==--
