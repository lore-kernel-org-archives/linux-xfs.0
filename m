Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54062 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726314AbfA2RzC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Jan 2019 12:55:02 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C57412D568
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jan 2019 17:55:01 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202441] Possibly vfs cache related replicable xfs regression
 since 4.19.0  on sata hdd:s
Date: Tue, 29 Jan 2019 17:55:00 +0000
Message-ID: <bug-202441-201763-Av2K1cZ8fw@https.bugzilla.kernel.org/>
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

--- Comment #12 from Roger (rogan6710@gmail.com) ---
Now I have tested all rc versions as well. None of them have the problem.
I'm watching "top" as the compile executes and seeing a _large_ difference
in how the problem free kernel versions handles buff/cache versus the others.

Beginnig from rc5, might have been earlier also, cache get's released,
sometimes almost all of it, and begins to fill up slowly again, while for
instance on 4.19.18 it get's almost completely filled (23.5 of 24 G) and is not
released unless the copying is manually halted.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
