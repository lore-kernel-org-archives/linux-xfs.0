Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p78NjdDr061651 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 18:45:39 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6FBD1F62A39
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2011 16:46:56 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	SYb5buDAG9TkktZu for <xfs@oss.sgi.com>;
	Mon, 08 Aug 2011 16:46:56 -0700 (PDT)
Date: Tue, 9 Aug 2011 09:45:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair 3.1.4/3.1.5: fatal error -- couldn't malloc dir2
	buffer data
Message-ID: <20110808234533.GM3162@dastard>
References: <20110806121728.GA20341@schmorp.de> <20110806141241.GF3162@dastard>
	<20110806175428.GA1900@schmorp.de> <20110806233913.GH3162@dastard>
	<20110808174911.GA7087@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110808174911.GA7087@schmorp.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Marc Lehmann <schmorp@schmorp.de>
Cc: xfs@oss.sgi.com

On Mon, Aug 08, 2011 at 07:49:11PM +0200, Marc Lehmann wrote:
> On Sun, Aug 07, 2011 at 09:39:13AM +1000, Dave Chinner <david@fromorbit.com> wrote:
> > > Then I unmounmted it and re-ran xfs_repair
> > > (http://ue.tst.eu/3cbc07150eb6b69c63361937c6c3044f.txt) which got much
> > > farther, but failed with the same error.
> > 
> > Looks lke corrupt directory blocks are causing it.
> > 
> > > Then I re-ran xfs_repair one last time, which ran through without any "error"
> > > messages.
> > > 
> > > An xfs_metadata -o is here (gzipped):
> > > http://data.plan9.de/smoker-chroot.bin.gz
> > 
> > I'll have a look at it.
> 
> I had another lockup, no xfs_fsr involved this time.
> 
> After rebooting, xfs_repair on the filesystem I mkfs'ed yesterday had the
> same problem, here is the metadump:
> 
>    http://data.plan9.de/metadump-smoker-new.gz
>    
> (if it's not accessible right now then this is because thats the server
> that locked up, it should be up and running in an hour again).
> 
> And here is the output of xfs_repair:
> 
>    Phase 1 - find and verify superblock...
>    Phase 2 - using internal log
>            - zero log...
>            - scan filesystem freespace and inode maps...
>            - found root inode chunk
>    Phase 3 - for each AG...
>            - scan and clear agi unlinked lists...
>            - process known inodes and perform inode discovery...
>            - agno = 0
>            - agno = 1
>            - agno = 2
>            - agno = 3
>            - agno = 4
>            - agno = 5
>            - agno = 6
>            - agno = 7
> 
>    fatal error -- couldn't malloc dir2 buffer data

Ok, I can reproduce that.

>From a quick look over breakfast, xfs_repair from the current git
tree results in this:

$ ~/src/build/xfsprogs-dev/repair/xfs_repair -nvd -f busted.img 
Phase 1 - find and verify superblock...
        - block cache size set to 2311200 entries
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
xfs_repair: read failed: Bad address
can't read block 0 for directory inode 29420386
no . entry for directory 29420386
no .. entry for directory 29420386
problem with directory contents in inode 29420386
would have cleared inode 29420386
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
xfs_repair: read failed: Bad address
can't read block 0 for directory inode 63252826
no . entry for directory 63252826
no .. entry for directory 63252826
problem with directory contents in inode 63252826
would have cleared inode 63252826
bad directory block magic # 0 in block 0 for directory inode 63254628
corrupt block 0 in directory inode 63254628
        would junk block
no . entry for directory 63254628
no .. entry for directory 63254628
problem with directory contents in inode 63254628
would have cleared inode 63254628
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 2
        - agno = 1
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 9
        - agno = 7
        - agno = 11
        - agno = 10
        - agno = 8
        - agno = 13
        - agno = 14
        - agno = 12
        - agno = 15
Segmentation fault
$

So it gets a lot further, and indicates somewhat how the directory
structure is corrupted - bad block pointers. Interstingly:

$ sudo xfs_db -r -f busted.img 
xfs_db> inode 63252826
xfs_db> p
core.magic = 0x494e
core.mode = 040755
core.version = 2
core.format = 2 (extents)
core.nlinkv2 = 2
....
core.size = 4096
core.nblocks = 8

That does not add up. A single block directory should be in block format,
which has a single 1 block extent.

core.extsize = 0
core.nextents = 3

That's quite clearly not the case:

....
u.bmx[0-2] = [startoff,startblock,blockcount,extentflag] 0:[0,32457376,3,0] 1:[3,32457504,3,0] 2:[6,32457631,2,0]

It's apparently got 8 blocks in the directory data space. Looking at
the first block:

$ sudo xfs_db -r -f busted.img 
xfs_db> fsb 32457376
xfs_db> p
000: 58443242 07900770 003003b0 00000000 00000000 03c5295a 012e5fc4 c27e0010
      X D 2 B - that's definitely a block format directory block.

020: 00000000 02047b33 022e2e02 66240020 ffff03b0 03c53047 0a303030 5f6c6f61
040: 642e7499 cf610030 00000000 03c53055 0b303031 5f626173 69632e74 131f0030
060: 00000000 03c53064 0c303035 5f737472 6963742e 741f0030 00000000 03c53067
080: 0c303130 5f646173 6865732e 748f0030 00000000 03c5306c 0c313033 5f75635f
0a0: 6275672e 74130030 00000000 03c5306d 0d303034 5f6e6f67 65746f70 2e740030
0c0: 00000000 03c53535 0d72656c 65617365 2d656f6c 2e740030 00000000 03c53536
0e0: 0e313031 5f617267 765f6275 672e749c 1e9be359 f7500030 00000000 03c53537
100: 0f313037 5f756e69 6f6e5f62 75672e74 a70fa089 e1230030 00000000 03c5354d
120: 0f313039 5f68656c 705f666c 61672e74 fd4ec683 52490030 00000000 03c53550
140: 10313038 5f757361 67655f61 7474722e 74731cd1 13e00030 00000000 03c53551
160: 11313032 5f626173 69635f62 61736963 2e744212 c5260030 00000000 03c53553
180: 11313035 5f75635f 6275675f 6d6f7265 2e744b0e c48a0030 00000000 03c53559
1a0: 1172656c 65617365 2d6e6f2d 74616273 2e740476 735f0030 00000000 03c5355a
1c0: 12303131 5f70726f 63657373 5f617267 762e743a 5b100030 00000000 03c5355b
1e0: 12313037 5f6e6f5f 6175746f 5f68656c 702e74af 32bc0030 00000000 03c5355c
xfs_db> type dir2
xfs_db> p
Segmentation fault

But clearly there's something bad in it. More digging needed.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
