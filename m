Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:48350 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbeLXKkW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Dec 2018 05:40:22 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4F38528BF1
        for <linux-xfs@vger.kernel.org>; Mon, 24 Dec 2018 10:40:21 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202053] [xfstests generic/464]: XFS corruption and Assertion
 failed: 0, file: fs/xfs/xfs_super.c, line: 985
Date: Mon, 24 Dec 2018 10:40:20 +0000
Message-ID: <bug-202053-201763-OzVlL9RlNZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202053-201763@https.bugzilla.kernel.org/>
References: <bug-202053-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202053

--- Comment #2 from Zorro Lang (zlang@redhat.com) ---
By enable XFS_DEBUG config option, I get a debug info "ino 28ff data fork has
delalloc extent at [0x160:0x1]":

[ 1298.421477] run fstests generic/464 at 2018-12-24 04:53:34
[ 1299.350730] XFS (dm-5): Unmounting Filesystem
[ 1301.357964] XFS (dm-5): Mounting V5 Filesystem
[ 1301.453602] XFS (dm-5): Ending clean mount
[ 1308.233740] XFS (dm-5): Unmounting Filesystem
[ 1308.921723] XFS (dm-5): Mounting V5 Filesystem
[ 1308.990435] XFS (dm-5): Ending clean mount
[ 1315.521677] XFS (dm-5): ino 28ff data fork has delalloc extent at
[0x160:0x1]
[ 1315.529686] XFS: Assertion failed: 0, file: fs/xfs/xfs_super.c, line: 985
[ 1315.537563] WARNING: CPU: 12 PID: 16993 at fs/xfs/xfs_message.c:104
assfail+0x54/0x57 [xfs]

I'll upload the metadump file which match this debug info later.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
