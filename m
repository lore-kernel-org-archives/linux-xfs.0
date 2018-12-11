Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38350 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727485AbeLKCcS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Dec 2018 21:32:18 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4B4762ADE0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Dec 2018 02:32:18 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201939] There is no 'no space' message when using xfs with nfs.
Date: Tue, 11 Dec 2018 02:32:17 +0000
Message-ID: <bug-201939-201763-5DhRoGKjsO@https.bugzilla.kernel.org/>
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

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |sandeen@sandeen.net
         Resolution|---                         |PATCH_ALREADY_AVAILABLE

--- Comment #4 from Eric Sandeen (sandeen@sandeen.net) ---
(In reply to gbkwon from comment #3)
> Thanks for your reply.
> 
> The same problem does not occur in 3.18 kernels.
> 
> Unfortunately, I have must to use 3.4 kernel.

So, it seems you have reported a bug in a 6 year old kernel which has already
been fixed - 4 years ago.  Which means that it's not a bug now.

This is an upstream bug tracker, not a user support forum.  You may wish to ask
your distribution for further support of the old kernel, or possibly try a user
mailing list.  You could also spot-check kernels in between, or do a full
bisect, to look for the commit(s) which fixed the old bug.

But because this issue has apparently already been resolved in upstream
kernels, I'm closing this bug.

Thanks,
-Eric

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
