Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53132 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729546AbfA2WTY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Jan 2019 17:19:24 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 627FC2D3B8
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jan 2019 22:19:23 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202441] Possibly vfs cache related replicable xfs regression
 since 4.19.0  on sata hdd:s
Date: Tue, 29 Jan 2019 22:19:22 +0000
Message-ID: <bug-202441-201763-fT1IgXJDCq@https.bugzilla.kernel.org/>
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

Dave Chinner (david@fromorbit.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |david@fromorbit.com

--- Comment #18 from Dave Chinner (david@fromorbit.com) ---
(In reply to Roger from comment #17)
> I suspected that commit as well...
> I would love to try that revert. I have never done one so I'm not sure how
> to go about it. I'll have to read up a little.
> Do I revert in 4.19.3 or the latest ?

Reverting in 4.19.3 and testing that would be ideal, though it would 
probably revert just fine in the lastest tree. If yuive been         
building from a git tree, then:                                      

$ git revert 5ebac3b957a9                                            

and rebuild is all you need to do (assuming it cleanly reverts).                

If you've been building from a downloaded tarball, then you'll need to apply
the revert yourself. I'll attach a revert patch, which you can apply via:

$ patch -p1 < revert.patch

and rebuild the kernel (assuming it applies cleanly - use --dry-run to test).

Or you can just manually change the code in an editor to set the code back to
the original. i.e:

        /* recently referenced inodes get one more pass */
        if (inode->i_state & I_REFERENCED) {

-Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
