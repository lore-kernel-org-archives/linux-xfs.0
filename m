Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34274 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389005AbfETPz7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 11:55:59 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3C075288DC
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 15:55:59 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 203653] XFS: Internal error xlog_clear_stale_blocks(2) at line
 1794 of file ../fs/xfs/xfs_log_recover.c
Date: Mon, 20 May 2019 15:55:57 +0000
Message-ID: <bug-203653-201763-SF4zZVyDZB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203653-201763@https.bugzilla.kernel.org/>
References: <bug-203653-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203653

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |sandeen@sandeen.net
         Resolution|---                         |INVALID

--- Comment #2 from Eric Sandeen (sandeen@sandeen.net) ---
Yup, this is a crafted image, with intentional corruption.  XFS is simply (and
verbosely) telling you that it's corrupted.  This is expected behavior.

(I'd prefer NOTABUG to INVALID, but I hope you get my meaning) :)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
