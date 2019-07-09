Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41682 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbfGIJXo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 05:23:44 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3F16E26222
        for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2019 09:23:43 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 204107] New: [xfstests xfs/442]: xfs_db process hang on ppc64le
Date: Tue, 09 Jul 2019 09:23:42 +0000
Message-ID: <bug-204107-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204107

            Bug ID: 204107
           Summary: [xfstests xfs/442]: xfs_db process hang on ppc64le
           Product: File System
           Version: 2.5
    Kernel Version: xfs-linux xfs-5.3-merge-10
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

Created attachment 283585
  --> https://bugzilla.kernel.org/attachment.cgi?id=283585&action=edit
console log

xfs/442 hang (about 24 hours) on ppc64le:

FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/ppc64le ibm-p8-kvm-09-guest-13 5.2.0-rc4+
MKFS_OPTIONS  -- -f -m crc=1,finobt=1,rmapbt=1,reflink=1 -i sparse=1 /dev/vda5
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/vda5
/mnt/xfstests/mnt2

xfs/442
...
...
...

[129993.778466] sysrq: Show Blocked State 
[129993.778592]   task                        PC stack   pid father 
[129993.779915] xfs_db          D 5920  9461   8573 0x00040080 
[129993.780002] Call Trace: 
[129993.780132] [c00000006e41f860] [c000000000027560] __switch_to+0x280/0x4b0 
[129993.780256] [c00000006e41f8c0] [c000000000f030b0] __schedule+0x4e0/0xd10 
[129993.780361] [c00000006e41f9a0] [c000000000f03938] schedule+0x58/0x150 
[129993.780486] [c00000006e41f9d0] [c0000000001cb98c] io_schedule+0x2c/0x50 
[129993.780609] [c00000006e41fa00] [c0000000004326b8]
wait_on_page_bit_killable+0x1d8/0x340 
[129993.780732] [c00000006e41fae0] [c00000000043c3c0]
__lock_page_or_retry+0xe0/0x1c0 
[129993.780855] [c00000006e41fb20] [c0000000004acd90] do_swap_page+0x3f0/0x1040 
[129993.780978] [c00000006e41fba0] [c0000000004b2e58]
__handle_mm_fault+0xc78/0xed0 
[129993.781137] [c00000006e41fc90] [c0000000004b3318]
handle_mm_fault+0x268/0x480 
[129993.781266] [c00000006e41fce0] [c000000000086eb8]
__do_page_fault+0x368/0x10e0 
[129993.781464] [c00000006e41fde0] [c000000000087c68] do_page_fault+0x38/0xf0 
[129993.781559] [c00000006e41fe20] [c00000000000aba4]
handle_page_fault+0x18/0x38

More details please check the attachment. I hit this issue twice on ppc64le
machine(kvm). Haven't reproduced it on x86_64.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
