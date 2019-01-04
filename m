Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54098 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726105AbfADWC6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Jan 2019 17:02:58 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4D359287D2
        for <linux-xfs@vger.kernel.org>; Fri,  4 Jan 2019 22:02:58 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Fri, 04 Jan 2019 22:02:58 +0000
Message-ID: <bug-202127-201763-t3oBXdH3w7@https.bugzilla.kernel.org/>
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

--- Comment #16 from Eric Sandeen (sandeen@sandeen.net) ---
Broadcom is simply wrong - ext4 doesn't care about or use the stripe geometry
like xfs does.  But that is beside the point, because:

It is not valid to have a preferred I/O size smaller than the minimum I/O size
- this should be obvious to the vendor.  We can detect this at mkfs time and
error out or ignore the bad values, but there can be no debate about whether
the hardware is returning nonsense.  It /is/ returning nonsense.  That's a
firmware bug.

Pose the question to broadcom:

"How can the preferred IO size be less than the minimum allowable IO size?

Because that's what the hardware it telling us.

-Eric

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
