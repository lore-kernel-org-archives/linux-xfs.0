Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:35154 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728598AbeJBUiE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 16:38:04 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id EB08D20453
        for <linux-xfs@vger.kernel.org>; Tue,  2 Oct 2018 13:54:34 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201259] [xfstests shared/010]: maybe pagecache contents is
 mutated after cycle mount
Date: Tue, 02 Oct 2018 13:54:35 +0000
Message-ID: <bug-201259-201763-3gh3WEp9dS@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201259-201763@https.bugzilla.kernel.org/>
References: <bug-201259-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201259

--- Comment #2 from Eric Sandeen (sandeen@sandeen.net) ---
Hrm sorry about the wrap.  Also:

> There also seems to be a reflinked extent prior to the pwrite.

That should say "there is an fallocated extent prior to the pwrite"

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
