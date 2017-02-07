Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46802 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754339AbdBGNBw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Feb 2017 08:01:52 -0500
Date: Tue, 7 Feb 2017 14:01:38 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: xfs wrongly report ENOSPACE
Message-ID: <20170207130138.l3vnuzuhbvxerdag@eorzea.usersys.redhat.com>
References: <58986E06.5050500@xtaotech.com>
 <20170206131435.GA57865@bfoster.bfoster>
 <5899C016.70308@xtaotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5899C016.70308@xtaotech.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "peng.hse" <peng.hse@xtaotech.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

> > In this case, please at least provide the output from 'df -i <mnt>,'
> > 'xfs_info <mnt>' and 'xfs_db -c "freesp -s" <dev>.'
> > 
> > Chances are that this is caused by free space fragmentation. This means
> > that while there might be plenty of free space, there isn't a contiguous
> > free extent large enough to allocate an inode chunk. We've seen this
> > kind of thing before with Ceph and it can be exacerbated by the use of
> > large inodes. Potential workarounds may be to use the default inode size
> > and/or enable the use of sparse inodes ('mkfs.xfs -i sparse <dev>').
> > 
> > Another possible cause is that you've simply hit the maximum inode
> > allocation limit (see the xfs_growfs manpage and the '-m' option)...
> > 
> > Brian
> > 
> 
> the problematic mnt point is /mnt/819f7954-bf88-430d-a637-a08bad56cf6e/
> 
> [root@xt1 ~]# touch /mnt/819f7954-bf88-430d-a637-a08bad56cf6e/xx
> touch: cannot touch ‘/mnt/819f7954-bf88-430d-a637-a08bad56cf6e/xx’: No space
> left on device
> 
> [root@xt1 ~]# df -i /mnt/819f7954-bf88-430d-a637-a08bad56cf6e/
> Filesystem     Inodes    IUsed   IFree       IUse%  Mounted on
> /dev/sdc2      982848  47296  935552    5%
> /mnt/819f7954-bf88-430d-a637-a08bad56cf6e
> 
> 
> 
> [root@xt1 ~]# xfs_info /mnt/819f7954-bf88-430d-a637-a08bad56cf6e
> meta-data=/dev/sdc2              isize=2048    agcount=4, agsize=491455 blks
>                  =                             sectsz=512   attr=2,

2048 bytes inode, I'd bet your filesystem is fragmented enough to not have any
more room to create inodes into it.

> projid32bit=1
>                  =                             crc=0 finobt=0
> data          =                             bsize=4096 blocks=1965819,
> imaxpct=25
>                  =                             sunit=0 swidth=0 blks
> naming     =version 2               bsize=4096   ascii-ci=0 ftype=0
> log            =internal                  bsize=4096   blocks=2560,
> version=2
>                  =                              sectsz=512   sunit=0 blks,
> lazy-count=1
> realtime    =none                      extsz=4096   blocks=0, rtextents=0
> 
> 
> 
> [root@xt1 ~]# xfs_db -r '-c freesp -s' /dev/sdc2
>    from      to extents  blocks    pct
>       1       1      80      80   0.01
>       2       3      61     159   0.02
>       4       7      88     483   0.06
>       8      15     146    1680   0.21
>      16      31   34312  788594  99.70

for creating new inodes you will need a contiguous space of 131072 bytes, which
you don't have anymore, so you won't be able to create any more files into this
filesystem, unless you free up some space to allow room for the creation of new
inodes.

XFS create inodes in chunks of 64 inodes, if you don't have enough space for
that, then you get a -ENOSPC as you are getting.


Cheers.


> total free extents 34687
> total free blocks 790996
> average free extent size 22.8038
> 
> the total number of files underneath the mnt is
> [root@xt1 819f7954-bf88-430d-a637-a08bad56cf6e]# find . |wc -l
> 47294
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
