Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50038 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726041AbeHQIgb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Aug 2018 04:36:31 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id EB5452B24F
        for <linux-xfs@vger.kernel.org>; Fri, 17 Aug 2018 05:34:31 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200835] XFS hangs in xfs_reclaim_inode()
Date: Fri, 17 Aug 2018 05:34:32 +0000
Message-ID: <bug-200835-201763-bRqpXHe3uq@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200835-201763@https.bugzilla.kernel.org/>
References: <bug-200835-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200835

--- Comment #4 from Peter Klotz (peter.klotz99@gmail.com) ---
Created attachment 277905
  --> https://bugzilla.kernel.org/attachment.cgi?id=277905&action=edit
journald output leading to the 4.14.62 hang

The output covers everything from booting the server to the XFS backtraces.

The delete_backups.sh script is called 3 minutes before the server is stuck.
There was no other activity on the server.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
