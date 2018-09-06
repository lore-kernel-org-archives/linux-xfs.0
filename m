Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50796 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725880AbeIFKNA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Sep 2018 06:13:00 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 6AF392A370
        for <linux-xfs@vger.kernel.org>; Thu,  6 Sep 2018 05:39:17 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200981] hypervisor fs hangs at heavy write activity on VM (kvm,
 qcow2 image) having a reflink disk copy
Date: Thu, 06 Sep 2018 05:39:18 +0000
Message-ID: <bug-200981-201763-rdwlaZA2Wd@https.bugzilla.kernel.org/>
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

--- Comment #7 from Alexander Y.  Fomichev (git.user@gmail.com) ---
Ok, it looks like a warning is a result of missing sb_end_intwrite in
xfs_reflink_allocate_cow, namely in a sequence xfs_trans_alloc -> goto retry ->
goto convert. With proof-of-concept patch (attached) warning is gone but
deadlock is not. Though now I have a list of held locks (dmesg attached).
Did you mean taintad kernel  will not show locks held?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
