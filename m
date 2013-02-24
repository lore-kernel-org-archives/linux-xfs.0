Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 813777F50
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 05:13:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5FE7B304043
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 03:13:42 -0800 (PST)
Received: from mail-oa0-f42.google.com (mail-oa0-f42.google.com
	[209.85.219.42]) by cuda.sgi.com with ESMTP id ppQ7i6RZjoLSdFx3
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 24 Feb 2013 03:13:40 -0800 (PST)
Received: by mail-oa0-f42.google.com with SMTP id i18so1995185oag.29
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 03:13:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130222202518.GX22182@sgi.com>
References: <CAGot=x-aiATNxBty7FXxV_td7Wx1_Mh8c8ta=mr4hpHxtmv6Nw@mail.gmail.com>
	<20130222202518.GX22182@sgi.com>
Date: Sun, 24 Feb 2013 12:13:39 +0100
Message-ID: <CAGot=x8eYQ_ko4Sqc-iih6+c1MHq+dbHCUrrg84TsvRJ-BoXDg@mail.gmail.com>
Subject: Re: dozens of xfsaild threads
From: Erik Knight <kutuzof@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3437179228783312014=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

--===============3437179228783312014==
Content-Type: multipart/alternative; boundary=e89a8f8396753c99e404d6768418

--e89a8f8396753c99e404d6768418
Content-Type: text/plain; charset=ISO-8859-1

Hi Ben,

Thanks again for your help. This should be all the relevant information
that you requested:

The workload is classic ETL. The problem shows up when trying to refresh
the DWH.

 *uname -a*
Linux  3.0.42-0.7-default #1 SMP Tue Oct 9 11:58:45 UTC 2012 (a8dc443)
x86_64 x86_64 x86_64 GNU/Linux

*xfs_repair -V*
xfs_repair version 3.1.8

Number of CPU: 8

processor       : 7
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Xeon(R) CPU           E5450  @ 3.00GHz
stepping        : 6
cpu MHz         : 2999.800
cache size      : 6144 KB
physical id     : 1
siblings        : 4
core id         : 3
cpu cores       : 4
apicid          : 7
initial apicid  : 7
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 lahf_lm dtherm
tpr_shadow vnmi flexpriority
bogomips        : 6003.48
clflush size    : 64
cache_alignment : 64
address sizes   : 38 bits physical, 48 bits virtual
power management:

*cat /proc/meminfo*
MemTotal:       24738004 kB
MemFree:          903492 kB
Buffers:             364 kB
Cached:         22131464 kB
SwapCached:        28044 kB
Active:         15011808 kB
Inactive:        7694912 kB
Active(anon):   12375396 kB
Inactive(anon):  3024204 kB
Active(file):    2636412 kB
Inactive(file):  4670708 kB
Unevictable:        5160 kB
Mlocked:            5160 kB
SwapTotal:      18874364 kB
SwapFree:       13429788 kB
Dirty:               916 kB
Writeback:             0 kB
AnonPages:        559160 kB
Mapped:         13143856 kB
Shmem:          14821620 kB
Slab:             618944 kB
SReclaimable:     499808 kB
SUnreclaim:       119136 kB
KernelStack:        5512 kB
PageTables:        64124 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    31243364 kB
Committed_AS:   31705548 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      336820 kB
VmallocChunk:   34359375216 kB
HardwareCorrupted:     0 kB
AnonHugePages:    258048 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:      129392 kB
DirectMap2M:    25034752 kB

*cat /proc/mounts*
rootfs / rootfs rw 0 0
udev /dev tmpfs rw,relatime,nr_inodes=0,mode=755 0 0
tmpfs /dev/shm tmpfs rw,relatime 0 0
/dev/mapper/system-root / xfs rw,relatime,delaylog,noquota 0 0
proc /proc proc rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
devpts /dev/pts devpts rw,relatime,gid=5,mode=620,ptmxmode=000 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
/dev/cciss/c0d0p1 /boot ext3
rw,relatime,errors=continue,user_xattr,acl,barrier=1,data=ordered 0 0
/dev/mapper/system-export /export xfs rw,relatime,delaylog,noquota 0 0
/dev/mapper/system-opt /opt xfs rw,relatime,delaylog,noquota 0 0
/dev/mapper/system-var /var xfs rw,relatime,delaylog,noquota 0 0
/dev/mapper/system-var /tmp xfs rw,relatime,delaylog,noquota 0 0
... etc

* cat /proc/partitions*

major minor  #blocks  name

 104        0  143338560 cciss/c0d0
 104        1     104391 cciss/c0d0p1
 104        2  143227507 cciss/c0d0p2
 253        0   10485760 dm-0
 253        1   10485760 dm-1
 253        2    8388608 dm-2
 253        3   18874368 dm-3
 253        4    5242880 dm-4
   8       48  536870912 sdd
   8        0  536870912 sda
   8       64  536870912 sde
   8       32  536870912 sdc
   8       80  536870912 sdf
   8       96  536870912 sdg
   8       16  536870912 sdb
   8      112  536870912 sdh
   8      128  536870912 sdi
   8      160  536870912 sdk
   8      144  536870912 sdj
   8      176  536870912 sdl
   8      192  536870912 sdm
   8      224  536870912 sdo
   8      240  536870912 sdp
   8      208  536870912 sdn
  65        0  536870912 sdq
  65       16  536870912 sdr
  65       32  536870912 sds
  65       48  536870912 sdt
  65       64  536870912 sdu
  65       80  536870912 sdv
  65       96  536870912 sdw
  65      112  536870912 sdx
  65      128  536870912 sdy
  65      144  536870912 sdz
  65      160  536870912 sdaa
  65      176  536870912 sdab
  65      192  536870912 sdac
  65      208  536870912 sdad
  65      224  536870912 sdae
  65      240  536870912 sdaf
 253        5  536870912 dm-5
 253        6  536870912 dm-6
 etc....


On Fri, Feb 22, 2013 at 9:25 PM, Ben Myers <bpm@sgi.com> wrote:

> Hi Erik,
>
> On Fri, Feb 22, 2013 at 02:04:17PM +0100, Erik Knight wrote:
> > We've recently noticed that our system is experiencing extreme
> performance
> > problems when running large workloads. The problem seems to come from
> > excessive System CPU time. Specifically dozens of xfsaild threads. We
> used
> > to have SSD drives but recently switched to HDD, so some of us are
> thinking
> > that there may be a configuration issue within XFS that is optimized for
> > SSD but performs terribly slow on HDD.
> >
> > Can anyone explain what these threads do, what would cause so many of
> them
> > to be running simultaneously or consume so much CPU?
>
> AIL stands for Active Item List.  These guys sync metadata which has been
> logged to its final location on disk.  You'll have one daemon per
> filesystem.
>
> If you have a very metadata intensive workload they could get a workout.
>  It
> would help to know a bit more about your workload and configuration.  Can
> you
> provide the relevant information listed here?
>
>
> http://www.xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> Regards,
>         Ben
>

--e89a8f8396753c99e404d6768418
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Ben,=A0<div><br></div><div style>Thanks again for your =
help. This should be all the relevant information that you requested:</div>=
<div style><br></div><div style>The workload is classic ETL. The problem sh=
ows up when trying to refresh the DWH.=A0</div>
<div style><br></div><div style><div>=A0<b>uname -a</b></div><div>Linux =A0=
3.0.42-0.7-default #1 SMP Tue Oct 9 11:58:45 UTC 2012 (a8dc443) x86_64 x86_=
64 x86_64 GNU/Linux</div><div><br></div><div><b>xfs_repair -V</b></div><div=
>
xfs_repair version 3.1.8</div><div><br></div><div>Number of CPU: 8</div><di=
v><br></div><div>processor =A0 =A0 =A0 : 7</div><div>vendor_id =A0 =A0 =A0 =
: GenuineIntel</div><div>cpu family =A0 =A0 =A0: 6</div><div>model =A0 =A0 =
=A0 =A0 =A0 : 23</div><div>
model name =A0 =A0 =A0: Intel(R) Xeon(R) CPU =A0 =A0 =A0 =A0 =A0 E5450 =A0@=
 3.00GHz</div><div>stepping =A0 =A0 =A0 =A0: 6</div><div>cpu MHz =A0 =A0 =
=A0 =A0 : 2999.800</div><div>cache size =A0 =A0 =A0: 6144 KB</div><div>phys=
ical id =A0 =A0 : 1</div><div>siblings =A0 =A0 =A0 =A0: 4</div>
<div>core id =A0 =A0 =A0 =A0 : 3</div><div>cpu cores =A0 =A0 =A0 : 4</div><=
div>apicid =A0 =A0 =A0 =A0 =A0: 7</div><div>initial apicid =A0: 7</div><div=
>fpu =A0 =A0 =A0 =A0 =A0 =A0 : yes</div><div>fpu_exception =A0 : yes</div><=
div>cpuid level =A0 =A0 : 10</div><div>wp =A0 =A0 =A0 =A0 =A0 =A0 =A0: yes<=
/div>
<div>flags =A0 =A0 =A0 =A0 =A0 : fpu vme de pse tsc msr pae mce cx8 apic se=
p mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm p=
be syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmper=
f pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 lah=
f_lm dtherm tpr_shadow vnmi flexpriority</div>
<div>bogomips =A0 =A0 =A0 =A0: 6003.48</div><div>clflush size =A0 =A0: 64</=
div><div>cache_alignment : 64</div><div>address sizes =A0 : 38 bits physica=
l, 48 bits virtual</div><div>power management:</div><div><br></div><div><b>=
cat /proc/meminfo</b></div>
<div>MemTotal: =A0 =A0 =A0 24738004 kB</div><div>MemFree: =A0 =A0 =A0 =A0 =
=A0903492 kB</div><div>Buffers: =A0 =A0 =A0 =A0 =A0 =A0 364 kB</div><div>Ca=
ched: =A0 =A0 =A0 =A0 22131464 kB</div><div>SwapCached: =A0 =A0 =A0 =A02804=
4 kB</div><div>Active: =A0 =A0 =A0 =A0 15011808 kB</div>
<div>Inactive: =A0 =A0 =A0 =A07694912 kB</div><div>Active(anon): =A0 123753=
96 kB</div><div>Inactive(anon): =A03024204 kB</div><div>Active(file): =A0 =
=A02636412 kB</div><div>Inactive(file): =A04670708 kB</div><div>Unevictable=
: =A0 =A0 =A0 =A05160 kB</div>
<div>Mlocked: =A0 =A0 =A0 =A0 =A0 =A05160 kB</div><div>SwapTotal: =A0 =A0 =
=A018874364 kB</div><div>SwapFree: =A0 =A0 =A0 13429788 kB</div><div>Dirty:=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 916 kB</div><div>Writeback: =A0 =A0 =A0 =A0 =
=A0 =A0 0 kB</div><div>AnonPages: =A0 =A0 =A0 =A0559160 kB</div>
<div>Mapped: =A0 =A0 =A0 =A0 13143856 kB</div><div>Shmem: =A0 =A0 =A0 =A0 =
=A014821620 kB</div><div>Slab: =A0 =A0 =A0 =A0 =A0 =A0 618944 kB</div><div>=
SReclaimable: =A0 =A0 499808 kB</div><div>SUnreclaim: =A0 =A0 =A0 119136 kB=
</div><div>KernelStack: =A0 =A0 =A0 =A05512 kB</div>
<div>PageTables: =A0 =A0 =A0 =A064124 kB</div><div>NFS_Unstable: =A0 =A0 =
=A0 =A0 =A00 kB</div><div>Bounce: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00 kB</div>=
<div>WritebackTmp: =A0 =A0 =A0 =A0 =A00 kB</div><div>CommitLimit: =A0 =A031=
243364 kB</div><div>Committed_AS: =A0 31705548 kB</div>
<div>VmallocTotal: =A0 34359738367 kB</div><div>VmallocUsed: =A0 =A0 =A0336=
820 kB</div><div>VmallocChunk: =A0 34359375216 kB</div><div>HardwareCorrupt=
ed: =A0 =A0 0 kB</div><div>AnonHugePages: =A0 =A0258048 kB</div><div>HugePa=
ges_Total: =A0 =A0 =A0 0</div>
<div>HugePages_Free: =A0 =A0 =A0 =A00</div><div>HugePages_Rsvd: =A0 =A0 =A0=
 =A00</div><div>HugePages_Surp: =A0 =A0 =A0 =A00</div><div>Hugepagesize: =
=A0 =A0 =A0 2048 kB</div><div>DirectMap4k: =A0 =A0 =A0129392 kB</div><div>D=
irectMap2M: =A0 =A025034752 kB</div><div>
<br></div><div><b>cat /proc/mounts</b></div><div>rootfs / rootfs rw 0 0</di=
v><div>udev /dev tmpfs rw,relatime,nr_inodes=3D0,mode=3D755 0 0</div><div>t=
mpfs /dev/shm tmpfs rw,relatime 0 0</div><div>/dev/mapper/system-root / xfs=
 rw,relatime,delaylog,noquota 0 0</div>
<div>proc /proc proc rw,relatime 0 0</div><div>sysfs /sys sysfs rw,relatime=
 0 0</div><div>devpts /dev/pts devpts rw,relatime,gid=3D5,mode=3D620,ptmxmo=
de=3D000 0 0</div><div>debugfs /sys/kernel/debug debugfs rw,relatime 0 0</d=
iv>
<div>/dev/cciss/c0d0p1 /boot ext3 rw,relatime,errors=3Dcontinue,user_xattr,=
acl,barrier=3D1,data=3Dordered 0 0</div><div>/dev/mapper/system-export /exp=
ort xfs rw,relatime,delaylog,noquota 0 0</div><div>/dev/mapper/system-opt /=
opt xfs rw,relatime,delaylog,noquota 0 0</div>
<div>/dev/mapper/system-var /var xfs rw,relatime,delaylog,noquota 0 0</div>=
<div>/dev/mapper/system-var /tmp xfs rw,relatime,delaylog,noquota 0 0</div>=
<div style>... etc</div><div><br></div><div><b>=A0cat /proc/partitions</b><=
/div>
<div><br></div><div>major minor =A0#blocks =A0name</div><div><br></div><div=
>=A0104 =A0 =A0 =A0 =A00 =A0143338560 cciss/c0d0</div><div>=A0104 =A0 =A0 =
=A0 =A01 =A0 =A0 104391 cciss/c0d0p1</div><div>=A0104 =A0 =A0 =A0 =A02 =A01=
43227507 cciss/c0d0p2</div><div>=A0253 =A0 =A0 =A0 =A00 =A0 10485760 dm-0</=
div>
<div>=A0253 =A0 =A0 =A0 =A01 =A0 10485760 dm-1</div><div>=A0253 =A0 =A0 =A0=
 =A02 =A0 =A08388608 dm-2</div><div>=A0253 =A0 =A0 =A0 =A03 =A0 18874368 dm=
-3</div><div>=A0253 =A0 =A0 =A0 =A04 =A0 =A05242880 dm-4</div><div>=A0 =A08=
 =A0 =A0 =A0 48 =A0536870912 sdd</div><div>=A0 =A08 =A0 =A0 =A0 =A00 =A0536=
870912 sda</div>
<div>=A0 =A08 =A0 =A0 =A0 64 =A0536870912 sde</div><div>=A0 =A08 =A0 =A0 =
=A0 32 =A0536870912 sdc</div><div>=A0 =A08 =A0 =A0 =A0 80 =A0536870912 sdf<=
/div><div>=A0 =A08 =A0 =A0 =A0 96 =A0536870912 sdg</div><div>=A0 =A08 =A0 =
=A0 =A0 16 =A0536870912 sdb</div><div>=A0 =A08 =A0 =A0 =A0112 =A0536870912 =
sdh</div>
<div>=A0 =A08 =A0 =A0 =A0128 =A0536870912 sdi</div><div>=A0 =A08 =A0 =A0 =
=A0160 =A0536870912 sdk</div><div>=A0 =A08 =A0 =A0 =A0144 =A0536870912 sdj<=
/div><div>=A0 =A08 =A0 =A0 =A0176 =A0536870912 sdl</div><div>=A0 =A08 =A0 =
=A0 =A0192 =A0536870912 sdm</div><div>=A0 =A08 =A0 =A0 =A0224 =A0536870912 =
sdo</div>
<div>=A0 =A08 =A0 =A0 =A0240 =A0536870912 sdp</div><div>=A0 =A08 =A0 =A0 =
=A0208 =A0536870912 sdn</div><div>=A0 65 =A0 =A0 =A0 =A00 =A0536870912 sdq<=
/div><div>=A0 65 =A0 =A0 =A0 16 =A0536870912 sdr</div><div>=A0 65 =A0 =A0 =
=A0 32 =A0536870912 sds</div><div>=A0 65 =A0 =A0 =A0 48 =A0536870912 sdt</d=
iv>
<div>=A0 65 =A0 =A0 =A0 64 =A0536870912 sdu</div><div>=A0 65 =A0 =A0 =A0 80=
 =A0536870912 sdv</div><div>=A0 65 =A0 =A0 =A0 96 =A0536870912 sdw</div><di=
v>=A0 65 =A0 =A0 =A0112 =A0536870912 sdx</div><div>=A0 65 =A0 =A0 =A0128 =
=A0536870912 sdy</div><div>=A0 65 =A0 =A0 =A0144 =A0536870912 sdz</div>
<div>=A0 65 =A0 =A0 =A0160 =A0536870912 sdaa</div><div>=A0 65 =A0 =A0 =A017=
6 =A0536870912 sdab</div><div>=A0 65 =A0 =A0 =A0192 =A0536870912 sdac</div>=
<div>=A0 65 =A0 =A0 =A0208 =A0536870912 sdad</div><div>=A0 65 =A0 =A0 =A022=
4 =A0536870912 sdae</div><div>=A0 65 =A0 =A0 =A0240 =A0536870912 sdaf</div>
<div>=A0253 =A0 =A0 =A0 =A05 =A0536870912 dm-5</div><div>=A0253 =A0 =A0 =A0=
 =A06 =A0536870912 dm-6</div><div style>=A0etc....</div></div></div><div cl=
ass=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Fri, Feb 22, 2013=
 at 9:25 PM, Ben Myers <span dir=3D"ltr">&lt;<a href=3D"mailto:bpm@sgi.com"=
 target=3D"_blank">bpm@sgi.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Hi Erik,<br>
<div><div class=3D"h5"><br>
On Fri, Feb 22, 2013 at 02:04:17PM +0100, Erik Knight wrote:<br>
&gt; We&#39;ve recently noticed that our system is experiencing extreme per=
formance<br>
&gt; problems when running large workloads. The problem seems to come from<=
br>
&gt; excessive System CPU time. Specifically dozens of xfsaild threads. We =
used<br>
&gt; to have SSD drives but recently switched to HDD, so some of us are thi=
nking<br>
&gt; that there may be a configuration issue within XFS that is optimized f=
or<br>
&gt; SSD but performs terribly slow on HDD.<br>
&gt;<br>
&gt; Can anyone explain what these threads do, what would cause so many of =
them<br>
&gt; to be running simultaneously or consume so much CPU?<br>
<br>
</div></div>AIL stands for Active Item List. =A0These guys sync metadata wh=
ich has been<br>
logged to its final location on disk. =A0You&#39;ll have one daemon per fil=
esystem.<br>
<br>
If you have a very metadata intensive workload they could get a workout. =
=A0It<br>
would help to know a bit more about your workload and configuration. =A0Can=
 you<br>
provide the relevant information listed here?<br>
<br>
<a href=3D"http://www.xfs.org/index.php/XFS_FAQ#Q:_What_information_should_=
I_include_when_reporting_a_problem.3F" target=3D"_blank">http://www.xfs.org=
/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_pr=
oblem.3F</a><br>

<br>
Regards,<br>
=A0 =A0 =A0 =A0 Ben<br>
</blockquote></div><br></div>

--e89a8f8396753c99e404d6768418--


--===============3437179228783312014==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3437179228783312014==--
