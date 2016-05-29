Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6665E7CA7
	for <xfs@oss.sgi.com>; Sun, 29 May 2016 18:21:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3974330404E
	for <xfs@oss.sgi.com>; Sun, 29 May 2016 16:20:59 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Q1KhHouaSTyne9oJ for <xfs@oss.sgi.com>;
	Sun, 29 May 2016 16:20:55 -0700 (PDT)
Date: Mon, 30 May 2016 09:20:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsrestore performance
Message-ID: <20160529232053.GK26977@dastard>
References: <CAPhCz3S7dvrOCqEJFvYvTQ89nUJwFxieQ5A1rShaxUb71rrNew@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPhCz3S7dvrOCqEJFvYvTQ89nUJwFxieQ5A1rShaxUb71rrNew@mail.gmail.com>
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
To: xfs.pkoch@dfgh.net
Cc: xfs@oss.sgi.com

On Sat, May 28, 2016 at 12:39:45AM +0200, xfs.pkoch@dfgh.net wrote:
> Dear XFS experts,
> 
> I was using a 16TB linux mdraid raid10 volume built from 16 seagate
> 2TB disks, which was formatted with an ext3 filesystem. It contained
> a couple of hundred very large files (ZFS full and incremental dumps
> with sizes between 10GB and 400GB). It also contained 7 million
> files from our users home directories, which where backuped with
> rsync --link-dest=<last backup dir>, so most of these files are
> just hard links to previous versions.

Oh, dear. There's a massive red flag. I'll come back to it...

> 1: create a 14TB XFS-filesystem on the temporary RAID5-volume
> 2: first rsync run to copy the ext3 fs to the temporary XFS-fs,
> this took 6 days

Rsync took 6 days to copy the filesystem - I doubt dump/restore is
going to be 3x faster than that - xfsdump is much faster than rsync
on the read side, but xfsdump runs at about the same speed as rsync 
on the write side. As such, 2x faster is about as much as you can
expect for a "data-mostly" dump/restore. I'll come back to this....

> 3: another rsync run to copy what changed during the first run,
> this took another 2 days
> 4: another rsync run to copy what changed during the second run,
> this took another day
> 5: xfsdump the temporary xfs fs to /dev/null. took 20 hours

Nothing to slow down xfsdump reading from disk. Benchmarks lie.

> 5: remounting the ext3 fs readonly and do a final rsync run to
> copy what changed during the third run. This took 10 hours.
> 6: delete the ext3 fs and create a 20TB xfs fs
> 7: copy back the temporary xfs fs to the new xfs fs using
> xfsdump | xfsrestore
> 
> Here's my problem Since dumping the temporary xfs fs to /dev/null
> needed less than a day I expected the xfsdump | xfsrestore
> combination to be finished in less than 2 day. xfsdump | xfsrestore
> should be a lot fasten than rsync since it justs pumps blocks from
> one xfs fs into another one.

dump is fast - restore is the slow point because it has to recreate
everything. That's what limits the speed of dump - the pipe has a
bound limit on data in flight, so dump is throttled to restore
speed when you run this.

And, as I said I'll come back to, restore is slow because:

[....]
> xfsrestore: reading directories
> xfsdump: dumping directories
> xfsdump: dumping non-directory files
> xfsdump: status at 20:04:52: 1/7886560 files dumped, 0.0% data dumped,
> 24550 seconds elapsed
> xfsrestore: 20756853 directories and 274128228 entries processed
> xfsrestore: directory post-processing
> xfsrestore: restoring non-directory files

The filesystem is not exactly as you described.  Did you notice that
xfs_restore realises that it has to restore 20 million directories
and *274 million* directory entries? i.e. for those 7 million inodes
containing data, there is roughly 40 hard links pointing to each
inode. There are also 3 directory inodes for every regular file.
This is not a "data mostly" filesystem - it has vastly more metadata
than it has data, even though the data takes up more space.

Keep in mind that it took dump the best part of 7 hours just to read
all the inodes and the directory structure to build the dump
inventory. This matches with the final ext3 rsync pass of 10 hours
which should have copied very little data.  Creating 270 million
hard links in 20 million directories from scratch takes a long time,
and xfs_restore will be no faster at that than rsync....

> Seems like 2 days was a little optimistic

Just a little. :/

Personally, I would have copied the data using rsync to the
temporary XFS filesystem of the same size and shape of the final
destination (via mkfs parameters to ensure stripe unit/width match
final destination) and then used xfs_copy to do a block level copy
of the temporary filesystem back to the final destination. xfs_copy
will run *much* faster than xfsdump/restore....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
