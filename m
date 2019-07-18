Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40796 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728054AbfGRUWc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 16:22:32 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5B318288C6
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2019 20:22:31 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 204223] [fstests generic/388 on xfs]: 4.19.58 xfs_nocrc /
 xfs_reflink null pointer dereference at xfs_trans_brelse+0x21
Date: Thu, 18 Jul 2019 20:22:30 +0000
Message-ID: <bug-204223-201763-pS4eUG2bzs@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204223-201763@https.bugzilla.kernel.org/>
References: <bug-204223-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204223

--- Comment #4 from Luis Chamberlain (mcgrof@kernel.org) ---
(In reply to Luis Chamberlain from comment #3)

> kz#204049 reveals upstream is also affected by this bug then.

To be clear, but with a different output, so different issue, and Zorro would
have to test other configurations to see if the same issue creeps up on
upstream with them as well.

-- 
You are receiving this mail because:
You are watching someone on the CC list of the bug.
