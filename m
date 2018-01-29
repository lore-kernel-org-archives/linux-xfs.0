Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:46286 "EHLO trent.utfs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750808AbeA2DW4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 28 Jan 2018 22:22:56 -0500
Date: Sun, 28 Jan 2018 19:22:54 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: xfs_repair: couldn't map inode 2089979520, err = 117
In-Reply-To: <20180118185546.GI25805@magnolia>
Message-ID: <alpine.DEB.2.21.9.1801281906451.2567@trent.utfs.org>
References: <alpine.DEB.2.21.9.1801172204210.14759@trent.utfs.org> <20180118183636.GB56446@bfoster.bfoster> <20180118185546.GI25805@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Thu, 18 Jan 2018, Darrick J. Wong wrote:
> Ahhhurrgh.  Yes, right now xfsprogs is rather inflexible about the
> verifiers -- the directory repairer decides that it can simply reset the
> parent pointer, but then libxfs_iget & friends barf because the sf
> directory verifier fails, and there's no way to turn that off.
> 
> Well, there /is/ a way -- refactor the sf verifiers such that they're
> (optionally) called by _iget so that repair can load the inode w/o
> verifiers, make the corrections, and write everything back out.  That
> refactoring will appear in Linux 4.16, so I imagine xfs_repair 4.16 will
> get back on track with that.
> 
> FWIW I think a reasonable reproducer is running xfs/384 with:
> 
> SCRATCH_XFS_LIST_METADATA_FIELDS=u3.sfdir3.hdr.parent.i4
> SCRATCH_XFS_LIST_FUZZ_VERBS=random

While the file system could be repaired eventually with xfsprogs-v4.10, it 
took me a while to find time to setup a VM and try to run xfs/384.

I checked out djwong-xfs-linux/master and booted into a kernel with 
CONFIG_XFS_ONLINE_SCRUB=y and also built djwong-xfsprogs-dev/djwong-devel 
where xfs_scrub was available, and then:


ubuntu0# export PATH=/opt/xfsprogs-dev/sbin:$PATH
ubuntu0# export SCRATCH_XFS_LIST_METADATA_FIELDS=u3.sfdir3.hdr.parent.i4 SCRATCH_XFS_LIST_FUZZ_VERBS=random
ubuntu0# ./check tests/xfs/384
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 ubuntu0 4.15.0-rc9-00001-g0d665e7b109d
MKFS_OPTIONS  -- -f -bsize=4096 /dev/mapper/vg0-lv1
MOUNT_OPTIONS -- /dev/mapper/vg0-lv1 /mnt/scratch

xfs/384  - output mismatch (see 
/opt/xfstests/xfstests/results//xfs/384.out.bad)
    --- tests/xfs/384.out       2018-01-19 17:10:21.382080009 -0800
    +++ /opt/xfstests/xfstests/results//xfs/384.out.bad 2018-01-28 
19:17:58.795130435 -0800
    @@ -2,4 +2,8 @@
     Format and populate
     Find inline-format dir inode
     Fuzz inline-format dir inode
    +offline repair failed (1) with u3.sfdir3.hdr.parent.i4 = random.
    +offline re-scrub (1) with u3.sfdir3.hdr.parent.i4 = random.
    +online re-scrub (1) with u3.sfdir3.hdr.parent.i4 = random.
    +re-repair failed (1) with u3.sfdir3.hdr.parent.i4 = random.
    ...
    (Run 'diff -u tests/xfs/384.out 
/opt/xfstests/xfstests/results//xfs/384.out.bad'  to see the entire diff)
_check_dmesg: something found in dmesg (see 
/opt/xfstests/xfstests/results//xfs/384.dmesg)
Ran: xfs/384
Failures: xfs/384
Failed 1 of 1 tests


   If this means anything to you, I've put the result files here:
   http://nerdbynature.de/bits/4.14/xfs/


Thanks,
Christian.
-- 
BOFH excuse #209:

Only people with names beginning with 'A' are getting mail this week (a la Microsoft)
