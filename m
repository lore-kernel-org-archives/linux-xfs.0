Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55744 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729060AbeL2Hfg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 29 Dec 2018 02:35:36 -0500
Date: Sat, 29 Dec 2018 15:38:29 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfstests: test swapext log replay
Message-ID: <20181229073829.GR30999@dhcp-12-149.nay.redhat.com>
References: <20181223141721.5318-1-zlang@redhat.com>
 <20181229052739.GD21777@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181229052739.GD21777@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: fstests@vger.kernel.org, sandeen@redhat.com, linux-xfs@vger.kernel.org

On Sat, Dec 29, 2018 at 01:27:39PM +0800, Eryu Guan wrote:
> On Sun, Dec 23, 2018 at 10:17:21PM +0800, Zorro Lang wrote:
> > If an inode had been in btree format and had a data fork owner change
> > logged (XFS_ILOG_DOWNER), after changing the format to non-btree, will
> > hit an ASSERT in xfs_recover_inode_owner_change() which enforces that
> > if XFS_ILOG_[AD]OWNER is set.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> > 
> > This case is written for Eric's patchset:
> > [PATCH 0/2] xfs: swapext replay fixes
> > 
> > Thanks for the reproducer which is provided by Eric. I've tested on latest
> > xfs-linux for-next branch with the 2 patches of Eric:
> > # git log --oneline
> > 39a9114528e4 (HEAD -> for-next) xfs: clear XFS_ILOG_[AD]OWNER for non-btree formats
> > 46fe0206d242 xfs: handle bad flags in xfs_recover_inode_owner_change
> > 86d163dbfe2a (tag: xfs-4.21-merge-1, origin/xfs-4.21-merge, origin/for-next) xfs: stringify scrub types in ftrace output
> > ...
> > ...
> > 
> > But I still can hit a fs corruption which can't be log replayed[1]. Only
> > "xfs_repair -L" can help to fix that.
> > 
> > Thanks,
> > Zorro
> > 
> > [1]
> > # ./check xfs/999
> > FSTYP         -- xfs (non-debug)
> > PLATFORM      -- Linux/x86_64 xxx-xxxx-xx 4.20.0-rc6+
> > MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=0,finobt=1,crc=1 -i sparse=1 /dev/mapper/rhel_xxx-xxxx-xx-xfscratch
> > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/mapper/rhel_xxx-xxxx-xx-xfscratch /mnt/scratch
> > 
> > xfs/999 82s ... [failed, exit status 1]- output mismatch (see /root/git/xfstests-zlang/results//xfs/999.out.bad)
> >     --- tests/xfs/999.out       2018-12-23 08:27:02.524495164 -0500
> >     +++ /root/git/xfstests-zlang/results//xfs/999.out.bad       2018-12-23 08:58:01.826244128 -0500
> >     @@ -1,2 +1,4 @@
> >      QA output created by 999
> >     -Silence is golden
> >     +mount: /mnt/scratch: mount(2) system call failed: Structure needs cleaning.
> >     +cycle mount failed
> >     +(see /root/git/xfstests-zlang/results//xfs/999.full for details)
> >     ...
> >     (Run 'diff -u /root/git/xfstests-zlang/tests/xfs/999.out /root/git/xfstests-zlang/results//xfs/999.out.bad'  to see the entire diff)
> > Ran: xfs/999
> > Failures: xfs/999
> > Failed 1 of 1 tests
> > 
> > # dmesg
> > [ 1961.335700] run fstests xfs/999 at 2018-12-23 08:56:53
> > [ 1962.270422] XFS (dm-5): Unmounting Filesystem
> > [ 1964.097509] XFS (dm-5): Mounting V5 Filesystem
> > [ 1964.217909] XFS (dm-5): Ending clean mount
> > [ 2026.309500] XFS (dm-5): User initiated shutdown received. Shutting down filesystem
> > [ 2026.343161] XFS (dm-5): Unmounting Filesystem
> > [ 2026.420747] XFS (dm-5): Mounting V5 Filesystem
> > [ 2028.557423] XFS (dm-5): Starting recovery (logdev: internal)
> > [ 2029.162746] XFS (dm-5): Corruption warning: Metadata has LSN (-842150451:-842150451) ahead of current LSN (1:785). Please unmount and run xfs_repair (>= v4.3) to resolve.
> > [ 2029.179889] XFS (dm-5): Metadata CRC error detected at xfs_bmbt_read_verify+0x1b/0x2d0 [xfs], xfs_bmbt block 0x5830 
> > [ 2029.191678] XFS (dm-5): Unmount and run xfs_repair
> > [ 2029.197051] XFS (dm-5): First 128 bytes of corrupted metadata buffer:
> > [ 2029.204262] 00000000: cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
> > [ 2029.213220] 00000010: cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
> > [ 2029.222178] 00000020: cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
> > [ 2029.231151] 00000030: cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
> > [ 2029.240107] 00000040: cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
> > [ 2029.249171] 00000050: cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
> > [ 2029.258134] 00000060: cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
> > [ 2029.267083] 00000070: cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
> > [ 2029.282435] XFS (dm-5): Corruption warning: Metadata has LSN (-842150451:-842150451) ahead of current LSN (1:785). Please unmount and run xfs_repair (>= v4.3) to resolve.
> > [ 2029.299516] XFS (dm-5): Metadata CRC error detected at xfs_bmbt_read_verify+0x1b/0x2d0 [xfs], xfs_bmbt block 0x5830 
> > [ 2029.311295] XFS (dm-5): Unmount and run xfs_repair
> > [ 2029.316666] XFS (dm-5): First 128 bytes of corrupted metadata buffer:
> > [ 2029.323887] 00000000: cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
> > [ 2029.332844] 00000010: cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
> > [ 2029.341817] 00000020: cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
> > [ 2029.350776] 00000030: cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
> > [ 2029.359731] 00000040: cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
> > [ 2029.368690] 00000050: cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
> > [ 2029.377648] 00000060: cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
> > [ 2029.386607] 00000070: cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
> > [ 2029.395599] XFS (dm-5): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x5830 len 8 error 74
> > [ 2029.499375] XFS (dm-5): log mount/recovery failed: error -117
> > [ 2029.506425] XFS (dm-5): log mount failed
> > [ 2029.552080] XFS (dm-2): Unmounting Filesystem
> > 
> > # xfs_repair /dev/mapper/rhel_xxx-xxxx-xx-xfscratch
> > Phase 1 - find and verify superblock...
> > Phase 2 - using internal log
> >         - zero log...
> > ERROR: The filesystem has valuable metadata changes in a log which needs to
> > be replayed.  Mount the filesystem to replay the log, and unmount it before
> > re-running xfs_repair.  If you are unable to mount the filesystem, then use
> > the -L option to destroy the log and attempt a repair.
> > Note that destroying the log may cause corruption -- please attempt a mount
> > of the filesystem before doing this
> > 
> > # mount /dev/mapper/rhel_xxx-xxxx-xx-xfscratch /mnt/scratch
> > mount: /mnt/scratch: mount(2) system call failed: Structure needs cleaning.
> > 
> > # xfs_repair -L /dev/mapper/rhel_xxx-xxxx-xx-xfscratch 
> > Phase 1 - find and verify superblock...
> > Phase 2 - using internal log
> >         - zero log...
> > ALERT: The filesystem has valuable metadata changes in a log which is being
> > destroyed because the -L option was used.
> >         - scan filesystem freespace and inode maps...
> > sb_ifree 61, counted 60
> > sb_fdblocks 22271328, counted 22270327
> >         - found root inode chunk
> > Phase 3 - for each AG...
> >         - scan and clear agi unlinked lists...
> >         - process known inodes and perform inode discovery...
> >         - agno = 0
> > Metadata CRC error detected at 0x449c9d, xfs_bmbt block 0x5830/0x1000
> > btree block 0/2822 is suspect, error -74
> > bad magic # 0xcdcdcdcd in inode 131 (data fork) bmbt block 2822
> > bad data fork in inode 131
> > cleared inode 131
> >         - agno = 1
> >         - agno = 2
> >         - agno = 3
> >         - process newly discovered inodes...
> > Phase 4 - check for duplicate blocks...
> >         - setting up duplicate extent list...
> >         - check for inodes claiming duplicate blocks...
> >         - agno = 0
> > entry "fragfile" in shortform directory 128 references free inode 131
> > junking entry "fragfile" in directory inode 128
> >         - agno = 1
> >         - agno = 3
> >         - agno = 2
> > Phase 5 - rebuild AG headers and trees...
> >         - reset superblock...
> > Phase 6 - check inode connectivity...
> >         - resetting contents of realtime bitmap and summary inodes
> >         - traversing filesystem ...
> >         - traversal finished ...
> >         - moving disconnected inodes to lost+found ...
> > Phase 7 - verify and correct link counts...
> > Metadata corruption detected at 0x449b47, xfs_bmbt block 0x5830/0x1000
> > libxfs_writebufr: write verifer failed on xfs_bmbt bno 0x5830/0x1000
> > Maximum metadata LSN (1:237) is ahead of log (1:2).
> > Format log to cycle 4.
> > releasing dirty buffer (bulk) to free list!done
> > 
> > 
> > 
> >  tests/xfs/999     | 76 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/999.out |  2 ++
> >  tests/xfs/group   |  1 +
> >  3 files changed, 79 insertions(+)
> >  create mode 100755 tests/xfs/999
> >  create mode 100644 tests/xfs/999.out
> > 
> > diff --git a/tests/xfs/999 b/tests/xfs/999
> > new file mode 100755
> > index 00000000..cfe5c4d4
> > --- /dev/null
> > +++ b/tests/xfs/999
> > @@ -0,0 +1,76 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2018 Red Hat Inc. All Rights Reserved.
> > +#
> > +# FS QA Test No. 999
> > +#
> > +# If an inode had been in btree format and had a data fork owner change
> > +# logged, after changing the format to non-btree, will hit an ASSERT or
> > +# fs corruption.
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> 
> I changed it to "_supported_fs xfs"
> 
> > +_supported_os Linux
> > +_require_scratch
> 
> I also added
> 
> _require_scratch_shutdown
> _require_command "$XFS_FSR_PROG" "xfs_fsr"
> 
> > +
> > +_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
> > +. $tmp.mkfs
> > +
> > +_scratch_mount
> > +localfile=$SCRATCH_MNT/fragfile
> > +
> > +# Try to create a file with 1024 * (3 blocks + 1 hole):
> > +# +----------+--------+-------+----------+--------+
> > +# | 3 blocks | 1 hole |  ...  | 3 blocks | 1 hole |
> > +# +----------+--------+-------+----------+--------+
> > +#
> > +# The number of extents we can get maybe more or less than 1024, this method
> > +# just to get a btree inode format.
> > +filesize=$((dbsize * 1024 * 4))
> > +for i in `seq $filesize -$dbsize 0`; do
> > +	if [ $((i % (3 * dbsize))) -eq 0 ]; then
> > +		continue
> > +	fi
> > +	$XFS_IO_PROG -f -d -c "pwrite $i $dbsize" $localfile >> $seqres.full
> > +done
> > +
> > +# Make a data fork owner change log
> > +$XFS_FSR_PROG -v -d $localfile >> $seqres.full 2>&1
> > +
> > +# Truncate the file to 0, and change the inode format to extent, then shutdown
> > +# the fs to keep the XFS_ILOG_DOWNER flag
> > +$XFS_IO_PROG -t -x -c "pwrite 0 $dbsize" \
> > +	     -c "fsync" \
> > +	     -c "shutdown" $localfile >> $seqres.full
> > +
> > +# Cycle mount, to replay the log
> > +_scratch_cycle_mount
> > +
> > +echo "Silence is golden"
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> > new file mode 100644
> > index 00000000..3b276ca8
> > --- /dev/null
> > +++ b/tests/xfs/999.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 999
> > +Silence is golden
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index dfaae2bc..9171144e 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -496,3 +496,4 @@
> >  496 dangerous_fuzzers dangerous_scrub dangerous_repair
> >  497 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> >  498 dangerous_fuzzers dangerous_norepair
> > +999 auto quick
> 
> Added 'shutdown log' groups.

Thanks your revewing. But I still have some problems as I described at
beginning, so I hope we can merge this patch after we have an reply
about that.

Thanks,
Zorro

> 
> Thanks,
> Eryu
> 
> > -- 
> > 2.17.2
> > 
