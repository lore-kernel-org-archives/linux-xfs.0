Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53106 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726044AbeIAJL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Sep 2018 05:11:56 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 67DB32B830
        for <linux-xfs@vger.kernel.org>; Sat,  1 Sep 2018 05:01:17 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200981] hypervisor fs hangs at heavy write activity on VM (kvm,
 qcow2 image) having a reflink disk copy
Date: Sat, 01 Sep 2018 05:01:17 +0000
Message-ID: <bug-200981-201763-w6n8naznxI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200981-201763@https.bugzilla.kernel.org/>
References: <bug-200981-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200981

Dave Chinner (david@fromorbit.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |david@fromorbit.com

--- Comment #4 from Dave Chinner (david@fromorbit.com) ---
Ok, so the obvious fix doesn't help.

Any idea why lockdep is not giving you the full stack trace of where the lock
that was leaked to userspace was first accessed? Without that, we have no idea
which of the 70-odd calls to xfs_trans_alloc() in the XFS code the lockdep
warning refers to. At minimum, we need to know what syscall is triggering the
warning so we know what code to look at.

Also, can you reproduce this on older kernels? If not, could you bisect it?

-Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
