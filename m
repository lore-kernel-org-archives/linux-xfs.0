Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58696 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726865AbeJEGKf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 02:10:35 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id CF358293AE
        for <linux-xfs@vger.kernel.org>; Thu,  4 Oct 2018 23:14:51 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201331] New: deadlock (XFS?)
Date: Thu, 04 Oct 2018 23:14:51 +0000
Message-ID: <bug-201331-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201331

            Bug ID: 201331
           Summary: deadlock (XFS?)
           Product: File System
           Version: 2.5
    Kernel Version: 4.18.12
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: edo.rus@gmail.com
        Regression: No

Created attachment 278927
  --> https://bugzilla.kernel.org/attachment.cgi?id=278927&action=edit
dmesg output

I've set up new server with ten of 10Tb disks.
Main volume is XFS over RAID6 (created with mdadm).

For now fs is filling with data. After several hours of uptime disk IO freezes
with such messages in log:
[ 5679.900329] INFO: task tar:18235 blocked for more than 120 seconds.
[ 5679.900404]       Not tainted 4.18.12 #2
...
[ 5679.904044] INFO: task kworker/u24:3:18307 blocked for more than 120
seconds.
[ 5679.904137]       Not tainted 4.18.12 #2
and so on.

I'm unsure, but it seems to be XFS-related.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
