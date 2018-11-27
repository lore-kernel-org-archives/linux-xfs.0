Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55442 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728303AbeK0O0f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Nov 2018 09:26:35 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0FAA72A8FA
        for <linux-xfs@vger.kernel.org>; Tue, 27 Nov 2018 03:30:09 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201793] New: [xfstests generic/299] XFS corruption found:
 sb_fdblocks 7302443, counted 7302451
Date: Tue, 27 Nov 2018 03:30:09 +0000
Message-ID: <bug-201793-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201793

            Bug ID: 201793
           Summary: [xfstests generic/299] XFS corruption found:
                    sb_fdblocks 7302443, counted 7302451
           Product: File System
           Version: 2.5
    Kernel Version: xfs-4.20-fixes-2
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

Description of problem:
I hit a XFS corruption several times on ppc64le, by running generic/299 on 2k
blocksize XFS (reflink=1,rmapbt=1):
#
# FSQA Test No. 299
#
# AIO/DIO stress test
# Run random AIO/DIO activity and fallocate/truncate simultaneously
# Test will operate on huge sparsed files so ENOSPC is expected.
#
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/ppc64le xxxxxxx 4.20.0-rc1.kasan
MKFS_OPTIONS  -- -f -b size=2048 -m crc=1,finobt=1,reflink=1,rmapbt=1 -i
sparse=1 /dev/vda5
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/vda5
/mnt/xfstests/mnt2

generic/299 176s ... _check_xfs_filesystem: filesystem on /dev/vda5 is
inconsistent (r)
(see /var/lib/xfstests/results//generic/299.full for details)

Ran: generic/299
Failures: generic/299
Failed 1 of 1 tests

Version-Release number of selected component (if applicable):
https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
xfs-4.20-fixes-2

How reproducible:
1~2% on my ppc64le kvm machine. But it's hard to reproduce on my x86_64 real
machine.

Steps to Reproduce:
Loop running generic/299, but maybe not easy to hit it

Actual results:
XFS corruption

Expected results:
test always pass

Additional info:
Please check the full output and xfs metadump from attachments.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
