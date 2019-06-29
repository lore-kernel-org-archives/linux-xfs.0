Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47206 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726770AbfF2ORE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Jun 2019 10:17:04 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B29AC287E6
        for <linux-xfs@vger.kernel.org>; Sat, 29 Jun 2019 14:17:03 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 204015] BUG: KASAN: slab-out-of-bounds in
 __bio_add_page+0x1ec/0x2b0
Date: Sat, 29 Jun 2019 14:17:02 +0000
Message-ID: <bug-204015-201763-lkIYczLWoS@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204015-201763@https.bugzilla.kernel.org/>
References: <bug-204015-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204015

--- Comment #2 from Zorro Lang (zlang@redhat.com) ---
(In reply to Darrick J. Wong from comment #1)
> I suspect this is fixed by "xfs: fix iclog allocation size" which will be in
> for-next soon.

Great, I'll verify that after the patch be merged.

-- 
You are receiving this mail because:
You are watching someone on the CC list of the bug.
