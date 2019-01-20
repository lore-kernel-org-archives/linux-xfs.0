Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58356 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726750AbfAUH2u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jan 2019 02:28:50 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F341C29C73
        for <linux-xfs@vger.kernel.org>; Sun, 20 Jan 2019 21:59:24 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202349] Extreme desktop freezes during sustained write
 operations with XFS
Date: Sun, 20 Jan 2019 21:59:13 +0000
Message-ID: <bug-202349-201763-y3lCIfrrOr@https.bugzilla.kernel.org/>
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

Dave Chinner (david@fromorbit.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |david@fromorbit.com

--- Comment #3 from Dave Chinner (david@fromorbit.com) ---
Output of 'echo w > /proc/sysrq-trigger' when the system is having freeze
problems, please, as well as `iostat -dxm 5` over a period of minutes leading
up to the freeze and after the freeze ends.

-Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
