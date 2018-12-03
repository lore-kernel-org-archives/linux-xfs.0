Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54724 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725908AbeLCVWB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 16:22:01 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 21A022A49A
        for <linux-xfs@vger.kernel.org>; Mon,  3 Dec 2018 21:22:00 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201823] inconsistent behaviour of xfs_db, xfs_repair and
 xfs_scrub
Date: Mon, 03 Dec 2018 21:21:59 +0000
Message-ID: <bug-201823-201763-ooJ0pkI51a@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201823-201763@https.bugzilla.kernel.org/>
References: <bug-201823-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201823

--- Comment #7 from Eric Sandeen (sandeen@sandeen.net) ---
So, the frag command emits these warnings under a debug build:

# xfs_db -c frag -r /dev/sde1
bad inode magic/vsn daddr 8366784 #0 (magic=5844)
Metadata corruption detected at 0x4289c3, xfs_inode block 0x7faac0/0x8000
bad inode magic/vsn daddr 34386688 #0 (magic=0)
Metadata corruption detected at 0x4289c3, xfs_inode block 0x20cb300/0x8000
bad inode magic/vsn daddr 36967232 #0 (magic=0)
Metadata corruption detected at 0x4289c3, xfs_inode block 0x2341340/0x8000

If we look at each of those blocks (daddr) after a blockget -n, 

xfs_db> daddr 8366784
xfs_db> blockuse
block 1045848 (0/1045848) type dir inode 8366719
xfs_db> daddr 34386688
xfs_db> blockuse
block 5292640 (1/1098336) type free2
xfs_db> daddr 36967232
xfs_db> blockuse
block 5615208 (1/1420904) type data inode 44934228

The "inode" corruption it's finding isn't actually in inode blocks...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
