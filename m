Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39698 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732435AbfFMONK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 10:13:10 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 585EA1FFE4
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 14:13:10 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 203887] New: CGroup writeback is not supported by `xfs`
 filesystem leading to errors when using containers.
Date: Thu, 13 Jun 2019 14:13:08 +0000
Message-ID: <bug-203887-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203887

            Bug ID: 203887
           Summary: CGroup writeback is not supported by `xfs` filesystem
                    leading to errors when using containers.
           Product: File System
           Version: 2.5
    Kernel Version: 4.14
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: axel.borja.login@gmail.com
        Regression: No

I am currently working on a Kubernetes cluster, which uses docker.

This cluster allows me to launch jobs. For each job, I specify a memory request
and a memory limit.

The memory limit will be used by Kubernetes to fill the `--memory` option of
the docker run command when creating the container. If this container exceeds
this limit it will be killed for OOM reason.

When writing on disk, pages will be written-back on the RAM before being
written to the disk. To do this the system will evaluate how many pages could
be written-back using the sysctl `vm.dirty_ratio` (20 % by default) and memory
from the root cgroup.

In case of intensive IO operations, it leads some containers to OOM errors.

xfs should be able to writeback using cgroup.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
