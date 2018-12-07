Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46756 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbeLGRHQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Dec 2018 12:07:16 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DE9462ECC1
        for <linux-xfs@vger.kernel.org>; Fri,  7 Dec 2018 17:07:15 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201577] [xfstests generic/070]: XFS corruption and Oops when
 setxattr on 64k blocksize XFS
Date: Fri, 07 Dec 2018 17:07:15 +0000
Message-ID: <bug-201577-201763-Rh7Cf4mEYP@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201577-201763@https.bugzilla.kernel.org/>
References: <bug-201577-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201577

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@sandeen.net

--- Comment #3 from Eric Sandeen (sandeen@sandeen.net) ---
Dave's patch 

[PATCH] xfs: fix overflow in xfs_attr3_leaf_verify

should fix the verifier failure but I think the OOPS is a separate problem that
still needs to be addressed.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
