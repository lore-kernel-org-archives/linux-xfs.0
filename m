Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56056 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726846AbfA2X2i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Jan 2019 18:28:38 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 803742DAB3
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jan 2019 23:28:37 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202441] Possibly vfs cache related replicable xfs regression
 since 4.19.0  on sata hdd:s
Date: Tue, 29 Jan 2019 23:28:36 +0000
Message-ID: <bug-202441-201763-2Sz6laj99E@https.bugzilla.kernel.org/>
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

--- Comment #22 from Dave Chinner (david@fromorbit.com) ---
On Tue, Jan 29, 2019 at 11:03:21PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=202441
> 
> --- Comment #21 from Roger (rogan6710@gmail.com) ---
> Worked very well :) (compile took 3min 31s) 
> I saw the same behaviour as I first noticed on rc5, sawtoothing buff/cache.

Ok, thanks for confirming. I doubt there's going to be a fast fix
for this, though, but we'll see how it goes.

Cheers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
