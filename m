Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49112 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726106AbeI1M27 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Sep 2018 08:28:59 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 6FAD72B03B
        for <linux-xfs@vger.kernel.org>; Fri, 28 Sep 2018 06:06:53 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201259] New: [xfstests shared/010]: maybe pagecache contents is
 mutated after cycle mount
Date: Fri, 28 Sep 2018 06:06:53 +0000
Message-ID: <bug-201259-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201259

            Bug ID: 201259
           Summary: [xfstests shared/010]: maybe pagecache contents is
                    mutated after cycle mount
           Product: File System
           Version: 2.5
    Kernel Version: v4.19-rc5
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

Recently, shared/010 sometimes hit below issue:

QA output created by 010
/mnt/scratch/dir/p0/deXXXXXXXXXXX/d218X/d3a0XXX/d3da/d90XXXXXXXXXXXXX/d1c8XXXXXXXXX/d71/d75XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/da6XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/db9XXXX/de0XXXXXXXXXXXXX/d7e0XXXXXXXXXXXX/d1d9X/f476XXXX:
FAILED
md5sum: WARNING: 1 computed checksum did NOT match
Silence is golden

Looks like something changed after cycle mount, cause this integrity issue.

Version-Release number of selected component (if applicable):
kernel v4.19-rc5

How reproducible:
10~30%

Steps to Reproduce:
1) git clone https://github.com/markfasheh/duperemove.git
2) cd duperemove; make; make install
3) Run shared/010 on XFS several times, with reflink=1:

Actual results:
checksum mismatch

Expected results:
test always pass

Additional info:
I can't be sure this's a real bug, maybe it's case issue. But I don't know
what's wrong with the case, so report this bug to get more
reviewing/suggestions from XFS developers. Thanks.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
