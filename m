Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f181.google.com ([209.85.166.181]:39244 "EHLO
        mail-it1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbeJXL11 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Oct 2018 07:27:27 -0400
Received: by mail-it1-f181.google.com with SMTP id m15so4770068itl.4
        for <linux-xfs@vger.kernel.org>; Tue, 23 Oct 2018 20:01:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAGiyNfAUewzAjASPBccOk91PJ+nLS0nF4U3EvO4n59XsYu5P-w@mail.gmail.com>
 <20181023145339.GA7537@bfoster>
In-Reply-To: <20181023145339.GA7537@bfoster>
From: Mao Cheng <chengmao2010@gmail.com>
Date: Wed, 24 Oct 2018 11:01:13 +0800
Message-ID: <CAGiyNfAy+eTq+oba0Rb8Oe_kajFqD5a6rPnOkWPjC_E=foSqkg@mail.gmail.com>
Subject: Re: xfs_alloc_ag_vextent_near() takes about 30ms to complete
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bfoster@redhat.com
Cc: linux-xfs@vger.kernel.org

Hi Brian,
Thanks for your response.
Brian Foster <bfoster@redhat.com> =E4=BA=8E2018=E5=B9=B410=E6=9C=8823=E6=97=
=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=8810:53=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Oct 23, 2018 at 03:56:51PM +0800, Mao Cheng wrote:
> > Sorry for trouble again. I just wrote wrong function name in previous
> > sending, so resend it.
> > If you have received previous email please ignore it, thanks
> >
> > we have a XFS mkfs with "-k" and mount with the default options(
> > rw,relatime,attr2,inode64,noquota), the size is about 2.2TB=EF=BC=8Cand
> > exported via samba.
> >
> > [root@test1 home]# xfs_info /dev/sdk
> > meta-data=3D/dev/sdk               isize=3D512    agcount=3D4, agsize=
=3D131072000 blks
> >          =3D                       sectsz=3D4096  attr=3D2, projid32bit=
=3D1
> >          =3D                       crc=3D1        finobt=3D0 spinodes=
=3D0
> > data     =3D                       bsize=3D4096   blocks=3D524288000, i=
maxpct=3D5
> >          =3D                       sunit=3D0      swidth=3D0 blks
> > naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D=
1
> > log      =3Dinternal               bsize=3D4096   blocks=3D256000, vers=
ion=3D2
> >          =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-=
count=3D1
> > realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
> >
> > free space about allocation groups:
> >    from      to extents  blocks    pct
> >       1       1       9       9   0.00
> >       2       3   14291   29124   0.19
> >       4       7    5689   22981   0.15
> >       8      15     119    1422   0.01
> >      16      31  754657 15093035  99.65
> >      32      63       1      33   0.00
> > total free extents 774766
> > total free blocks 15146604
> > average free extent size 19.5499
> >    from      to extents  blocks    pct
> >       1       1     253     253   0.00
> >       2       3    7706   16266   0.21
> >       4       7    7718   30882   0.39
> >       8      15      24     296   0.00
> >      16      31  381976 7638130  96.71
> >      32      63     753   38744   0.49
> >  131072  262143       1  173552   2.20
> > total free extents 398431
> > total free blocks 7898123
> > average free extent size 19.8231
> >    from      to extents  blocks    pct
> >       1       1     370     370   0.00
> >       2       3    2704    5775   0.01
> >       4       7    1016    4070   0.01
> >       8      15      24     254   0.00
> >      16      31  546614 10931743  20.26
> >      32      63   19191 1112600   2.06
> >      64     127       2     184   0.00
> >  131072  262143       1  163713   0.30
> >  524288 1048575       2 1438626   2.67
> > 1048576 2097151       4 5654463  10.48
> > 2097152 4194303       1 3489060   6.47
> > 4194304 8388607       2 12656637  23.46
> > 16777216 33554431       1 18502975  34.29
> > total free extents 569932
> > total free blocks 53960470
> > average free extent size 94.6788
> >    from      to extents  blocks    pct
> >       1       1       8       8   0.00
> >       2       3    5566   11229   0.06
> >       4       7    9622   38537   0.21
> >       8      15      57     686   0.00
> >      16      31  747242 14944852  80.31
> >      32      63     570   32236   0.17
> > 2097152 4194303       1 3582074  19.25
> > total free extents 763066
> > total free blocks 18609622
> > average free extent size 24.38
> >
>
> So it looks like free space in 3 out of 4 AGs is mostly fragmented to
> 16-31 block extents. Those same AGs appear to have a much higher number
> (~15k-20k) of even smaller extents.
>
> > we copy small files(about 150kb) from windows to xfs via SMB protocal,
> > sometines  kworker process consumes 100% of one CPU, and "perf top"
> > shows xfs_extent_busy_trim() and xfs_btree_increment()  consume too muc=
h
> > cpu resources, ftrace also show xfs_alloc_ag_vextent_near takes about 3=
0ms to
> > complete.
> >
>
> This is kind of a vague performance report. Some process consumes a full
> CPU and this is a problem for some (??) reason given unknown CPU and
> unknown storage (with unknown amount of RAM). I assume that kworker task
> is writeback, but you haven't really specified that either.
yes, the kworker task is writeback, and the storage is XFS-formatted disk
that is alos the target we copy files to.

>
> xfs_alloc_ag_vextent_near() is one of the several block allocation
> algorithms in XFS. That function itself includes a couple different
> algorithms for the "near" allocation based on the state of the AG. One
> looks like an intra-block search of the by-size free space btree (if not
> many suitably sized extents are available) and the second looks like an
> outward sweep of the by-block free space btree to find a suitably sized
> extent. I could certainly see the latter taking some time for certain
> sized allocation requests under fragmented free space conditions. If you
> wanted more detail over what's going on here, I'd suggest to capture a
> sample of the xfs_alloc* (and perhaps xfs_extent_busy*) tracepoints
> during the workload.
>
> That aside, it's probably best to step back and describe for the list
> the overall environment, workload and performance problem you observed
> that caused this level of digging in the first place. For example, has
> throughput degraded over time? Latency increased? How many writers are
> active at once? Is preallocation involved (I thought Samba/Windows
> triggered it certain cases, but I don't recall)?
We share an xfs filesystem to windows via SMB protocol.
There are about 5 windows copy small files to the samba share at the same t=
ime.
The main problem is the throughput degraded from 30MB/s to around
10KB/s periodically and recovered about 5s later.
The kworker consumes 100% of one CPU when the throughput degraded and
kworker task is wrteback.
/proc/vmstat shows nr_dirty is very close to nr_dirty_threshold
and nr_writeback is too small(is that means there too many dirty pages
in page cache and can't be written out to disk?)

Mao
>
> Brian
>
> > In addition all tests were performed on Centos7.4(3.10.0-693.el7.x86_64=
).
> >
> > Any suggestions are welcome.
