Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59530 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966368AbeFSRKr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 13:10:47 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0841628CBA
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jun 2018 17:10:47 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200137] [xfstests generic/485] XFS: Assertion failed:
 (irec->br_startoff & ~XFS_IEXT_STARTOFF_MASK) == 0, file:
 fs/xfs/libxfs/xfs_iext_tree.c, line: 68
Date: Tue, 19 Jun 2018 17:10:46 +0000
Message-ID: <bug-200137-201763-IXkMzzvQGa@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200137-201763@https.bugzilla.kernel.org/>
References: <bug-200137-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200137

--- Comment #1 from Darrick J. Wong (djwong+kernel@djwong.org) ---
Created attachment 276691
  --> https://bugzilla.kernel.org/attachment.cgi?id=276691&action=edit
proposed fix

Zoro: does the attached patch fix the problem?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.