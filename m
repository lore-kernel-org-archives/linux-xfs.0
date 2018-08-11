Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44652 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727043AbeHKDYC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Aug 2018 23:24:02 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 998272B3AC
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 00:51:48 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200047] slab-out-of-bounds in xlog_recover_do_reg_buffer() when
 mounting a crafted xfs image
Date: Sat, 11 Aug 2018 00:51:49 +0000
Message-ID: <bug-200047-201763-1rTnVE8hM2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200047-201763@https.bugzilla.kernel.org/>
References: <bug-200047-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200047

Darrick J. Wong (djwong+kernel@djwong.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |djwong+kernel@djwong.org

--- Comment #1 from Darrick J. Wong (djwong+kernel@djwong.org) ---
(Does this still reproduce on 4.18-rc8 + for-next?  I couldn't get it to...)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
