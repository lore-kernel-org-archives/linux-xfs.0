Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42808 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726768AbeIRRTB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Sep 2018 13:19:01 -0400
Date: Tue, 18 Sep 2018 07:46:47 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-writecache issue
In-Reply-To: <20180911221147.GA23308@redhat.com>
Message-ID: <alpine.LRH.2.02.1809180741001.6599@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180911221147.GA23308@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, David Teigland <teigland@redhat.com>

I would ask the XFS developers about this - why does mkfs.xfs select 
sector size 512 by default?

If a filesystem created with the default 512-byte sector size is activated 
on a device with 4k sectors, it results in mount failure.

Mikulas



On Tue, 11 Sep 2018, David Teigland wrote:

> Hi Mikulas,
> 
> Am I doing something wrong below or is there a bug somewhere?  (I could be
> doing something wrong in the lvm activation code, also.)
> Thanks
> 
> 
> [root@null-05 ~]# lvs foo
>   LV   VG  Attr       LSize   
>   fast foo -wi-------  32.00m
>   main foo -wi------- 200.00m
> 
> [root@null-05 ~]# lvchange -ay foo/main
> 
> [root@null-05 ~]# mkfs.xfs /dev/foo/main
> meta-data=/dev/foo/main          isize=512    agcount=4, agsize=12800 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=0, sparse=0
> data     =                       bsize=4096   blocks=51200, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal log           bsize=4096   blocks=855, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> [root@null-05 ~]# mount /dev/foo/main /mnt
> [root@null-05 ~]# cp /root/pattern* /mnt/
> [root@null-05 ~]# umount /mnt
> [root@null-05 ~]# lvchange -an foo/main
> 
> [root@null-05 ~]# lvconvert --type writecache --cachepool fast foo/main
>   Logical volume foo/main now has write cache.
> 
> [root@null-05 ~]# lvs -a foo -o+devices
>   LV            VG  Attr       LSize   Origin        Devices       
>   [fast]        foo -wi-------  32.00m               /dev/pmem0(0) 
>   main          foo Cwi------- 200.00m [main_wcorig] main_wcorig(0)
>   [main_wcorig] foo -wi------- 200.00m               /dev/loop0(0) 
> 
> [root@null-05 ~]# lvchange -ay foo/main
> 
> [root@null-05 ~]# dmsetup ls
> foo-main_wcorig (253:4)
> rhel_null--05-home      (253:2)
> foo-main        (253:5)
> foo-fast        (253:3)
> rhel_null--05-swap      (253:1)
> rhel_null--05-root      (253:0)
> 
> [root@null-05 ~]# dmsetup table
> foo-main_wcorig: 0 409600 linear 7:0 2048
> rhel_null--05-home: 0 853286912 linear 8:2 16517120
> foo-main: 0 409600 writecache p 253:4 253:3 4096 0
> foo-fast: 0 65536 linear 259:0 2048
> rhel_null--05-swap: 0 16515072 linear 8:2 2048
> rhel_null--05-root: 0 104857600 linear 8:2 869804032
> 
> [root@null-05 ~]# mount /dev/foo/main /mnt
> mount: mount /dev/mapper/foo-main on /mnt failed: Function not implemented
> 
> [root@null-05 ~]# dmesg | tail -1
> [802734.176118] XFS (dm-5): device supports 4096 byte sectors (not 512)
> 
> [root@null-05 ~]# lvchange -an foo/main
> 
> [root@null-05 ~]# lvconvert --splitcache foo/main
>   Logical volume foo/main write cache has been detached.
> 
> [root@null-05 ~]# lvchange -ay foo/main
> 
> [root@null-05 ~]# mount /dev/foo/main /mnt
> 
> [root@null-05 ~]# diff /mnt/pattern1 /root/pattern1
> 
> [root@null-05 ~]# lvs foo
>   LV   VG  Attr       LSize   
>   fast foo -wi-------  32.00m
>   main foo -wi-ao---- 200.00m
> 
