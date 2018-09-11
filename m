Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47334 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726408AbeIKNKu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Sep 2018 09:10:50 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A909728FF6
        for <linux-xfs@vger.kernel.org>; Tue, 11 Sep 2018 08:12:41 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201089] New: [xfstests generic/417]: XFS corruption attribute
 entry #0 in attr block 0, inode 674 is INCOMPLETE
Date: Tue, 11 Sep 2018 08:12:42 +0000
Message-ID: <bug-201089-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201089

            Bug ID: 201089
           Summary: [xfstests generic/417]: XFS corruption attribute entry
                    #0 in attr block 0, inode 674 is INCOMPLETE
           Product: File System
           Version: 2.5
    Kernel Version: 4.19-rc3
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

Created attachment 278449
  --> https://bugzilla.kernel.org/attachment.cgi?id=278449&action=edit
xfs (512 blocksize) with the orphan list

I just hit a XFS corruption by running xfstests generic/417 on 512 blocksize
XFS (reproduce on linux 4.19-rc3):

_check_xfs_filesystem: filesystem on /dev/sda5 is inconsistent (r)
*** xfs_repair -n output ***
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
sb_icount 64, counted 128
sb_ifree 61, counted 124
sb_fdblocks 31436740, counted 31436706
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
attribute entry #0 in attr block 0, inode 674 is INCOMPLETE
problem with attribute contents in inode 674
would clear attr fork
bad nblocks 2 for inode 674, would reset to 0
bad anextents 2 for inode 674, would reset to 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.
*** end xfs_repair output


Although g/417 is the reproducer, it's very hard to reproduce it by g/417. So I
got the metadump file which can trigger this bug by running g/417:

...
echo "mount dirty orphans ro, then unmount"
create_dirty_orphans
                     <<< metadump at HERE
_scratch_mount -o ro
_scratch_unmount
# We should be clean at this point
echo "check fs consistency"
_check_scratch_fs
...

Steps to Reproduce:
1. Download the attachment from this bug
2. mdrestore the metadump
3. mount && umount the XFS to replay log
4. xfs_repair -n above XFS image


Additional info:
Brian (bfoster@) has left some messages for this bug, but that's an internal
link can't be opened from outside. So I paste his comment as below:
---
>From skimming through the code and reminding myself about the xattr INCOMPLETE
flag semantics, I think this flag can be expected after a crash regardless of
log recovery. For example, if we're setting a largish xattr value that requires
remote block allocation, we'd set the xattr name and mark the entry INCOMPLETE,
roll the transaction, allocate the remote block(s) (rolling the transaction
again), synchronous write the remote value, clear the INCOMPLETE flag (and roll
the tx) and the finally commit the transaction.

So IOW, it's quite possible to leave a partially constructed (i.e., no value)
xattr in place after a crash and the purpose of the flag is to accommodate
that. It looks like there are cases where incomplete xattrs might be quietly
cleaned out, so this isn't a catastrophic problem that requires immediate
repair, but otherwise it makes sense for repair to detect and clear them out as
well. It's not clear that the block accounting error is to be expected,
however, so there still could be something going on here..
---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
