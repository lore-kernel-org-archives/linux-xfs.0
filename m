Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr002msb.fastweb.it ([85.18.95.86]:56567 "EHLO
        mr002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750997AbcKYKqw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Nov 2016 05:46:52 -0500
Received: from ceres.assyoma.it (93.63.55.57) by mr002msb.fastweb.it (8.5.140.05)
        id 579B514005B8038C for linux-xfs@vger.kernel.org; Fri, 25 Nov 2016 11:40:41 +0100
From: Gionatan Danti <g.danti@assyoma.it>
Subject: Slow file stat/deletion
Message-ID: <bef58272-f791-52bf-cc4c-1cb1b7c9efec@assyoma.it>
Date: Fri, 25 Nov 2016 11:40:40 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Gionatan Danti <g.danti@assyoma.it>

Hi all,
I am using a XFS filesystem as a target for rsnapshot hardlink-based 
backups.

Being hardlink-based, our backups generally are quite fast. However, I 
noticed that for some directories having many small files the longer 
part of the backup process is to remove the old (out-of-retention) 
subdirs that must be purged to make room for the new backup iteration.

Further analysis show that the slower part of the 'rm' process is the 
reading of the affected inodes/dentries. An example: to remove a subdir 
with ~700000 files and directories, the system needs about 30 minutes. 
At the same time, issuing a simple "find <dir> / | wc -l" (after having 
dropped the caches) need ~24 minutes. In other words, actual reads need 
4x the real delete time.

So, my question is: there is anything I can do to speedup the 
read/stat/deletion?

Here is my system config:
CPU: AMD Opteron(tm) Processor 4334
RAM: 16 GB
HDD: 12x 2TB WD RE in a RAID6 array (64k stripe unit), attached to a 
PERC H700 controller with 512MB BBU writeback cache
OS:  CentOS 7.2 x86_64 with 3.10.0-327.18.2.el7.x86_64 kernel

Relevant LVM setup:
LV           VG         Attr       LSize  Pool         Origin Data% 
Meta%  Move Log Cpy%Sync Convert Chunk
000-ThinPool vg_storage twi-aotz-- 10,85t                     86,71 
38,53                            8,00m
Storage      vg_storage Vwi-aotz-- 10,80t 000-ThinPool        87,12 
                                 0

XFS filesystem info:
meta-data=/dev/mapper/vg_storage-Storage isize=512    agcount=32, 
agsize=90596992 blks
          =                       sectsz=512   attr=2, projid32bit=1
          =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=2899103744, imaxpct=5
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Some consideration:
1) I am using a single big thin volume because back in the time ( >2 
years ago) I was not sure about XFS and, having no shrinking capability, 
I relayed on thin volume unmap should the filesystem choice change. 
However, thin pool's chunk size is quite big (8 MB) so it should not 
pose acute fragmentation problem;

2) due to being layered over a thinly provided volume, the filesystem 
was created with "noalign" option. I run some in-the-lab test on a spare 
machine and I (still) find that this option seems to *lower* the time 
needed to stat/delete files when XFS is on top of a thin volume, so I do 
not think this is a problem. I'm right?

3) the filesystem is over 2 years old and has a very big number of files 
on it (inode count is 12588595, but each inode has multiple hardlinked 
files). Is this slow delete performance a side effect of "aging" ?

4) I have not changed the default read-ahead value (256 KB). I know this 
is quite small compared to available disk resources but, before messing 
with low-level block device tuning, I would really like to know your 
opinion on my case.

Thank you all.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
