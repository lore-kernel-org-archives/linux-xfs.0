Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E3D467F37
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2015 20:11:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7E64DAC003
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2015 18:11:28 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ziYevdOZfaF62I5o for <xfs@oss.sgi.com>;
	Sun, 23 Aug 2015 18:11:25 -0700 (PDT)
Date: Mon, 24 Aug 2015 11:11:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150824011123.GA714@dastard>
References: <20150813224415.GG4496@mtj.duckdns.org>
	<20150814111408.GB8710@quack.suse.cz>
	<20150817200254.GG21075@mtj.duckdns.org>
	<20150818091603.GA12317@quack.suse.cz>
	<20150818174718.GA15739@mtj.duckdns.org>
	<20150818195439.GB15739@mtj.duckdns.org>
	<20150818215611.GD3902@dastard>
	<20150821102053.GL17933@dhcp-13-216.nay.redhat.com>
	<20150822003025.GS3902@dastard>
	<20150822044609.GM17933@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150822044609.GM17933@dhcp-13-216.nay.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

On Sat, Aug 22, 2015 at 12:46:09PM +0800, Eryu Guan wrote:
> On Sat, Aug 22, 2015 at 10:30:25AM +1000, Dave Chinner wrote:
> > On Fri, Aug 21, 2015 at 06:20:53PM +0800, Eryu Guan wrote:
> [snip]
> > 
> > Eryu, can you try again, this time manually specifying the writeback
> > tracepoints so you exclude the really noisy ones? You can also drop
> > the xfs_file_buffered_write and xfs_file_fsync tracepoints as well,
> > as we can see that the incoming side of the code is doing the right
> > thing....
> 
> I excluded the writeback tracepoints you mentioned
> 
> writeback_mark_inode_dirty
> writeback_dirty_inode_start
> writeback_dirty_inode
> writeback_dirty_page
> writeback_write_inode
> 
> and left all other writeback tracepoints enabled, also dropped
> xfs_file_buffered_write and xfs_file_fsync.
> 
> This time I can reproduce generic/048 quickly and please download the
> trace info from below
> 
> http://128.199.137.77/writeback-v2/

ok:

$ ls -li /mnt/scr
total 102396
15688948 -rw------- 1 root root        0 Aug 22 14:31 978
15688950 -rw------- 1 root root        0 Aug 22 14:31 980
15688952 -rw------- 1 root root 10481664 Aug 22 14:31 982
15688957 -rw------- 1 root root        0 Aug 22 14:31 987
15688961 -rw------- 1 root root        0 Aug 22 14:31 991
15688963 -rw------- 1 root root        0 Aug 22 14:31 993
15688964 -rw------- 1 root root        0 Aug 22 14:31 994
15688966 -rw------- 1 root root        0 Aug 22 14:31 996
15688967 -rw------- 1 root root        0 Aug 22 14:31 997
15688968 -rw------- 1 root root        0 Aug 22 14:31 998
$

So, looking at what is on disk and what is in the log:

      Inode #		   Size	       block count	flushiter
   dec	    hex	      inode	log    inode   log	inode  log
15688948  0xef64f4      0        0     0xa00  0xa00      0      0
15688950  0xef64f6      0        0     0xa00  0xa00      0      0
15688952  0xef64f8  0x9ff000 0x9ff000  0x9ff  0xa00      1      0
15688957  0xef64fd      0        0     0xa00  0xa00      0      0
15688961  0xef6501      0        0     0xa00  0xa00      0      0
15688963  0xef6503      0        0     0xa00  0xa00      0      0
15688964  0xef6504      0        0     0xa00  0xa00      0      0
15688966  0xef6506      0        0     0xa00  0xa00      0      0
15688967  0xef6507      0        0     0xa00  0xa00      0      0
15688968  0xef6508      0        0     0xa00  0xa00      0      0

Now, inode #15688952 looks like there's some weirdness going on
there with a non-zero flushiter and a block count that doesn't match
between what is in the log and what is on disk. However, this is a
result of the second mount that checks the file sizes and extent
counts - it loads the inode into memory, checks it, and then when
it is purged from the cache on unmount the blocks beyond EOF are
punched away and the inode writen to disk. Hence there is a second
transaction in the log for that inode after all the other inodes
have been unlinked:

INODE: #regs: 3   ino: 0xef64f8  flags: 0x5   dsize: 16
.....
size 0x9ff000 nblocks 0x9ff extsize 0x0 nextents 0x1

It is preceeded in the log by modifications to the AGF and frees
space btree buffers. It's then followed by the superblock buffer and
the unmount record. Hence this is not unexpected.

What it does tell us, though, is that the log never recorded file
size changes for all of the inode with zero size. We see the block
count of 0xa00, which means the delayed allocation transaction
during IO submission has hit the disk, but there are none of the
IO completion transactions in the log.

So let's go look at the event trace now now that we know the EOF
size update transactions were not run before the filesystem shut
down.

 Inode #     writeback		completion
  hex      first     last    first     last
0xef64f4  0-0x9ff000  yes     no        no
0xef64f6  0-0x9ff000  yes     no        no
0xef64f8  0-0x9ff000  yes     no        no
0xef64fd  0-0x9ff000  yes     no        no
0xef6501  0-0x9ff000  yes     no        no
0xef6503     no       no      no        no
0xef6504     no       no      no        no
0xef6506     no       no      no        no
0xef6507     no       no      no        no
0xef6508     no       no      no        no

Ok, so we still can't trust the event trace to be complete - we know
from the log and the on-disk state that that allocation occurred for
those last 5 inodes, so we can't read anything into the fact the
traces for completions are missing.

Eryu, can you change the way you run the event trace to be:

$ sudo trace-cmd <options> -o <outfile location> ./check <test options>

rather than running the trace as a background operation elsewhere?
Maybe that will give better results.

Also, it would be informative to us if you can reproduce this with a
v5 filesystem (i.e. mkfs.xfs -m crc=1) because it has much better
on-disk information for sequence-of-event triage like this. If you
can reproduce it with a v5 filesystem, can you post the trace and
metadump?

Other things to check (separately):

	- change godown to godown -f
	- add a "sleep 5" before running godown after sync
	- add a "sleep 5; sync" before running godown

i.e. I'm wondering if sync is not waiting for everything, and so we
aren't capturing the IO completions because the filesystem is
already shut down by the time they are delivered...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
