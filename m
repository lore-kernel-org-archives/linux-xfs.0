Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51692 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727958AbeJFAJS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 20:09:18 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1EE9229A8D
        for <linux-xfs@vger.kernel.org>; Fri,  5 Oct 2018 17:09:40 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201331] deadlock (XFS?)
Date: Fri, 05 Oct 2018 17:09:39 +0000
Message-ID: <bug-201331-201763-hVNMHGhjxC@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201331-201763@https.bugzilla.kernel.org/>
References: <bug-201331-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201331

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@sandeen.net
           Assignee|filesystem_xfs@kernel-bugs. |io_md@kernel-bugs.osdl.org
                   |kernel.org                  |

--- Comment #11 from Eric Sandeen (sandeen@sandeen.net) ---
One thing that's kind of weird is this:

[ 1679.494859] md: md2: resync done.
[ 5679.900329] INFO: task tar:18235 blocked for more than 120 seconds.

almost exactly 4000 seconds?  Maybe a coincidence.

The messages from md's bitmap_startwrite is almost the same timestamp, too:

[ 5679.904044] INFO: task kworker/u24:3:18307 blocked for more than 120
seconds.

md is scheduled out here:

                if (unlikely(COUNTER(*bmc) == COUNTER_MAX)) {
                        DEFINE_WAIT(__wait);
                        /* note that it is safe to do the prepare_to_wait
                         * after the test as long as we do it before dropping
                         * the spinlock.
                         */
                        prepare_to_wait(&bitmap->overflow_wait, &__wait,
                                        TASK_UNINTERRUPTIBLE);
                        spin_unlock_irq(&bitmap->counts.lock);
                        schedule();
                        finish_wait(&bitmap->overflow_wait, &__wait);
                        continue;
                }

So md is waiting to be woken up when the bitmap writer finishes.  Details
aside, I really do think that xfs is the victim/messenger here; we should at
least try to get some md eyes on this one as well.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
