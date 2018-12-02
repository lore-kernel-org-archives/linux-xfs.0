Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55562 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725379AbeLBRCt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Dec 2018 12:02:49 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 332872A99F
        for <linux-xfs@vger.kernel.org>; Sun,  2 Dec 2018 17:02:47 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201823] inconsistent behaviour of xfs_db, xfs_repair and
 xfs_scrub
Date: Sun, 02 Dec 2018 17:02:47 +0000
Message-ID: <bug-201823-201763-SQxbGgt1ty@https.bugzilla.kernel.org/>
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

--- Comment #5 from Eric Sandeen (sandeen@sandeen.net) ---
If you'd like to send me a compressed metadump image (offline for maximum
privacy) I'll take a look.

However, some of your messages above are a result user error: you are providing
a block number as an inode number to xfs_db, so it is trying to parse a
non-inode as an inode.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
