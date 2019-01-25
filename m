Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51306 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725909AbfAYMur (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Jan 2019 07:50:47 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 847D02F4C5
        for <linux-xfs@vger.kernel.org>; Fri, 25 Jan 2019 12:50:46 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202349] Extreme desktop freezes during sustained write
 operations with XFS
Date: Fri, 25 Jan 2019 12:50:45 +0000
Message-ID: <bug-202349-201763-7sdZmgHAKO@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202349-201763@https.bugzilla.kernel.org/>
References: <bug-202349-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202349

--- Comment #9 from nfxjfg@googlemail.com ---
On the kernel which I ran the tests:

# zcat /proc/config.gz |grep WBT
CONFIG_BLK_WBT=y
# CONFIG_BLK_WBT_SQ is not set
CONFIG_BLK_WBT_MQ=y


I can't reproduce any of this when running the same test script on an ext4
formatted disk under the same circumstances (different disk, but comparable
speed).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
