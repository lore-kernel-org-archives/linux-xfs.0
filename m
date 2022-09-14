Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2415AECAAD8
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Sep 2022 08:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiININA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Sep 2022 04:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiINIM6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Sep 2022 04:12:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD994F19E
        for <linux-xfs@vger.kernel.org>; Wed, 14 Sep 2022 01:12:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FF55618E1
        for <linux-xfs@vger.kernel.org>; Wed, 14 Sep 2022 08:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92AE9C43142
        for <linux-xfs@vger.kernel.org>; Wed, 14 Sep 2022 08:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663143176;
        bh=n8weGN2l32EPVeJ0tXN8KDtw9ZI69VFxAbY01ro0/9E=;
        h=From:To:Subject:Date:From;
        b=W0eltCTqT5rTK+jT8CDyv/90bjEHWfe5tpmwV41MLDM4bV6Aa/rRchNVLgOu4ES6j
         9M90sD+vcTFh5Lqq3IMZIy6xUn/bDc4UA4w0KBPDocuUeXxg45wM1VcD0JGV9kW4Au
         1FRTUbmHw2ZUjBLeLh4Q1ATtfn5i9A4fLnppGDXkOA5PcJZ1f8uWZapr8LiWo0KyXQ
         rXfytqL3lAGeH9EHLvuq+gjuqfjptESZOPGi1G8lhcdvGYro1pTXM84LamnpKjv9Dj
         uIj1Av+0OelCxFhYF51kqg85d4ESnIuyKYmoXIWzT4MdJQckVpZGyPoiRpk2K99/fc
         B2ZW4P9M4Mvkg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 809C8C433E7; Wed, 14 Sep 2022 08:12:56 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216486] New: [xfstests generic/447] xfs_scrub always complains 
 fs corruption
Date:   Wed, 14 Sep 2022 08:12:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-216486-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216486

            Bug ID: 216486
           Summary: [xfstests generic/447] xfs_scrub always complains  fs
                    corruption
           Product: File System
           Version: 2.5
    Kernel Version: 6.0.0-rc4+
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

Recently xfstests generic/447 always fails[1][2][3] on latest xfs kernel wi=
th
xfsprogs. It's reproducible on 1k blocksize and rmapbt enabled XFS (-b
size=3D1024 -m rmapbt=3D1). Not sure if it's a kernel bug or a xfsprogs iss=
ue, or
an expected failure.

[1]
SECTION       -- default
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 hp-xxxxxxxx-01
6.0.0-0.rc4.20220906git53e99dcff61e.32.fc38.x86_64 #1 SMP PREEMPT_DYNAMIC W=
ed
Sep 7 07:51:49 UTC 2022
MKFS_OPTIONS  -- -f -b size=3D1024 -m rmapbt=3D1 /dev/sda3
MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /dev/sda3 /mnt/sc=
ratch

generic/447 246s ... _check_xfs_filesystem: filesystem on /dev/sda3 failed
scrub
(see /root/git/xfstests/results//default/generic/447.full for details)

[2]
# cat results//default/generic/447.full
meta-data=3D/dev/sda3              isize=3D512    agcount=3D16, agsize=3D32=
76544 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D1
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D=
1 nrext64=3D0
data     =3D                       bsize=3D1024   blocks=3D52424704, imaxpc=
t=3D25
         =3D                       sunit=3D256    swidth=3D256 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D1024   blocks=3D65536, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D256 blks, lazy-co=
unt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
creating 2097152 blocks...
wrote 2147483648/2147483648 bytes at offset 0
2.000 GiB, 512 ops; 0:00:07.59 (269.766 MiB/sec and 67.4414 ops/sec)
Punching file2...
...done
_check_xfs_filesystem: filesystem on /dev/sda3 failed scrub
*** xfs_scrub -v -d -n output ***
EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
Phase 1: Find filesystem geometry.
/mnt/scratch: using 1 threads to scrub.
Phase 2: Check internal metadata.
Corruption: AG 0 reference count btree: Repairs are required. (scrub.c line
196)
Info: AG 1 superblock: Optimization is possible. (scrub.c line 212)
Info: AG 2 superblock: Optimization is possible. (scrub.c line 212)
Info: AG 3 superblock: Optimization is possible. (scrub.c line 212)
Info: AG 4 superblock: Optimization is possible. (scrub.c line 212)
Info: AG 5 superblock: Optimization is possible. (scrub.c line 212)
Info: AG 6 superblock: Optimization is possible. (scrub.c line 212)
Info: AG 7 superblock: Optimization is possible. (scrub.c line 212)
Info: AG 8 superblock: Optimization is possible. (scrub.c line 212)
Info: AG 9 superblock: Optimization is possible. (scrub.c line 212)
Info: AG 10 superblock: Optimization is possible. (scrub.c line 212)
Info: AG 11 superblock: Optimization is possible. (scrub.c line 212)
Info: AG 12 superblock: Optimization is possible. (scrub.c line 212)
Info: AG 13 superblock: Optimization is possible. (scrub.c line 212)
Info: AG 14 superblock: Optimization is possible. (scrub.c line 212)
Info: AG 15 superblock: Optimization is possible. (scrub.c line 212)
Phase 3: Scan all inodes.
Info: inode 512 (0/512) inode record: Cross-referencing failed. (scrub.c li=
ne
117)
Info: inode 515 (0/515) inode record: Cross-referencing failed. (scrub.c li=
ne
117)
Info: inode 517 (0/517) inode record: Cross-referencing failed. (scrub.c li=
ne
117)
Info: inode 517 (0/517) data block map: Cross-referencing failed. (scrub.c =
line
117)
Info: /mnt/scratch: Optimizations of inode record are possible. (scrub.c li=
ne
253)
Phase 5: Check directory tree.
Info: /mnt/scratch: Filesystem has errors, skipping connectivity checks.
(phase5.c line 392)
Phase 7: Check summary counters.
5.2GiB data used;  6 inodes used.
1.1GiB data found; 5 inodes found.
5 inodes counted; 6 inodes checked.
/mnt/scratch: corruptions found: 1
/mnt/scratch: Re-run xfs_scrub without -n.
*** end xfs_scrub output

[3]
# dmesg
[329558.995550] run fstests generic/447 at 2022-09-13 14:01:24
[329560.019866] systemd[1]: Started fstests-generic-447.scope - /usr/bin/ba=
sh
-c test -w /proc/self/oom_score_adj && echo 250 > /proc/self/oom_score_adj;
exec ./tests/generic/447.
[329561.466573] XFS (sda3): Mounting V5 Filesystem
[329561.542655] XFS (sda3): Ending clean mount
[329561.596681] XFS (sda3): Unmounting Filesystem
[329561.598209] systemd[1]: mnt-scratch.mount: Deactivated successfully.
[329562.183863] XFS (sda3): Mounting V5 Filesystem
[329562.265873] XFS (sda3): Ending clean mount
[329727.320231] systemd[1]: mnt-scratch.mount: Deactivated successfully.
[329729.160375] XFS (sda3): Unmounting Filesystem
[329730.480159] XFS (sda3): Mounting V5 Filesystem
[329730.559529] XFS (sda3): Ending clean mount
[329730.595342] systemd[1]: fstests-generic-447.scope: Deactivated
successfully.
[329730.597524] systemd[1]: fstests-generic-447.scope: Consumed 2min 44.321s
CPU time.
[329730.641904] XFS (sda5): Unmounting Filesystem
[329730.644716] systemd[1]: mnt-test.mount: Deactivated successfully.
[329730.899455] XFS (sda3): EXPERIMENTAL online scrub feature in use. Use at
your own risk!
[329743.405813] XFS (sda3): Corruption detected during scrub.
[329743.922150] XFS (sda3): Corruption detected during scrub.
[329744.438304] XFS (sda3): Corruption detected during scrub.
[329744.956067] XFS (sda3): Corruption detected during scrub.
[329745.472617] XFS (sda3): Corruption detected during scrub.
[329745.988849] XFS (sda3): Corruption detected during scrub.
[329746.505812] XFS (sda3): Corruption detected during scrub.
[329747.022342] XFS (sda3): Corruption detected during scrub.
[329747.538927] XFS (sda3): Corruption detected during scrub.
[329748.055586] XFS (sda3): Corruption detected during scrub.
[329748.572338] XFS (sda3): Corruption detected during scrub.
[329911.911869] XFS (sda3): Unmounting Filesystem
[329911.913058] XFS (sda3): Uncorrected metadata errors detected; please run
xfs_repair.
[329911.913588] systemd[1]: mnt-scratch.mount: Deactivated successfully.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
