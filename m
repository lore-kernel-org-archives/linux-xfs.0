Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13394ECAAD3
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Sep 2022 17:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiINRpv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Sep 2022 13:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiINRpu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Sep 2022 13:45:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D433A12D3D
        for <linux-xfs@vger.kernel.org>; Wed, 14 Sep 2022 10:45:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6C015CE16B9
        for <linux-xfs@vger.kernel.org>; Wed, 14 Sep 2022 17:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58955C433D6;
        Wed, 14 Sep 2022 17:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663177543;
        bh=3BhpTt2q60TFuydNwFgbbsMgtAAU4NT9+IxnimbLwfk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZqHtMqI0OeiBifPT3hPJtA1s42eIpVIQZUMW9s2pqgIrN+9S/A/8CStynfX9quu0E
         /M0EIgD26IyXhjTqjLiEIrf1CeItUv+SXUrPp9EKNMwNnmvUiU0e0EnRZBcXATliY2
         zojpAaYOE124TdhElxRTMrxYVGf9Dtnv2VHjB8Fh8534YIdq4qH4Zl3u2yHfLQ3Stu
         2kpuhzsDDBSFt0kSq7WxeZEJZPSNqM7nnCUbjwzt9CbEYsC3VhYS5qfhk3QAD2XK+d
         iyCO4Q2ogHYBia4dE85ZaDKMWpA+PsEB9LVfwQEUio1vnJcQamh/Zp7Af4zLGIR0lu
         sgTTa/TAhyUYQ==
Date:   Wed, 14 Sep 2022 10:45:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 216486] New: [xfstests generic/447] xfs_scrub always
 complains fs corruption
Message-ID: <YyITRqoh7rP2pzNm@magnolia>
References: <bug-216486-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-216486-201763@https.bugzilla.kernel.org/>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 14, 2022 at 08:12:56AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=216486
> 
>             Bug ID: 216486
>            Summary: [xfstests generic/447] xfs_scrub always complains  fs
>                     corruption
>            Product: File System
>            Version: 2.5
>     Kernel Version: 6.0.0-rc4+
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: zlang@redhat.com
>         Regression: No
> 
> Recently xfstests generic/447 always fails[1][2][3] on latest xfs kernel with
> xfsprogs. It's reproducible on 1k blocksize and rmapbt enabled XFS (-b
> size=1024 -m rmapbt=1). Not sure if it's a kernel bug or a xfsprogs issue, or
> an expected failure.

It's an expected failure that is one of the many things fixed by the
online fsck patchset.  The solution I came up with is described here:
https://djwong.org/docs/xfs-online-fsck-design/#eventual-consistency-vs-online-fsck

The TLDR is that scrub is probably racing with a thread that's in the
middle of doing a file mapping change that involves both an rmap and a
refcount update.  This is possible because we don't hold the AGF buffer
between work items in a defer ops chain.

--D

> [1]
> SECTION       -- default
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 hp-xxxxxxxx-01
> 6.0.0-0.rc4.20220906git53e99dcff61e.32.fc38.x86_64 #1 SMP PREEMPT_DYNAMIC Wed
> Sep 7 07:51:49 UTC 2022
> MKFS_OPTIONS  -- -f -b size=1024 -m rmapbt=1 /dev/sda3
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda3 /mnt/scratch
> 
> generic/447 246s ... _check_xfs_filesystem: filesystem on /dev/sda3 failed
> scrub
> (see /root/git/xfstests/results//default/generic/447.full for details)
> 
> [2]
> # cat results//default/generic/447.full
> meta-data=/dev/sda3              isize=512    agcount=16, agsize=3276544 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
> data     =                       bsize=1024   blocks=52424704, imaxpct=25
>          =                       sunit=256    swidth=256 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=1024   blocks=65536, version=2
>          =                       sectsz=512   sunit=256 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> creating 2097152 blocks...
> wrote 2147483648/2147483648 bytes at offset 0
> 2.000 GiB, 512 ops; 0:00:07.59 (269.766 MiB/sec and 67.4414 ops/sec)
> Punching file2...
> ...done
> _check_xfs_filesystem: filesystem on /dev/sda3 failed scrub
> *** xfs_scrub -v -d -n output ***
> EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
> Phase 1: Find filesystem geometry.
> /mnt/scratch: using 1 threads to scrub.
> Phase 2: Check internal metadata.
> Corruption: AG 0 reference count btree: Repairs are required. (scrub.c line
> 196)
> Info: AG 1 superblock: Optimization is possible. (scrub.c line 212)
> Info: AG 2 superblock: Optimization is possible. (scrub.c line 212)
> Info: AG 3 superblock: Optimization is possible. (scrub.c line 212)
> Info: AG 4 superblock: Optimization is possible. (scrub.c line 212)
> Info: AG 5 superblock: Optimization is possible. (scrub.c line 212)
> Info: AG 6 superblock: Optimization is possible. (scrub.c line 212)
> Info: AG 7 superblock: Optimization is possible. (scrub.c line 212)
> Info: AG 8 superblock: Optimization is possible. (scrub.c line 212)
> Info: AG 9 superblock: Optimization is possible. (scrub.c line 212)
> Info: AG 10 superblock: Optimization is possible. (scrub.c line 212)
> Info: AG 11 superblock: Optimization is possible. (scrub.c line 212)
> Info: AG 12 superblock: Optimization is possible. (scrub.c line 212)
> Info: AG 13 superblock: Optimization is possible. (scrub.c line 212)
> Info: AG 14 superblock: Optimization is possible. (scrub.c line 212)
> Info: AG 15 superblock: Optimization is possible. (scrub.c line 212)
> Phase 3: Scan all inodes.
> Info: inode 512 (0/512) inode record: Cross-referencing failed. (scrub.c line
> 117)
> Info: inode 515 (0/515) inode record: Cross-referencing failed. (scrub.c line
> 117)
> Info: inode 517 (0/517) inode record: Cross-referencing failed. (scrub.c line
> 117)
> Info: inode 517 (0/517) data block map: Cross-referencing failed. (scrub.c line
> 117)
> Info: /mnt/scratch: Optimizations of inode record are possible. (scrub.c line
> 253)
> Phase 5: Check directory tree.
> Info: /mnt/scratch: Filesystem has errors, skipping connectivity checks.
> (phase5.c line 392)
> Phase 7: Check summary counters.
> 5.2GiB data used;  6 inodes used.
> 1.1GiB data found; 5 inodes found.
> 5 inodes counted; 6 inodes checked.
> /mnt/scratch: corruptions found: 1
> /mnt/scratch: Re-run xfs_scrub without -n.
> *** end xfs_scrub output
> 
> [3]
> # dmesg
> [329558.995550] run fstests generic/447 at 2022-09-13 14:01:24
> [329560.019866] systemd[1]: Started fstests-generic-447.scope - /usr/bin/bash
> -c test -w /proc/self/oom_score_adj && echo 250 > /proc/self/oom_score_adj;
> exec ./tests/generic/447.
> [329561.466573] XFS (sda3): Mounting V5 Filesystem
> [329561.542655] XFS (sda3): Ending clean mount
> [329561.596681] XFS (sda3): Unmounting Filesystem
> [329561.598209] systemd[1]: mnt-scratch.mount: Deactivated successfully.
> [329562.183863] XFS (sda3): Mounting V5 Filesystem
> [329562.265873] XFS (sda3): Ending clean mount
> [329727.320231] systemd[1]: mnt-scratch.mount: Deactivated successfully.
> [329729.160375] XFS (sda3): Unmounting Filesystem
> [329730.480159] XFS (sda3): Mounting V5 Filesystem
> [329730.559529] XFS (sda3): Ending clean mount
> [329730.595342] systemd[1]: fstests-generic-447.scope: Deactivated
> successfully.
> [329730.597524] systemd[1]: fstests-generic-447.scope: Consumed 2min 44.321s
> CPU time.
> [329730.641904] XFS (sda5): Unmounting Filesystem
> [329730.644716] systemd[1]: mnt-test.mount: Deactivated successfully.
> [329730.899455] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at
> your own risk!
> [329743.405813] XFS (sda3): Corruption detected during scrub.
> [329743.922150] XFS (sda3): Corruption detected during scrub.
> [329744.438304] XFS (sda3): Corruption detected during scrub.
> [329744.956067] XFS (sda3): Corruption detected during scrub.
> [329745.472617] XFS (sda3): Corruption detected during scrub.
> [329745.988849] XFS (sda3): Corruption detected during scrub.
> [329746.505812] XFS (sda3): Corruption detected during scrub.
> [329747.022342] XFS (sda3): Corruption detected during scrub.
> [329747.538927] XFS (sda3): Corruption detected during scrub.
> [329748.055586] XFS (sda3): Corruption detected during scrub.
> [329748.572338] XFS (sda3): Corruption detected during scrub.
> [329911.911869] XFS (sda3): Unmounting Filesystem
> [329911.913058] XFS (sda3): Uncorrected metadata errors detected; please run
> xfs_repair.
> [329911.913588] systemd[1]: mnt-scratch.mount: Deactivated successfully.
> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.
