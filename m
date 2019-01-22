Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39796 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725950AbfAVRso (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jan 2019 12:48:44 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 39D192B83D
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jan 2019 17:48:44 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Tue, 22 Jan 2019 17:48:43 +0000
Message-ID: <bug-202127-201763-65AvcGshga@https.bugzilla.kernel.org/>
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

--- Comment #30 from Eric Sandeen (sandeen@sandeen.net) ---
Or, actually - I'm not sure if this is an option for you, but mounting with new
and /correct/ sunit/swidth values on the older kernel should rewrite them on
disk, and make them pass muster with the new kernel.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
