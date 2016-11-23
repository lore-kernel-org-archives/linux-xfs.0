Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.webx.cz ([109.123.222.201]:34765 "EHLO mail.webx.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935727AbcKWLkT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Nov 2016 06:40:19 -0500
From: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Subject: Re: BUG: Metadata corruption detected at xfs_attr3_leaf_read_verify
Date: Wed, 23 Nov 2016 12:40:15 +0100
Message-ID: <1673187.nXukm9ZPb1@libor-nb>
In-Reply-To: <20161110213057.GH28922@dastard>
References: <5244720.RPRsZ88NJ0@libor-nb> <2152865.L3K5Xz7SXO@libor-nb> <20161110213057.GH28922@dastard>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

Hello,
collegue of mine was trying metadump, but it segfaults :-(

# xfs_metadump -g /dev/vgDisk2/lvData /mnt/xfs_dump/vps2_metadump
Copied 2588032 of 5767488 inodes (1 of 3 AGs)              Segmentation fault

He ran it twice, segfault occured on same place

dmesg says
Nov 23 05:04:42 vps2 kernel: [1294386.804427] xfs_db[25156]: segfault at fffffffffffffff0 ip 00007f6bd7bc567d sp 00007ffc1a2897b8 error 7 in libc-2.19.so[7f6bd7b40000+1a1000]
Nov 23 05:20:22 vps2 kernel: [1295327.311413] xfs_db[28241]: segfault at fffffffffffffff0 ip 00007f7b7426d67d sp 00007ffddefeb4f8 error 7 in libc-2.19.so[7f7b741e8000+1a1000]

Are you interested in this partial metadump? It has over 3GB decompressed.
I will keep it here for few days:
https://download.bcom.cz/vps2_metadump_20161123.xz

btw, it seems to contain strings from inside of files, is that normal? 
It also contains strings from mail.log which is on another (ext4) filesystem.

Thanks,
Libor


> On Thu, Nov 10, 2016 at 05:04:48PM +0100, Libor Klep�? wrote:
> > On ?tvrtek 10. listopadu 2016 16:29:15 CET Dave Chinner wrote:
> > > Which:
> > > > > Phase 3 - for each AG...
> > > > > 
> > > > >         - scan (but don't clear) agi unlinked lists...
> > > > >         - process known inodes and perform inode discovery...
> > > > >         - agno = 0
> > > > >         - agno = 1
> > > > > 
> > > > > Metadata corruption detected at xfs_attr3_leaf block 0x12645ef8/0x1000
> > > > > Metadata corruption detected at xfs_attr3_leaf block 0x12f63f40/0x1000
> > > 
> > > These two blocks. It looks like repair didn't clean them up?
> > > 
> > > Hmmmm - looking at the code I'm not sure that repair detects and
> > > removes empty attr leaf blocks, which would explain why the error
> > > showed up again.. Can you provide a metadump of the filesystem so we
> > > can did into the exact neature of the problem you are seeing?
> > 
> > Sure not a problem. How much time will it take giving xfs_repair took approx 40 minutes?
> 
> No longer than that, with agood possibility it will be much faster
> as metadump only needs 1 pass over the metadata, not three...
> 
> Cheers,
> 
> Dave.
> 



