Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33826 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727019AbeI3JcA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Sep 2018 05:32:00 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4F3BD296B7
        for <linux-xfs@vger.kernel.org>; Sun, 30 Sep 2018 03:00:54 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201287] xfsprogs 4.17 and later can't be built as static
 binaries anymore
Date: Sun, 30 Sep 2018 03:00:54 +0000
Message-ID: <bug-201287-201763-JAifPmGprl@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201287-201763@https.bugzilla.kernel.org/>
References: <bug-201287-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201287

Dave Chinner (david@fromorbit.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |david@fromorbit.com

--- Comment #6 from Dave Chinner (david@fromorbit.com) ---
So the distro build env modifies the xfsprogs build flags to add something
upstream doesn't support, right? And that distro hack doesn't work anymore,
yes?

If so, this is a distro package build problem, not an upstream issue. If the
distro package maintainers want the upstream source tree to support static
builds as the distro requires, then please send patches to support this
functionality directly out of the upstream tree to linux-xfs@vger.kernel.org.

-Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
