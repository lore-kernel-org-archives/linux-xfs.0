Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 10E727F54
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 13:39:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F400B8F804C
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 11:39:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AnBIRcB8Ds57EaVm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 19 Aug 2015 11:39:07 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id EE4CA36B1FD
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 18:39:06 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-103.bos.redhat.com [10.18.41.103])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7JId6UN000557
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 14:39:06 -0400
Date: Wed, 19 Aug 2015 14:39:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: v5 filesystem corruption due to log recovery lsn ordering
Message-ID: <20150819183904.GB49174@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi all,

Here's another issue I've run into from recent log recovery testing...

Many on-disk data structures for v5 filesystems have the LSN from the
last modification stamped the associated header. As of the following
commit, log recovery compares the recovery item LSN against the LSN of
the on-disk structure to avoid restoration of stale contents:

  50d5c8d xfs: check LSN ordering for v5 superblocks during recovery

This presumably addresses some problems where recovery of the stale
contents leads to CRC failure. The problem here is that xfs_repair
clears the log (even when the fs is clean) and resets the current LSN on
the next mount. This creates a situation where logging is ineffective
for any structure that has not yet been modified since the current LSN
was reset.

I'm not quite sure how pervasive this is in practice, but the following
is a corruption reproducer for directory buffers:

- mkfs (-m crc=1), mount and fsstress a filesystem for a bit such that
  the LSN increases a decent amount (e.g., several log cycles or so).

	# cat /sys/fs/xfs/dm-3/log/log_*
	3:9378
	3:9376

- Kill fsstress, create a new directory and populate with some files:

	# mkdir /mnt/dir
	# for i in $(seq 0 999); do touch /mnt/dir/$i; done

- Unmount the fs, run xfs_repair, mount the fs and verify the LSN has
  been reset:

	# cat /sys/fs/xfs/dm-3/log/log_*
	1:2
	1:2

- Remove a file from the previously created directory and immediately
  shutdown the fs, flushing the log:

	# rm -f /mnt/dir/0; ~/xfstests-dev/src/godown -f /mnt/
	# umount /mnt

- Remount the fs to replay the log. Unmount and repair once more:

	# mount <dev> /mnt; umount /mnt
	# xfs_repair -n <dev>
	...
	imap claims in-use inode 3082 is free, would correct imap
	...

... and the filesystem is inconsistent. This occurs because the log
recovery records are tagged with an LSN based on the reset value of
(1:2) and the buffers to be recovered that hadn't yet been rewritten
before the shutdown have an LSN from around the time the fsstress was
stopped. The target buffer is incorrectly seen as "newer" than the
recovery item, and thus recovery of this buffer is skipped.

Note that the resulting behavior is not always consistent. I have seen
log recovery ignore the file removal such that the fs is consistent and
the modification is simply lost. The original instance I hit on a
separate machine caused repair to complain about and fix the directory
rather than the imap, but that could have been a repair thing.

The larger question is how to resolve this problem? I don't think this
is something that is ultimately addressed in xfs_repair. Even if we
stopped clearing the log, that doesn't help users who might have had to
forcibly zero the log to recover a filesystem. Another option in theory
might be to unconditionally reset the LSN of everything on disk, but
that sounds like overkill just to preserve the current kernel
workaround.

It sounds more to me that we have to adjust this behavior on the kernel
side. That said, the original commit presumably addresses some log
recovery shutdown problems that we do not want to reintroduce. I haven't
yet wrapped my head around what that original problem was, but I wanted
to get this reported. If the issue was early buffer I/O submission,
perhaps we need a new mechanism to defer this I/O submission until a
point that CRC verification is expected to pass (or otherwise generate a
filesystem error)? Or perhaps do something similar with CRC
verification? Any other thoughts, issues or things I might have missed
here?

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
