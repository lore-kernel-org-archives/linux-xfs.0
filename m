Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2OGRWXE060304 for <xfs@oss.sgi.com>; Sat, 24 Mar 2012 11:27:33 -0500
Received: from honeysuckle.london.02.net (honeysuckle.london.02.net
	[87.194.255.144]) by cuda.sgi.com with ESMTP id
	QebfoRiO14JsI0Fi for <xfs@oss.sgi.com>;
	Sat, 24 Mar 2012 09:27:29 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by honeysuckle.london.02.net
	(8.5.140)
	id 4F58EC1A00766E52 for xfs@oss.sgi.com; Sat, 24 Mar 2012 16:27:27 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1SBToH-0002JP-7e
	for <xfs@oss.sgi.com>; Sat, 24 Mar 2012 16:27:21 +0000
MIME-Version: 1.0
Message-ID: <20333.62951.784434.92213@tree.ty.sabi.co.UK>
Date: Sat, 24 Mar 2012 16:27:19 +0000
Subject: GNU 'tar', Schilling's 'tar', write-cache/barrier
In-Reply-To: <20333.8944.573177.821944@tree.ty.sabi.co.UK>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F6624A3.5010206@hardwarefreak.com>
	<20331.39194.377610.888636@tree.ty.sabi.co.UK>
	<201203232348.09158.Martin@lichtvoll.de>
	<20333.8944.573177.821944@tree.ty.sabi.co.UK>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@oss.sgi.com>

>> [ ... ] there has been quite some other metadata related
>> performance improvements. Thus IMHO reducing the recent
>> improvements in metadata performance is underselling XFS and
>> overselling delaylog. [ ... ]

> That's a good way of putting it, and I am pleased that I finally
> get a reasonable comment on this story, and one that agrees with
> one of my previous points in this thread: [ ... ]
[ ... ]
> http://xfs.org/images/d/d1/Xfs-scalability-lca2012.pdf
>  =AB* Ext4 can be up 20-50x times than XFS when data is also being
>     written as well (e.g. untarring kernel tarballs).
>   * This is XFS @ 2009-2010.
>   * Unless you have seriously fast storage, XFS just won't
>     perform well on metadata modification heavy workloads.=BB

> It is never mentioned that 'ext4' is 20-50x faster on metadata
> modification workloads because it implements much weaker
> semantics than =ABXFS @ 2009-2010=BB, and that 'delaylog' matches
> 'ext4' because it implements similarly weaker semantics, by
> reducing the frequency of commits, as the XFS FAQ briefly
> summarizes: [ ... ]

As to this, I have realized that there is a very big detail that
I have given for implicit but that perhaps at this point should
be made explicit as to the deliberately misleading propaganda
that =ABExt4 can be up 20-50x times than XFS when data is also
being written as well (e.g. untarring kernel tarballs).=BB:

  Almost all =ABuntarring kernel tarballs=BB "benchmarks" are done
  with GNU 'tar', and it does not 'fsync'.

This matters because XFS has done the "right thing" with 'fsync'
for a long time, and if the application does 'fsync' then 'ext4',
XFS without and with 'delaylog' are mostly equivalent.

Conversely Schilling's 'tar' does 'fsync' and as a result it is
often considered (by the gullible crowd to which the presentation
propaganda referred to above is addressed) to have less
"performance" than GNU 'tar'.

To illustrate I have done a tiny test '.tar' file with a
directory and two files within, and this is what happens with
Schilling's 'tar':

  $ strace -f -e trace=3Dfile,fsync,fdatasync,read,write star xf d.tar
  open("d.tar", O_RDONLY)                 =3D 7
  read(7, "d/\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0".=
.., 512) =3D 512
  Process 8201 attached
  [ ... ]
  [pid  8200] lstat("d/", 0x7fff174d9490) =3D -1 ENOENT (No such file or di=
rectory)
  [pid  8200] lstat("d/", 0x7fff174d9330) =3D -1 ENOENT (No such file or di=
rectory)
  [pid  8200] access("d", F_OK)           =3D -1 ENOENT (No such file or di=
rectory)
  [pid  8200] mkdir("d", 0700)            =3D 0
  [pid  8200] lstat("d/", {st_mode=3DS_IFDIR|0700, st_size=3D6, ...}) =3D 0
  [pid  8200] lstat("d/f1", 0x7fff174d9490) =3D -1 ENOENT (No such file or =
directory)
  [pid  8200] open("d/f1", O_WRONLY|O_CREAT|O_TRUNC, 0600) =3D 4
  [pid  8200] write(4, "3\275@&{U(\356\332\25z\250\236\256v\6U[5\334\265\31=
3\206:\351\335\366Q\21\231\210H"..., 128) =3D 128
  [pid  8200] fsync(4 <unfinished ...>
  [pid  8201] <... write resumed> )       =3D 1
  [pid  8201] read(7, "", 10240)          =3D 0
  Process 8201 detached
  <... fsync resumed> )                   =3D 0
  --- SIGCHLD (Child exited) @ 0 (0) ---
  utimes("d/f1", {{1332588240, 0}, {1332588240, 0}}) =3D 0
  utimes("d/f1", {{1332588240, 0}, {1332588240, 0}}) =3D 0
  lstat("d/f2", 0x7fff174d9490)           =3D -1 ENOENT (No such file or di=
rectory)
  open("d/f2", O_WRONLY|O_CREAT|O_TRUNC, 0600) =3D 4
  write(4, "\377\325\253\257,\210\2719e\24\347*P\325x\357\345\220\375Ei\375=
\355\22063\17\355\312.\6\347"..., 4096) =3D 4096
  fsync(4)                                =3D 0
  utimes("d/f2", {{1332588257, 0}, {1332588257, 0}}) =3D 0
  utimes("d/f2", {{1332588257, 0}, {1332588257, 0}}) =3D 0
  utimes("d", {{1332588242, 0}, {1332588242, 0}}) =3D 0
  write(2, "star: 1 blocks + 0 bytes (total "..., 58star: 1 blocks + 0 byte=
s (total of 10240 bytes =3D 10.00k).
  ) =3D 58

Compare with GNU 'tar':

  $ strace -f -e trace=3Dfile,fsync,fdatasync,read,write tar xf d.tar
  [ ... ]
  open("d.tar", O_RDONLY)                 =3D 3
  read(3, "d/\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0".=
.., 10240) =3D 10240
  [ ... ]
  mkdir("d", 0700)                        =3D -1 EEXIST (File exists)
  stat("d", {st_mode=3DS_IFDIR|0700, st_size=3D24, ...}) =3D 0
  open("d/f1", O_WRONLY|O_CREAT|O_EXCL, 0600) =3D -1 EEXIST (File exists)
  unlink("d/f1")                          =3D 0
  open("d/f1", O_WRONLY|O_CREAT|O_EXCL, 0600) =3D 4
  write(4, "3\275@&{U(\356\332\25z\250\236\256v\6U[5\334\265\313\206:\351\3=
35\366Q\21\231\210H"..., 128) =3D 128
  close(4)                                =3D 0
  utimensat(AT_FDCWD, "d/f1", {{1332589368, 193330071}, {1332588240, 0}}, 0=
) =3D 0
  open("d/f2", O_WRONLY|O_CREAT|O_EXCL, 0600) =3D -1 EEXIST (File exists)
  unlink("d/f2")                          =3D 0
  open("d/f2", O_WRONLY|O_CREAT|O_EXCL, 0600) =3D 4
  write(4, "\377\325\253\257,\210\2719e\24\347*P\325x\357\345\220\375Ei\375=
\355\22063\17\355\312.\6\347"..., 4096) =3D 4096
  close(4)                                =3D 0
  utimensat(AT_FDCWD, "d/f2", {{1332589368, 193330071}, {1332588257, 0}}, 0=
) =3D 0
  close(3)                                =3D 0
  utimensat(AT_FDCWD, "d", {{1332589368, 193330071}, {1332588242, 0}}, 0) =
=3D 0
  close(1)                                =3D 0
  close(2)                                =3D 0

In effect running GNU 'tar x' (GNU 'tar') is the same as running
'eatmydata tar x ...'; and indeed as its documentation says,
'eatmydata' is designed to achieve higher "performance" by
turning programs that behave like Schilling's 'tar' into programs
that behave like GNU 'tar'.

When GNU 'tar' is used as a "benchmark" for 'delaylog' and there
are no 'fsync's, the longer the interval between commits (and
thus the implicit unsafety) the higher the "performance", or at
least that's the argument I think propagandists and buffoons may
be using.

That's one important reason why I mentioned 'eatmydata' as one
performance enhancing technique in a group with 'nobarrier' and
'delaylog'; and why I was amused by this buffoonery:

 =ABSo you're comparing delaylog's volatile buffer architecture to
  software that *intentionally and transparently disables fsync*?=BB

Because when the 'delaylog' propagandists write that:

  =ABExt4 can be up 20-50x times than XFS when data is also being
   written as well (e.g. untarring kernel tarballs).=BB

it is them who are comparing "performance" using GNU 'tar' which
intentionally and transparently does not use at all 'fsync'.

To illustrate here are some "benchmarks", which hopefully should
be revealing as to the merit of the posturings of some of the
buffoons or propagandists that have been discontributing to this
discussion (note that there are somewhat subtle details both as
to the setup and the results):

--------------------------------------------------------------
#  uname -a
Linux base.ty.sabi.co.uk 2.6.18-274.18.1.el5 #1 SMP Thu Feb 9 12:20:03 EST =
2012 x86_64 x86_64 x86_64 GNU/Linux
#  egrep ' (/tmp|/tmp/(ext4|xfs))' /proc/mounts; sysctl vm | egrep '_(bytes=
|centisecs)' | sort
none /tmp tmpfs rw 0 0
/dev/sdd8 /tmp/xfs xfs rw,nouuid,attr2,inode64,logbsize=3D256k,sunit=3D8,sw=
idth=3D8,noquota 0 0
/dev/sdd3 /tmp/ext4 ext4 rw,barrier=3D1,data=3Dordered 0 0
vm.dirty_background_bytes =3D 900000000
vm.dirty_bytes =3D 500000000
vm.dirty_expire_centisecs =3D 2000
vm.dirty_writeback_centisecs =3D 1000
--------------------------------------------------------------
#  (cd /tmp/ext4; rm -rf linux-2.6.32; sync; time tar -x -f /tmp/linux-2.6.=
32.tar; egrep 'Dirty|Writeback' /proc/meminfo; time sync)

real    0m1.027s
user    0m0.105s
sys     0m0.922s
Dirty:          419700 kB
Writeback:           0 kB

real    0m5.163s
user    0m0.000s
sys     0m0.473s
--------------------------------------------------------------
#  (cd /tmp/ext4; rm -rf linux-2.6.32; sync; time star -no-fsync -x -f /tmp=
/linux-2.6.32.tar; egrep 'Dirty|Writeback' /proc/meminfo; time sync)
star: 37343 blocks + 0 bytes (total of 382392320 bytes =3D 373430.00k).

real    0m1.204s
user    0m0.139s
sys     0m1.270s
Dirty:          419456 kB
Writeback:           0 kB

real    0m5.012s
user    0m0.000s
sys     0m0.458s
--------------------------------------------------------------
#  (cd /tmp/ext4; rm -rf linux-2.6.32; sync; time star -x -f /tmp/linux-2.6=
.32.tar; egrep 'Dirty|Writeback' /proc/meminfo; time sync)
star: 37343 blocks + 0 bytes (total of 382392320 bytes =3D 373430.00k).

real    23m29.346s
user    0m0.327s
sys     0m2.280s
Dirty:             108 kB
Writeback:           0 kB

real    0m0.236s
user    0m0.000s
sys     0m0.199s
--------------------------------------------------------------
#  (cd /tmp/xfs; rm -rf linux-2.6.32; sync; time tar -x -f /tmp/linux-2.6.3=
2.tar; egrep 'Dirty|Writeback' /proc/meminfo; time sync)

real    0m46.554s
user    0m0.107s
sys     0m1.271s
Dirty:          415168 kB
Writeback:           0 kB

real    1m54.913s
user    0m0.000s
sys     0m0.325s
----------------------------------------------------------------
#  (cd /tmp/xfs; rm -rf linux-2.6.32; sync; time star -x -f /tmp/linux-2.6.=
32.tar; egrep 'Dirty|Writeback' /proc/meminfo; time sync)
star: 37343 blocks + 0 bytes (total of 382392320 bytes =3D 373430.00k).

real    60m15.723s
user    0m0.442s
sys     0m7.009s
Dirty:               4 kB
Writeback:           0 kB

real    0m0.222s
user    0m0.000s
sys     0m0.194s
----------------------------------------------------------------

>From the above my conclusion is that =ABXFS @ 2009-2010=BB half the
performance of 'ext4' on this workload, and that =ABExt4 can be up
20-50x times than XFS when data is also being written as well
(e.g. untarring kernel tarballs).=BB only when both data and
metadata are written to RAM by 'ext4'.

One can spend a lot of time changing parameters, as in using
'delaylog' or 'nobarrier' etc.

I have tried with my favourite rather "tighter" flusher
parameters, some comparisons that I find interesting:

----------------------------------------------------------------
#  egrep ' (/tmp|/tmp/(ext4|xfs))' /proc/mounts; sysctl vm | egrep '_(bytes=
|centisecs)' | sort
none /tmp tmpfs rw 0 0
/dev/sdd3 /tmp/ext4 ext4 rw,barrier=3D1,data=3Dordered 0 0
/dev/sdd8 /tmp/xfs xfs rw,nouuid,attr2,inode64,logbsize=3D256k,sunit=3D8,sw=
idth=3D8,noquota 0 0
vm.dirty_background_bytes =3D 900000000
vm.dirty_bytes =3D 100000
vm.dirty_expire_centisecs =3D 200
vm.dirty_writeback_centisecs =3D 100
#  (cd /tmp/ext4; rm -rf linux-2.6.32; sync; time tar -x -f /tmp/linux-2.6.=
32.tar; egrep 'Dirty|Writeback' /proc/meminfo; time sync)

real    0m6.776s
user    0m0.107s
sys     0m1.260s
Dirty:            1776 kB
Writeback:           0 kB

real    0m0.231s
user    0m0.000s
sys     0m0.197s
----------------------------------------------------------------
#  (cd /tmp/xfs; rm -rf linux-2.6.32; sync; time tar -x -f /tmp/linux-2.6.3=
2.tar; egrep 'Dirty|Writeback' /proc/meminfo; time sync)

real    2m25.805s
user    0m0.135s
sys     0m1.812s
Dirty:            2372 kB
Writeback:          84 kB

real    0m1.683s
user    0m0.000s
sys     0m0.196s
----------------------------------------------------------------

That's a bit of a surprise, because time to completion on both
when the flusher parameters allowed writing entirely to memory
for both with 'eatmydata tar' were the same. It looks like that
when flushing 'xfs' still does a fair bit of implicit metadata
commits, as switching off barriers shows:

----------------------------------------------------------------
#  mount -o remount,barrier=3D0 /dev/sdd8 /tmp/ext4
#  (cd /tmp/ext4; rm -rf linux-2.6.32; sync; time tar -x -f /tmp/linux-2.6.=
32.tar; egrep 'Dirty|Writeback' /proc/meminfo; time sync)

real    0m7.388s
user    0m0.127s
sys     0m1.235s
Dirty:             508 kB
Writeback:           0 kB

real    0m0.243s
user    0m0.000s
sys     0m0.199s
----------------------------------------------------------------
#  mount -o remount,nobarrier /dev/sdd3 /tmp/xfs
#  (cd /tmp/xfs; rm -rf linux-2.6.32; sync; time tar -x -f /tmp/linux-2.6.3=
2.tar; egrep 'Dirty|Writeback' /proc/meminfo; time sync)

real    0m31.047s
user    0m0.124s
sys     0m1.880s
Dirty:            2324 kB
Writeback:          24 kB

real    0m0.269s
user    0m0.000s
sys     0m0.195s
----------------------------------------------------------------

While it seems likely 'ext4' runs headlong without commits on
either metadata or data ('ext4' and 'ext3' in effect have a
rather loose 'delaylog'). XFS however seems to be a bit at a
disadvantage though as with 'nobarrier' and 'eatmydata tar' the
time to completion should be the same. The partition for XFS is
on inner tracks, but that does not make that much of a
difference.

Also compare with 'ext4' using 'eatmydata tar' with no barriers
and using 'star' with no barrier and also 'data=3Dwriteback':

----------------------------------------------------------------
  base#  umount /tmp/ext4; mount -t ext4 -o defaults,barrier=3D0,data=3Dwri=
teback /dev/sdd3 /tmp/ext4
  base#  (cd /tmp/ext4; rm -rf linux-2.6.32; sync; time tar -x -f /tmp/linu=
x-2.6.32.tar; egrep 'Dirty|Writeback' /proc/meminfo; time sync)

real    0m6.158s
user    0m0.123s
sys     0m1.233s
Dirty:            1704 kB
Writeback:           0 kB

real    0m0.247s
user    0m0.001s
sys     0m0.194s
----------------------------------------------------------------
  base#  (cd /tmp/ext4; rm -rf linux-2.6.32; sync; time star -x -f /tmp/lin=
ux-2.6.32.tar; egrep 'Dirty|Writeback' /proc/meminfo; time sync)
star: 37343 blocks + 0 bytes (total of 382392320 bytes =3D 373430.00k).

real    0m32.101s
user    0m0.196s
sys     0m1.718s
Dirty:              24 kB
Writeback:          48 kB

real    0m0.217s
user    0m0.000s
sys     0m0.193s
----------------------------------------------------------------

Finally here is on XFS, with 'delaylog', on a system with a
3.x kernel and a rather fast (especially on small random writes)
SSD drive (and my usual tighter flusher parameters):

----------------------------------------------------------------
#  uname -a
Linux.ty.sabi.co.UK 3.0.0-15-generic #26~lucid1-Ubuntu SMP Wed Jan 25 15:37=
:10 UTC 2012 x86_64 GNU/Linux
#  egrep ' (/tmp|/tmp/(ext4|xfs))' /proc/mounts; sysctl -a 2>/dev/null | eg=
rep '_(bytes|centisecs)' | sort
none /tmp tmpfs rw,relatime,size=3D1024000k 0 0
/dev/sda6 /tmp/xfs xfs rw,noatime,nodiratime,attr2,delaylog,discard,inode64=
,logbsize=3D256k,sunit=3D16,swidth=3D8192,noquota 0 0
/dev/sda3 /tmp/ext4 ext4 rw,nodiratime,relatime,errors=3Dremount-ro,user_xa=
ttr,acl,barrier=3D1,data=3Dordered,discard 0 0
fs.xfs.age_buffer_centisecs =3D 1500
fs.xfs.filestream_centisecs =3D 3000
fs.xfs.xfsbufd_centisecs =3D 100
fs.xfs.xfssyncd_centisecs =3D 3000
vm.dirty_background_bytes =3D 900000000
vm.dirty_bytes =3D 100000000
vm.dirty_expire_centisecs =3D 200
vm.dirty_writeback_centisecs =3D 100
----------------------------------------------------------------
#  (cd /tmp/xfs; rm -rf linux-2.6.32; sync; time tar -x -f /tmp/linux-2.6.3=
2.tar; egrep 'Dirty|Writeback' /proc/meminfo; time sync)

real    0m5.148s
user    0m0.300s
sys     0m2.876s
Dirty:             50052 kB
Writeback:             0 kB
WritebackTmp:          0 kB

real    0m0.784s
user    0m0.000s
sys     0m0.100s
----------------------------------------------------------------
#  (cd /tmp/xfs; rm -rf linux-2.6.32; sync; time star -x -f /tmp/linux-2.6.=
32.tar; egrep 'Dirty|Writeback' /proc/meminfo; time sync)
star: 37343 blocks + 0 bytes (total of 382392320 bytes =3D 373430.00k).

real    6m21.946s
user    0m0.808s
sys     0m11.321s
Dirty:                 0 kB
Writeback:             0 kB
WritebackTmp:          0 kB

real    0m0.097s
user    0m0.000s
sys     0m0.044s
----------------------------------------------------------------

The effect of 'delaylog' is pretty obvious there.

The numbers above with their wide variation depending on changes
in the level of safety requested amply demonstrate that it takes
the skills of a propagandist or a buffoon to boast about the
"performance" of 'delaylog' and comparisons with 'ext4' without
prominently mentioning the big safety tradeoffs involved.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
