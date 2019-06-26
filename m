Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51678 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726239AbfFZWVP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 18:21:15 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id E47C7289D7
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 22:21:14 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 203999] [xfstests xfs/442] kernel BUG at mm/swap_state.c:170!
 RIP: 0010:__delete_from_swap_cache+0x45a/0x6c0
Date: Wed, 26 Jun 2019 22:21:13 +0000
Message-ID: <bug-203999-201763-8B3EHugRuG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203999-201763@https.bugzilla.kernel.org/>
References: <bug-203999-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203999

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@sandeen.net

--- Comment #1 from Eric Sandeen (sandeen@sandeen.net) ---
It seems unlikely that this is an xfs problem.

It's also been reported upstream at https://lkml.org/lkml/2019/5/29/1

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
