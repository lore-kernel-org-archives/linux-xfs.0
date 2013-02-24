Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5C5867F37
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 15:38:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 303D2304039
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 13:38:02 -0800 (PST)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
	[209.85.212.178]) by cuda.sgi.com with ESMTP id
	Dep3AlTmBXm1qYlD (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 24 Feb 2013 13:38:00 -0800 (PST)
Received: by mail-wi0-f178.google.com with SMTP id o1so2520251wic.5
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 13:37:59 -0800 (PST)
MIME-Version: 1.0
From: wolfwings@wolfwings.us
Date: Sun, 24 Feb 2013 15:37:39 -0600
Message-ID: <CAG+9BZWD9mg+NAy+QdobPRkQJS4b6TTkiAvKWD4Q-gLH0AYU3g@mail.gmail.com>
Subject: xfs_growfs: Cannot allocate memory on an online resize 60GB->120GB,
	30+GB free RAM.
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Complete error message:

> xfs_growfs /
meta-data=/dev/sdc4              isize=256    agcount=4, agsize=5999616 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=23998464, imaxpct=25
         =                       sunit=512    swidth=512 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=11720, version=2
         =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Cannot allocate memory

> gdisk -l /dev/sdc
GPT fdisk (gdisk) version 0.8.5

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sdc: 468862128 sectors, 223.6 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): B9C5F617-E746-4356-ABC3-FBEDA055287C
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 468862094
Partitions will be aligned on 2048-sector boundaries
Total free space is 84866157 sectors (40.5 GiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048         1023999   499.0 MiB   EF00  EFI system partition
   2         1024000         2047999   500.0 MiB   0C01  Microsoft reserved part
   3         2048000       127997951   60.1 GiB    0700  Basic data partition
   4       128000000       383999999   122.1 GiB   8300  Linux filesystem

> mount | grep " / "
rootfs on / type rootfs (rw)
/dev/sdc4 on / type xfs
(rw,noatime,attr2,inode64,sunit=4096,swidth=4096,noquota)

> free
             total       used       free     shared    buffers     cached
Mem:      32722828     847340   31875488          0        664     355164
-/+ buffers/cache:     491512   32231316
Swap:            0          0          0

> df | egrep " /$"
rootfs          95946976 29250996  66695980  31% /
/dev/sdc4       95946976 29250996  66695980  31% /

I'm not in a rush to do this resize, I was deleting some other OSes
and growing my Linux install; I have plenty of filesystem space left
even now, so felt it better to report this so I could either
understand what I'm doing wrong and/or help troubleshoot a possible
bug this since it seems really strange to get an ENOMEM when I have...
well, 30+GB of memory free.

It's a ThinkPad W530 if that matters, I can dump further details if needed?

- Wolf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
