Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:33455 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdB1EPo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Feb 2017 23:15:44 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v1S2sddw009079
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2017 02:54:39 GMT
Date: Mon, 27 Feb 2017 18:52:48 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs_growfs 3.2.1 on Knoppix-ADRIANE from Debian 7 does not grow
Message-ID: <20170228025248.GC5297@birch.djwong.org>
References: <20170228023724.GJ23709@justpickone.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170228023724.GJ23709@justpickone.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David T-G <davidtg@justpickone.org>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 27, 2017 at 09:37:24PM -0500, David T-G wrote:
> Hi, all --
> 
> I finally settled on xfs as the filesystem for my raid5 volume on my
> home computer even though I've been a longtime reiserfs lover :-)  But,
> hey, let's try something new.
> 
> I recently added another device to my md raid5 set and expanded the
> device from 8T to 12T, and now I want to grow the filesystem.  I remade
> the partition and we oughta be good to go:
> 
>   diskfarm:root:10:~> parted /dev/md0 print | egrep 'TB|Table|Sector'
>   Disk /dev/md0: 12.0TB
>   Sector size (logical/physical): 512B/4096B
>   Partition Table: gpt
>    1      1049kB  12.0TB  12.0TB  xfs          Linux filesystem
> 
> When I try xfs_growfs, however, nothing changes:
> 
>   diskfarm:root:10:~> df -kh /mnt/4Traid5md/
>   Filesystem      Size  Used Avail Use% Mounted on
>   /dev/md0p1      7.3T  6.5T  863G  89% /mnt/4Traid5md
>   diskfarm:root:10:~> xfs_growfs -d /mnt/4Traid5md/
>   meta-data=/dev/md0p1             isize=256    agcount=32, agsize=61043072 blks

Did parted tell the kernel to reread the partition table?

blockdev --getsz /dev/md0p1 will tell us the kernel's view of how big
md0p1 is right now.

unmount, blockdev --rereadpt /dev/md0, try again(?)

--D

>            =                       sectsz=4096  attr=2, projid32bit=1
>            =                       crc=0        finobt=0
>   data     =                       bsize=4096   blocks=1953377275, imaxpct=5
>            =                       sunit=128    swidth=256 blks
>   naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
>   log      =internal               bsize=4096   blocks=521728, version=2
>            =                       sectsz=4096  sunit=1 blks, lazy-count=1
>   realtime =none                   extsz=4096   blocks=0, rtextents=0
>   data size unchanged, skipping
>   diskfarm:root:10:~> df -kh /mnt/4Traid5md/
>   Filesystem      Size  Used Avail Use% Mounted on
>   /dev/md0p1      7.3T  6.5T  863G  89% /mnt/4Traid5md
> 
> I've searched high and low and haven't found any indication of why I
> shouldn't be able to grow as long as the partition is large enough, so
> now it's time to dive into the mailing list :-)
> 
> Please bcc: me on your replies since I am not subscribed.  I promise to
> follow up with my ongoing results :-)
> 
> 
> TIA & HAND
> 
> :-D
> -- 
> David T-G
> See http://justpickone.org/davidtg/email/
> See http://justpickone.org/davidtg/tofu.txt
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
