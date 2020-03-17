Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA253C10F29
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 04:32:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82E3D20663
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 04:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgCQEcu convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 00:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbgCQEcu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Mar 2020 00:32:50 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 206869] New: [xfstests generic/587]: quota mismatch
Date:   Tue, 17 Mar 2020 04:32:49 +0000
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
Message-ID: <bug-206869-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206869

            Bug ID: 206869
           Summary: [xfstests generic/587]: quota mismatch
           Product: File System
           Version: 2.5
    Kernel Version: xfs-linux xfs-5.3-merge-3
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

xfstests generic/587 always fails on 512b blocksize XFS:

# ./check generic/587
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 ibm-x3650m4-10 5.6.0-rc5-xfs-whatamess+ #2 SMP
Fri Mar 13 12:21:33 CST 2020
MKFS_OPTIONS  -- -f -m crc=0 -b size=512 /dev/mapper/testvg-scratchdev
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0
/dev/mapper/testvg-scratchdev /mnt/scratch

generic/587 3s ... - output mismatch (see
/root/git/xfstests-dev/results//generic/587.out.bad)
    --- tests/generic/587.out   2020-03-12 11:22:50.036148632 +0800
    +++ /root/git/xfstests-dev/results//generic/587.out.bad     2020-03-17
12:29:40.149766703 +0800
    @@ -1,2 +1,3 @@
     QA output created by 587
    +fsgqa: quota blocks 29KiB, expected 28KiB!
     Silence is golden.
    ...
    (Run 'diff -u /root/git/xfstests-dev/tests/generic/587.out
/root/git/xfstests-dev/results//generic/587.out.bad'  to see the entire diff)
Ran: generic/587
Failures: generic/587
Failed 1 of 1 tests

Only 512b XFS can reproduce this failure.
"-m crc=0 -b size=1024"   PASS
"-m crc=0 -b size=4096"   PASS
"-m crc=1,reflink=1,rmapbt=1 -b size=1024"   PASS
"-m crc=1,reflink=1,rmapbt=1 -b size=4096"   PASS

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
