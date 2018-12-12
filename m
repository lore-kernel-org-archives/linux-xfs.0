Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43650 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727681AbeLLPcB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Dec 2018 10:32:01 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2A5582AB61
        for <linux-xfs@vger.kernel.org>; Wed, 12 Dec 2018 15:32:00 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201973] File Size
Date: Wed, 12 Dec 2018 15:31:59 +0000
Message-ID: <bug-201973-201763-Quz2hz9ryF@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201973-201763@https.bugzilla.kernel.org/>
References: <bug-201973-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201973

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |sandeen@sandeen.net
         Resolution|---                         |INVALID

--- Comment #1 from Eric Sandeen (sandeen@sandeen.net) ---
Hi, this is the upstream kernel bug tracker, and 3.10.0-862.el7.x86_64 is not
an upstream kernel.  This is not the appropriate bug tracker for distribution
kernels.

Also, you've not provided any reproducer steps, just a screenshot of du & ls
which shows no problem.

There is no expectation that du should match ls.  One reflects the maximum
offset in a file, the other reflects the amount of space allocated to the file.
 They are two different quantities.  Observe:

# fallocate -l 161m output.out
# truncate --size 18g output.out

# du -h output.out
161M    output.out

# ls -lh output.out
-rw-r--r--. 1 root root 18G Dec 12 10:30 output.out

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
