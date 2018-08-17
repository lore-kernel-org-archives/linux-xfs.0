Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41870 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726134AbeHQO7H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Aug 2018 10:59:07 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4ABE22B3B1
        for <linux-xfs@vger.kernel.org>; Fri, 17 Aug 2018 11:55:57 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200835] XFS hangs in xfs_reclaim_inode()
Date: Fri, 17 Aug 2018 11:55:58 +0000
Message-ID: <bug-200835-201763-8HtmS6iRub@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200835-201763@https.bugzilla.kernel.org/>
References: <bug-200835-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200835

--- Comment #6 from Peter Klotz (peter.klotz99@gmail.com) ---
Hello Dave

You are right! Both XFS filesystems are on top of dm-crypt:

 * 30TB: XFS/dm-crypt/dm-raid
 *  4TB: XFS/dm-crypt

So everytime a hang occurred, dm-crypt was definitely involved.

Do you know any dm-crypt developers that could be CCed so that the
investigation can continue? Or should I change Product/Component of the bug?

Regards, Peter.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
