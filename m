Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:57202 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727178AbeHaLp6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Aug 2018 07:45:58 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 196562B22A
        for <linux-xfs@vger.kernel.org>; Fri, 31 Aug 2018 07:39:51 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200981] hypervisor fs hangs at heavy write activity on VM (kvm,
 qcow2 image) having a reflink disk copy
Date: Fri, 31 Aug 2018 07:39:52 +0000
Message-ID: <bug-200981-201763-R5Am4BtTwG@https.bugzilla.kernel.org/>
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

--- Comment #3 from Alexander Y.  Fomichev (git.user@gmail.com) ---
> Can you see if commit dcbd44f79986 ("xfs: fix transaction leak on
remote attr set/remove failure") addresses the problem you are
seeing?

I've just tried but see no difference.
Warning still here and vm become blocked some time after.
( It worth noting I've CONFIG_LOCKDEP turned on )

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
