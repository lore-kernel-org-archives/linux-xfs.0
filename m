Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53492 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbeLCWfD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 17:35:03 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 85EC12AE11
        for <linux-xfs@vger.kernel.org>; Mon,  3 Dec 2018 22:35:03 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201823] inconsistent behaviour of xfs_db, xfs_repair and
 xfs_scrub
Date: Mon, 03 Dec 2018 22:35:03 +0000
Message-ID: <bug-201823-201763-O9AaXZPN9i@https.bugzilla.kernel.org/>
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

--- Comment #9 from Eric Sandeen (sandeen@sandeen.net) ---
Yep, that's the case.  We're missing the equivalent of

ea8a48f xfs_check: process sparse inode chunks correctly

for the frag function's version of scanfun_ino.  I'll send a patch to the list,
but in the meantime I think you can relax: this is a bug in the xfs_db frag
command, not filesystem corruption.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
