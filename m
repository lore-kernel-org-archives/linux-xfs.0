Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40226 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729131AbeIFTBq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Sep 2018 15:01:46 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 15FF32A916
        for <linux-xfs@vger.kernel.org>; Thu,  6 Sep 2018 14:25:59 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200981] hypervisor fs hangs at heavy write activity on VM (kvm,
 qcow2 image) having a reflink disk copy
Date: Thu, 06 Sep 2018 14:25:59 +0000
Message-ID: <bug-200981-201763-heu6MHcjjj@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200981-201763@https.bugzilla.kernel.org/>
References: <bug-200981-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200981

--- Comment #8 from Dave Chinner (david@fromorbit.com) ---
(In reply to Alexander Y.  Fomichev from comment #7)
> Ok, it looks like a warning is a result of missing y in
> xfs_reflink_allocate_cow, namely in a sequence xfs_trans_alloc -> goto retry
> -> goto convert.

Yup, I see the issue. Nice work finding this!

> With proof-of-concept patch (attached) warning is gone but
> deadlock is not.

The code is not missing a sb_end_intwrite() call - it's missing a
xfs_trans_cancel() call. That's why it still deadlocks even though you shut up
the warning. I'll have a closer look in the morning to see if there's any other
paths that can leak the transaction and write a patch to fix it.

Thanks again for tracking it down, Alexander :)

Cheers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
