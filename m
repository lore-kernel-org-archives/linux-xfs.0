Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D60237F37
	for <xfs@oss.sgi.com>; Sun, 16 Jun 2013 17:31:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C4115304032
	for <xfs@oss.sgi.com>; Sun, 16 Jun 2013 15:31:15 -0700 (PDT)
Received: from mail-qa0-f53.google.com (mail-qa0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id dz2YYyFGD0ziaEhW
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 16 Jun 2013 15:31:13 -0700 (PDT)
Received: by mail-qa0-f53.google.com with SMTP id g10so1091261qah.12
	for <xfs@oss.sgi.com>; Sun, 16 Jun 2013 15:31:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130616220648.GG29338@dastard>
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
	<91017249.1356192.1371248207334.JavaMail.root@redhat.com>
	<CAC2B=ZHYV6d-1PO_=-jXsQidZnYPHVwcVAaQh2mxJt=5K03AEA@mail.gmail.com>
	<504625587.1365681.1371255450937.JavaMail.root@redhat.com>
	<CAC2B=ZF+eMyNLPQmhA_onDPEUqgNfcgCdZVvobNH9pofvioN7Q@mail.gmail.com>
	<20130615020414.GB29338@dastard>
	<CAC2B=ZEUkd+ADnQLUKj9S-3rdo2=93WbW0tbLbwwHUvkh6v7Rw@mail.gmail.com>
	<CAC2B=ZGgr5WPWOEehHDHKekM8yHgQ3QS4HMzM8+j217AfEoPyQ@mail.gmail.com>
	<20130616001130.GE29338@dastard>
	<CAC2B=ZFZskLnp5baVJK+R1xrpOfTkr1QXpA9jyHvxfk5Wd4yDg@mail.gmail.com>
	<20130616220648.GG29338@dastard>
Date: Sun, 16 Jun 2013 18:31:13 -0400
Message-ID: <CAC2B=ZHBxCcvg4DMDdcRBXGrRJ2KVAibW1ToQ3yU5T5bQuHJtA@mail.gmail.com>
Subject: Re: definitions for /proc/fs/xfs/stat
From: Mark Seger <mjseger@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7972556140885506539=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Nathan Scott <nathans@redhat.com>, xfs@oss.sgi.com

--===============7972556140885506539==
Content-Type: multipart/alternative; boundary=047d7b33d89297325d04df4d098d

--047d7b33d89297325d04df4d098d
Content-Type: text/plain; charset=ISO-8859-1

>
> There is no way that fallocate() of 1000x1k files should be causing
> 450MB/s of IO for 5 seconds.
>

I agree and that's what has me puzzled as well.


> However, I still have no idea what you are running this test on - as
> I asked in another email, can you provide some information about
> the system your are seeing this problem on so we can try to work out
> what might be causing this?
>

sorry about that.  This is an HP box with 192GB RAM and 6 2-core
hyperthreaded CPUs, running ubuntu/precise

segerm@az1-sw-object-0006:~$ uname -a
Linux az1-sw-object-0006 2.6.38-16-server #68hf1026116v20120926-Ubuntu SMP
Wed Sep 26 14:34:13 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

segerm@az1-sw-object-0006:~$ python --version
Python 2.7.1+

segerm@az1-sw-object-0006:~$ xfs_repair -V
xfs_repair version 3.1.4

segerm@az1-sw-object-0006:~$ cat /proc/meminfo
MemTotal:       198191696 kB
MemFree:        166202324 kB
Buffers:          193268 kB
Cached:         21595332 kB
SwapCached:           36 kB
Active:          7992268 kB
Inactive:       14068428 kB
Active(anon):     719408 kB
Inactive(anon):  5244092 kB
Active(file):    7272860 kB
Inactive(file):  8824336 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:      126889980 kB
SwapFree:       126863972 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:        232156 kB
Mapped:            11384 kB
Shmem:           5731388 kB
Slab:            5755820 kB
SReclaimable:    4792292 kB
SUnreclaim:       963528 kB
KernelStack:        6240 kB
PageTables:         7328 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    225985828 kB
Committed_AS:    8851976 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      725112 kB
VmallocChunk:   34159749436 kB
HardwareCorrupted:     0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:      118648 kB
DirectMap2M:     5089280 kB
DirectMap1G:    196083712 kB

over 60 mounts, but here's the one I'm writing to:

segerm@az1-sw-object-0006:~$ mount | grep disk0
/dev/sdc1 on /srv/node/disk0 type xfs (rw,nobarrier)

not sure what you're looking for here so here's it all

segerm@az1-sw-object-0006:~$ cat /proc/partitions
major minor  #blocks  name

   8        0  976762584 sda
   8        1     248976 sda1
   8        2          1 sda2
   8        5  976510993 sda5
 251        0   41943040 dm-0
 251        1    8785920 dm-1
 251        2    2928640 dm-2
   8       16  976762584 sdb
   8       17  976760832 sdb1
 251        3  126889984 dm-3
 251        4     389120 dm-4
 251        5   41943040 dm-5
   8       32 2930233816 sdc
   8       33 2930233344 sdc1
   8       48 2930233816 sdd
   8       49 2930233344 sdd1
   8       64 2930233816 sde
   8       65 2930233344 sde1
   8       80 2930233816 sdf
   8       81 2930233344 sdf1
   8       96 2930233816 sdg
   8       97 2930233344 sdg1
   8      112 2930233816 sdh
   8      113 2930233344 sdh1
   8      128 2930233816 sdi
   8      129 2930233344 sdi1
   8      144 2930233816 sdj
   8      145 2930233344 sdj1
   8      160 2930233816 sdk
   8      161 2930233344 sdk1
   8      176 2930233816 sdl
   8      177 2930233344 sdl1
   8      192 2930233816 sdm
   8      193 2930233344 sdm1
   8      208 2930233816 sdn
   8      209 2930233344 sdn1
   8      240 2930233816 sdp
   8      241 2930233344 sdp1
   8      224 2930233816 sdo
   8      225 2930233344 sdo1
  65        0 2930233816 sdq
  65        1 2930233344 sdq1
  65       16 2930233816 sdr
  65       17 2930233344 sdr1
  65       32 2930233816 sds
  65       33 2930233344 sds1
  65      176 2930233816 sdab
  65      177 2930233344 sdab1
  66        0 2930233816 sdag
  66        1 2930233344 sdag1
  65       64 2930233816 sdu
  65       65 2930233344 sdu1
  65      128 2930233816 sdy
  65      129 2930233344 sdy1
  65      224 2930233816 sdae
  65      225 2930233344 sdae1
  65      144 2930233816 sdz
  65      145 2930233344 sdz1
  65      208 2930233816 sdad
  65      209 2930233344 sdad1
  65       48 2930233816 sdt
  65       49 2930233344 sdt1
  65      240 2930233816 sdaf
  65      241 2930233344 sdaf1
  65       96 2930233816 sdw
  65       97 2930233344 sdw1
  66       32 2930233816 sdai
  66       33 2930233344 sdai1
  66       48 2930233816 sdaj
  66       49 2930233344 sdaj1
  65      112 2930233816 sdx
  65      113 2930233344 sdx1
  65      160 2930233816 sdaa
  65      161 2930233344 sdaa1
  65       80 2930233816 sdv
  65       81 2930233344 sdv1
  65      192 2930233816 sdac
  65      193 2930233344 sdac1
  66       16 2930233816 sdah
  66       17 2930233344 sdah1
  66       64 2930233816 sdak
  66       65 2930233344 sdak1
  66      144 2930233816 sdap
  66      145 2930233344 sdap1
  66      224 2930233816 sdau
  66      225 2930233344 sdau1
  67      208 2930233816 sdbj
  67      209 2930233344 sdbj1
  66      112 2930233816 sdan
  66      113 2930233344 sdan1
  66       96 2930233816 sdam
  66       97 2930233344 sdam1
  66       80 2930233816 sdal
  66       81 2930233344 sdal1
  67       96 2930233816 sdbc
  67       97 2930233344 sdbc1
  66      128 2930233816 sdao
  66      129 2930233344 sdao1
  67      128 2930233816 sdbe
  67      129 2930233344 sdbe1
  66      176 2930233816 sdar
  66      177 2930233344 sdar1
  67      160 2930233816 sdbg
  67      161 2930233344 sdbg1
  66      160 2930233816 sdaq
  66      161 2930233344 sdaq1
  67       48 2930233816 sdaz
  67       49 2930233344 sdaz1
  66      208 2930233816 sdat
  66      209 2930233344 sdat1
  67      112 2930233816 sdbd
  67      113 2930233344 sdbd1
  67      144 2930233816 sdbf
  67      145 2930233344 sdbf1
  67       64 2930233816 sdba
  67       65 2930233344 sdba1
  67       16 2930233816 sdax
  67       17 2930233344 sdax1
  67       32 2930233816 sday
  67       33 2930233344 sday1
  66      192 2930233816 sdas
  66      193 2930233344 sdas1
  67      192 2930233816 sdbi
  67      193 2930233344 sdbi1
  66      240 2930233816 sdav
  66      241 2930233344 sdav1
  67       80 2930233816 sdbb
  67       81 2930233344 sdbb1
  67      176 2930233816 sdbh
  67      177 2930233344 sdbh1
  67        0 2930233816 sdaw
  67        1 2930233344 sdaw1

segerm@az1-sw-object-0006:~$ xfs_info /srv/node/disk0
meta-data=/dev/sdc1              isize=1024   agcount=32, agsize=22892416
blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=732557312, imaxpct=5
         =                       sunit=64     swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=357696, version=2
         =                       sectsz=512   sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Is this enough to describe my environment?


>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> > This is the same behavior I'm seeing on swift.  10K 1KB files X 4kb
> minimal
> > block size still comes out to a lot less than the multiple GB of writes
> > being reported.  Actually since these whole thing only takes a few
> seconds
> > and I know a single disk can't write that fast maybe it's just a bug in
> the
> > way the kernel is reported allocated preallocated blocks and nothing to
> do
> > with XFS?  Or iis xfs responsible for the stats?
>
> I don't know what stats you are getting your information from. XFS
> is only responsible for what is in /proc/fs/xfs/,,,


I'm getting my stats from 2 places, collectl reading /proc/diskstats AND
xfs from /proc/fs/xfs though I've only shown you the collectl stats.  It's
easy enough to send you the /proc/fs/xfs stats if you want them as both
formatted output as well as the raw /proc/fs/xfs contents every second from
which they're derived.


> > If I remove the fallocate call I see the expected amount of disk traffic.
>
> Have you run strace to confirm that your python script is actually
> calling fallocate(), and it's not being emulated by python or libc?


I haven't.  However when I saw this exact behavior with swift, we did see
both fallocate being called and here's a small section showing a complete
10K PUT operation and the beginning of the next one:

    0.067874 cpu=0 pid=41977 fallocate [285] entry fd=15 mode=0x1
offset=0x0 len=10240
    0.067980 cpu=0 pid=41977 block_rq_insert dev_t=0x04100030 wr=write
flags=SYNC sector=0xaec11a00 len=262144
    0.067983 cpu=0 pid=41977 block_rq_issue dev_t=0x04100030 wr=write
flags=SYNC sector=0xaec11a00 len=262144
    0.068010 cpu=0 pid=41977 sched_switch prio=120 state=SSLEEP next_pid=0
next_prio=120
    0.068125 cpu=0 pid=0 block_rq_complete dev_t=0x04100030 wr=write
flags=SYNC sector=0xaec11a00 len=262144 qpid=41977 spid=41977 qtm=
 0.000004 svtm=  0.000142
    0.068175 cpu=0 pid=48168 sched_wakeup target_pid=41977 prio=120
target_cpu=12 success=1
    0.068180 cpu=12 pid=0 sched_switch prio=n/a state=n/a next_pid=41977
next_prio=120
    0.068185 cpu=12 pid=41977 fallocate [285] ret=0x0 syscallbeg=
 0.000311 fd=15 mode=0x1 offset=0x0 len=10240

I hope this helps but if there's any more I can provide I'll be happy to do
so.
-mark



> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--047d7b33d89297325d04df4d098d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote"><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left=
-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;paddi=
ng-left:1ex">
There is no way that fallocate() of 1000x1k files should be causing<br>
450MB/s of IO for 5 seconds.<br></blockquote><div><br></div><div style>I ag=
ree and that&#39;s what has me puzzled as well.</div><div>=A0</div><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-wid=
th:1px;border-left-color:rgb(204,204,204);border-left-style:solid;padding-l=
eft:1ex">

However, I still have no idea what you are running this test on - as<br>
I asked in another email, can you provide some information about<br>
the system your are seeing this problem on so we can try to work out<br>
what might be causing this?<br></blockquote><div><br></div><div style>sorry=
 about that. =A0This is an HP box with 192GB RAM and 6 2-core hyperthreaded=
 CPUs, running ubuntu/precise</div><div style><br></div><div>segerm@az1-sw-=
object-0006:~$ uname -a</div>
<div>Linux az1-sw-object-0006 2.6.38-16-server #68hf1026116v20120926-Ubuntu=
 SMP Wed Sep 26 14:34:13 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux</div><div>=
<br></div><div style><div>segerm@az1-sw-object-0006:~$ python --version</di=
v>
<div>Python 2.7.1+</div><div><br></div><div><div>segerm@az1-sw-object-0006:=
~$ xfs_repair -V</div><div>xfs_repair version 3.1.4</div></div><div><br></d=
iv><div><div>segerm@az1-sw-object-0006:~$ cat /proc/meminfo</div><div>MemTo=
tal: =A0 =A0 =A0 198191696 kB</div>
<div>MemFree: =A0 =A0 =A0 =A0166202324 kB</div><div>Buffers: =A0 =A0 =A0 =
=A0 =A0193268 kB</div><div>Cached: =A0 =A0 =A0 =A0 21595332 kB</div><div>Sw=
apCached: =A0 =A0 =A0 =A0 =A0 36 kB</div><div>Active: =A0 =A0 =A0 =A0 =A079=
92268 kB</div><div>Inactive: =A0 =A0 =A0 14068428 kB</div>
<div>Active(anon): =A0 =A0 719408 kB</div><div>Inactive(anon): =A05244092 k=
B</div><div>Active(file): =A0 =A07272860 kB</div><div>Inactive(file): =A088=
24336 kB</div><div>Unevictable: =A0 =A0 =A0 =A0 =A0 0 kB</div><div>Mlocked:=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 kB</div>
<div>SwapTotal: =A0 =A0 =A0126889980 kB</div><div>SwapFree: =A0 =A0 =A0 126=
863972 kB</div><div>Dirty: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 kB</div><div>W=
riteback: =A0 =A0 =A0 =A0 =A0 =A0 0 kB</div><div>AnonPages: =A0 =A0 =A0 =A0=
232156 kB</div><div>Mapped: =A0 =A0 =A0 =A0 =A0 =A011384 kB</div>
<div>Shmem: =A0 =A0 =A0 =A0 =A0 5731388 kB</div><div>Slab: =A0 =A0 =A0 =A0 =
=A0 =A05755820 kB</div><div>SReclaimable: =A0 =A04792292 kB</div><div>SUnre=
claim: =A0 =A0 =A0 963528 kB</div><div>KernelStack: =A0 =A0 =A0 =A06240 kB<=
/div><div>PageTables: =A0 =A0 =A0 =A0 7328 kB</div>
<div>NFS_Unstable: =A0 =A0 =A0 =A0 =A00 kB</div><div>Bounce: =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A00 kB</div><div>WritebackTmp: =A0 =A0 =A0 =A0 =A00 kB</di=
v><div>CommitLimit: =A0 =A0225985828 kB</div><div>Committed_AS: =A0 =A08851=
976 kB</div><div>VmallocTotal: =A0 34359738367 kB</div>
<div>VmallocUsed: =A0 =A0 =A0725112 kB</div><div>VmallocChunk: =A0 34159749=
436 kB</div><div>HardwareCorrupted: =A0 =A0 0 kB</div><div>HugePages_Total:=
 =A0 =A0 =A0 0</div><div>HugePages_Free: =A0 =A0 =A0 =A00</div><div>HugePag=
es_Rsvd: =A0 =A0 =A0 =A00</div>
<div>HugePages_Surp: =A0 =A0 =A0 =A00</div><div>Hugepagesize: =A0 =A0 =A0 2=
048 kB</div><div>DirectMap4k: =A0 =A0 =A0118648 kB</div><div>DirectMap2M: =
=A0 =A0 5089280 kB</div><div>DirectMap1G: =A0 =A0196083712 kB</div></div><d=
iv><br></div><div style>over 60 mounts, but here&#39;s the one I&#39;m writ=
ing to:</div>
<div style><br></div><div><div>segerm@az1-sw-object-0006:~$ mount | grep di=
sk0</div><div>/dev/sdc1 on /srv/node/disk0 type xfs (rw,nobarrier)</div></d=
iv><div style><br></div><div style>not sure what you&#39;re looking for her=
e so here&#39;s it all</div>
<div style><br></div><div><div>segerm@az1-sw-object-0006:~$ cat /proc/parti=
tions</div><div>major minor =A0#blocks =A0name</div><div><br></div><div>=A0=
 =A08 =A0 =A0 =A0 =A00 =A0976762584 sda</div><div>=A0 =A08 =A0 =A0 =A0 =A01=
 =A0 =A0 248976 sda1</div><div>
=A0 =A08 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A0 =A01 sda2</div><div>=A0 =A08 =A0 =
=A0 =A0 =A05 =A0976510993 sda5</div><div>=A0251 =A0 =A0 =A0 =A00 =A0 419430=
40 dm-0</div><div>=A0251 =A0 =A0 =A0 =A01 =A0 =A08785920 dm-1</div><div>=A0=
251 =A0 =A0 =A0 =A02 =A0 =A02928640 dm-2</div><div>=A0 =A08 =A0 =A0 =A0 16 =
=A0976762584 sdb</div>
<div>=A0 =A08 =A0 =A0 =A0 17 =A0976760832 sdb1</div><div>=A0251 =A0 =A0 =A0=
 =A03 =A0126889984 dm-3</div><div>=A0251 =A0 =A0 =A0 =A04 =A0 =A0 389120 dm=
-4</div><div>=A0251 =A0 =A0 =A0 =A05 =A0 41943040 dm-5</div><div>=A0 =A08 =
=A0 =A0 =A0 32 2930233816 sdc</div><div>=A0 =A08 =A0 =A0 =A0 33 2930233344 =
sdc1</div>
<div>=A0 =A08 =A0 =A0 =A0 48 2930233816 sdd</div><div>=A0 =A08 =A0 =A0 =A0 =
49 2930233344 sdd1</div><div>=A0 =A08 =A0 =A0 =A0 64 2930233816 sde</div><d=
iv>=A0 =A08 =A0 =A0 =A0 65 2930233344 sde1</div><div>=A0 =A08 =A0 =A0 =A0 8=
0 2930233816 sdf</div><div>=A0 =A08 =A0 =A0 =A0 81 2930233344 sdf1</div>
<div>=A0 =A08 =A0 =A0 =A0 96 2930233816 sdg</div><div>=A0 =A08 =A0 =A0 =A0 =
97 2930233344 sdg1</div><div>=A0 =A08 =A0 =A0 =A0112 2930233816 sdh</div><d=
iv>=A0 =A08 =A0 =A0 =A0113 2930233344 sdh1</div><div>=A0 =A08 =A0 =A0 =A012=
8 2930233816 sdi</div><div>=A0 =A08 =A0 =A0 =A0129 2930233344 sdi1</div>
<div>=A0 =A08 =A0 =A0 =A0144 2930233816 sdj</div><div>=A0 =A08 =A0 =A0 =A01=
45 2930233344 sdj1</div><div>=A0 =A08 =A0 =A0 =A0160 2930233816 sdk</div><d=
iv>=A0 =A08 =A0 =A0 =A0161 2930233344 sdk1</div><div>=A0 =A08 =A0 =A0 =A017=
6 2930233816 sdl</div><div>=A0 =A08 =A0 =A0 =A0177 2930233344 sdl1</div>
<div>=A0 =A08 =A0 =A0 =A0192 2930233816 sdm</div><div>=A0 =A08 =A0 =A0 =A01=
93 2930233344 sdm1</div><div>=A0 =A08 =A0 =A0 =A0208 2930233816 sdn</div><d=
iv>=A0 =A08 =A0 =A0 =A0209 2930233344 sdn1</div><div>=A0 =A08 =A0 =A0 =A024=
0 2930233816 sdp</div><div>=A0 =A08 =A0 =A0 =A0241 2930233344 sdp1</div>
<div>=A0 =A08 =A0 =A0 =A0224 2930233816 sdo</div><div>=A0 =A08 =A0 =A0 =A02=
25 2930233344 sdo1</div><div>=A0 65 =A0 =A0 =A0 =A00 2930233816 sdq</div><d=
iv>=A0 65 =A0 =A0 =A0 =A01 2930233344 sdq1</div><div>=A0 65 =A0 =A0 =A0 16 =
2930233816 sdr</div><div>=A0 65 =A0 =A0 =A0 17 2930233344 sdr1</div>
<div>=A0 65 =A0 =A0 =A0 32 2930233816 sds</div><div>=A0 65 =A0 =A0 =A0 33 2=
930233344 sds1</div><div>=A0 65 =A0 =A0 =A0176 2930233816 sdab</div><div>=
=A0 65 =A0 =A0 =A0177 2930233344 sdab1</div><div>=A0 66 =A0 =A0 =A0 =A00 29=
30233816 sdag</div><div>=A0 66 =A0 =A0 =A0 =A01 2930233344 sdag1</div>
<div>=A0 65 =A0 =A0 =A0 64 2930233816 sdu</div><div>=A0 65 =A0 =A0 =A0 65 2=
930233344 sdu1</div><div>=A0 65 =A0 =A0 =A0128 2930233816 sdy</div><div>=A0=
 65 =A0 =A0 =A0129 2930233344 sdy1</div><div>=A0 65 =A0 =A0 =A0224 29302338=
16 sdae</div><div>=A0 65 =A0 =A0 =A0225 2930233344 sdae1</div>
<div>=A0 65 =A0 =A0 =A0144 2930233816 sdz</div><div>=A0 65 =A0 =A0 =A0145 2=
930233344 sdz1</div><div>=A0 65 =A0 =A0 =A0208 2930233816 sdad</div><div>=
=A0 65 =A0 =A0 =A0209 2930233344 sdad1</div><div>=A0 65 =A0 =A0 =A0 48 2930=
233816 sdt</div><div>=A0 65 =A0 =A0 =A0 49 2930233344 sdt1</div>
<div>=A0 65 =A0 =A0 =A0240 2930233816 sdaf</div><div>=A0 65 =A0 =A0 =A0241 =
2930233344 sdaf1</div><div>=A0 65 =A0 =A0 =A0 96 2930233816 sdw</div><div>=
=A0 65 =A0 =A0 =A0 97 2930233344 sdw1</div><div>=A0 66 =A0 =A0 =A0 32 29302=
33816 sdai</div><div>=A0 66 =A0 =A0 =A0 33 2930233344 sdai1</div>
<div>=A0 66 =A0 =A0 =A0 48 2930233816 sdaj</div><div>=A0 66 =A0 =A0 =A0 49 =
2930233344 sdaj1</div><div>=A0 65 =A0 =A0 =A0112 2930233816 sdx</div><div>=
=A0 65 =A0 =A0 =A0113 2930233344 sdx1</div><div>=A0 65 =A0 =A0 =A0160 29302=
33816 sdaa</div><div>=A0 65 =A0 =A0 =A0161 2930233344 sdaa1</div>
<div>=A0 65 =A0 =A0 =A0 80 2930233816 sdv</div><div>=A0 65 =A0 =A0 =A0 81 2=
930233344 sdv1</div><div>=A0 65 =A0 =A0 =A0192 2930233816 sdac</div><div>=
=A0 65 =A0 =A0 =A0193 2930233344 sdac1</div><div>=A0 66 =A0 =A0 =A0 16 2930=
233816 sdah</div><div>=A0 66 =A0 =A0 =A0 17 2930233344 sdah1</div>
<div>=A0 66 =A0 =A0 =A0 64 2930233816 sdak</div><div>=A0 66 =A0 =A0 =A0 65 =
2930233344 sdak1</div><div>=A0 66 =A0 =A0 =A0144 2930233816 sdap</div><div>=
=A0 66 =A0 =A0 =A0145 2930233344 sdap1</div><div>=A0 66 =A0 =A0 =A0224 2930=
233816 sdau</div><div>=A0 66 =A0 =A0 =A0225 2930233344 sdau1</div>
<div>=A0 67 =A0 =A0 =A0208 2930233816 sdbj</div><div>=A0 67 =A0 =A0 =A0209 =
2930233344 sdbj1</div><div>=A0 66 =A0 =A0 =A0112 2930233816 sdan</div><div>=
=A0 66 =A0 =A0 =A0113 2930233344 sdan1</div><div>=A0 66 =A0 =A0 =A0 96 2930=
233816 sdam</div><div>=A0 66 =A0 =A0 =A0 97 2930233344 sdam1</div>
<div>=A0 66 =A0 =A0 =A0 80 2930233816 sdal</div><div>=A0 66 =A0 =A0 =A0 81 =
2930233344 sdal1</div><div>=A0 67 =A0 =A0 =A0 96 2930233816 sdbc</div><div>=
=A0 67 =A0 =A0 =A0 97 2930233344 sdbc1</div><div>=A0 66 =A0 =A0 =A0128 2930=
233816 sdao</div><div>=A0 66 =A0 =A0 =A0129 2930233344 sdao1</div>
<div>=A0 67 =A0 =A0 =A0128 2930233816 sdbe</div><div>=A0 67 =A0 =A0 =A0129 =
2930233344 sdbe1</div><div>=A0 66 =A0 =A0 =A0176 2930233816 sdar</div><div>=
=A0 66 =A0 =A0 =A0177 2930233344 sdar1</div><div>=A0 67 =A0 =A0 =A0160 2930=
233816 sdbg</div><div>=A0 67 =A0 =A0 =A0161 2930233344 sdbg1</div>
<div>=A0 66 =A0 =A0 =A0160 2930233816 sdaq</div><div>=A0 66 =A0 =A0 =A0161 =
2930233344 sdaq1</div><div>=A0 67 =A0 =A0 =A0 48 2930233816 sdaz</div><div>=
=A0 67 =A0 =A0 =A0 49 2930233344 sdaz1</div><div>=A0 66 =A0 =A0 =A0208 2930=
233816 sdat</div><div>=A0 66 =A0 =A0 =A0209 2930233344 sdat1</div>
<div>=A0 67 =A0 =A0 =A0112 2930233816 sdbd</div><div>=A0 67 =A0 =A0 =A0113 =
2930233344 sdbd1</div><div>=A0 67 =A0 =A0 =A0144 2930233816 sdbf</div><div>=
=A0 67 =A0 =A0 =A0145 2930233344 sdbf1</div><div>=A0 67 =A0 =A0 =A0 64 2930=
233816 sdba</div><div>=A0 67 =A0 =A0 =A0 65 2930233344 sdba1</div>
<div>=A0 67 =A0 =A0 =A0 16 2930233816 sdax</div><div>=A0 67 =A0 =A0 =A0 17 =
2930233344 sdax1</div><div>=A0 67 =A0 =A0 =A0 32 2930233816 sday</div><div>=
=A0 67 =A0 =A0 =A0 33 2930233344 sday1</div><div>=A0 66 =A0 =A0 =A0192 2930=
233816 sdas</div><div>=A0 66 =A0 =A0 =A0193 2930233344 sdas1</div>
<div>=A0 67 =A0 =A0 =A0192 2930233816 sdbi</div><div>=A0 67 =A0 =A0 =A0193 =
2930233344 sdbi1</div><div>=A0 66 =A0 =A0 =A0240 2930233816 sdav</div><div>=
=A0 66 =A0 =A0 =A0241 2930233344 sdav1</div><div>=A0 67 =A0 =A0 =A0 80 2930=
233816 sdbb</div><div>=A0 67 =A0 =A0 =A0 81 2930233344 sdbb1</div>
<div>=A0 67 =A0 =A0 =A0176 2930233816 sdbh</div><div>=A0 67 =A0 =A0 =A0177 =
2930233344 sdbh1</div><div>=A0 67 =A0 =A0 =A0 =A00 2930233816 sdaw</div><di=
v>=A0 67 =A0 =A0 =A0 =A01 2930233344 sdaw1</div></div><div><br></div><div><=
div>segerm@az1-sw-object-0006:~$ xfs_info /srv/node/disk0</div>
<div>meta-data=3D/dev/sdc1 =A0 =A0 =A0 =A0 =A0 =A0 =A0isize=3D1024 =A0 agco=
unt=3D32, agsize=3D22892416 blks</div><div>=A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectsz=3D512 =A0 attr=3D2</div><div>dat=
a =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=3D4096 =A0 =
blocks=3D732557312, imaxpct=3D5</div>
<div>=A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sun=
it=3D64 =A0 =A0 swidth=3D64 blks</div><div>naming =A0 =3Dversion 2 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0bsize=3D4096 =A0 ascii-ci=3D0</div><div>log =A0 =A0 =A0=
=3Dinternal =A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=3D4096 =A0 blocks=3D357696, v=
ersion=3D2</div><div>
=A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectsz=
=3D512 =A0 sunit=3D64 blks, lazy-count=3D1</div><div>realtime =3Dnone =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 extsz=3D4096 =A0 blocks=3D0, rtextents=3D0<=
/div></div><div><br></div><div style>Is this enough to describe my environm=
ent?</div>
<div><br></div></div><blockquote class=3D"gmail_quote" style=3D"margin:0px =
0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);bord=
er-left-style:solid;padding-left:1ex">
<br>
<a href=3D"http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_in=
clude_when_reporting_a_problem.3F" target=3D"_blank">http://xfs.org/index.p=
hp/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F=
</a><br>

<div class=3D"im"><br>
&gt; This is the same behavior I&#39;m seeing on swift. =A010K 1KB files X =
4kb minimal<br>
&gt; block size still comes out to a lot less than the multiple GB of write=
s<br>
&gt; being reported. =A0Actually since these whole thing only takes a few s=
econds<br>
&gt; and I know a single disk can&#39;t write that fast maybe it&#39;s just=
 a bug in the<br>
&gt; way the kernel is reported allocated preallocated blocks and nothing t=
o do<br>
&gt; with XFS? =A0Or iis xfs responsible for the stats?<br>
<br>
</div>I don&#39;t know what stats you are getting your information from. XF=
S<br>
is only responsible for what is in /proc/fs/xfs/,,,</blockquote><div><br></=
div><div style>I&#39;m getting my stats from 2 places, collectl reading /pr=
oc/diskstats AND xfs from /proc/fs/xfs though I&#39;ve only shown you the c=
ollectl stats. =A0It&#39;s easy enough to send you the /proc/fs/xfs stats i=
f you want them as both formatted output as well as the raw /proc/fs/xfs co=
ntents every second from which they&#39;re derived.</div>
<div>=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px=
 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-left=
-style:solid;padding-left:1ex"><div class=3D"im">
&gt; If I remove the fallocate call I see the expected amount of disk traff=
ic.<br>
<br>
</div>Have you run strace to confirm that your python script is actually<br=
>
calling fallocate(), and it&#39;s not being emulated by python or libc?</bl=
ockquote><div><br></div><div style>I haven&#39;t. =A0However when I saw thi=
s exact behavior with swift, we did see both fallocate being called and her=
e&#39;s a small section showing a complete 10K PUT operation and the beginn=
ing of the next one:</div>
<div style><br></div><div style><div>=A0 =A0 0.067874 cpu=3D0 pid=3D41977 f=
allocate [285] entry fd=3D15 mode=3D0x1 offset=3D0x0 len=3D10240</div><div>=
=A0 =A0 0.067980 cpu=3D0 pid=3D41977 block_rq_insert dev_t=3D0x04100030 wr=
=3Dwrite flags=3DSYNC sector=3D0xaec11a00 len=3D262144</div>
<div>=A0 =A0 0.067983 cpu=3D0 pid=3D41977 block_rq_issue dev_t=3D0x04100030=
 wr=3Dwrite flags=3DSYNC sector=3D0xaec11a00 len=3D262144</div><div>=A0 =A0=
 0.068010 cpu=3D0 pid=3D41977 sched_switch prio=3D120 state=3DSSLEEP next_p=
id=3D0 next_prio=3D120</div><div>
=A0 =A0 0.068125 cpu=3D0 pid=3D0 block_rq_complete dev_t=3D0x04100030 wr=3D=
write flags=3DSYNC sector=3D0xaec11a00 len=3D262144 qpid=3D41977 spid=3D419=
77 qtm=3D =A00.000004 svtm=3D =A00.000142</div><div>=A0 =A0 0.068175 cpu=3D=
0 pid=3D48168 sched_wakeup target_pid=3D41977 prio=3D120 target_cpu=3D12 su=
ccess=3D1</div>
<div>=A0 =A0 0.068180 cpu=3D12 pid=3D0 sched_switch prio=3Dn/a state=3Dn/a =
next_pid=3D41977 next_prio=3D120</div><div>=A0 =A0 0.068185 cpu=3D12 pid=3D=
41977 fallocate [285] ret=3D0x0 syscallbeg=3D =A0 =A00.000311 fd=3D15 mode=
=3D0x1 offset=3D0x0 len=3D10240</div>
<div><br></div></div><div style>I hope this helps but if there&#39;s any mo=
re I can provide I&#39;ll be happy to do so.</div><div style>-mark</div><di=
v style><br></div><div>=A0</div><blockquote class=3D"gmail_quote" style=3D"=
margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,20=
4,204);border-left-style:solid;padding-left:1ex">
<div class=3D""><div class=3D"h5">
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div></div>

--047d7b33d89297325d04df4d098d--


--===============7972556140885506539==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7972556140885506539==--
