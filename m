Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55758 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726462AbfA3R60 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jan 2019 12:58:26 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 590B62FCC0
        for <linux-xfs@vger.kernel.org>; Wed, 30 Jan 2019 17:58:25 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202349] Extreme desktop freezes during sustained write
 operations with XFS
Date: Wed, 30 Jan 2019 17:58:23 +0000
Message-ID: <bug-202349-201763-1G0jYV87bS@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202349-201763@https.bugzilla.kernel.org/>
References: <bug-202349-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202349

--- Comment #11 from nfxjfg@googlemail.com ---
I also have to note that I found it impossible to reproduce the issue using the
test script on some other hard disks. It must depend a lot on the work load and
the speed/size of the disk, or other unknown circumstances. This also means
that my comment about ext4 might be misleading, although I definitely confirmed
that my problem went away when I reformatted yet another disk from xfs to ext4.

Dave Chinner: would a 4.18.20 kernel also do? (I still have that on my disk.)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
