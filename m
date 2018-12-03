Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39644 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725980AbeLCWQq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 17:16:46 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 823A02AFCF
        for <linux-xfs@vger.kernel.org>; Mon,  3 Dec 2018 22:16:45 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201823] inconsistent behaviour of xfs_db, xfs_repair and
 xfs_scrub
Date: Mon, 03 Dec 2018 22:16:45 +0000
Message-ID: <bug-201823-201763-OOZd9o6NdX@https.bugzilla.kernel.org/>
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

--- Comment #8 from Eric Sandeen (sandeen@sandeen.net) ---
I think this is probably just a bug in the frag command, and not indicative of
actual filesystem corruption.  Another reason to kill off the worthless frag()
command.  ;)

I think the bug is probably in sparse inode chunk handling.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
