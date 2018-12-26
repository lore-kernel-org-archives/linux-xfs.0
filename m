Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56410 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727078AbeLZRTO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Dec 2018 12:19:14 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C0F772856A
        for <linux-xfs@vger.kernel.org>; Wed, 26 Dec 2018 17:19:13 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202077] New: xfs transaction overruns on 4.14.67
Date: Wed, 26 Dec 2018 17:19:12 +0000
Message-ID: <bug-202077-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202077

            Bug ID: 202077
           Summary: xfs transaction overruns on 4.14.67
           Product: File System
           Version: 2.5
    Kernel Version: 4.14.67
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: thomas.walker@twosigma.com
        Regression: No

Created attachment 280149
  --> https://bugzilla.kernel.org/attachment.cgi?id=280149&action=edit
xfs transaction overrun #1

We've encountered two recent examples of xfs transaction overruns on production
systems running 4.14.67 kernels.  Both systems in this case are running docker
with dozens of overlay mounts, using this xfs fs as both upper and lower.  In
both cases the filesystem was able to successfully recover when the filesystem
was unmounted and remounted again.

It looks like there has been a good bit of work in 4.16+ addressing similar
issues but none of it has made it back into the 4.14 LTS.  Any chance that any
of the attached debug output points to anything specific that might be a
candidate for backport?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
