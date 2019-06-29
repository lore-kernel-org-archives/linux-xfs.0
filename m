Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50096 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726837AbfF2QHr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Jun 2019 12:07:47 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9F0932876B
        for <linux-xfs@vger.kernel.org>; Sat, 29 Jun 2019 16:07:46 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 203947] [xfstests generic/475]: general protection fault: 0000
 [#1] RIP: 0010:xfs_setfilesize_ioend+0xb1/0x220 [xfs]
Date: Sat, 29 Jun 2019 16:07:45 +0000
Message-ID: <bug-203947-201763-ZoLV7UynfB@https.bugzilla.kernel.org/>
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

--- Comment #7 from Darrick J. Wong (djwong+kernel@djwong.org) ---
This is a different issue.  It would help to know where "xfs_bmapi_read+0x311"
points to in your kernel, though it looks like inode inactivation crashed while
trying to tear down an attr fork, and maybe the attr fork wasn't loaded in
memory?  (Possibly because the fs went down while the inode was being set up?)

Ahh generic/475, bringer of much bug report. :)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
