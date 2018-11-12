Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47482 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729783AbeKLXYp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Nov 2018 18:24:45 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5DDB229E61
        for <linux-xfs@vger.kernel.org>; Mon, 12 Nov 2018 13:31:27 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200063] XFS corruption: mismatch between format (2) and size
 (0) in symlink
Date: Mon, 12 Nov 2018 13:31:26 +0000
Message-ID: <bug-200063-201763-KTWUnqKC4W@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200063-201763@https.bugzilla.kernel.org/>
References: <bug-200063-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200063

--- Comment #4 from Zorro Lang (zlang@redhat.com) ---
I still can reproduce this bug on linux v4.20-rc1. So we haven't merged this
patch (in comment 3), right?

Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - 14:10:29: scanning filesystem freespace - 16 of 16 allocation groups
done
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - 14:10:29: scanning agi unlinked lists - 16 of 16 allocation groups
done
        - process known inodes and perform inode discovery...
        - agno = 15
        - agno = 0
        - agno = 1
mismatch between format (2) and size (0) in symlink ino 125888517
bad data fork in symlink 125888517
would have cleared inode 125888517
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - 14:10:32: process known inodes and inode discovery - 50048 of 50048
inodes done
        - process newly discovered inodes...
        - 14:10:32: process newly discovered inodes - 16 of 16 allocation
groups done
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - 14:10:32: setting up duplicate extent list - 16 of 16 allocation
groups done
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 13
        - agno = 2
        - agno = 3
        - agno = 5
        - agno = 4
        - agno = 6
        - agno = 7
        - agno = 9
        - agno = 11
        - agno = 10
        - agno = 8
        - agno = 14
        - agno = 12
        - agno = 15
        - agno = 1
mismatch between format (2) and size (0) in symlink ino 125888517
bad data fork in symlink 125888517
would have cleared inode 125888517
        - 14:10:32: check for inodes claiming duplicate blocks - 50048 of 50048
inodes done
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
        - 14:10:33: verify and correct link counts - 16 of 16 allocation groups
done

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
