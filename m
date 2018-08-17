Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49868 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725837AbeHQIeL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Aug 2018 04:34:11 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 536092B0A6
        for <linux-xfs@vger.kernel.org>; Fri, 17 Aug 2018 05:32:12 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200835] XFS hangs in xfs_reclaim_inode()
Date: Fri, 17 Aug 2018 05:32:13 +0000
Message-ID: <bug-200835-201763-kGEJGFnAIg@https.bugzilla.kernel.org/>
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

--- Comment #3 from Peter Klotz (peter.klotz99@gmail.com) ---
Hello Dave

Thanks for the reply. I will upload a complete journald leading to one of the
crashes.

It seems the problem now occurs on a daily basis. The trigger is the deletion
of old backups.

I have a directory structure of this kind:

Backups
 Machine1
  Day1
  Day2
  ...
 Machine2
  Day1
  Day2
  ...

The files in the daily directories are hardlinked, so a minimum amount of space
is wasted. However subdirectories still consume inodes, so lots of them are in
use.

[root@hpmicroserver ~]# df -i
Filesystem                Inodes    IUsed      IFree IUse% Mounted on
/dev/mapper/halvar     390701504 12805954  377895550    4% /mnt/halvar
/dev/mapper/faxe      2929890048 24276605 2905613443    1% /mnt/faxe

The only unusual thing I had to configure is "libata.force=noncq" since the
SATA controller had otherwise problems when talking to the SSD.

Any help (maybe a workaround) is appreciated.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
