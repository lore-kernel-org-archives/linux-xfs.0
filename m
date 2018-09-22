Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49596 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725756AbeIVH05 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Sep 2018 03:26:57 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F217F2D9FE
        for <linux-xfs@vger.kernel.org>; Sat, 22 Sep 2018 01:35:25 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201173] [xfstests xfs/137]: xfs_repair hang when it trying to
 repair a 500t xfs
Date: Sat, 22 Sep 2018 01:35:25 +0000
Message-ID: <bug-201173-201763-obG255pYHJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201173-201763@https.bugzilla.kernel.org/>
References: <bug-201173-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201173

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@sandeen.net
           Assignee|filesystem_xfs@kernel-bugs. |sandeen@sandeen.net
                   |kernel.org                  |

--- Comment #1 from Eric Sandeen (sandeen@sandeen.net) ---
Several hours of debugging later, a simple patch seems to fix this:

diff --git a/repair/prefetch.c b/repair/prefetch.c
index 9571b24..c9a0748 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -768,8 +768,11 @@ pf_queuing_worker(
                         * might get stuck on a buffer that has been locked
                         * and added to the I/O queue but is waiting for
                         * the thread to be woken.
+                        * Start processing as well, in case everything so
+                        * far was already prefetched and the queue is empty.
                         */
                        pf_start_io_workers(args);
+                       pf_start_processing(args);
                        sem_wait(&args->ra_count);
                }


but it still feels like a slightly odd fix, will give it more thought.  The
problem is that if every buffer we tried to read ahead in phase6 was already up
to date, pf_start_io_workers has no effect; there is no io to do, and the
sem_wait waits forever.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
