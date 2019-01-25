Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43562 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726878AbfAYJzd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Jan 2019 04:55:33 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id E85DB2E85D
        for <linux-xfs@vger.kernel.org>; Fri, 25 Jan 2019 09:55:32 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202349] Extreme desktop freezes during sustained write
 operations with XFS
Date: Fri, 25 Jan 2019 09:55:30 +0000
Message-ID: <bug-202349-201763-w4cTyERu7i@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202349-201763@https.bugzilla.kernel.org/>
References: <bug-202349-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202349

Lucas Stach (dev@lynxeye.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dev@lynxeye.de

--- Comment #8 from Lucas Stach (dev@lynxeye.de) ---
So with my GPU developer hat on: What is it that the GPU driver devs should do
to avoid this?
GPU tasks aren't per-se realtime or interactive (think GPU compute tasks with
big working sets, that can take hours or even days to complete). So from the
driver perspective we _want_ FS reclaim to happen instead of failing a task,
but in general for the interactive workload we would rather trash the working
set a bit (by purging clean caches) instead of doing a high latency writeback
of dirty caches.

Also to put the obvious question up again: Why doesn't the reporter see any of
those catastrophic latency events with ext4? It it just that XFS can queue up
way more IO and thus direct reclaim getting stuck behind the already scheduled
IO for a way longer time?

If I understand the problem right, the basic issue is that we still don't have
have IO less dirty throttling in Linux, so we make the interactive GPU process
pay part of the bill of the background process dirtying lots of pages, instead
of throttling this one earlier.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
