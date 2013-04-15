Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1342A7F4C
	for <xfs@oss.sgi.com>; Sun, 14 Apr 2013 21:08:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7945CAC001
	for <xfs@oss.sgi.com>; Sun, 14 Apr 2013 19:08:33 -0700 (PDT)
Received: from mail-ia0-f180.google.com (mail-ia0-f180.google.com
	[209.85.210.180]) by cuda.sgi.com with ESMTP id
	etDS0CNn1O8EXSMF (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 14 Apr 2013 19:08:28 -0700 (PDT)
Received: by mail-ia0-f180.google.com with SMTP id l29so3853447iag.39
	for <xfs@oss.sgi.com>; Sun, 14 Apr 2013 19:08:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADFMGuKH_jYhuxzMQ_4mj_Zv4EgPfpuBYR=fpqBfJPWf=POJPQ@mail.gmail.com>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
	<CADFMGuKqkPbpcU=taqjTR4sA3o=w1LLAnKoEuj=OhJqEbQVijw@mail.gmail.com>
	<20130409145238.GE22182@sgi.com>
	<CADFMGuJaiH0wuxOHrDjDn7qRVH+vQkLOOSPUyqSdXnLcS47t3w@mail.gmail.com>
	<CADFMGu+TdyjTjMTWMwpdHqmszhpCU162UA4Y-njARwSEjM1xNw@mail.gmail.com>
	<20130410121025.78a42b22@harpe.intellique.com>
	<CADFMGu+yCg4ux0n6S98bqm_cXc=VCcijVBTqwRxvxmtKt_JO-A@mail.gmail.com>
	<CADFMGuLxgBFU=FUK94tPsCh+qxRW0rEELxSXYoMQLFJ1u3=q0Q@mail.gmail.com>
	<516746AC.3090808@redhat.com>
	<CADFMGuK-tJQFQzN9wN0LiWWj6SY4tg_c0W9dJadctg=ytegB+w@mail.gmail.com>
	<516798AE.9050908@sandeen.net>
	<CADFMGuK67G85+J3LAjS=w_nkkSrj7At9HnPLSL-DBO6g0V=ThA@mail.gmail.com>
	<CADFMGuLNmSpA+e2Wo0qS5y2evQM=q_oVJJPf6kZkfAP4jfk=6w@mail.gmail.com>
	<CADFMGuJoar_uKB_Lrq0nKFsbdjyZWFaHXU-ni2ky3sToSQwUSQ@mail.gmail.com>
	<516800F7.80502@redhat.com>
	<CADFMGuKH_jYhuxzMQ_4mj_Zv4EgPfpuBYR=fpqBfJPWf=POJPQ@mail.gmail.com>
Date: Mon, 15 Apr 2013 10:08:27 +0800
Message-ID: <CADFMGuJmNLTcyb4aQmbto--dgFBgP55QWeaP+grAoPL+q8eRCg@mail.gmail.com>
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
From: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7409544759333341789=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Ben Myers <bpm@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============7409544759333341789==
Content-Type: multipart/alternative; boundary=14dae9340ee7841fc504da5cba9a

--14dae9340ee7841fc504da5cba9a
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Dear xfs experts,
Now I'm deploying Brian's system script in out cluster. But from last night
till now 5 servers in our 24 servers xfs shutdown with the same error. I
run xfs_repair command and found all the lost inodes are glusterfs dht link
files. This explains why the xfs shutdown tend to happen during glusterfs
rebalance. During glusterfs rebalance procedure a lot of dhk link files may
be unlinked. For example the following inodes are found in lost+found in
one of the servers:
[root@* lost+found]# pwd
/mnt/xfsd/lost+found
[root@* lost+found]# ls -l
total 740
---------T 1 root root 0 Apr  8 21:06 100119
---------T 1 root root 0 Apr  8 21:11 101123
---------T 1 root root 0 Apr  8 21:19 102659
---------T 1 root root 0 Apr 12 14:46 1040919
---------T 1 root root 0 Apr 12 14:58 1041943
---------T 1 root root 0 Apr  8 21:32 105219
---------T 1 root root 0 Apr  8 21:37 105731
---------T 1 root root 0 Apr 12 17:48 1068055
---------T 1 root root 0 Apr 12 18:38 1073943
---------T 1 root root 0 Apr  8 21:54 108035
---------T 1 root root 0 Apr 12 21:49 1091095
---------T 1 root root 0 Apr 13 00:17 1111063
---------T 1 root root 0 Apr 13 03:51 1121815
---------T 1 root root 0 Apr  8 22:25 112387
---------T 1 root root 0 Apr 13 06:39 1136151
...
[root@* lost+found]# getfattr -m . -d -e hex *

# file: 96007
trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000000000000000
trusted.afr.mams-cq-mt-video-client-4=3D0x000000000000000000000000
trusted.afr.mams-cq-mt-video-client-5=3D0x000000000000000000000000
trusted.gfid=3D0xa0370d8a9f104dafbebbd0e6dd7ce1f7
trusted.glusterfs.dht.linkto=3D0x6d616d732d63712d6d742d766964656f2d7265706c=
69636174652d3600
trusted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x000=
0000049dff000

# file: 97027
trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000000000000000
trusted.afr.mams-cq-mt-video-client-4=3D0x000000000000000000000000
trusted.afr.mams-cq-mt-video-client-5=3D0x000000000000000000000000
trusted.gfid=3D0xc1c1fe2ec7034442a623385f43b04c25
trusted.glusterfs.dht.linkto=3D0x6d616d732d63712d6d742d766964656f2d7265706c=
69636174652d3600
trusted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x000=
000006ac78000

# file: 97559
trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000000000000000
trusted.afr.mams-cq-mt-video-client-4=3D0x000000000000000000000000
trusted.afr.mams-cq-mt-video-client-5=3D0x000000000000000000000000
trusted.gfid=3D0xcf7c17013c914511bda4d1c743fae118
trusted.glusterfs.dht.linkto=3D0x6d616d732d63712d6d742d766964656f2d7265706c=
69636174652d3500
trusted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x000=
00000519fb000

# file: 98055
trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000000000000000
trusted.afr.mams-cq-mt-video-client-4=3D0x000000000000000000000000
trusted.afr.mams-cq-mt-video-client-5=3D0x000000000000000000000000
trusted.gfid=3D0xe86abc6e2c4b44c28d415fbbe34f2102
trusted.glusterfs.dht.linkto=3D0x6d616d732d63712d6d742d766964656f2d7265706c=
69636174652d3600
trusted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x000=
000004c098000

# file: 98567
trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000000000000000
trusted.afr.mams-cq-mt-video-client-4=3D0x000000000000000000000000
trusted.afr.mams-cq-mt-video-client-5=3D0x000000000000000000000000
trusted.gfid=3D0x12543a2efbdf4b9fa61c6d89ca396f80
trusted.glusterfs.dht.linkto=3D0x6d616d732d63712d6d742d766964656f2d7265706c=
69636174652d3500
trusted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x000=
000006bc98000

# file: 98583
trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000000000000000
trusted.afr.mams-cq-mt-video-client-4=3D0x000000000000000000000000
trusted.afr.mams-cq-mt-video-client-5=3D0x000000000000000000000000
trusted.gfid=3D0x760d16d3b7974cfb9c0a665a0982c470
trusted.glusterfs.dht.linkto=3D0x6d616d732d63712d6d742d766964656f2d7265706c=
69636174652d3500
trusted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x000=
000006cde9000

# file: 99607
trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000000000000000
trusted.afr.mams-cq-mt-video-client-4=3D0x000000000000000000000000
trusted.afr.mams-cq-mt-video-client-5=3D0x000000000000000000000000
trusted.gfid=3D0x0849a732ea204bc3b8bae830b46881da
trusted.glusterfs.dht.linkto=3D0x6d616d732d63712d6d742d766964656f2d7265706c=
69636174652d3500
trusted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x000=
00000513f1000
...

What do you think about it? Thank you very much.


2013/4/12 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>

> Hi Brian,
>
> Your scripts works for me now after I installed all the rpm built out fro=
m
> kernel srpm. I'll try it. Thank you.
>
>
> 2013/4/12 Brian Foster <bfoster@redhat.com>
>
>> On 04/12/2013 04:32 AM, =B7=FB=D3=C0=CC=CE wrote:
>> > Dear xfs experts,
>> > Can I just call xfs_stack_trace(); in the second line of
>> > xfs_do_force_shutdown() to print stack and rebuild kernel to check
>> > what's the error?
>> >
>>
>> I suppose that's a start. If you're willing/able to create and run a
>> modified kernel for the purpose of collecting more debug info, perhaps
>> we can get a bit more creative in collecting more data on the problem
>> (but a stack trace there is a good start).
>>
>> BTW- you might want to place the call after the XFS_FORCED_SHUTDOWN(mp)
>> check almost halfway into the function to avoid duplicate messages.
>>
>> Brian
>>
>> >
>> > 2013/4/12 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com <mailto:yongtaofu@gm=
ail.com>>
>> >
>> >     Hi Brian,
>> >     What else I'm missing? Thank you.
>> >     stap -e 'probe module("xfs").function("xfs_iunlink"){}'
>> >
>> >     WARNING: cannot find module xfs debuginfo: No DWARF information
>> found
>> >     semantic error: no match while resolving probe point
>> >     module("xfs").function("xfs_iunlink")
>> >     Pass 2: analysis failed.  Try again with another '--vp 01' option.
>> >
>> >
>> >     2013/4/12 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com <mailto:yongtaof=
u@gmail.com>>
>> >
>> >         ls -l
>> >
>> /usr/lib/debug/lib/modules/2.6.32-279.el6.x86_64/kernel/fs/xfs/xfs.ko.de=
bug
>> >         -r--r--r-- 1 root root 21393024 Apr 12 12:08
>> >
>> /usr/lib/debug/lib/modules/2.6.32-279.el6.x86_64/kernel/fs/xfs/xfs.ko.de=
bug
>> >
>> >         rpm -qa|grep  kernel
>> >         kernel-headers-2.6.32-279.el6.x86_64
>> >         kernel-devel-2.6.32-279.el6.x86_64
>> >         kernel-2.6.32-358.el6.x86_64
>> >         kernel-debuginfo-common-x86_64-2.6.32-279.el6.x86_64
>> >         abrt-addon-kerneloops-2.0.8-6.el6.x86_64
>> >         kernel-firmware-2.6.32-358.el6.noarch
>> >         kernel-debug-2.6.32-358.el6.x86_64
>> >         kernel-debuginfo-2.6.32-279.el6.x86_64
>> >         dracut-kernel-004-283.el6.noarch
>> >         libreport-plugin-kerneloops-2.0.9-5.el6.x86_64
>> >         kernel-devel-2.6.32-358.el6.x86_64
>> >         kernel-2.6.32-279.el6.x86_64
>> >
>> >         rpm -q kernel-debuginfo
>> >         kernel-debuginfo-2.6.32-279.el6.x86_64
>> >
>> >         rpm -q kernel
>> >         kernel-2.6.32-279.el6.x86_64
>> >         kernel-2.6.32-358.el6.x86_64
>> >
>> >         do I need to re probe it?
>> >
>> >
>> >         2013/4/12 Eric Sandeen <sandeen@sandeen.net
>> >         <mailto:sandeen@sandeen.net>>
>> >
>> >             On 4/11/13 11:32 PM, =B7=FB=D3=C0=CC=CE wrote:
>> >             > Hi Brian,
>> >             > Sorry but when I execute the script it says:
>> >             > WARNING: cannot find module xfs debuginfo: No DWARF
>> >             information found
>> >             > semantic error: no match while resolving probe point
>> >             module("xfs").function("xfs_iunlink")
>> >             >
>> >             > uname -a
>> >             > 2.6.32-279.el6.x86_64
>> >             > kernel debuginfo has been installed.
>> >             >
>> >             > Where can I find the correct xfs debuginfo?
>> >
>> >             it should be in the kernel-debuginfo rpm (of the same
>> >             version/release as the kernel rpm you're running)
>> >
>> >             You should have:
>> >
>> >
>> /usr/lib/debug/lib/modules/2.6.32-279.el6.x86_64/kernel/fs/xfs/xfs.ko.de=
bug
>> >
>> >             If not, can you show:
>> >
>> >             # uname -a
>> >             # rpm -q kernel
>> >             # rpm -q kernel-debuginfo
>> >
>> >             -Eric
>> >
>> >
>> >
>> >
>> >
>> >         --
>> >         =B7=FB=D3=C0=CC=CE
>> >
>> >
>> >
>> >
>> >     --
>> >     =B7=FB=D3=C0=CC=CE
>> >
>> >
>> >
>> >
>> > --
>> > =B7=FB=D3=C0=CC=CE
>> >
>> >
>> > _______________________________________________
>> > xfs mailing list
>> > xfs@oss.sgi.com
>> > http://oss.sgi.com/mailman/listinfo/xfs
>> >
>>
>>
>
>
> --
> =B7=FB=D3=C0=CC=CE
>



--=20
=B7=FB=D3=C0=CC=CE

--14dae9340ee7841fc504da5cba9a
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Dear xfs experts,<br></div>Now I&#39;m deploying=
 Brian&#39;s system script in out cluster. But from last night till now 5 s=
ervers in our 24 servers xfs shutdown with the same error. I run xfs_repair=
 command and found all the lost inodes are glusterfs dht link files. This e=
xplains why the xfs shutdown tend to happen during glusterfs rebalance. Dur=
ing glusterfs rebalance procedure a lot of dhk link files may be unlinked. =
For example the following inodes are found in lost+found in one of the serv=
ers:<br>
[root@* lost+found]# pwd<br>/mnt/xfsd/lost+found<br>[root@* lost+found]# ls=
 -l<br>total 740<br>---------T 1 root root 0 Apr&nbsp; 8 21:06 100119<br>--=
-------T 1 root root 0 Apr&nbsp; 8 21:11 101123<br>---------T 1 root root 0=
 Apr&nbsp; 8 21:19 102659<br>
---------T 1 root root 0 Apr 12 14:46 1040919<br>---------T 1 root root 0 A=
pr 12 14:58 1041943<br>---------T 1 root root 0 Apr&nbsp; 8 21:32 105219<br=
>---------T 1 root root 0 Apr&nbsp; 8 21:37 105731<br>---------T 1 root roo=
t 0 Apr 12 17:48 1068055<br>
---------T 1 root root 0 Apr 12 18:38 1073943<br>---------T 1 root root 0 A=
pr&nbsp; 8 21:54 108035<br>---------T 1 root root 0 Apr 12 21:49 1091095<br=
>---------T 1 root root 0 Apr 13 00:17 1111063<br>---------T 1 root root 0 =
Apr 13 03:51 1121815<br>
---------T 1 root root 0 Apr&nbsp; 8 22:25 112387<br>---------T 1 root root=
 0 Apr 13 06:39 1136151<br>...<br>[root@* lost+found]# getfattr -m . -d -e =
hex *<br><br># file: 96007<br>trusted.afr.mams-cq-mt-video-client-3=3D0x000=
000000000000000000000<br>
trusted.afr.mams-cq-mt-video-client-4=3D0x000000000000000000000000<br>trust=
ed.afr.mams-cq-mt-video-client-5=3D0x000000000000000000000000<br>trusted.gf=
id=3D0xa0370d8a9f104dafbebbd0e6dd7ce1f7<br>trusted.glusterfs.dht.linkto=3D0=
x6d616d732d63712d6d742d766964656f2d7265706c69636174652d3600<br>
trusted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x000=
0000049dff000<br><br># file: 97027<br>trusted.afr.mams-cq-mt-video-client-3=
=3D0x000000000000000000000000<br>trusted.afr.mams-cq-mt-video-client-4=3D0x=
000000000000000000000000<br>
trusted.afr.mams-cq-mt-video-client-5=3D0x000000000000000000000000<br>trust=
ed.gfid=3D0xc1c1fe2ec7034442a623385f43b04c25<br>trusted.glusterfs.dht.linkt=
o=3D0x6d616d732d63712d6d742d766964656f2d7265706c69636174652d3600<br>trusted=
.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x000000006a=
c78000<br>
<br># file: 97559<br>trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000=
000000000000<br>trusted.afr.mams-cq-mt-video-client-4=3D0x00000000000000000=
0000000<br>trusted.afr.mams-cq-mt-video-client-5=3D0x0000000000000000000000=
00<br>
trusted.gfid=3D0xcf7c17013c914511bda4d1c743fae118<br>trusted.glusterfs.dht.=
linkto=3D0x6d616d732d63712d6d742d766964656f2d7265706c69636174652d3500<br>tr=
usted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x00000=
000519fb000<br>
<br># file: 98055<br>trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000=
000000000000<br>trusted.afr.mams-cq-mt-video-client-4=3D0x00000000000000000=
0000000<br>trusted.afr.mams-cq-mt-video-client-5=3D0x0000000000000000000000=
00<br>
trusted.gfid=3D0xe86abc6e2c4b44c28d415fbbe34f2102<br>trusted.glusterfs.dht.=
linkto=3D0x6d616d732d63712d6d742d766964656f2d7265706c69636174652d3600<br>tr=
usted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x00000=
0004c098000<br>
<br># file: 98567<br>trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000=
000000000000<br>trusted.afr.mams-cq-mt-video-client-4=3D0x00000000000000000=
0000000<br>trusted.afr.mams-cq-mt-video-client-5=3D0x0000000000000000000000=
00<br>
trusted.gfid=3D0x12543a2efbdf4b9fa61c6d89ca396f80<br>trusted.glusterfs.dht.=
linkto=3D0x6d616d732d63712d6d742d766964656f2d7265706c69636174652d3500<br>tr=
usted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x00000=
0006bc98000<br>
<br># file: 98583<br>trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000=
000000000000<br>trusted.afr.mams-cq-mt-video-client-4=3D0x00000000000000000=
0000000<br>trusted.afr.mams-cq-mt-video-client-5=3D0x0000000000000000000000=
00<br>
trusted.gfid=3D0x760d16d3b7974cfb9c0a665a0982c470<br>trusted.glusterfs.dht.=
linkto=3D0x6d616d732d63712d6d742d766964656f2d7265706c69636174652d3500<br>tr=
usted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x00000=
0006cde9000<br>
<br># file: 99607<br>trusted.afr.mams-cq-mt-video-client-3=3D0x000000000000=
000000000000<br>trusted.afr.mams-cq-mt-video-client-4=3D0x00000000000000000=
0000000<br>trusted.afr.mams-cq-mt-video-client-5=3D0x0000000000000000000000=
00<br>
trusted.gfid=3D0x0849a732ea204bc3b8bae830b46881da<br>trusted.glusterfs.dht.=
linkto=3D0x6d616d732d63712d6d742d766964656f2d7265706c69636174652d3500<br>tr=
usted.glusterfs.quota.ca34e1ce-f046-4ed4-bbd1-261b21bfe0b8.contri=3D0x00000=
000513f1000<br>
...<br><br></div>What do you think about it? Thank you very much.<br></div>=
<div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">2013/4/12 =B7=
=FB=D3=C0=CC=CE <span dir=3D"ltr">&lt;<a href=3D"mailto:yongtaofu@gmail.com=
" target=3D"_blank">yongtaofu@gmail.com</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div>Hi Brian,<br><br></div=
>Your scripts works for me now after I installed all the rpm built out from=
 kernel srpm. I&#39;ll try it. Thank you.<br>
</div><div class=3D"gmail_extra"><div><div class=3D"h5"><br><br><div class=
=3D"gmail_quote">
2013/4/12 Brian Foster <span dir=3D"ltr">&lt;<a href=3D"mailto:bfoster@redh=
at.com" target=3D"_blank">bfoster@redhat.com</a>&gt;</span><br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">

<div>On 04/12/2013 04:32 AM, =B7=FB=D3=C0=CC=CE wrote:<br>
&gt; Dear xfs experts,<br>
&gt; Can I just call xfs_stack_trace(); in the second line of<br>
&gt; xfs_do_force_shutdown() to print stack and rebuild kernel to check<br>
&gt; what&#39;s the error?<br>
&gt;<br>
<br>
</div>I suppose that&#39;s a start. If you&#39;re willing/able to create an=
d run a<br>
modified kernel for the purpose of collecting more debug info, perhaps<br>
we can get a bit more creative in collecting more data on the problem<br>
(but a stack trace there is a good start).<br>
<br>
BTW- you might want to place the call after the XFS_FORCED_SHUTDOWN(mp)<br>
check almost halfway into the function to avoid duplicate messages.<br>
<br>
Brian<br>
<br>
&gt;<br>
&gt; 2013/4/12 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:yongtaofu@gmail.com=
" target=3D"_blank">yongtaofu@gmail.com</a> &lt;mailto:<a href=3D"mailto:yo=
ngtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a>&gt;&gt;<br>
<div>&gt;<br>
&gt; &nbsp; &nbsp; Hi Brian,<br>
&gt; &nbsp; &nbsp; What else I&#39;m missing? Thank you.<br>
&gt; &nbsp; &nbsp; stap -e &#39;probe module(&quot;xfs&quot;).function(&quo=
t;xfs_iunlink&quot;){}&#39;<br>
&gt;<br>
&gt; &nbsp; &nbsp; WARNING: cannot find module xfs debuginfo: No DWARF info=
rmation found<br>
&gt; &nbsp; &nbsp; semantic error: no match while resolving probe point<br>
&gt; &nbsp; &nbsp; module(&quot;xfs&quot;).function(&quot;xfs_iunlink&quot;=
)<br>
&gt; &nbsp; &nbsp; Pass 2: analysis failed. &nbsp;Try again with another &#=
39;--vp 01&#39; option.<br>
&gt;<br>
&gt;<br>
</div>&gt; &nbsp; &nbsp; 2013/4/12 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto=
:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a> &lt;mailto:=
<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.co=
m</a>&gt;&gt;<br>
<div>&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; ls -l<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; /usr/lib/debug/lib/modules/2.6.32-279.el6.=
x86_64/kernel/fs/xfs/xfs.ko.debug<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; -r--r--r-- 1 root root 21393024 Apr 12 12:=
08<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; /usr/lib/debug/lib/modules/2.6.32-279.el6.=
x86_64/kernel/fs/xfs/xfs.ko.debug<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; rpm -qa|grep &nbsp;kernel<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-headers-2.6.32-279.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-devel-2.6.32-279.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-2.6.32-358.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-debuginfo-common-x86_64-2.6.32-279.=
el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; abrt-addon-kerneloops-2.0.8-6.el6.x86_64<b=
r>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-firmware-2.6.32-358.el6.noarch<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-debug-2.6.32-358.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-debuginfo-2.6.32-279.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; dracut-kernel-004-283.el6.noarch<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; libreport-plugin-kerneloops-2.0.9-5.el6.x8=
6_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-devel-2.6.32-358.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-2.6.32-279.el6.x86_64<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; rpm -q kernel-debuginfo<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-debuginfo-2.6.32-279.el6.x86_64<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; rpm -q kernel<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-2.6.32-279.el6.x86_64<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; kernel-2.6.32-358.el6.x86_64<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; do I need to re probe it?<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; 2013/4/12 Eric Sandeen &lt;<a href=3D"mail=
to:sandeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a><br>
</div>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:sandeen=
@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a>&gt;&gt;<br>
<div><div>&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; On 4/11/13 11:32 PM, =B7=FB=
=D3=C0=CC=CE wrote:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Hi Brian,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Sorry but when I execut=
e the script it says:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; WARNING: cannot find mo=
dule xfs debuginfo: No DWARF<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; information found<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; semantic error: no matc=
h while resolving probe point<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; module(&quot;xfs&quot;).func=
tion(&quot;xfs_iunlink&quot;)<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; uname -a<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; 2.6.32-279.el6.x86_64<b=
r>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; kernel debuginfo has be=
en installed.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Where can I find the co=
rrect xfs debuginfo?<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; it should be in the kernel-d=
ebuginfo rpm (of the same<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; version/release as the kerne=
l rpm you&#39;re running)<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; You should have:<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; /usr/lib/debug/lib/modules/2=
.6.32-279.el6.x86_64/kernel/fs/xfs/xfs.ko.debug<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; If not, can you show:<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # uname -a<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # rpm -q kernel<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; # rpm -q kernel-debuginfo<br=
>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; -Eric<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; --<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; --<br>
&gt; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; =B7=FB=D3=C0=CC=CE<br>
&gt;<br>
&gt;<br>
</div></div><div><div>&gt; _______________________________________________<=
br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</=
a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
&gt;<br>
<br>
</div></div></blockquote></div><br><br clear=3D"all"><br></div></div><span =
class=3D"HOEnZb"><font color=3D"#888888">-- <br>=B7=FB=D3=C0=CC=CE
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=C0=CC=CE
</div>

--14dae9340ee7841fc504da5cba9a--


--===============7409544759333341789==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7409544759333341789==--
