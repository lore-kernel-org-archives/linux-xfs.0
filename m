Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D37FC7F5E
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 03:09:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C16B28F8037
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 01:09:11 -0700 (PDT)
Received: from mail-lb0-f170.google.com (mail-lb0-f170.google.com
	[209.85.217.170]) by cuda.sgi.com with ESMTP id
	Y4AT7H39jzpfrqjC (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Aug 2014 01:09:06 -0700 (PDT)
Received: by mail-lb0-f170.google.com with SMTP id l4so11833552lbv.1
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 01:09:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140825051801.GY26465@dastard>
References: <CAKEtwsWxZseS8M+O7vSR2FRXr4gjVQ0RDO8ok+jMPWq-8jPEeA@mail.gmail.com>
	<20140825051801.GY26465@dastard>
Date: Mon, 25 Aug 2014 16:09:05 +0800
Message-ID: <CAKEtwsWWoJ4QK1Od4WUT+hx7iFeX2bKfXk3QF9f2yG6vJ+TgxQ@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============4910201977608659339=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============4910201977608659339==
Content-Type: multipart/alternative; boundary=089e01493e8057e80405016fb33d

--089e01493e8057e80405016fb33d
Content-Type: text/plain; charset=UTF-8

Thanks for your quick and clear response. Some comments bellow:


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
[Qiang] This meas that if I want to fix this issue, I have to apply the
following patches and build my own kernel.

As the on-disk structure has been changed, so should I also re-create xfs
filesystem again? is there any user space tools to convert old disk
filesystem to new one, and don't need to backup and restore currently data?



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
[Qiang] Do you think if it's possible to just backport these patches to
kernel  6.2.32 (CentOS 6.3) to fix this issue?

Or it's better to backport to 3.10 kernel, used in CentOS 7.0?



> There's really not much you can do to avoid the problem once you've
> punched random freespace holes in the allocated inode btree. IT
> generally doesn't affect many people; those that it does affect are
> normally using XFS as an object store indexed by a hard link farm
> (e.g. various backup programs do this).
>
OK, I see.

Could you please guide me to reproduce this issue easily? as I have tried
to use a 500G xfs partition, and use about 98 % spaces, but still can't
reproduce this issue. Is there any easy way from your mind?


> If you dump the superblock via xfs_db, the difference between icount
> and ifree will give you idea of how much "needle in a haystack"
> searching is going on. You can probably narrow it down to a specific
> AG by dumping the AGI headers and checking the same thing. filling
> in all the holes (by creating a bunch of zero length files in the
> appropriate AGs) might take some time, but it should make the
> problem go away until you remove more filesystem and create random
> free inode holes again...
>

I will try to investigate the detail issue.

Thanks for your kindly response.
Qiang


>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--089e01493e8057e80405016fb33d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks for your quick and clear response. Some comments be=
llow:<br><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">2014=
-08-25 13:18 GMT+08:00 Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto=
:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span>:=
<br>
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
</div></div>No.<br></blockquote><div>=C2=A0</div><blockquote class=3D"gmail=
_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:=
1ex">
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
new on-disk free inode btree index:<br></blockquote><div>[Qiang] This meas =
that if I want to fix this issue, I have to apply the following patches and=
 build my own kernel.</div><div><br></div><div>As the on-disk structure has=
 been changed, so should I also re-create xfs filesystem again? is there an=
y user space tools to convert old disk filesystem to new one, and don&#39;t=
 need to backup and restore currently data?</div>
<div><br></div><div>=C2=A0<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
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
any CentOS kernel.<br></blockquote><div>[Qiang] Do you think if it&#39;s po=
ssible to just backport these patches to kernel =C2=A06.2.32 (CentOS 6.3) t=
o fix this issue?</div><div><br></div><div>Or it&#39;s better to backport t=
o 3.10 kernel, used in CentOS 7.0?</div>
<div><br></div><div><br></div><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
There&#39;s really not much you can do to avoid the problem once you&#39;ve=
<br>
punched random freespace holes in the allocated inode btree. IT<br>
generally doesn&#39;t affect many people; those that it does affect are<br>
normally using XFS as an object store indexed by a hard link farm<br>
(e.g. various backup programs do this).<br></blockquote><div>OK, I see.</di=
v><div><br></div><div>Could you please guide me to reproduce this issue eas=
ily? as I have tried to use a 500G xfs partition, and use about 98 % spaces=
, but still can&#39;t reproduce this issue. Is there any easy way from your=
 mind?</div>
<div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex=
;border-left:1px #ccc solid;padding-left:1ex">
<br>
If you dump the superblock via xfs_db, the difference between icount<br>
and ifree will give you idea of how much &quot;needle in a haystack&quot;<b=
r>
searching is going on. You can probably narrow it down to a specific<br>
AG by dumping the AGI headers and checking the same thing. filling<br>
in all the holes (by creating a bunch of zero length files in the<br>
appropriate AGs) might take some time, but it should make the<br>
problem go away until you remove more filesystem and create random<br>
free inode holes again...<br></blockquote><div>=C2=A0</div><div>I will try =
to investigate the detail issue.</div><div><br></div><div>Thanks for your k=
indly response.</div><div>Qiang</div><div>=C2=A0</div><blockquote class=3D"=
gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-=
left:1ex">

<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div></div>

--089e01493e8057e80405016fb33d--


--===============4910201977608659339==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4910201977608659339==--
