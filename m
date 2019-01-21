Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:46454 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727422AbfAUVSu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jan 2019 16:18:50 -0500
Date: Tue, 22 Jan 2019 08:18:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Regular FS shutdown while rsync is running
Message-ID: <20190121211846.GB4205@dastard>
References: <1543238989.2507.33.camel@pengutronix.de>
 <20181126153249.GC14585@bfoster>
 <1548067317.2465.7.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1548067317.2465.7.camel@pengutronix.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Jan 21, 2019 at 11:41:57AM +0100, Lucas Stach wrote:
> > Can you provide xfs_info for the fs and details of your storage, CPU and
> > RAM configuration?
> 
> root@XXX:~# xfs_info /srv/
> meta-data=/dev/mapper/XXX-backup isize=512    agcount=33, agsize=183123968 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1 spinodes=0 rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=5860389888, imaxpct=15
>          =                       sunit=16     swidth=48 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

Just recreated a similar fs here to do some math with xfs_db...

> bad magic # 0x49414233 in inobt block 5/7831662

So repair tripped over this bad block at AG 5, agbno 7831662.
Let's check that against the info in the block that the kernel
reported as corrupt:

> With that applied we were able to collect the following dump:
> 
> [215922.475666] 00000000d471c70c: 49 41 42 33 00 01 01 0c 00 07 58 ab ff ff ff ff  IAB3......X.....
> [215922.475954] 000000001be9cc59: 00 00 00 01 b5 db 40 b8 00 00 00 00 00 00 00 00  ......@.........
                                    ^^^^^^^^^^^^^^^^^^^^^^^
				    daddr of the block that was read.

xfs_db> convert daddr 0x1b5db40b8 agno
0x5 (5)
xfs_db> convert daddr 0x1b5db40b8 agbno
0x282817 (2631703)
xfs_db> 

That doesn't match the agbno that xfs repair reported.

xfs_db> convert agno 5 agbno 7831662 daddr
0x1b8560370 (7387612016)
xfs_db> convert daddr 0x1b8560370 agbno
0x77806e (7831662)
xfs_db> 

The agbno isn't even close to being correct. We may have a
misdirected write here. So, we really need to start to walk the tree
structure to determine if this really is in the correct place.  So
what we really need is to look at is the left sibling block of the
bad block (agbno 0x758ab) and determine what agbno it points to
(i.e. if it points to the agbno that repair told us about or the
agbno the kernel thinks it has read).

i.e. run these commands and paste the output:

xfs_db> convert agno 5 agbno 0x758ab fsb
0x500758ab (1342658731)
xfs_db> fsb 0x500758ab
xfs_db> type data
xfs_db> p
[hexdump output we need]
xfs_db> type finobt
xfs_db> p
[same info but decoded as finobt structure]
xfs_db> type inobt
xfs_db> p
[same info but decoded as inobt structure]

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
