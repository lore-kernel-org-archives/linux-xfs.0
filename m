Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 23 Feb 2008 14:14:12 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1NME96m013843
	for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 14:14:10 -0800
Received: from ug-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A99260E4B3
	for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 14:14:35 -0800 (PST)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.173]) by cuda.sgi.com with ESMTP id ZzVENbQQCMLsRpdI for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 14:14:35 -0800 (PST)
Received: by ug-out-1314.google.com with SMTP id o29so430892ugd.20
        for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 14:14:34 -0800 (PST)
Message-ID: <2db2c6b80802231414m38f70795n7f24fea1a40195df@mail.gmail.com>
Date: Sat, 23 Feb 2008 23:14:32 +0100
From: Rekrutacja119 <rekrutacja119@gmail.com>
Subject: Re: xfs I/O error
In-Reply-To: <20080223220818.GC27124@teal.hq.k1024.org>
MIME-Version: 1.0
References: <2db2c6b80802231346r78d59381j49927e15f40e7ef8@mail.gmail.com>
	 <20080223220818.GC27124@teal.hq.k1024.org>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rekrutacja119 <rekrutacja119@gmail.com>
Cc: xfs@oss.sgi.com

so i should use the list i got from badblocks with dd but with bs=1024? are
you sure? i'm not sure what is my block size, but xfs_info says this:

debian:/# xfs_info /dev/md0
meta-data=/dev/md0               isize=256    agcount=32, agsize=5723342
blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=183146912, imaxpct=25
         =                       sunit=2      swidth=6 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=24576  blocks=0, rtextents=0

i think i made it with 4K stack size ... well anyways, i should use the list
i got earlier and just try dd but with bs=1024... ? don't want to erase more
than i have to. (i want to do it so i can smartctl -t offline /dev/sdb then,
so maybe it will somehow see that these blocks are broken and mark them)


2008/2/23, Iustin Pop <iusty@k1024.org>:
>
> On Sat, Feb 23, 2008 at 10:46:52PM +0100, Rekrutacja119 wrote:
> > hello, is there any way to force XFS to ignore I/O errors? it seems it
> is
> > shutting down the fs when it encounters any error.
> > The problem is that i can't mark badsectors, as XFS doesn't support bad
> > sector marking, but i also cannot access any correct data on partition,
> > because when i try to access damaged sector, the whole fs goes down.
> >
> > any idea why?
> >
> > i use xfsprogs 2.9.4, my xfs is array made from 3 HDs, RAID 0, and one
> of
> > them is getting some bad sectors. i cannot replace it currently.
> >
> > after i run xfs_repair on it, i was able to mount it and access the
> data,
> > but when somebody tries to access bad data, the whole XFS goes down. i
> don't
> > want that, i also dont have place to xfsmetadump the whole array to
> another
> > disks.
> >
> > i tried scaning whole disk with badblocks (badblocks -c 1 -s -v
> /dev/sdb),
> > and then running dd if=/dev/zero of=/dev/sdb count=1 bs=1
> > seek=NUMBER_FROM_BADBLOCKOUTPUT
> >
> > but every block was written fine! (which is strange i guess), and it
> didnt
> > help.
>
> I'm not really sure, but the above seems wrong. badblocks has a default
> block size of 1024 (-c does something else, not set the block size), and
> you use that block number as an offset in bytes for dd  (because you set
> bs=1).
>
> I would recommend to try the dd again, but with bs=1024. And afterwards,
> rerun badblocks and check you have no errors.
>
> As for xfs, I don't think if it can do what you want (ignore bad
> blocks), if the error is in the metadata sections.
>
> regards,
> iustin
>


[[HTML alternate version deleted]]
