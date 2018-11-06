Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52876 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727464AbeKFMhB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Nov 2018 07:37:01 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 396822A20A
        for <linux-xfs@vger.kernel.org>; Tue,  6 Nov 2018 03:14:01 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201259] [xfstests shared/010]: maybe pagecache contents is
 mutated after cycle mount
Date: Tue, 06 Nov 2018 03:14:01 +0000
Message-ID: <bug-201259-201763-QsgJPUzbx3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201259-201763@https.bugzilla.kernel.org/>
References: <bug-201259-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201259

--- Comment #9 from Zorro Lang (zlang@redhat.com) ---
(In reply to Eric Sandeen from comment #8)
> Zorro, I see that your new report is using a smaller blocksize (-b 1024) -
> was that used in the initial report?

No, smaller blocksize is not necessary (I just forgot remove that line after
another testing:). Both 1024 or 4096 blocksize can reproduce this bug.

Thanks,
Zorro

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
