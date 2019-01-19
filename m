Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52360 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726642AbfASQus (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Jan 2019 11:50:48 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 689B02C9E1
        for <linux-xfs@vger.kernel.org>; Sat, 19 Jan 2019 16:50:47 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202349] New: Extreme desktop freezes during sustained write
 operations with XFS
Date: Sat, 19 Jan 2019 16:50:46 +0000
Message-ID: <bug-202349-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202349

            Bug ID: 202349
           Summary: Extreme desktop freezes during sustained write
                    operations with XFS
           Product: File System
           Version: 2.5
    Kernel Version: 4,19.16
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: nfxjfg@googlemail.com
        Regression: No

If you keep appending data to a a file on a XFS filesystem, the entire system
will occasionally freeze for up to 4 seconds or so. Then it recovers and
continues for a few minutes, until it happens again. Although the freezes
happen at sort of random times, it's generally highly reproducible.

This is extremely bothersome for desktop use, as _everything_ stops during the
freeze. Even typing text into a terminal. Even processes that don't appear to
do any I/O are frozen (at least not I/O to disks). For example, a python script
that does nothing else than printing a counter to stdout (running in a X11
terminal emulator) will stop. Everything is completely in memory; the system
disk is on a SSD anyway.

In general, the desktop becomes completely unusable garbage, which in turn
makes XFS unsuitable for desktop operation until this is fixed.

Reproduction is simple enough: if I copy multiple large files (dozens of files
with about 500-5000 MB per file) with rsync from one disk to another (both hard
disks using XFS filesystems), the freezes will happen at least every few
minutes.

Someone else observed something similar independently just now, and suspects
this is happening because XFS blocks the entire kernel when freeing certain
caches: https://twitter.com/marcan42/status/1086652425061056515
I don't know whether my case is the same, but it sure looks very similar.

This is with kernel 4.19.16, deadline scheduler for both source and target (as
recommended by XFS FAQ), and full kernel preemption enabled. The system has
16GB RAM, of which 10GB are usually available for caches. I don't know what
information is useful, so please request whatever information might be useful
for analyzing this.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
