Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39064 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726359AbeI3Fdb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Sep 2018 01:33:31 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 01DD129A37
        for <linux-xfs@vger.kernel.org>; Sat, 29 Sep 2018 23:03:13 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201287] New: xfsprogs 4.17 and later can't be built as static
 binaries anymore
Date: Sat, 29 Sep 2018 23:03:12 +0000
Message-ID: <bug-201287-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201287

            Bug ID: 201287
           Summary: xfsprogs 4.17 and later can't be built as static
                    binaries anymore
           Product: File System
           Version: 2.5
    Kernel Version: n/a
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: dilfridge@gentoo.org
        Regression: No

In Gentoo we offer the possibility to build xfsprogs fully static, e.g. for
initramdisks.

This still worked fine with 4.14. 

With 4.17 and 4.18 we however get:

../libfrog/.libs/libfrog.a(convert.o): In function `gid_from_string':
convert.c:(.text+0x984): warning: Using 'getgrnam' in statically linked
applications requires at runtime the shared libraries from the glibc version
used for linking

and final linking fails.

See also https://bugs.gentoo.org/666196

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
