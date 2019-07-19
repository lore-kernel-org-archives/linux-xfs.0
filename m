Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59482 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726055AbfGSD0l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 23:26:41 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 39370288C6
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jul 2019 03:26:40 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 204223] [fstests generic/388 on xfs]: 4.19.58 xfs_nocrc /
 xfs_reflink null pointer dereference at xfs_trans_brelse+0x21
Date: Fri, 19 Jul 2019 03:26:39 +0000
Message-ID: <bug-204223-201763-BdHEDLNNmz@https.bugzilla.kernel.org/>
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

--- Comment #5 from Luis Chamberlain (mcgrof@kernel.org) ---
(In reply to Luis Chamberlain from comment #0)
> [129135.499383] BUG: unable to handle kernel NULL pointer dereference at

<-- snip -->

> [129135.507540] RIP: 0010:xfs_trans_brelse+0x21/0xd0 [xfs]

Reproduced with the "xfs_reflink_normapbt" configuration and can confirm an
immediate panic on vanilla 4.19.20 with the same trace as above.

-- 
You are receiving this mail because:
You are watching someone on the CC list of the bug.
