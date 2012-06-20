Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5KFUQ7d095908 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 10:30:30 -0500
Received: from mail-gh0-f181.google.com (mail-gh0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	HR1awAQ2qy7tVsKb (version=TLSv1 cipher=RC4-MD5 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Jun 2012 08:30:24 -0700 (PDT)
Received: by ghbz13 with SMTP id z13so7460280ghb.26
	for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 08:30:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120620060733.GB30705@dastard>
References: <CA+UH363THQXhT8bH8Mb8Hpz9kvMnWxhq4ToVg6uiwDFLN91VmA@mail.gmail.com>
	<20120619123624.GD16802@sgi.com> <20120620060733.GB30705@dastard>
Date: Wed, 20 Jun 2012 17:30:23 +0200
Message-ID: <CA+UH362RAQiuzZ+RZoy1Y+fWa4CjO10e=TNtvXf+jtDTriXsDw@mail.gmail.com>
Subject: Re: No space left on device
From: =?UTF-8?B?QW5kcsOpIMOYaWVuIExhbmd2YW5k?=
	<andre.oien.langvand@wimpmusic.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6810241343074854595=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============6810241343074854595==
Content-Type: multipart/alternative; boundary=e89a8fb1eef2e3223e04c2e913b5

--e89a8fb1eef2e3223e04c2e913b5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Thank you both for informative replies, much appreciated.

I ended up doing the tedious job of shuffling data around to get a more
reasonable distance to ENOSPC, as there was no way I could free up the
needed contiguous free space with my dataset.


Thanks,

Andr=C3=A9

On 20 June 2012 08:07, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Jun 19, 2012 at 07:36:24AM -0500, Geoffrey Wehrman wrote:
> > On Tue, Jun 19, 2012 at 02:05:34PM +0200, Andr=C3=A9 =C3=98ien Langvand=
 wrote:
> > | Hi,
> > |
> > | I know there are quite a few posts regarding similar issues around,
> but I
> > | can't seem to find a solution or at least an answer to why this is
> > | happening in my case, so I thought I'd try the mailing list and I hop=
e
> > | that's okay.
> > |
> > | We have 2 file servers with identical hardware and identical
> configuration
> > | (Dell R610's, H800 controllers, MD1200 DAS, RAID-5) set up with rsync
> to
> > | mirror the contents. The content is music in several formats (from PC=
M
> WAV
> > | to 64kbit AAC previews), which means file sizes of about 1 - 40mb. Bo=
th
> > | systems running SLES 11 SP1. Same kernel (2.6.32.59-0.3-default), sam=
e
> > | xfsprogs version (xfsprogs-3.1.1-0.1.36).
> > |
> > | My example partition on the source now has 9.9G (of 9.1T) available
> space
> > | and still doesn't report the drive as full. On the destination,
> however, it
> > | wont allow me to use any of the remaining 51G. This is obviously a
> problem
> > | when trying to do mirroring.
> > |
> > | Both file systems have been mounted with inode64 option since first
> mount,
> > | there are plenty of inodes available and I've also verified that ther=
e
> are
> > | noe sparse files (find -type f -printf "%S\t%p\n" 2>/dev/null | gawk
> '{if
> > | ($1 < 1.0) print $1 $2}'), just in case.
> > |
> > | I have tried repairing (xfs_repair), defragmenting (xfs_fsr) and alte=
r
> > | imaxpct without any luck. Rsync is run like this: # ionice -c3 rsync
> -rv
> > | --size-only --progress --delete-before --inplace.
> > |
> > |
> > | More detailed information on source file system:
> > |
> > | # df -k | grep sdg1
> > | /dev/sdg1            9762777052 9752457156  10319896 100%
> /content/raid31
> > |
> > | # df -i | grep sdg1
> > | /dev/sdg1            7471884 2311914 5159970   31% /content/raid31
> > |
> > | # xfs_info /dev/sdg1
> > | meta-data=3D/dev/sdg1              isize=3D2048   agcount=3D10,
> agsize=3D268435424
> > | blks
> > |          =3D                       sectsz=3D512   attr=3D2
> > | data     =3D                       bsize=3D4096   blocks=3D2441215991=
,
> imaxpct=3D5
> > |          =3D                       sunit=3D16     swidth=3D80 blks
> > | naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
> > | log      =3Dinternal               bsize=3D4096   blocks=3D521728, ve=
rsion=3D2
> > |          =3D                       sectsz=3D512   sunit=3D16 blks,
> lazy-count=3D1
> > | realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtexten=
ts=3D0
> > |
> > | # xfs_db -r "-c freesp -s" /dev/sdg1
> > |    from      to extents  blocks    pct
> > |       1       1   69981   69981   2.99
> > |       2       3  246574  559149  23.86
> > |       4       7  315038 1707929  72.88
> > |       8      15     561 6374 0.27
> > | total free extents 632154
> > | total free blocks 2343433
> > | average free extent size 3.70706
> > |
> > |
> > |
> > | More detailed information on destination file system:
> > |
> > | # df -k | grep sdj1
> > | /dev/sdj1            9762777052 9710148076  52628976 100%
> /content/sg08/vd08
> > |
> > | # df -i | grep sdj1
> > | /dev/sdj1            28622264 2307776 26314488    9% /content/sg08/vd=
08
> > |
> > | # xfs_info /dev/sdj1
> > | meta-data=3D/dev/sdj1              isize=3D2048   agcount=3D10,
> agsize=3D268435424
> > | blks
> > |          =3D                       sectsz=3D512   attr=3D2
> > | data     =3D                       bsize=3D4096   blocks=3D2441215991=
,
> imaxpct=3D5
> > |          =3D                       sunit=3D16     swidth=3D80 blks
> > | naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
> > | log      =3Dinternal               bsize=3D4096   blocks=3D521728, ve=
rsion=3D2
> > |          =3D                       sectsz=3D512   sunit=3D16 blks,
> lazy-count=3D1
> > | realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtexten=
ts=3D0
> > |
> > | # xfs_db -r "-c freesp -s" /dev/sdj1
> > |    from      to extents  blocks    pct
> > |       1       1   81761   81761   0.62
> > |       2       3  530258 1147719   8.73
> > |       4       7  675864 3551039  27.01
> > |       8      15  743089 8363043  63.62
> > |      16      31     102    1972   0.02
> > | total free extents 2031074
> > | total free blocks 13145534
> > | average free extent size 6.47221
> > |
> > |
> > | I would be grateful if anyone could shed some light on why this is
> > | happening or maybe even provide a solution.
> >
> > You are using 2 KiB inodes, so an inode cluster (64 inodes) requires
> > 128 KiB of contiguous space on disk.  The freesp output above shows tha=
t
> > the largest possible contiguous free space chunk available is 31 * 4 Ki=
B
> > or 4 KiB short of 128 KiB.  You don't have enough contiguous space to
> > create a new inode cluster, and your existing inodes are likely all
> > used.  This can be verified using xfs_db:
> >       xfs_db -r -c "sb" -c "p ifree" /dev/sdj1
> >
> > xfs_fsr does not defragment free space, it only makes the problem worse=
.
> > A possible solution:
> >   1.  mount the filesystem with the ikeep mount option
> >   2.  delete a few large files to free up some contiguous space
>
> large -contiguous- files. It's likely any files written recently
> will be as fragmented as the free space....
>
> >   3.  create a few thousand files to "preallocate" inodes
> >   4.  delete the newly created files
>
> That will work for a while, but it's really just a temporary
> workaround until those "preallocated" inodes are exhausted. Normally
> to recover from this situation you need to free 15-20% of the disk
> space to allow sufficiently large contiguous free space extents to
> reform naturally and allow the allocator to work at full efficiency
> again....
>
> > The ikeep mount option will prevent the space for inodes from being
> > reused for other purposes.
>
> The problem with using ikeep is that the remaining empty inode
> chunks prevent free space from defragmenting itself fully as you
> remove files from the filesystem.
>
> Realistically, I think the problem is that you are running your
> filesystems at near ENOSPC for extended periods of time. That is
> guaranteed to fragment free space and any files that are written
> when the filesytem is in this condition. As Geoffrey has said -
> xfs_fsr will not fix your problems - only changing the way you use
> your storage will prevent the problem from occurring again.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--e89a8fb1eef2e3223e04c2e913b5
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Thank you both for informative replies, much appreciated.<br><br>I ended up=
 doing the tedious job of=C2=A0shuffling=C2=A0data around to get a more rea=
sonable distance to ENOSPC, as there was no way I could free up the needed =
contiguous free space with my dataset.=C2=A0<div>
<br></div><div><br></div><div>Thanks,</div><div><br></div><div>Andr=C3=A9<b=
r><br><div class=3D"gmail_quote">On 20 June 2012 08:07, Dave Chinner <span =
dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">da=
vid@fromorbit.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On T=
ue, Jun 19, 2012 at 07:36:24AM -0500, Geoffrey Wehrman wrote:<br>
&gt; On Tue, Jun 19, 2012 at 02:05:34PM +0200, Andr=C3=A9 =C3=98ien Langvan=
d wrote:<br>
&gt; | Hi,<br>
&gt; |<br>
&gt; | I know there are quite a few posts regarding similar issues around, =
but I<br>
&gt; | can&#39;t seem to find a solution or at least an answer to why this =
is<br>
&gt; | happening in my case, so I thought I&#39;d try the mailing list and =
I hope<br>
&gt; | that&#39;s okay.<br>
&gt; |<br>
&gt; | We have 2 file servers with identical hardware and identical configu=
ration<br>
&gt; | (Dell R610&#39;s, H800 controllers, MD1200 DAS, RAID-5) set up with =
rsync to<br>
&gt; | mirror the contents. The content is music in several formats (from P=
CM WAV<br>
&gt; | to 64kbit AAC previews), which means file sizes of about 1 - 40mb. B=
oth<br>
&gt; | systems running SLES 11 SP1. Same kernel (2.6.32.59-0.3-default), sa=
me<br>
&gt; | xfsprogs version (xfsprogs-3.1.1-0.1.36).<br>
&gt; |<br>
&gt; | My example partition on the source now has 9.9G (of 9.1T) available =
space<br>
&gt; | and still doesn&#39;t report the drive as full. On the destination, =
however, it<br>
&gt; | wont allow me to use any of the remaining 51G. This is obviously a p=
roblem<br>
&gt; | when trying to do mirroring.<br>
&gt; |<br>
&gt; | Both file systems have been mounted with inode64 option since first =
mount,<br>
&gt; | there are plenty of inodes available and I&#39;ve also verified that=
 there are<br>
&gt; | noe sparse files (find -type f -printf &quot;%S\t%p\n&quot; 2&gt;/de=
v/null | gawk &#39;{if<br>
&gt; | ($1 &lt; 1.0) print $1 $2}&#39;), just in case.<br>
&gt; |<br>
&gt; | I have tried repairing (xfs_repair), defragmenting (xfs_fsr) and alt=
er<br>
&gt; | imaxpct without any luck. Rsync is run like this: # ionice -c3 rsync=
 -rv<br>
&gt; | --size-only --progress --delete-before --inplace.<br>
&gt; |<br>
&gt; |<br>
&gt; | More detailed information on source file system:<br>
&gt; |<br>
&gt; | # df -k | grep sdg1<br>
&gt; | /dev/sdg1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A09762777052 975245=
7156 =C2=A010319896 100% /content/raid31<br>
&gt; |<br>
&gt; | # df -i | grep sdg1<br>
&gt; | /dev/sdg1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A07471884 2311914 5=
159970 =C2=A0 31% /content/raid31<br>
&gt; |<br>
&gt; | # xfs_info /dev/sdg1<br>
&gt; | meta-data=3D/dev/sdg1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0isize=3D2048 =C2=A0 agcount=3D10, agsize=3D268435424<br>
&gt; | blks<br>
&gt; | =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 attr=
=3D2<br>
&gt; | data =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D2441215991, im=
axpct=3D5<br>
&gt; | =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sunit=3D16 =C2=A0 =C2=A0 s=
width=3D80 blks<br>
&gt; | naming =C2=A0 =3Dversion 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0bsize=3D4096 =C2=A0 ascii-ci=3D0<br>
&gt; | log =C2=A0 =C2=A0 =C2=A0=3Dinternal =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D521728, version=3D2<br>
&gt; | =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 sunit=
=3D16 blks, lazy-count=3D1<br>
&gt; | realtime =3Dnone =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 extsz=3D4096 =C2=A0 blocks=3D0, rtextents=3D0<br>
&gt; |<br>
&gt; | # xfs_db -r &quot;-c freesp -s&quot; /dev/sdg1<br>
&gt; | =C2=A0 =C2=A0from =C2=A0 =C2=A0 =C2=A0to extents =C2=A0blocks =C2=A0=
 =C2=A0pct<br>
&gt; | =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 69981 =C2=A0 69=
981 =C2=A0 2.99<br>
&gt; | =C2=A0 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 3 =C2=A0246574 =C2=A0559=
149 =C2=A023.86<br>
&gt; | =C2=A0 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 7 =C2=A0315038 1707929 =
=C2=A072.88<br>
&gt; | =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A015 =C2=A0 =C2=A0 <a href=
=3D"tel:561%20%20%20%206374%20%20%200.27" value=3D"+15616374027">561    637=
4   0.27</a><br>
&gt; | total free extents 632154<br>
&gt; | total free blocks 2343433<br>
&gt; | average free extent size 3.70706<br>
&gt; |<br>
&gt; |<br>
&gt; |<br>
&gt; | More detailed information on destination file system:<br>
&gt; |<br>
&gt; | # df -k | grep sdj1<br>
&gt; | /dev/sdj1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A09762777052 971014=
8076 =C2=A052628976 100% /content/sg08/vd08<br>
&gt; |<br>
&gt; | # df -i | grep sdj1<br>
&gt; | /dev/sdj1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A028622264 2307776 =
26314488 =C2=A0 =C2=A09% /content/sg08/vd08<br>
&gt; |<br>
&gt; | # xfs_info /dev/sdj1<br>
&gt; | meta-data=3D/dev/sdj1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0isize=3D2048 =C2=A0 agcount=3D10, agsize=3D268435424<br>
&gt; | blks<br>
&gt; | =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 attr=
=3D2<br>
&gt; | data =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D2441215991, im=
axpct=3D5<br>
&gt; | =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sunit=3D16 =C2=A0 =C2=A0 s=
width=3D80 blks<br>
&gt; | naming =C2=A0 =3Dversion 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0bsize=3D4096 =C2=A0 ascii-ci=3D0<br>
&gt; | log =C2=A0 =C2=A0 =C2=A0=3Dinternal =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D521728, version=3D2<br>
&gt; | =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 sunit=
=3D16 blks, lazy-count=3D1<br>
&gt; | realtime =3Dnone =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 extsz=3D4096 =C2=A0 blocks=3D0, rtextents=3D0<br>
&gt; |<br>
&gt; | # xfs_db -r &quot;-c freesp -s&quot; /dev/sdj1<br>
&gt; | =C2=A0 =C2=A0from =C2=A0 =C2=A0 =C2=A0to extents =C2=A0blocks =C2=A0=
 =C2=A0pct<br>
&gt; | =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 81761 =C2=A0 81=
761 =C2=A0 0.62<br>
&gt; | =C2=A0 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 3 =C2=A0530258 1147719 =
=C2=A0 8.73<br>
&gt; | =C2=A0 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 7 =C2=A0675864 3551039 =
=C2=A027.01<br>
&gt; | =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A015 =C2=A0743089 8363043 =
=C2=A063.62<br>
&gt; | =C2=A0 =C2=A0 =C2=A016 =C2=A0 =C2=A0 =C2=A031 =C2=A0 =C2=A0 102 =C2=
=A0 =C2=A01972 =C2=A0 0.02<br>
&gt; | total free extents 2031074<br>
&gt; | total free blocks 13145534<br>
&gt; | average free extent size 6.47221<br>
&gt; |<br>
&gt; |<br>
&gt; | I would be grateful if anyone could shed some light on why this is<b=
r>
&gt; | happening or maybe even provide a solution.<br>
&gt;<br>
&gt; You are using 2 KiB inodes, so an inode cluster (64 inodes) requires<b=
r>
&gt; 128 KiB of contiguous space on disk. =C2=A0The freesp output above sho=
ws that<br>
&gt; the largest possible contiguous free space chunk available is 31 * 4 K=
iB<br>
&gt; or 4 KiB short of 128 KiB. =C2=A0You don&#39;t have enough contiguous =
space to<br>
&gt; create a new inode cluster, and your existing inodes are likely all<br=
>
&gt; used. =C2=A0This can be verified using xfs_db:<br>
&gt; =C2=A0 =C2=A0 =C2=A0 xfs_db -r -c &quot;sb&quot; -c &quot;p ifree&quot=
; /dev/sdj1<br>
&gt;<br>
&gt; xfs_fsr does not defragment free space, it only makes the problem wors=
e.<br>
&gt; A possible solution:<br>
&gt; =C2=A0 1. =C2=A0mount the filesystem with the ikeep mount option<br>
&gt; =C2=A0 2. =C2=A0delete a few large files to free up some contiguous sp=
ace<br>
<br>
</div></div>large -contiguous- files. It&#39;s likely any files written rec=
ently<br>
will be as fragmented as the free space....<br>
<div class=3D"im"><br>
&gt; =C2=A0 3. =C2=A0create a few thousand files to &quot;preallocate&quot;=
 inodes<br>
&gt; =C2=A0 4. =C2=A0delete the newly created files<br>
<br>
</div>That will work for a while, but it&#39;s really just a temporary<br>
workaround until those &quot;preallocated&quot; inodes are exhausted. Norma=
lly<br>
to recover from this situation you need to free 15-20% of the disk<br>
space to allow sufficiently large contiguous free space extents to<br>
reform naturally and allow the allocator to work at full efficiency<br>
again....<br>
<div class=3D"im"><br>
&gt; The ikeep mount option will prevent the space for inodes from being<br=
>
&gt; reused for other purposes.<br>
<br>
</div>The problem with using ikeep is that the remaining empty inode<br>
chunks prevent free space from defragmenting itself fully as you<br>
remove files from the filesystem.<br>
<br>
Realistically, I think the problem is that you are running your<br>
filesystems at near ENOSPC for extended periods of time. That is<br>
guaranteed to fragment free space and any files that are written<br>
when the filesytem is in this condition. As Geoffrey has said -<br>
xfs_fsr will not fix your problems - only changing the way you use<br>
your storage will prevent the problem from occurring again.<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div>

--e89a8fb1eef2e3223e04c2e913b5--


--===============6810241343074854595==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6810241343074854595==--
