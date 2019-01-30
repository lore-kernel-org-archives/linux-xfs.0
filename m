Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:35286 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726548AbfA3KuN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jan 2019 05:50:13 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4D3132E762
        for <linux-xfs@vger.kernel.org>; Wed, 30 Jan 2019 10:50:13 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202441] Possibly vfs cache related replicable xfs regression
 since 4.19.0  on sata hdd:s
Date: Wed, 30 Jan 2019 10:50:12 +0000
Message-ID: <bug-202441-201763-yQ5YCatYVh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202441-201763@https.bugzilla.kernel.org/>
References: <bug-202441-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202441

--- Comment #24 from Roger (rogan6710@gmail.com) ---
A few moments ago, a piece of the puzzle fell into place.

The problem persists. All this revert did, was to make the issue granularity
dependent from what I gather. While redoing the test with all those source
trees I used to compile the kernels, the same exact problem came back.

The earlier tests were done using mostly multi GB files.

After some more testing I found out that rc4 is completely problem free in this
regard, but rc5 is definately not, so the real culprit was probably introduced
in rc5. 

After applying our inode.c revert on 4.19.18, it shows the same behaviour as
rc5. I can test on intermediate versions as well if necessary, as I still have
them all compiled and ready.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
