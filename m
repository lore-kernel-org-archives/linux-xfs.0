Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52072 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726575AbfAUTEU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jan 2019 14:04:20 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id E15D52A910
        for <linux-xfs@vger.kernel.org>; Mon, 21 Jan 2019 19:04:19 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202349] Extreme desktop freezes during sustained write
 operations with XFS
Date: Mon, 21 Jan 2019 19:04:17 +0000
Message-ID: <bug-202349-201763-kwF0QpfsoP@https.bugzilla.kernel.org/>
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

Chris Murphy (bugzilla@colorremedies.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bugzilla@colorremedies.com

--- Comment #5 from Chris Murphy (bugzilla@colorremedies.com) ---
My suggestion is enable sysrq, and then type out the trigger line in a shell in
advance without pressing return; and then hit return once the hang happens. It
almost certainly will get through to the kernel even if the command doesn't
return until after the system recovers. It might be more reliable to do this
over ssh than through the desktop environment's terminal.

If you're running systemd, you can extract the full dmesg using 'journalctl -k
> kernel.log' without systemd you may need to reboot with boot param
log_buf_len=1M  and issue 'dmesg -n 8'before reproducing.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
