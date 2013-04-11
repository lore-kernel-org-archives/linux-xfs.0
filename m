Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 760207FE0
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 00:25:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 35344304043
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 22:25:28 -0700 (PDT)
Received: from mail-we0-f176.google.com (mail-we0-f176.google.com
	[74.125.82.176]) by cuda.sgi.com with ESMTP id T8xFQpzLTAMGX5tR
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 10 Apr 2013 22:25:25 -0700 (PDT)
Received: by mail-we0-f176.google.com with SMTP id s43so948093wey.35
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 22:25:24 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 11 Apr 2013 13:25:24 +0800
Message-ID: <CAPaMSRCGSyhmnjrXpFFkEpmKrjsHqLn0kJ1xLGyf-WZosV7mmQ@mail.gmail.com>
Subject: xfs_repair breaks with assertion
From: Victor K <kvic45@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8979335457917224016=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8979335457917224016==
Content-Type: multipart/alternative; boundary=089e010d85747b098304da0f03ec

--089e010d85747b098304da0f03ec
Content-Type: text/plain; charset=UTF-8

Hello,

I'm trying to repair an XFS file system on our mdadm raid6 array after
sudden system failure.
Running xfs_repair /dev/md1 the first time resulted in suggestion to
mount/unmount to replay log, but mounting would not work. After running
xfs_repair -v -L -P /dev/md1 this happens:
(lots of output on stderr, moving to Phase 3, then more output - not sure
if it is relevant, the log file is ~170Mb in size), then stops and prints
the only line on stdout:

xfs_repair: dinode.c:768: process_bmbt_reclist_int: Assertion `i <
*numrecs' failed.
Aborted

After inserting a printf before the assert, I get the following:

i = 0, *numrecs = -570425343  for printf( "%d, %d")
or
i= 0, *numrecs = 3724541953  for printf("%ld, %ld) - makes me wonder if
it's signed/unsigned int related

both trips on if(i>*numrecs) conditional

The filesystem size is 10Tb (7x2Tb disks in raid6) and it is about 8Tb full.

xfsprogs version is 3.1.10 compiled from git source this morning.

The system is Ubuntu 12.04.2 with kernel version 3.8.5.

When I try to run xfs_metadump, it crashes:
*** glibc detected *** xfs_db: double free or corruption (!prev):
0x0000000000da800
0 ***
======= Backtrace: =========
/lib/x86_64-linux-gnu/libc.so.6(+0x7eb96)[0x7f3d9501cb96]
xfs_db[0x417383]
xfs_db[0x41a941]
xfs_db[0x419030]
xfs_db[0x41a85c]
xfs_db[0x419030]
xfs_db[0x41b89e]
xfs_db[0x4050c0]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xed)[0x7f3d94fbf76d]
xfs_db[0x4051c5]
======= Memory map: ========
00400000-0046e000 r-xp 00000000 08:81 1837319
 /usr/sbin/
xfs_db
0066d000-0066e000 r--p 0006d000 08:81 1837319
 /usr/sbin/
xfs_db
0066e000-0066f000 rw-p 0006e000 08:81 1837319
 /usr/sbin/
xfs_db
0066f000-00682000 rw-p 00000000 00:00 0
00d63000-00dc4000 rw-p 00000000 00:00 0
 [heap]
7f3d94d88000-7f3d94d9d000 r-xp 00000000 08:81 2363486
 /lib/x86_64-linux-gnu/libgcc_s.so.1
7f3d94d9d000-7f3d94f9c000 ---p 00015000 08:81 2363486
 /lib/x86_64-linux-gnu/libgcc_s.so.1
7f3d94f9c000-7f3d94f9d000 r--p 00014000 08:81 2363486
 /lib/x86_64-linux-gnu/libgcc_s.so.1
7f3d94f9d000-7f3d94f9e000 rw-p 00015000 08:81 2363486
 /lib/x86_64-linux-gnu/libgcc_s.so.1
7f3d94f9e000-7f3d95153000 r-xp 00000000 08:81 2423054
 /lib/x86_64-linux-gnu/libc-2.15.so
7f3d95153000-7f3d95352000 ---p 001b5000 08:81 2423054
 /lib/x86_64-linux-gnu/libc-2.15.so
7f3d95352000-7f3d95356000 r--p 001b4000 08:81 2423054
 /lib/x86_64-linux-gnu/libc-2.15.so
7f3d95356000-7f3d95358000 rw-p 001b8000 08:81 2423054
 /lib/x86_64-linux-gnu/libc-2.15.so
7f3d95358000-7f3d9535d000 rw-p 00000000 00:00 0
7f3d9535d000-7f3d95375000 r-xp 00000000 08:81 2423056
 /lib/x86_64-linux-gnu/libpthread-2.15.so
7f3d95375000-7f3d95574000 ---p 00018000 08:81 2423056
 /lib/x86_64-linux-gnu/libpthread-2.15.so
7f3d95574000-7f3d95575000 r--p 00017000 08:81 2423056
 /lib/x86_64-linux-gnu/libpthread-2.15.so
7f3d95575000-7f3d95576000 rw-p 00018000 08:81 2423056
 /lib/x86_64-linux-gnu/libpthread-2.15.so
7f3d95576000-7f3d9557a000 rw-p 00000000 00:00 0
7f3d9557a000-7f3d9557e000 r-xp 00000000 08:81 2359972
 /lib/x86_64-linux-gnu/libuuid.so.1.3.0
7f3d9557e000-7f3d9577d000 ---p 00004000 08:81 2359972
 /lib/x86_64-linux-gnu/libuuid.so.1.3.0
7f3d9577d000-7f3d9577e000 r--p 00003000 08:81 2359972
 /lib/x86_64-linux-gnu/libuuid.so.1.3.0
7f3d9577e000-7f3d9577f000 rw-p 00004000 08:81 2359972
 /lib/x86_64-linux-gnu/libuuid.so.1.3.0
7f3d9577f000-7f3d957a1000 r-xp 00000000 08:81 2423068
 /lib/x86_64-linux-gnu/ld-2.15.so
7f3d957ba000-7f3d957fb000 rw-p 00000000 00:00 0
7f3d957fb000-7f3d95985000 r--p 00000000 08:81 1967430
 /usr/lib/locale/locale-archive
7f3d95985000-7f3d95989000 rw-p 00000000 00:00 0
7f3d9599d000-7f3d959a1000 rw-p 00000000 00:00 0
7f3d959a1000-7f3d959a2000 r--p 00022000 08:81 2423068
 /lib/x86_64-linux-gnu/ld-2.15.so
7f3d959a2000-7f3d959a4000 rw-p 00023000 08:81 2423068
 /lib/x86_64-linux-gnu/ld-2.15.so
7fffa80d8000-7fffa80f9000 rw-p 00000000 00:00 0
 [stack]
7fffa8170000-7fffa8171000 r-xp 00000000 00:00 0
 [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0
 [vsyscall]
Aborted

It produces a file of size 4325376 bytes - not sure if it's right, as I
read about sizes of 80Mb for the dump file.

If I try now (after running xfs_repair -L) to mount the fs read-only, it
mounts but says some directories have structures that need cleaning, so the
dirs are inaccessible.

Any suggestion on how to possibly fix this?

Thanks!
Victor

--089e010d85747b098304da0f03ec
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<div><br><div>I&#39;m trying to repair an XFS file s=
ystem on our mdadm raid6 array after sudden system failure.</div><div style=
>Running xfs_repair /dev/md1 the first time resulted in suggestion to mount=
/unmount to replay log, but mounting would not work. After running xfs_repa=
ir -v -L -P /dev/md1 this happens:</div>
<div style>(lots of output on stderr, moving to Phase 3, then more output -=
 not sure if it is relevant, the log file is ~170Mb in size), then stops an=
d prints the only line on stdout:</div><div style><br></div><div style>
<div>xfs_repair: dinode.c:768: process_bmbt_reclist_int: Assertion `i &lt; =
*numrecs&#39; failed.</div><div>Aborted</div><div><br></div><div style>Afte=
r inserting a printf before the assert, I get the following:</div><div styl=
e>
<br></div><div style>i =3D 0, *numrecs =3D -570425343 =C2=A0for printf( &qu=
ot;%d, %d&quot;)<br></div><div style>or</div><div style>i=3D 0, *numrecs =
=3D 3724541953 =C2=A0for printf(&quot;%ld, %ld) - makes me wonder if it&#39=
;s signed/unsigned int related<br>
</div><div style><br></div><div style>both trips on if(i&gt;*numrecs) condi=
tional</div><div style><br></div><div style>The filesystem size is 10Tb (7x=
2Tb disks in raid6) and it is about 8Tb full.</div><div style><br></div>
<div style>xfsprogs version is 3.1.10 compiled from git source this morning=
.</div><div style><br></div><div style>The system is Ubuntu 12.04.2 with ke=
rnel version 3.8.5.</div><div style><br></div><div style>When I try to run =
xfs_metadump, it crashes:</div>
<div style><div>*** glibc detected *** xfs_db: double free or corruption (!=
prev): 0x0000000000da800</div><div>0 ***</div><div>=3D=3D=3D=3D=3D=3D=3D Ba=
cktrace: =3D=3D=3D=3D=3D=3D=3D=3D=3D</div><div>/lib/x86_64-linux-gnu/libc.s=
o.6(+0x7eb96)[0x7f3d9501cb96]</div>
<div>xfs_db[0x417383]</div><div>xfs_db[0x41a941]</div><div>xfs_db[0x419030]=
</div><div>xfs_db[0x41a85c]</div><div>xfs_db[0x419030]</div><div>xfs_db[0x4=
1b89e]</div><div>xfs_db[0x4050c0]</div><div>/lib/x86_64-linux-gnu/libc.so.6=
(__libc_start_main+0xed)[0x7f3d94fbf76d]</div>
<div>xfs_db[0x4051c5]</div><div>=3D=3D=3D=3D=3D=3D=3D Memory map: =3D=3D=3D=
=3D=3D=3D=3D=3D</div><div>00400000-0046e000 r-xp 00000000 08:81 1837319 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0/usr/sbin/</div><div>xfs_db</div><div>0066d000-0066e000=
 r--p 0006d000 08:81 1837319 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/usr/sbin/</div>
<div>xfs_db</div><div>0066e000-0066f000 rw-p 0006e000 08:81 1837319 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0/usr/sbin/</div><div>xfs_db</div><div><div>0066f000-006820=
00 rw-p 00000000 00:00 0</div><div>00d63000-00dc4000 rw-p 00000000 00:00 0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[heap]</div>
<div>7f3d94d88000-7f3d94d9d000 r-xp 00000000 08:81 2363486 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/lib/x86_64-linux-gn=
u/libgcc_s.so.1</div><div>7f3d94d9d000-7f3d94f9c000 ---p 00015000 08:81 236=
3486 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/=
lib/x86_64-linux-gnu/libgcc_s.so.1</div>
<div>7f3d94f9c000-7f3d94f9d000 r--p 00014000 08:81 2363486 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/lib/x86_64-linux-gn=
u/libgcc_s.so.1</div><div>7f3d94f9d000-7f3d94f9e000 rw-p 00015000 08:81 236=
3486 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/=
lib/x86_64-linux-gnu/libgcc_s.so.1</div>
<div>7f3d94f9e000-7f3d95153000 r-xp 00000000 08:81 2423054 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/lib/x86_64-linux-gn=
u/<a href=3D"http://libc-2.15.so">libc-2.15.so</a></div><div>7f3d95153000-7=
f3d95352000 ---p 001b5000 08:81 2423054 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/lib/x86_64-linux-gnu/<a href=3D"http://l=
ibc-2.15.so">libc-2.15.so</a></div>
<div>7f3d95352000-7f3d95356000 r--p 001b4000 08:81 2423054 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/lib/x86_64-linux-gn=
u/<a href=3D"http://libc-2.15.so">libc-2.15.so</a></div><div>7f3d95356000-7=
f3d95358000 rw-p 001b8000 08:81 2423054 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/lib/x86_64-linux-gnu/<a href=3D"http://l=
ibc-2.15.so">libc-2.15.so</a></div>
<div>7f3d95358000-7f3d9535d000 rw-p 00000000 00:00 0</div><div>7f3d9535d000=
-7f3d95375000 r-xp 00000000 08:81 2423056 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/lib/x86_64-linux-gnu/<a href=3D"http=
://libpthread-2.15.so">libpthread-2.15.so</a> =C2=A0</div>
<div>7f3d95375000-7f3d95574000 ---p 00018000 08:81 2423056 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/lib/x86_64-linux-gn=
u/<a href=3D"http://libpthread-2.15.so">libpthread-2.15.so</a> =C2=A0</div>=
<div>7f3d95574000-7f3d95575000 r--p 00017000 08:81 2423056 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/lib/x86_64-linux-gn=
u/<a href=3D"http://libpthread-2.15.so">libpthread-2.15.so</a> =C2=A0</div>
<div>7f3d95575000-7f3d95576000 rw-p 00018000 08:81 2423056 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/lib/x86_64-linux-gn=
u/<a href=3D"http://libpthread-2.15.so">libpthread-2.15.so</a> =C2=A0</div>=
<div>7f3d95576000-7f3d9557a000 rw-p 00000000 00:00 0</div>
<div>7f3d9557a000-7f3d9557e000 r-xp 00000000 08:81 2359972 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/lib/x86_64-linux-gn=
u/libuuid.so.1.3.0</div><div>7f3d9557e000-7f3d9577d000 ---p 00004000 08:81 =
2359972 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0/lib/x86_64-linux-gnu/libuuid.so.1.3.0</div>
<div>7f3d9577d000-7f3d9577e000 r--p 00003000 08:81 2359972 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/lib/x86_64-linux-gn=
u/libuuid.so.1.3.0</div><div>7f3d9577e000-7f3d9577f000 rw-p 00004000 08:81 =
2359972 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0/lib/x86_64-linux-gnu/libuuid.so.1.3.0</div>
<div>7f3d9577f000-7f3d957a1000 r-xp 00000000 08:81 2423068 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/lib/x86_64-linux-gn=
u/<a href=3D"http://ld-2.15.so">ld-2.15.so</a></div><div>7f3d957ba000-7f3d9=
57fb000 rw-p 00000000 00:00 0</div><div>7f3d957fb000-7f3d95985000 r--p 0000=
0000 08:81 1967430 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0/usr/lib/locale/locale-archive</div>
<div>7f3d95985000-7f3d95989000 rw-p 00000000 00:00 0</div><div>7f3d9599d000=
-7f3d959a1000 rw-p 00000000 00:00 0</div><div>7f3d959a1000-7f3d959a2000 r--=
p 00022000 08:81 2423068 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0/lib/x86_64-linux-gnu/<a href=3D"http://ld-2.15.so">ld-=
2.15.so</a></div>
<div>7f3d959a2000-7f3d959a4000 rw-p 00023000 08:81 2423068 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/lib/x86_64-linux-gn=
u/<a href=3D"http://ld-2.15.so">ld-2.15.so</a></div><div>7fffa80d8000-7fffa=
80f9000 rw-p 00000000 00:00 0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[stack]</div>
<div>7fffa8170000-7fffa8171000 r-xp 00000000 00:00 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[vdso]=
</div><div>ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[vsyscall]</div><div=
>Aborted</div></div><div><br></div>
<div style>It produces a file of size=C2=A04325376 bytes - not sure if it&#=
39;s right, as I read about sizes of 80Mb for the dump file.</div><div styl=
e><br></div><div style>If I try now (after running xfs_repair -L) to mount =
the fs read-only, it mounts but says some directories have structures that =
need cleaning, so the dirs are inaccessible.</div>
<div style><br></div><div style>Any suggestion on how to possibly fix this?=
</div><div style><br></div><div style>Thanks!</div><div style>Victor</div><=
div style><br></div><div><br></div></div></div></div></div>

--089e010d85747b098304da0f03ec--


--===============8979335457917224016==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8979335457917224016==--
