Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q282B4Z1194047 for <xfs@oss.sgi.com>; Wed, 7 Mar 2012 20:11:04 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7n6132Npo1vwv1oN for <xfs@oss.sgi.com>;
	Wed, 07 Mar 2012 18:10:57 -0800 (PST)
Date: Thu, 8 Mar 2012 13:10:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: df bigger than ls?
Message-ID: <20120308021054.GM3592@dastard>
References: <20120307155439.GA23360@nsrc.org> <20120307171619.GA23557@nsrc.org>
	<4F57A32A.5010704@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F57A32A.5010704@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com, Brian Candler <B.Candler@pobox.com>

On Wed, Mar 07, 2012 at 12:04:26PM -0600, Eric Sandeen wrote:
> On 3/7/12 11:16 AM, Brian Candler wrote:
> > On Wed, Mar 07, 2012 at 03:54:39PM +0000, Brian Candler wrote:
> >> core.size = 1085407232
> >> core.nblocks = 262370
> > 
> > core.nblocks is correct here: space used = 262370 * 4 = 1049480 KB
> > 
> > (If I add up all the non-hole extents I get 2098944 blocks = 1049472 KB
> > so there are two extra blocks of something)
> > 
> > This begs the question of where stat() is getting its info from?

stat(2) also reported delayed allocation reservations that are only
kept in memory.

....

> so:
> 
> # dd if=/dev/zero of=bigfile bs=1M count=1100 &>/dev/null
> # ls -lh bigfile
> -rw-r--r--. 1 root root 1.1G Mar  7 11:47 bigfile
> # du -h bigfile
> 1.1G	bigfile
> 
> but:
> 
> # rm -f bigfile
> # for I in `seq 1 1100`; do dd if=/dev/zero of=bigfile conv=notrunc bs=1M seek=$I count=1 &>/dev/null; done
> # ls -lh bigfile
> -rw-r--r--. 1 root root 1.1G Mar  7 11:49 bigfile
> # du -h bigfile
> 2.0G	bigfile

This is tripping the NFS server write pattern heuristic. i.e. it is
detecting repeated open/write at EOF/close patterns and so is not
truncating away the speculative EOF reservation on close(). This
si what prevents fragmentation of files being written concurrently
with this pattern.

> This should get freed when the inode is dropped from the cache;
> hence your cache drop bringing it back to size.

Right. It is assumes that once you've triggered that heuristic, the
preallocation needs to last for as long as the inode is in the
working set. The inode cache tracks the current working set, so the
preallocation release is tied to cache eviction.

> But there does seem to be an issue here; if I make a 4G filesystem
> and repeat the above test 3 times, the 3rd run gets ENOSPC, and
> the last file written comes up short, while the first one retains
> all it's extra preallocated space:
> 
> # du -hc bigfile* 2.0G	bigfile1 1.1G	bigfile2 907M
> bigfile3
> 
> Dave, is this working as intended?

Yes. Your problem is that you have a very small filesystem, which is
not the case that we optimise XFS for. :/

> I know the speculative
> preallocation amount for new files is supposed to go down as the
> fs fills, but is there no way to discard prealloc space to avoid
> ENOSPC on other files?

We don't track what files have current active preallocations, we
only reduce the preallocation size as the filesystem nears ENOSPC.
This generally works just fine in situations where the filesystem
size is significantly greater than the maximum extent size. i.e. the
common case

The problem you are tripping over here is that the maximum extent
size is greater than the filesystem size, so the preallocation size
is also greater than the filesystem size and hence can contribute
significantly to premature ENOSPC. I see two possible ways to
minimise this problem:

	1. reduce the maximum speculative preallocation size based
	on filesystem size at mount time.

	2. track inodes with active speculative preallocation and
	have an enospc based trigger that can find them and truncate
	away excess idle speculative preallocation.

The first is relatively easy to do, but will only reduce the
incidence of your problem - we still need to allow significant
preallocation sizes (e.g. 64MB) to avoid the fragmentation problems.

The second is needed to reclaim the space we've already preallocated
but is not being used. That's more complex to do - probably a radix
tree bit and a periodic background scan to reduce the time window
the preallocation sits around from cache lifetime to "idle for some
time" along with a on-demand, synchronous ENOSPC scan. This will
need some more thought as to how to do it effectively, but isn't
impossible to do....

Cheers,

Dave.
> 
> -Eric
> 
> > root@storage1:~# du -h /disk*/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 2.0G	/disk10/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 2.0G	/disk11/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 2.0G	/disk12/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 1.1G	/disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 1.1G	/disk2/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 2.0G	/disk3/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 2.0G	/disk4/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 2.0G	/disk5/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 2.0G	/disk6/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 2.0G	/disk7/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 2.0G	/disk8/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 2.0G	/disk9/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > root@storage1:~# echo 3 >/proc/sys/vm/drop_caches 
> > root@storage1:~# du -h /disk*/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 1.1G	/disk10/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 1.1G	/disk11/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 1.1G	/disk12/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 1.1G	/disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 1.1G	/disk2/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 1.1G	/disk3/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 1.1G	/disk4/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 1.1G	/disk5/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 1.1G	/disk6/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 1.1G	/disk7/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 1.1G	/disk8/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > 1.1G	/disk9/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> > root@storage1:~# 
> > 
> > Very odd, but not really a major problem other than the confusion it causes.
> > 
> > Regards,
> > 
> > Brian.
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
