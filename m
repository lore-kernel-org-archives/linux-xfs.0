Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3U05YuG112018 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 19:05:34 -0500
Received: from mail-iw0-f193.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 374D9300292
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 17:07:38 -0700 (PDT)
Received: from mail-iw0-f193.google.com (mail-iw0-f193.google.com
	[209.85.223.193]) by cuda.sgi.com with ESMTP id
	1DQa6HF9BNmBwpId for <xfs@oss.sgi.com>;
	Thu, 29 Apr 2010 17:07:38 -0700 (PDT)
Received: by iwn31 with SMTP id 31so9284064iwn.30
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 17:07:38 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 29 Apr 2010 17:07:37 -0700
Message-ID: <i2hdb2d1ee61004291707k9ffebed2k4ff6eb72354cbe63@mail.gmail.com>
Subject: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Argument list too
	long
From: Benjamin Lau <benjamin.a.lau@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

I've been using XFS for about a decade and have never run across this
error before... then again I've never grown a file system to as large
as size as this one either.

First a little about the setup.  I have a large disk array that I use
for storing media.  I've been growing it a bit at a time over the past
2 years.  To accomplish this I have setup a collection of RAIDed
drives that are then bound together using LVM so I can increase the
size of the array as I acquire new disks.  So far this process has
worked fine while growing the array from it's initial size of 2TB to
approximately 9TB.

Today I was adding another collection of drives (6 2TB drives in a
RAID-5 configuration for an additional 10TB or storage) and performed
the usual steps[1] to grow extend the LVM group and grow the file
system using xfs_growfs.  When I encountered the following error:

xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Argument list too long [2]

I'm guessing something about my configuration is funky... but I'm not
sure what and was wondering if anybody on this list had any thoughts
or suggestions of things to try.  I'm not sure what information I
should provide to help with tracking down this issue... but I can
provide anything that is requested.  I've included some additional
data below.

Everything is working fine otherwise and the file system is up and
running and able to provide the usual services.

Thanks in advance,

Ben

[1] Usual set of commands to grow the filesystem:
pvcreate /dev/md7
vgextend vg00 /dev/md7
lvextend --extents +100%FREE /dev/vg00/lv_raid
xfs_growfs /dev/vg00/lv_raid

[2] Full output of xfs_growfs:
meta-data=/dev/mapper/vg00-lv_raid isize=256    agcount=40, agsize=61047552 blks
            =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=2441868288, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Argument list too long

OS/Kernel Info:
Debian Lenny
Linux bigmama 2.6.30-2-686-bigmem #1 SMP Sat Sep 26 02:30:18 UTC 2009
i686 GNU/Linux

Custom kernel with bigmem enabled to allow access to memory about 4GB
on a 32-bit CPU

/proc/cpuinfo:


processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 4
model name	: Intel(R) Xeon(TM) CPU 3.20GHz
stepping	: 1
cpu MHz		: 3200.222
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc pebs bts pni dtes64 monitor ds_cpl cid cx16 xtpr
bogomips	: 6400.44
clflush size	: 64
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 15
model		: 4
model name	: Intel(R) Xeon(TM) CPU 3.20GHz
stepping	: 1
cpu MHz		: 3200.222
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc pebs bts pni dtes64 monitor ds_cpl cid cx16 xtpr
bogomips	: 6400.66
clflush size	: 64
power management:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
