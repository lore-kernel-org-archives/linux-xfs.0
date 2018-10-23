Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f176.google.com ([209.85.166.176]:54386 "EHLO
        mail-it1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbeJWQTR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Oct 2018 12:19:17 -0400
Received: by mail-it1-f176.google.com with SMTP id l191-v6so807149ita.4
        for <linux-xfs@vger.kernel.org>; Tue, 23 Oct 2018 00:57:03 -0700 (PDT)
MIME-Version: 1.0
From: Mao Cheng <chengmao2010@gmail.com>
Date: Tue, 23 Oct 2018 15:56:51 +0800
Message-ID: <CAGiyNfAUewzAjASPBccOk91PJ+nLS0nF4U3EvO4n59XsYu5P-w@mail.gmail.com>
Subject: xfs_alloc_ag_vextent_near() takes about 30ms to complete
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Sorry for trouble again. I just wrote wrong function name in previous
sending, so resend it.
If you have received previous email please ignore it, thanks

we have a XFS mkfs with "-k" and mount with the default options(
rw,relatime,attr2,inode64,noquota), the size is about 2.2TB=EF=BC=8Cand
exported via samba.

[root@test1 home]# xfs_info /dev/sdk
meta-data=3D/dev/sdk               isize=3D512    agcount=3D4, agsize=3D131=
072000 blks
         =3D                       sectsz=3D4096  attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D0 spinodes=3D0
data     =3D                       bsize=3D4096   blocks=3D524288000, imaxp=
ct=3D5
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D1
log      =3Dinternal               bsize=3D4096   blocks=3D256000, version=
=3D2
         =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

free space about allocation groups:
   from      to extents  blocks    pct
      1       1       9       9   0.00
      2       3   14291   29124   0.19
      4       7    5689   22981   0.15
      8      15     119    1422   0.01
     16      31  754657 15093035  99.65
     32      63       1      33   0.00
total free extents 774766
total free blocks 15146604
average free extent size 19.5499
   from      to extents  blocks    pct
      1       1     253     253   0.00
      2       3    7706   16266   0.21
      4       7    7718   30882   0.39
      8      15      24     296   0.00
     16      31  381976 7638130  96.71
     32      63     753   38744   0.49
 131072  262143       1  173552   2.20
total free extents 398431
total free blocks 7898123
average free extent size 19.8231
   from      to extents  blocks    pct
      1       1     370     370   0.00
      2       3    2704    5775   0.01
      4       7    1016    4070   0.01
      8      15      24     254   0.00
     16      31  546614 10931743  20.26
     32      63   19191 1112600   2.06
     64     127       2     184   0.00
 131072  262143       1  163713   0.30
 524288 1048575       2 1438626   2.67
1048576 2097151       4 5654463  10.48
2097152 4194303       1 3489060   6.47
4194304 8388607       2 12656637  23.46
16777216 33554431       1 18502975  34.29
total free extents 569932
total free blocks 53960470
average free extent size 94.6788
   from      to extents  blocks    pct
      1       1       8       8   0.00
      2       3    5566   11229   0.06
      4       7    9622   38537   0.21
      8      15      57     686   0.00
     16      31  747242 14944852  80.31
     32      63     570   32236   0.17
2097152 4194303       1 3582074  19.25
total free extents 763066
total free blocks 18609622
average free extent size 24.38

we copy small files(about 150kb) from windows to xfs via SMB protocal,
sometines  kworker process consumes 100% of one CPU, and "perf top"
shows xfs_extent_busy_trim() and xfs_btree_increment()  consume too much
cpu resources, ftrace also show xfs_alloc_ag_vextent_near takes about 30ms =
to
complete.

In addition all tests were performed on Centos7.4(3.10.0-693.el7.x86_64).

Any suggestions are welcome.
