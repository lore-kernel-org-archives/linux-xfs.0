Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50214 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727488AbfA2VTz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Jan 2019 16:19:55 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 726D72D2EA
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jan 2019 21:19:54 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202441] Possibly vfs cache related replicable xfs regression
 since 4.19.0  on sata hdd:s
Date: Tue, 29 Jan 2019 21:19:52 +0000
Message-ID: <bug-202441-201763-GRtP2T87ne@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202441-201763@https.bugzilla.kernel.org/>
References: <bug-202441-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202441

--- Comment #13 from Roger (rogan6710@gmail.com) ---
Considering that rc8 which I believe was released as 4.19.0 did not show any
problems on my 24G machine I must have managed to get a false positive on
4.19.0. The machine I tested that on has less ram (8G) but I don't know if that
matters.

Anyhow, after a filthy amount of copying and compiling I can say that
something probably went wrong between 4.19.2, which is ok, and 4.19.3
which is not, at least on this 9590. 

I downloaded, compiled, and tested all rc versions, 4.19.{2,3,5,9} and verified
that 4.19.{3,5,9,18} all have the problems described above on the 9590.
All tests were done in console (nomodeset) directly after boot.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
