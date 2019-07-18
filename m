Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38856 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391428AbfGRUTP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 16:19:15 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4DBAB28889
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2019 20:19:14 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 204049] [xfstests generic/388]: XFS: Assertion failed:
 ip->i_d.di_format != XFS_DINODE_FMT_BTREE || ip->i_d.di_nextents >
 XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK), file: fs/xfs/xfs_inode.c, line: 3646
Date: Thu, 18 Jul 2019 20:19:13 +0000
Message-ID: <bug-204049-201763-Hxx059XxpB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204049-201763@https.bugzilla.kernel.org/>
References: <bug-204049-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204049

--- Comment #2 from Luis Chamberlain (mcgrof@kernel.org) ---
I spoke too soon, after 30 runs I managed to hit the same crash that I reported
on kz#204223 [0] with the same configuration you used to report here this bug,
"xfs_reflink_normapbt".

So, if you bisect, it will still fail, but you should hit at lest a different
crash, the one being tracked on kz#204223.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=204223

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
