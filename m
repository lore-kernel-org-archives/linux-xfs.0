Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40988 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727040AbeJRJtb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Oct 2018 05:49:31 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 62243287A2
        for <linux-xfs@vger.kernel.org>; Thu, 18 Oct 2018 01:50:59 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201453] Bug 1640090 - [xfstests xfs/490]: xfs_db print a bad
 (negative number) as agi freecount
Date: Thu, 18 Oct 2018 01:50:58 +0000
Message-ID: <bug-201453-201763-AJnFFkMzC4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201453-201763@https.bugzilla.kernel.org/>
References: <bug-201453-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201453

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@sandeen.net

--- Comment #3 from Eric Sandeen (sandeen@sandeen.net) ---
Yep, does this fix it?

diff --git a/db/btblock.c b/db/btblock.c
index cbd2990..5a5b061 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -513,7 +513,7 @@ const field_t       inobt_sprec_flds[] = {
        { "holemask", FLDT_UINT16X, OI(ROFF(ir_u.sp.ir_holemask)), C1, 0,
          TYP_NONE },
        { "count", FLDT_UINT8D, OI(ROFF(ir_u.sp.ir_count)), C1, 0, TYP_NONE },
-       { "freecount", FLDT_INT8D, OI(ROFF(ir_u.sp.ir_freecount)), C1, 0,
+       { "freecount", FLDT_UINT8D, OI(ROFF(ir_u.sp.ir_freecount)), C1, 0,
          TYP_NONE },
        { "free", FLDT_INOFREE, OI(ROFF(ir_free)), C1, 0, TYP_NONE },
        { NULL }

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
