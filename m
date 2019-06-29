Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52224 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726858AbfF2RfQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Jun 2019 13:35:16 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BC09C28564
        for <linux-xfs@vger.kernel.org>; Sat, 29 Jun 2019 17:35:15 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 203947] [xfstests generic/475]: general protection fault: 0000
 [#1] RIP: 0010:xfs_setfilesize_ioend+0xb1/0x220 [xfs]
Date: Sat, 29 Jun 2019 17:35:14 +0000
Message-ID: <bug-203947-201763-1ou6q7Q6oR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203947-201763@https.bugzilla.kernel.org/>
References: <bug-203947-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203947

--- Comment #9 from Darrick J. Wong (djwong+kernel@djwong.org) ---
Zorro,

If you get a chance, can you try this debugging patch, please?

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index baf0b72c0a37..1bf408255349 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3846,6 +3846,12 @@ xfs_bmapi_read(
                return 0;
        }

+       if (!ifp) {
+               xfs_err(mp, "NULL FORK, inode x%llx fork %d??",
+                               ip->i_ino, whichfork);
+               return -EFSCORRUPTED;
+       }
+
        if (!(ifp->if_flags & XFS_IFEXTENTS)) {
                error = xfs_iread_extents(NULL, ip, whichfork);
                if (error)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
