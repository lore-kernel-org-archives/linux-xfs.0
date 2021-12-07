Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05E72C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Dec 2021 17:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235313AbhLGSAU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Dec 2021 13:00:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37762 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbhLGSAU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Dec 2021 13:00:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CD06B81DAE
        for <linux-xfs@vger.kernel.org>; Tue,  7 Dec 2021 17:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1947C341CB
        for <linux-xfs@vger.kernel.org>; Tue,  7 Dec 2021 17:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638899807;
        bh=7NdeRBDVA7ynBbvewsWi7NrMHABwYqe8eJEK88uN2P4=;
        h=From:To:Subject:Date:From;
        b=lhaZtEV/fmT6+L500DqBzPN4HGfOqi+Gw+0Nsj+766Qau9ZC1XkkZJTMd6u0GBBQb
         lGa8jDGLYi8aogGF2LkYKN7yOtut+sZ/XYW7MKENBIVt+vnzjqYZdS1GGPjcMwU1DS
         GVkkoBjnw5am1bFBwOYRKZ+e2kxXlgn6pWH/xGMFJcaxrDYICKkm/btrJaUNhYxQy2
         DyYHjMeFIrg3O6X7HFsScnrwgBzsK6evdtqbiLxYDvLds9+vr+YyBki/RSt3rv8C2o
         fIh+GffEzB1GvjSOLb/EztXNVmVFqFS/LfU/5/T9zNO9Y9xtyLt/3ifXO7qyUDCroq
         PV5BgP5Jr2vUQ==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id D3B7660F4F; Tue,  7 Dec 2021 17:56:47 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215261] New: [xfstests xfs/177] test still fails after merge
 f38a032b165d ("xfs: fix I_DONTCACHE")
Date:   Tue, 07 Dec 2021 17:56:47 +0000
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
Message-ID: <bug-215261-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215261

            Bug ID: 215261
           Summary: [xfstests xfs/177] test still fails after merge
                    f38a032b165d ("xfs: fix I_DONTCACHE")
           Product: File System
           Version: 2.5
    Kernel Version: v5.16-rc2 + xfs-5.16-fixes-2
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

xfstests xfs/177 still fails on xfs-5.16-fixes-2 sometimes, e.g [1][2]. The
kernel has merged f38a032b165d ("xfs: fix I_DONTCACHE").

[1]
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 ibm-x3650m4-xxx-vm-xx 5.16.0-rc2+ #1 SMP PREE=
MPT
Sun Nov 28 06:43:30 EST 2021
MKFS_OPTIONS  -- -f -m crc=3D1,finobt=3D1,rmapbt=3D0,reflink=3D1,bigtime=3D=
1,inobtcount=3D1
/dev/vda3
MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /dev/vda3
/mnt/xfstests/scratch

xfs/177 - output mismatch (see /var/lib/xfstests/results//xfs/177.out.bad)
    --- tests/xfs/177.out       2021-11-28 09:56:52.236830568 -0500
    +++ /var/lib/xfstests/results//xfs/177.out.bad      2021-11-30
04:21:03.282699626 -0500
    @@ -2,11 +2,14 @@
     new file count is in range
     inodes after creating files is in range
     Round 1
    -inodes after bulkstat is in range
    +inodes after bulkstat has value of 102
    +inodes after bulkstat is NOT in range 1023 .. 1033
     inodes after expire is in range
    ...
    (Run 'diff -u /var/lib/xfstests/tests/xfs/177.out
/var/lib/xfstests/results//xfs/177.out.bad'  to see the entire diff)
Ran: xfs/177
Failures: xfs/177
Failed 1 of 1 tests

[2]
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/aarch64 hpe-apollo-cnxxxx-xx-vm-xx 5.16.0-rc2+ #1 SMP
Sun Nov 28 06:10:24 EST 2021
MKFS_OPTIONS  -- -f -m crc=3D1,finobt=3D1,rmapbt=3D0,reflink=3D1,bigtime=3D=
1,inobtcount=3D1
/dev/vda3
MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /dev/vda3
/mnt/xfstests/scratch

xfs/177 - output mismatch (see /var/lib/xfstests/results//xfs/177.out.bad)
    --- tests/xfs/177.out       2021-11-28 10:04:49.415509327 -0500
    +++ /var/lib/xfstests/results//xfs/177.out.bad      2021-11-29
04:47:32.148868974 -0500
    @@ -2,7 +2,8 @@
     new file count is in range
     inodes after creating files is in range
     Round 1
    -inodes after bulkstat is in range
    +inodes after bulkstat has value of 575
    +inodes after bulkstat is NOT in range 1023 .. 1033
     inodes after expire is in range
    ...
    (Run 'diff -u /var/lib/xfstests/tests/xfs/177.out
/var/lib/xfstests/results//xfs/177.out.bad'  to see the entire diff)
Ran: xfs/177
Failures: xfs/177
Failed 1 of 1 tests

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
