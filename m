Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34838 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726041AbfACVN5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 16:13:57 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 13153201CB
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jan 2019 21:13:57 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Thu, 03 Jan 2019 21:13:57 +0000
Message-ID: <bug-202127-201763-rHHEIqE3ar@https.bugzilla.kernel.org/>
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

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@sandeen.net

--- Comment #2 from Eric Sandeen (sandeen@sandeen.net) ---
>          =                       sunit=256    swidth=64 blks

It's very strange to have automatically arrived at an impossible geometry with
swidth < sunit.

Can you provide the output of:

# blockdev --getsz  --getsize64 --getss --getpbsz  --getiomin   --getioopt
/dev/sda

please?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
