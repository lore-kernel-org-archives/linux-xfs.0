Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C69A029E00
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 00:31:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 72EDBAC016
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 22:31:35 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PIIgEBsUntbP1zIT for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 22:31:32 -0700 (PDT)
Date: Tue, 8 Apr 2014 15:31:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS fragmentation on file append
Message-ID: <20140408053117.GJ27017@dastard>
References: <CAJhmKHmwvCBx=arJ6m2ZhuQVq=Jj-XbBGvEPjTPY5a1QtWRTCQ@mail.gmail.com>
	<20140408015012.GB22917@dastard>
	<CAJhmKHnap0vu8m4AXBxJr9L0RKoquFrm3NjKQdDBJwpRTYmfpw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJhmKHnap0vu8m4AXBxJr9L0RKoquFrm3NjKQdDBJwpRTYmfpw@mail.gmail.com>
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
To: Keyur Govande <keyurgovande@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Apr 07, 2014 at 11:42:02PM -0400, Keyur Govande wrote:
> On Mon, Apr 7, 2014 at 9:50 PM, Dave Chinner <david@fromorbit.com> wrote:
> > [cc the XFS mailing list <xfs@oss.sgi.com>]
> >
> > On Mon, Apr 07, 2014 at 06:53:46PM -0400, Keyur Govande wrote:
> >> Hello,
> >>
> >> I'm currently investigating a MySQL performance degradation on XFS due
> >> to file fragmentation.
> >>
> >> The box has a 16 drive RAID 10 array with a 1GB battery backed cache
> >> running on a 12 core box.
> >>
> >> xfs_info shows:
> >> meta-data=/dev/sda4    isize=256    agcount=24, agsize=24024992 blks
> >>                =                 sectsz=512   attr=2, projid32bit=0
> >> data         =                 bsize=4096   blocks=576599552, imaxpct=5
> >>                =                 sunit=16     swidth=512 blks
> >> naming   = version 2     bsize=4096   ascii-ci=0
> >> log         = internal       bsize=4096   blocks=281552, version=2
> >>              =                   sectsz=512   sunit=16 blks, lazy-count=1
> >> realtime = none            extsz=4096   blocks=0, rtextents=0
> >>
> >> The kernel version is: 3.14.0-1.el6.elrepo.x86_64 and the XFS
> >> partition is mounted with: rw,noatime,allocsize=128m,inode64,swalloc.
> >> The partition is 2TB in size and 40% full to simulate production.
> >>
> >> Here's a test program that appends 512KB like MySQL does (write and
> >> then fsync). To exacerbate the issue, it loops a bunch of times:
> >> https://gist.github.com/keyurdg/961c19175b81c73fdaa3
> >>
> >> When run, this creates ~9500 extents most of length 1024.
> >
> > 1024 of what? Most likely it is 1024 basic blocks, which is 512KB,
> > the size of your writes.
> 
> Yeah, 1024 basic blocks of 512 bytes each.
> 
> >
> > Could you post the output of the xfs_bmap commands you are using to
> > get this information?
> 
> I'm getting the extent information via xfs_bmap -v <file name>. Here's
> a sample: https://gist.github.com/keyurdg/291b2a429f03c9a649ad

Yup, looks like fragmented free space so it's only finding islands
of 512kb of freespace near to the inode to allocate out of.

Can you post the output of /proc/mounts so I can check what the
allocator behaviour is being used?

> >> cat'ing the
> >> file to /dev/null after dropping the caches reads at an average of 75
> >> MBps, way less than the hardware is capable of.
> >
> > What you are doing is "open-seekend-write-fsync-close".  You haven't
> > told the filesystem you are doing append writes (O_APPEND, or the
> > append inode flag) so it can't optimise for them.
> 
> I tried this; adding O_APPEND the the open() in the pathological
> pwrite.c makes no difference to the extent allocation and hence the
> read performance.

Yeah, I had a look at what XFS does and in the close path it doesn't
know that the FD was O_APPEND because that state is available to the
->release path.

> > You are also cleaning the file before closing it, so you are
> > defeating the current heuristics that XFS uses to determine whether
> > to remove speculative preallocation on close() - if the inode is
> > dirty at close(), then it won't be removed. Hence speculative
> > preallocation does nothing for your IO pattern (i.e. the allocsize
> > mount option is completely useless). Remove the fsync and you'll
> > see your fragmentation problem go away completely.
> 
> I agree, but the MySQL data files (*.ibd) on our production cluster
> are appended to in bursts and they have thousands of tiny (512KB)
> extents. Getting rid of fsync is not possible given the use case.

Sure - just demonstrating that it's the fsync that is causing the
problems. i.e. it's application driven behaviour that the filesystem
can't easily detect and optimise...

> Arguably, MySQL does not close the files, but it writes out
> infrequently enough that I couldn't make a good and small test case
> for it. But the output of xfs_bmap is exactly the same as that of
> pwrite.c

Once you've fragmented free space, the only way to defrag it is to
remove whatever is using the space between the small freespace
extents. Usually the condition occurs when you intermix long lived
files with short lived files - removing the short lived files
results in fragmented free space that cannot be made contiguous
until both the short lived and long lived data has been removed.

If you want an idea of whether you've fragmented free space, use
the xfs_db freespace command. To see what each ag looks like
(change it to iterate all the ags in your fs):

$ for i in 0 1 2 3; do echo "*** AG $i:" ; sudo xfs_db -c "freesp -a $i -s" /dev/vda; done
*** AG 0:
   from      to extents  blocks    pct
      1       1     129     129   0.02
      2       3     119     283   0.05
      4       7     125     641   0.11
      8      15      93     944   0.16
     16      31      64    1368   0.23
     32      63      53    2300   0.39
     64     127      21    1942   0.33
    128     255      16    3145   0.53
    256     511       6    1678   0.28
    512    1023       1     680   0.11
  16384   32767       1   23032   3.87
 524288 1048576       1  558825  93.93
total free extents 629
total free blocks 594967
average free extent size 945.893
*** AG 1:
   from      to extents  blocks    pct
      1       1     123     123   0.01
      2       3     125     305   0.04
      4       7      79     418   0.05
......

And that will tell us what state your filesystem is in w.r.t.
freespace fragmentation...

> >> When I add a posix_fallocate before calling pwrite() as shown here
> >> https://gist.github.com/keyurdg/eb504864d27ebfe7b40a the file
> >> fragments an order of magnitude less (~30 extents), and cat'ing to
> >> /dev/null proceeds at ~1GBps.
> >
> > That should make no difference on XFS as you are only preallocating
> > the 512KB region beyond EOF that you are about to write into and
> > hence both delayed allocation and preallocation have the same
> > allocation target (the current EOF block). Hence in both cases the
> > allocation patterns should be identical if the freespace extent they
> > are being allocated out of are identical.
> >
> > Did you remove the previous test files and sync the filesystem
> > between test runs so that the available freespace was identical for
> > the different test runs? If you didn't then the filesystem allocated
> > the files out of different free space extents and hence you'll get
> > different allocation patterns...
> 
> I do clear everything and sync the FS before every run, and this is
> reproducible across multiple machines in our cluster.

Which indicates that you've probably already completely fragmented
free space in the filesystems.

> I've re-run the
> programs at least a 1000 times now, and every time get the same
> results. For some reason even the tiny 512KB fallocate() seems to be
> triggering some form of extent "merging" and placement.

Both methods of allocation shoul dbe doing the same thing - they use
exactly the same algorithm to select the next extent to allocate.
Can you tell me the:

	a) inode number of each of the target files that show
	different output
	b) the xfs_bmap output of the different files.

> > Alternatively, set an extent size hint on the log files to define
> > the minimum sized allocation (e.g. 32MB) and this will limit
> > fragmentation without you having to modify the MySQL code at all...
> >
> 
> I tried enabling extsize to 32MB, but it seems to make no difference.
> [kgovande@host]# xfs_io -c "extsize" /var/lib/mysql/xfs/plain_pwrite.werr
> [33554432] /var/lib/mysql/xfs/plain_pwrite.werr
> [kgovande@host]# xfs_bmap -v /var/lib/mysql/xfs/*.werr  | wc -l
> 20001
> [kgovande@host]# sync; echo 3 > /proc/sys/vm/drop_caches; pv
> plain_pwrite.werr > /dev/null
> 9.77GB 0:02:41 [61.7MB/s] [========================================>] 100%

Ah, extent size hints are not being considered in
xfs_can_free_eofblocks(). I suspect they should be, and that would
fix the problem.

Can you add this to xfs_can_free_eofblocks() in your kernel and see
what happens?


 	/* prealloc/delalloc exists only on regular files */
 	if (!S_ISREG(ip->i_d.di_mode))
 		return false;
 
+	if (xfs_get_extsz_hint(ip))
+		return false;
+
 	/*
 	 * Zero sized files with no cached pages and delalloc blocks will not
 	 * have speculative prealloc/delalloc blocks to remove.
 	 */

If that solves the problem, then I suspect that we might need to
modify this code to take into account the allocsize mount option as
well...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
