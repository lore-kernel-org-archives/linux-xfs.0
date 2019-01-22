Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56489 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbfAVJP4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jan 2019 04:15:56 -0500
Message-ID: <1548148553.2465.16.camel@pengutronix.de>
Subject: Re: Regular FS shutdown while rsync is running
From: Lucas Stach <l.stach@pengutronix.de>
Date: Tue, 22 Jan 2019 10:15:53 +0100
In-Reply-To: <20190121211846.GB4205@dastard>
References: <1543238989.2507.33.camel@pengutronix.de>
         <20181126153249.GC14585@bfoster> <1548067317.2465.7.camel@pengutronix.de>
         <20190121211846.GB4205@dastard>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

Hi Dave,

Am Dienstag, den 22.01.2019, 08:18 +1100 schrieb Dave Chinner:
> On Mon, Jan 21, 2019 at 11:41:57AM +0100, Lucas Stach wrote:
> > > Can you provide xfs_info for the fs and details of your storage, CPU and
> > > RAM configuration?
> > 
> > root@XXX:~# xfs_info /srv/
> > meta-data=/dev/mapper/XXX-backup isize=512    agcount=33, agsize=183123968 blks
> >          =                       sectsz=4096  attr=2, projid32bit=1
> >          =                       crc=1        finobt=1 spinodes=0 rmapbt=0
> >          =                       reflink=0
> > data     =                       bsize=4096   blocks=5860389888, imaxpct=15
> >          =                       sunit=16     swidth=48 blks
> > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > log      =internal               bsize=4096   blocks=521728, version=2
> >          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Just recreated a similar fs here to do some math with xfs_db...
> 
> > bad magic # 0x49414233 in inobt block 5/7831662
> 
> So repair tripped over this bad block at AG 5, agbno 7831662.
> Let's check that against the info in the block that the kernel
> reported as corrupt:
> 
> > With that applied we were able to collect the following dump:
> > 
> > [215922.475666] 00000000d471c70c: 49 41 42 33 00 01 01 0c 00 07 58 ab ff ff ff ff  IAB3......X.....
> > [215922.475954] 000000001be9cc59: 00 00 00 01 b5 db 40 b8 00 00 00 00 00 00 00 00  ......@.........
> 
>                                     ^^^^^^^^^^^^^^^^^^^^^^^
> > 				    daddr of the block that was read.
> 
> xfs_db> convert daddr 0x1b5db40b8 agno
> 0x5 (5)
> xfs_db> convert daddr 0x1b5db40b8 agbno
> 0x282817 (2631703)
> xfs_db> 
> 
> That doesn't match the agbno that xfs repair reported.
> 
> xfs_db> convert agno 5 agbno 7831662 daddr
> 0x1b8560370 (7387612016)
> xfs_db> convert daddr 0x1b8560370 agbno
> 0x77806e (7831662)
> xfs_db> 
> 
> The agbno isn't even close to being correct. We may have a
> misdirected write here.

Sorry for causing confusion here. The kernel splat is not from the same
crash where we were able to capture the metadump from and which the
xfs_repair output references. It is from a later run, where we didn't
store a complete metadump. All it does is prove that the bug is still
present in a later 4.19 stable release.

I guess we should concentrate on the exact crash where we have the
metadump from to do any analysis on.

Just to rule out the misdirected write theory, I did the following:

xfs_db> convert agno 5 agbno 7831662 fsb
0x5077806e (1350008942)
xfs_db> fsb 0x5077806e
xfs_db> type data
xfs_db> p
000: 49414233 0001014f 00772f28 ffffffff 00000001 b8560370 00006671 003d9700
020: 026711cc 25c744b9 89aa0aac 496edfec 00000005 e12b19b2 39259c80 393b8c80
[... snip ...]
xfs_db> convert	daddr 0x1b8560370 agno
0x5 (5)
xfs_db> convert daddr 0x1b8560370 agbno       
0x77806e (7831662)

So it seems we are looking at a finobt node that is exactly where it is
supposed to be, but carries the wrong magic. We are still waiting to
get back results from a run with Brians verifier changes applied.

> So, we really need to start to walk the tree
> structure to determine if this really is in the correct place.  So
> what we really need is to look at is the left sibling block of the
> bad block (agbno 0x758ab) and determine what agbno it points to
> (i.e. if it points to the agbno that repair told us about or the
> agbno the kernel thinks it has read).
> 
> i.e. run these commands and paste the output:
> 
> xfs_db> convert agno 5 agbno 0x758ab fsb
> 0x500758ab (1342658731)
> xfs_db> fsb 0x500758ab
> xfs_db> type data
> xfs_db> p
> [hexdump output we need]
> xfs_db> type finobt
> xfs_db> p
> [same info but decoded as finobt structure]
> xfs_db> type inobt
> xfs_db> p
> [same info but decoded as inobt structure]

Just for completeness I did a bit of the tree walk to look at the left
sibling:

xfs_db> convert agno 5 agbno 7810856 fsb
0x50772f28 (1349988136)
xfs_db> fsb 0x50772f28
xfs_db> type finobt 
xfs_db> p
magic = 0x46494233
level = 1
numrecs = 252
leftsib = null
rightsib = 7831662
bno = 7387445568
lsn = 0x66bc003f28a8
uuid = 026711cc-25c7-44b9-89aa-0aac496edfec
owner = 5
crc = 0xe5e78504 (correct)
[... snip ...]

It seems interesting that this node doesn't have a left sibling. Does
this mean the finobt is just those 2 nodes at that point?

Regards,
Lucas
