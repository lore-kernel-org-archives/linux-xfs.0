Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 43D4C7F56
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2014 22:34:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 24267304051
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2014 20:34:38 -0700 (PDT)
Received: from mail-lb0-f170.google.com (mail-lb0-f170.google.com
	[209.85.217.170]) by cuda.sgi.com with ESMTP id
	PPHn9rf3pVMzCv8j (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 24 Aug 2014 20:34:36 -0700 (PDT)
Received: by mail-lb0-f170.google.com with SMTP id l4so11691299lbv.15
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2014 20:34:34 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 25 Aug 2014 11:34:34 +0800
Message-ID: <CAKEtwsWxZseS8M+O7vSR2FRXr4gjVQ0RDO8ok+jMPWq-8jPEeA@mail.gmail.com>
Subject: bad performance on touch/cp file on XFS system
From: Zhang Qiang <zhangqiang.buaa@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1725086763796259915=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1725086763796259915==
Content-Type: multipart/alternative; boundary=001a113471dc9df63d05016bdd04

--001a113471dc9df63d05016bdd04
Content-Type: text/plain; charset=UTF-8

Dear XFS community & developers,

I am using CentOS 6.3 and xfs as base file system and use RAID5 as hardware
storage.

Detail environment as follow:
   OS: CentOS 6.3
   Kernel: kernel-2.6.32-279.el6.x86_64
   XFS option info(df output): /dev/sdb1 on /data type xfs
(rw,noatime,nodiratime,nobarrier)

Detail phenomenon:

    # df
    Filesystem            Size  Used Avail Use% Mounted on
    /dev/sda1              29G   17G   11G  61% /
    /dev/sdb1             893G  803G   91G  90% /data
    /dev/sda4             2.2T  1.6T  564G  75% /data1

    # time touch /data1/1111
    real    0m23.043s
    user    0m0.001s
    sys     0m0.349s

    # perf top
    Events: 6K cycles
     16.96%  [xfs]                     [k] xfs_inobt_get_rec
     11.95%  [xfs]                     [k] xfs_btree_increment
     11.16%  [xfs]                     [k] xfs_btree_get_rec
      7.39%  [xfs]                     [k] xfs_btree_get_block
      5.02%  [xfs]                     [k] xfs_dialloc
      4.87%  [xfs]                     [k] xfs_btree_rec_offset
      4.33%  [xfs]                     [k] xfs_btree_readahead
      4.13%  [xfs]                     [k] _xfs_buf_find
      4.05%  [kernel]                  [k] intel_idle
      2.89%  [xfs]                     [k] xfs_btree_rec_addr
      1.04%  [kernel]                  [k] kmem_cache_free


It seems that some xfs kernel function spend much time (xfs_inobt_get_rec,
xfs_btree_increment, etc.)

I found a bug in bugzilla [1], is that is the same issue like this?

It's very greatly appreciated if you can give constructive suggestion about
this issue, as It's really hard to reproduce from another system and it's
not possible to do upgrade on that online machine.


[1] https://bugzilla.redhat.com/show_bug.cgi?format=multiple&id=813137

Thanks in advance
Qiang

--001a113471dc9df63d05016bdd04
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Dear XFS community &amp; developers,</div><div><br></=
div><div>I am using CentOS 6.3 and xfs as base file system and use RAID5 as=
 hardware storage.</div><div><br></div><div>Detail environment as follow:</=
div>
<div>=C2=A0 =C2=A0OS: CentOS 6.3</div><div>=C2=A0 =C2=A0Kernel: kernel-2.6.=
32-279.el6.x86_64</div><div>=C2=A0 =C2=A0XFS option info(df output): /dev/s=
db1 on /data type xfs (rw,noatime,nodiratime,nobarrier)</div><div><br></div=
><div>Detail phenomenon:</div>
<div>=C2=A0 =C2=A0=C2=A0</div><div>=C2=A0 =C2=A0 # df</div><div>=C2=A0 =C2=
=A0 Filesystem =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Size =C2=A0Used Ava=
il Use% Mounted on</div><div>=C2=A0 =C2=A0 /dev/sda1 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A029G =C2=A0 17G =C2=A0 11G =C2=A061% /</div><div>=
=C2=A0 =C2=A0 /dev/sdb1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 893G =C2=
=A0803G =C2=A0 91G =C2=A090% /data</div>
<div>=C2=A0 =C2=A0 /dev/sda4 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 2.2T=
 =C2=A01.6T =C2=A0564G =C2=A075% /data1</div><div>=C2=A0 =C2=A0=C2=A0</div>=
<div>=C2=A0 =C2=A0 # time touch /data1/1111</div><div>=C2=A0 =C2=A0 real =
=C2=A0 =C2=A00m23.043s</div><div>=C2=A0 =C2=A0 user =C2=A0 =C2=A00m0.001s</=
div><div>=C2=A0 =C2=A0 sys =C2=A0 =C2=A0 0m0.349s</div><div>=C2=A0 =C2=A0=
=C2=A0</div>
<div>=C2=A0 =C2=A0 # perf top</div><div>=C2=A0 =C2=A0 Events: 6K cycles</di=
v><div>=C2=A0 =C2=A0 =C2=A016.96% =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 [k] xfs_inobt_get_rec</div><div>=
=C2=A0 =C2=A0 =C2=A011.95% =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 [k] xfs_btree_increment</div><div>=C2=A0=
 =C2=A0 =C2=A011.16% =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 [k] xfs_btree_get_rec</div>
<div>=C2=A0 =C2=A0 =C2=A0 7.39% =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 [k] xfs_btree_get_block</div><div>=
=C2=A0 =C2=A0 =C2=A0 5.02% =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 [k] xfs_dialloc</div><div>=C2=A0 =C2=A0 =
=C2=A0 4.87% =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 [k] xfs_btree_rec_offset</div><div>=C2=A0 =C2=A0 =C2=
=A0 4.33% =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 [k] xfs_btree_readahead</div>
<div>=C2=A0 =C2=A0 =C2=A0 4.13% =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 [k] _xfs_buf_find</div><div>=C2=A0 =
=C2=A0 =C2=A0 4.05% =C2=A0[kernel] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0[k] intel_idle</div><div>=C2=A0 =C2=A0 =C2=A0 2.89%=
 =C2=A0[xfs] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 [k] xfs_btree_rec_addr</div><div>=C2=A0 =C2=A0 =C2=A0 1.04% =C2=A0[=
kernel] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[k] k=
mem_cache_free</div>
<div><br></div><div><br></div><div>It seems that some xfs kernel function s=
pend much time (xfs_inobt_get_rec, xfs_btree_increment, etc.)</div><div><br=
></div><div>I found a bug in bugzilla [1], is that is the same issue like t=
his?</div>
<div><br></div><div>It&#39;s very greatly appreciated if you can give const=
ructive suggestion about this issue, as It&#39;s really hard to reproduce f=
rom another system and it&#39;s not possible to do upgrade on that online m=
achine.</div>
<div><br></div><div><br></div><div>[1] <a href=3D"https://bugzilla.redhat.c=
om/show_bug.cgi?format=3Dmultiple&amp;id=3D813137">https://bugzilla.redhat.=
com/show_bug.cgi?format=3Dmultiple&amp;id=3D813137</a></div><div><br></div>=
<div>Thanks in advance</div>
<div>Qiang</div></div>

--001a113471dc9df63d05016bdd04--


--===============1725086763796259915==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1725086763796259915==--
