Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jan 2008 02:15:29 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0TAFKFL012925
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 02:15:20 -0800
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 687F75729BB
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 02:15:36 -0800 (PST)
Received: from postoffice.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id RIdcHEa59ojgIjqs for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 02:15:36 -0800 (PST)
Message-ID: <43347.192.168.3.1.1201601702.squirrel@mail.aconex.com>
In-Reply-To: <20080129093201.GA16203@citd.de>
References: <20080129093201.GA16203@citd.de>
Date: Tue, 29 Jan 2008 21:15:02 +1100 (EST)
Subject: Re: mkfs.xfs doesn't detect size of storage correctly
From: nscott@aconex.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

> Hi
>
>
> Yesterday i bought a 750GB HDD.
> I encrypt nearly everything with loop-aes, so i also did it with this
> HDD.
>
> I create a "fake" partition table and:
> losetup -e aes256 -p 0 -o 4096 /dev/loop6 /dev/sdb < key
>
> This creates a loop with everything except the first 4KB, i.e. it leaves
> out the MBR and another 3,5KB.
>
> /proc/partions shows the correct(tm) size informations for the HDD and
> the loop:
> - snip -
>    7     6  732574580 loop6
>    8    16  732574584 sdb
>    8    17  732572001 sdb1
> - snip -
>
> But when i mkfs.xfs the loop
> #> mkfs.xfs /dev/loop6
> meta-data=/dev/loop6             isize=256    agcount=3, agsize=45785911
> blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=137357733, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096
> log      =internal log           bsize=4096   blocks=32768, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>
> And mount it:
> mount /dev/loop6 /mnt
>
> And least but not least df it:
> #> df -m /mnt
> Filesystem           1M-blocks      Used Available Use% Mounted on
> /dev/loop6              536426         5    536422   1% /mnt
>
> There is roughly 1/3 missing.
>
> What can i do to fix this?

mkfs.xfs uses the BLKGETSIZE64 ioctl to extract the device size, so
the problem is likely in the loop device driver (just a guess).  You
can use the test program xfs-cmds/xfstests/src/getdevicesize.c to
test what that device returns as its size (no XFS-specific code in the
test program, so if it returns bad data we've narrowed down the root
cause a whole lot).

What does that program produce for your device?

cheers.

--
Nathan
