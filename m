Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Jun 2007 13:04:40 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5FK4ZWt021417
	for <linux-xfs@oss.sgi.com>; Fri, 15 Jun 2007 13:04:36 -0700
Received: from localhost (dslb-084-056-065-071.pools.arcor-ip.net [84.56.65.71])
	by mail.lichtvoll.de (Postfix) with ESMTP id 91E245AD56
	for <linux-xfs@oss.sgi.com>; Fri, 15 Jun 2007 22:04:36 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: xfs_fsr - problem with open files possible?
Date: Fri, 15 Jun 2007 22:04:34 +0200
References: <200706151804.43067.Martin@lichtvoll.de> <4672C531.9020802@sandeen.net> <200706152013.52836.Martin@lichtvoll.de> (sfid-20070615_203725_895576_F4CF076E)
In-Reply-To: <200706152013.52836.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706152204.34506.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Freitag 15 Juni 2007 schrieb Martin Steigerwald:

> Hello Eric!
>
> Well also from the man page as I just found out after sending my mail:
>
> "xfs_fsr  can  be  called with one or more arguments naming filesystems
> (block device name), and files to reorganize.  In this mode xfs_fsr
> does not read or write /var/tmp/.fsrlast_xfs nor does it run for a
> fixed time interval.  It makes  one pass through each specified regular
> file and all regular files in each specified filesystem.  A command
> line name referring to a symbolic link (except to a file system
> device), FIFO, or UNIX domain socket generates a warning  message,  but
> is otherwise ignored.  While traversing the filesystem these types of
> files are silently skipped."
>
> So maybe something along the lines of:
>
> xfs_fsr ~/Mail/.trash.index
>
> while it is open by KMail should be enough. I think I will give this a
> try soon.

Hello!

Hmmm, could not reproduce it with a single file. xfs_fsr seems to be 
behaving correctly:

shambala:Mail/.Lichtvoll.directory/.Linux.directory> 
xfs_bmap -v .Kernel.index
.Kernel.index:
 EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET          TOTAL
   0: [0..167]:        83985960..83986127 15 (1586760..1586927)   168
   1: [168..175]:      83985824..83985831 15 (1586624..1586631)     8
shambala:Mail/.Lichtvoll.directory/.Linux.directory> md5sum .Kernel.index
9d1fdd1138e297fd97548a3a4696e308  .Kernel.index

Started Kontact (KMail)...

shambala:Mail/.Lichtvoll.directory/.Linux.directory> md5sum .Kernel.index
9d1fdd1138e297fd97548a3a4696e308  .Kernel.index
shambala:Mail/.Lichtvoll.directory/.Linux.directory> lsof .Kernel.index
COMMAND   PID   USER   FD   TYPE DEVICE  SIZE      NODE NAME
kontact 15985 martin  mem    REG    8,2 86497 254828298 .Kernel.index
kontact 15985 martin   23u   REG    8,2 86497 254828298 .Kernel.index
shambala:Mail/.Lichtvoll.directory/.Linux.directory> 
cp -a .Kernel.index .Kernel.index.old
shambala:Mail/.Lichtvoll.directory/.Linux.directory> 
md5sum .Kernel.index.old
9d1fdd1138e297fd97548a3a4696e308  .Kernel.index.old
shambala:Mail/.Lichtvoll.directory/.Linux.directory> md5sum .Kernel.index
9d1fdd1138e297fd97548a3a4696e308  .Kernel.index

Trying to defragment while file is open: xfs_fsr seems to leave the file 
alone completely like it should.

shambala:Mail/.Lichtvoll.directory/.Linux.directory> xfs_fsr .Kernel.index
shambala:Mail/.Lichtvoll.directory/.Linux.directory> 
xfs_bmap -v .Kernel.index
.Kernel.index:
 EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET          TOTAL
   0: [0..167]:        83985960..83986127 15 (1586760..1586927)   168
   1: [168..175]:      83985824..83985831 15 (1586624..1586631)     8
shambala:Mail/.Lichtvoll.directory/.Linux.directory> md5sum .Kernel.index
9d1fdd1138e297fd97548a3a4696e308  .Kernel.index

Also on a second try

shambala:Mail/.Lichtvoll.directory/.Linux.directory> xfs_fsr .Kernel.index
shambala:Mail/.Lichtvoll.directory/.Linux.directory> 
xfs_bmap -v .Kernel.index
.Kernel.index:
 EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET          TOTAL
   0: [0..167]:        83985960..83986127 15 (1586760..1586927)   168
   1: [168..175]:      83985824..83985831 15 (1586624..1586631)     8
shambala:Mail/.Lichtvoll.directory/.Linux.directory> md5sum .Kernel.index
9d1fdd1138e297fd97548a3a4696e308  .Kernel.index

Stopping Kontact (KMail) and trying to defragment then... well now it 
defragments. md5sum stays the fine.

shambala:Mail/.Lichtvoll.directory/.Linux.directory> md5sum .Kernel.index
9d1fdd1138e297fd97548a3a4696e308  .Kernel.index
shambala:Mail/.Lichtvoll.directory/.Linux.directory> xfs_fsr .Kernel.index
shambala:Mail/.Lichtvoll.directory/.Linux.directory> 
xfs_bmap -v .Kernel.index
.Kernel.index:
 EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET          TOTAL
   0: [0..175]:        86612448..86612623 15 (4213248..4213423)   176
shambala:Mail/.Lichtvoll.directory/.Linux.directory> md5sum .Kernel.index
9d1fdd1138e297fd97548a3a4696e308  .Kernel.index


Hmmm, maybe there is some race condition that is not triggered always. If 
I find time I let xfs_fsr run von ~/Mail or folder with several sub 
folders so that more index files are touched. I can make a backup, let it 
run and if Kontact / KMail complains look at the differences.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
