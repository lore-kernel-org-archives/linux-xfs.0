Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43614 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725818AbfGIEaM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 00:30:12 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 04F1128650
        for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2019 04:30:12 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 203947] [xfstests generic/475]: general protection fault: 0000
 [#1] RIP: 0010:xfs_setfilesize_ioend+0xb1/0x220 [xfs]
Date: Tue, 09 Jul 2019 04:30:11 +0000
Message-ID: <bug-203947-201763-c0RSRdU5IW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203947-201763@https.bugzilla.kernel.org/>
References: <bug-203947-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203947

--- Comment #11 from Zorro Lang (zlang@redhat.com) ---
(In reply to Zorro Lang from comment #10)
> (In reply to Darrick J. Wong from comment #9)
> > Zorro,
> > 
> > If you get a chance, can you try this debugging patch, please?
> 
> Sure, I'll give it a try. With this bug together ... they both triggered by
> g/475. You really write a nice case :)
> 
> Both these two bugs are too hard to reproduce, so I only can try my best to
> test it, but I can't 100% verify they're fixed even if all test pass, I'll
> try to approach 99% :-P
> 
> BTW, if this's a separate bug, I'd like to report a new bug to track it, to
> avoid confusion.
> 
> Thanks,
> Zorro

Updata: By merging the patches in comment 2 and comment 9, I can't reproduce
this bug and https://bugzilla.kernel.org/show_bug.cgi?id=204031, after running
generic/475 on six different machines 3 days.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
