Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Jun 2008 14:56:04 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5TLtnF3024528
	for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 14:55:51 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C5F2184E584
	for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 14:56:50 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id njN4bQa5qpDTfJve for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 14:56:50 -0700 (PDT)
Date: Mon, 30 Jun 2008 07:56:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs Access to block zero  exception and system crash
Message-ID: <20080629215647.GJ29319@disturbed>
References: <340C71CD25A7EB49BFA81AE8C839266701323BD8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080625084931.GI16257@build-svl-1.agami.com> <340C71CD25A7EB49BFA81AE8C839266701323BE8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080626070215.GI11558@disturbed> <4864BD5D.1050202@pmc-sierra.com> <4864C001.2010308@pmc-sierra.com> <20080628000516.GD29319@disturbed> <340C71CD25A7EB49BFA81AE8C8392667028A1CA7@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <340C71CD25A7EB49BFA81AE8C8392667028A1CA7@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sagar Borikar <Sagar_Borikar@pmc-sierra.com>
Cc: xfs@oss.sgi.com

On Sat, Jun 28, 2008 at 09:47:44AM -0700, Sagar Borikar wrote:
> > FWIW, can you send the output of xfs_growfs -n <mntpt> and details
> > of the partitioning and volume config?
....
> [root@NAS001ee5ab9c85 ~]# cat /etc/fstab
> /dev/root       /              ext2     rw,noauto         0      1
> proc            /proc          proc     defaults          0      0
> devpts          /dev/pts       devpts   defaults,gid=5,mode=620   0
> 0
> tmpfs           /tmp           tmpfs    defaults          0      0
> /dev/RAIDA/vol  /mnt/RAIDA/vol  xfs     defaults,usrquota,grpquota
> 0 0
> /mnt/RAIDA/vol/sh       /mnt/ftp_dir/sh none    rw,bind 0 0
> /mnt/RAIDA/vol/.autohome/       /mnt/ftp_dir/homes      none    rw,bind
> 0 0
> 
> [root@NAS001ee5ab9c85 ~]# fdisk -l
> 
> Disk /dev/scsibd: 257 MB, 257425408 bytes
> 8 heads, 32 sectors/track, 1964 cylinders
> Units = cylinders of 256 * 512 = 131072 bytes
> 
>       Device Boot      Start         End      Blocks   Id  System
> /dev/scsibd1             126         286       20608   83  Linux
> /dev/scsibd2             287        1023       94336   83  Linux
> /dev/scsibd3            1149        1309       20608   83  Linux
> /dev/scsibd4            1310        2046       94336   83  Linux

I'd have to assume thats a flash based root drive, right?

> Disk /dev/md0: 251.0 GB, 251000160256 bytes
> 2 heads, 4 sectors/track, 61279336 cylinders
> Units = cylinders of 8 * 512 = 4096 bytes
> 
> Disk /dev/md0 doesn't contain a valid partition table
> 
> Disk /dev/dm-0: 107.3 GB, 107374182400 bytes
> 255 heads, 63 sectors/track, 13054 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes

Neither of these tell me what /dev/RAIDA/vol is....

> But still the issue is why doesn't it happen every time and less stress?
> 
> I am surprised to see to let this happen immediately when the
> subdirectories increase more than 30. Else it decays slowly.

So it happens when you get more than 30 entries in a directory
under a certain load? That might be an extent->btree format
conversion bug or vice versa. I'd suggest setting up a test based
around this to try to narrow down the problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
