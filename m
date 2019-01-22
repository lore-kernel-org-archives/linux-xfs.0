Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39606 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725896AbfAVRsC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jan 2019 12:48:02 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C84502B835
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jan 2019 17:48:01 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Tue, 22 Jan 2019 17:48:01 +0000
Message-ID: <bug-202127-201763-q9s0C7WIFM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202127-201763@https.bugzilla.kernel.org/>
References: <bug-202127-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202127

--- Comment #29 from Eric Sandeen (sandeen@sandeen.net) ---
(In reply to daimh from comment #28)
> The "sunit=256,swidth=64" comes from the output of mkfs.xfs in old kernel.

Yes, that's the root-cause bug causing all this pain.

> I actually tried 'sunit=256,swidth=256', the dmesg error is exactly the same
> as 'noalign'

Ok, we need to sort out a way to efficiently rewrite or remove the geometry
from those old filesystems, then.  It's probably going to involve some xfs_db
surgery.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
