Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 28 Jun 2008 09:46:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5SGkFUX020180
	for <xfs@oss.sgi.com>; Sat, 28 Jun 2008 09:46:17 -0700
Received: from bby1mta01.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 00EC129869E
	for <xfs@oss.sgi.com>; Sat, 28 Jun 2008 09:47:16 -0700 (PDT)
Received: from bby1mta01.pmc-sierra.bc.ca (bby1mta01.pmc-sierra.com [216.241.235.116]) by cuda.sgi.com with ESMTP id BvADjiWvwg6yD1pJ for <xfs@oss.sgi.com>; Sat, 28 Jun 2008 09:47:16 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Xfs Access to block zero  exception and system crash
Date: Sat, 28 Jun 2008 09:47:44 -0700
Message-ID: <340C71CD25A7EB49BFA81AE8C8392667028A1CA7@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
In-Reply-To: <20080628000516.GD29319@disturbed>
References: <340C71CD25A7EB49BFA81AE8C839266701323BD8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080625084931.GI16257@build-svl-1.agami.com> <340C71CD25A7EB49BFA81AE8C839266701323BE8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080626070215.GI11558@disturbed> <4864BD5D.1050202@pmc-sierra.com> <4864C001.2010308@pmc-sierra.com> <20080628000516.GD29319@disturbed>
From: "Sagar Borikar" <Sagar_Borikar@pmc-sierra.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


Dave,

Attaching required information:

> nothing to do with memory availabilty, I think.

> FWIW, can you send the output of xfs_growfs -n <mntpt> and details
> of the partitioning and volume config?

[root@NAS001ee5ab9c85 ~]# xfs_growfs -n /mnt/RAIDA/vol/
meta-data=/dev/RAIDA/vol         isize=256    agcount=16, agsize=1638400
blks
         =                       sectsz=512   attr=1
data  =                       bsize=4096   blocks=26214400, imaxpct=25
        =                       sunit=0      swidth=0 blks, unwritten=1
naming=version 2              bsize=4096
log      =internal               bsize=4096   blocks=12800, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0

[root@NAS001ee5ab9c85 ~]# cat /etc/fstab
/dev/root       /              ext2     rw,noauto         0      1
proc            /proc          proc     defaults          0      0
devpts          /dev/pts       devpts   defaults,gid=5,mode=620   0
0
tmpfs           /tmp           tmpfs    defaults          0      0
/dev/RAIDA/vol  /mnt/RAIDA/vol  xfs     defaults,usrquota,grpquota
0 0
/mnt/RAIDA/vol/sh       /mnt/ftp_dir/sh none    rw,bind 0 0
/mnt/RAIDA/vol/.autohome/       /mnt/ftp_dir/homes      none    rw,bind
0 0

[root@NAS001ee5ab9c85 ~]# fdisk -l

Disk /dev/scsibd: 257 MB, 257425408 bytes
8 heads, 32 sectors/track, 1964 cylinders
Units = cylinders of 256 * 512 = 131072 bytes

      Device Boot      Start         End      Blocks   Id  System
/dev/scsibd1             126         286       20608   83  Linux
/dev/scsibd2             287        1023       94336   83  Linux
/dev/scsibd3            1149        1309       20608   83  Linux
/dev/scsibd4            1310        2046       94336   83  Linux

Disk /dev/md0: 251.0 GB, 251000160256 bytes
2 heads, 4 sectors/track, 61279336 cylinders
Units = cylinders of 8 * 512 = 4096 bytes

Disk /dev/md0 doesn't contain a valid partition table

Disk /dev/dm-0: 107.3 GB, 107374182400 bytes
255 heads, 63 sectors/track, 13054 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

But still the issue is why doesn't it happen every time and less stress?

I am surprised to see to let this happen immediately when the
subdirectories increase more than 30. Else it decays slowly.

Thanks
Sagar

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
