Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49048 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbeLXKtB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Dec 2018 05:49:01 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A281B28A3B
        for <linux-xfs@vger.kernel.org>; Mon, 24 Dec 2018 10:49:00 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202053] [xfstests generic/464]: XFS corruption and Assertion
 failed: 0, file: fs/xfs/xfs_super.c, line: 985
Date: Mon, 24 Dec 2018 10:49:00 +0000
Message-ID: <bug-202053-201763-QxN2WHavi2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202053-201763@https.bugzilla.kernel.org/>
References: <bug-202053-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202053

--- Comment #4 from Zorro Lang (zlang@redhat.com) ---
I never hit this bug before, just a similar bug which has been fixed one year
ago, by:
commit 40214d128e07dd21bb07a8ed6a7fe2f911281ab2
Author: Brian Foster <bfoster@redhat.com>
Date:   Fri Oct 13 09:47:46 2017 -0700

    xfs: trim writepage mapping to within eof

So I doubt if this's a regression issue?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
