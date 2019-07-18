Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44700 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391484AbfGRU3T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 16:29:19 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 60D8B2889E
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2019 20:29:19 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 204049] [xfstests generic/388]: XFS: Assertion failed:
 ip->i_d.di_format != XFS_DINODE_FMT_BTREE || ip->i_d.di_nextents >
 XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK), file: fs/xfs/xfs_inode.c, line: 3646
Date: Thu, 18 Jul 2019 20:29:18 +0000
Message-ID: <bug-204049-201763-sqxMi1T70G@https.bugzilla.kernel.org/>
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

--- Comment #3 from Luis Chamberlain (mcgrof@kernel.org) ---
And, do you not get a crash with the "xfs_nocrc" or "xfs_reflink"
configurations? What if you run the test in a loop. To test in a loop I use
oscheck's naggy-check.sh [0]. Provided you have configured your sections named
in the fstests configuration as I have on oscheck [1], you should be able to
use it as follows until a failure is found:

./naggy-check.sh -s xfs_reflink_normapbt -f generic/388

I just added xfs_reflink_normapbt to the upstream oscheck demo config.

[0] https://gitlab.com/mcgrof/oscheck/blob/master/naggy-check.sh
[1] https://gitlab.com/mcgrof/oscheck/blob/master/fstests-configs/xfs.config

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
