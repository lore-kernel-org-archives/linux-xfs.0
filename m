Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 386607CA2
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 18:54:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F14D98F8037
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 16:54:41 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	k6OXWSsQypRPm1Qw for <xfs@oss.sgi.com>;
	Tue, 29 Mar 2016 16:54:36 -0700 (PDT)
Date: Wed, 30 Mar 2016 10:54:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG in xfs_trans_binval
Message-ID: <20160329235415.GF30721@dastard>
References: <20160329171553.GA17885@aepfle.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160329171553.GA17885@aepfle.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Olaf Hering <olaf@aepfle.de>
Cc: xfs@oss.sgi.com

On Tue, Mar 29, 2016 at 07:15:53PM +0200, Olaf Hering wrote:
> During receiving a backup stream (netcal -l 12345 | tar xf -) the host
> crashed and rebooted, no idea why.

That's the likely cause of your problems, because....

> After reboot I tried to remove the received directory (rm -rf dir) and
> got this BUG:
> 
> "_xfs_buf_find: Block out of range: block 0x81ffff3f8, EOFS 0x7fffd000"

This will be caused by a corrupt block....

> Kernel is 4.5.0 from openSUSE Tumbleweed.
> dmesg is attached, I just realized it has the backtrace.
> 
> [    1.883626] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

So, write cache is enabled on the drive.

> [   20.083397] XFS (sdb1): Mounting V5 Filesystem
> [   20.291900] XFS (sdb1): Starting recovery (logdev: internal)
> [   25.285846] XFS (sdb1): Bad dir block magic!
> [   26.448027] XFS (sdb1): Ending recovery (logdev: internal)

And that's a big clue that something went badly wrong at the storage
level. Basically, after recovering a buffer from the log, it had an
invalid magic number for the type of buffer information being
recovered. In this case, the journal entry being recovered was for a
directory block in "single block" format. The magic number foundi in
the block after recovery of the transaction was not that of a
directory block in single block format.

The only way this can happen is if there is an underlying corruption
in the block prior to recovery starting. Given that the system
crashed and rebooted, it's entirely possible that initialisation of
the block never made it to persistent storage, or it was corrupted
on the way to disk by whatever caused the crash and reboot.

> [  130.489414] XFS (sdb1): _xfs_buf_find: Block out of range: block 0x81ffff3f8, EOFS 0x7fffd000 
> [  130.494271] XFS (sdb1): _xfs_buf_find: Block out of range: block 0x81ffff3f8, EOFS 0x7fffd000 

These occur because a bad sector address is being detected.

> [  130.489707]  [<ffffffff81395921>] dump_stack+0x63/0x82
> [  130.489715]  [<ffffffff8107d912>] warn_slowpath_common+0x82/0xc0
> [  130.489722]  [<ffffffff8107da0a>] warn_slowpath_null+0x1a/0x20
> [  130.489766]  [<ffffffffa0941b80>] _xfs_buf_find+0x350/0x3b0 [xfs]
> [  130.489824]  [<ffffffffa0941c0a>] xfs_buf_get_map+0x2a/0x2c0 [xfs]
> [  130.489876]  [<ffffffffa097026a>] xfs_trans_get_buf_map+0x11a/0x1c0 [xfs]
> [  130.489923]  [<ffffffffa0919040>] xfs_btree_get_bufs+0x50/0x60 [xfs]
> [  130.489961]  [<ffffffffa090283f>] xfs_alloc_fix_freelist+0x20f/0x3c0 [xfs]

And this location generating the out-of-range disk address indicates
that there may be a bad block number on the AGFL.

Given that none of these have triggered verifier failures on read
from disk, it makes me think that whatever has gone wrong in this
filesystem occurred before the crash and reboot, and smells somewhat
of memory corruption and/or misdirected writes.

Given that xfs_repair didn't warn about blocks on the AGFL being out
of range (which is checked), nor any other metadata linkage in the
filesystem pointing to a block out of range, nor did it warn about
directory blocks cwbeing corrupted or having invalid formats, this
is starting to look like an in-memory problem. Perhaps there is
still memory corruption occurring - the block out of range has a
single high bit set that puts it out of range. i.e.  when we mask of
the single bit that is out of range, 0x1ffff3f8 is a valid sector
address.

Can you run a memory tester on the machine?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
