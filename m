Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49624 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725812AbfGTWtl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Jul 2019 18:49:41 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 00A0D28823
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jul 2019 22:49:40 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 204223] [fstests generic/388 on xfs]: 4.19.58 xfs_nocrc /
 xfs_reflink null pointer dereference at xfs_trans_brelse+0x21
Date: Sat, 20 Jul 2019 22:49:38 +0000
Message-ID: <bug-204223-201763-ZOtqggK0xm@https.bugzilla.kernel.org/>
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

--- Comment #8 from Luis Chamberlain (mcgrof@kernel.org) ---
These commits fix this crash:

xfs: Move fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
xfs: Add helper function xfs_attr_try_sf_addname
xfs: Add attibute set and helper functions
xfs: Add attibute remove and helper functions
xfs: always rejoin held resources during defer roll

I've left generic/388 running over time and it ran up to 247 times
successfully, and failed but at least without a crash in the end.

In particular the last commit has has some fixes to correct bhold callers to
release held buffers correctly merged into the patch, which IMHO should have
been split up into a separate patch.

Trying to extract the exact minor fix is difficult due to the amount of churn
from the prior patches. We'll have to try to do that work somehow or just
consider merging all of these.

-- 
You are receiving this mail because:
You are watching someone on the CC list of the bug.
