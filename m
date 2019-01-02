Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33186 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728720AbfABQyz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jan 2019 11:54:55 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C376528C31
        for <linux-xfs@vger.kernel.org>; Wed,  2 Jan 2019 16:54:54 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202077] xfs transaction log reservation overruns on 4.14.67
Date: Wed, 02 Jan 2019 16:54:54 +0000
Message-ID: <bug-202077-201763-oDz2FZ5t5Y@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202077-201763@https.bugzilla.kernel.org/>
References: <bug-202077-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202077

--- Comment #3 from Thomas Walker (thomas.walker@twosigma.com) ---
Thanks for the response.  That first patchset does appear to apply cleanly
(with a little fuzz) to 4.14 but, as you say, I don't know offhand how mature
the code it depends upon is in 4.14 and without a reliable reproducer it will
be hard to say whether it even addresses my issue.  I'll keep seeing if I can
reproduce the problem more consistently and see...

While I'm running 4.19 on a few test systems, I've been taking a wait-and-see
approach towards broader usage given the number of regressions that have
cropped up (and been fixed) thus far.  Good to know that this is likely
addressed there though.

Thanks,
Tom.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
