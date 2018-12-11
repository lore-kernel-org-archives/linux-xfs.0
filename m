Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34524 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727485AbeLKCGA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Dec 2018 21:06:00 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 47AA02A88C
        for <linux-xfs@vger.kernel.org>; Tue, 11 Dec 2018 02:05:59 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201939] There is no 'no space' message when using xfs with nfs.
Date: Tue, 11 Dec 2018 02:05:59 +0000
Message-ID: <bug-201939-201763-KpTMMm8fgY@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201939-201763@https.bugzilla.kernel.org/>
References: <bug-201939-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201939

--- Comment #3 from gbkwon@gmail.com ---
Thanks for your reply.


The same problem does not occur in 3.18 kernels.

Unfortunately, I have must to use 3.4 kernel.

If I add 'noac' to the nfs mount option, there is no such problem.

However, the 'noac' option causes a performance penalty of more than 50%.

I want to fix the problem without adding the 'noac' option.

If I add the 'actimeo=0' option to the nfs mount option, the problem happens,
but after about 5 minutes the problem disappears.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
