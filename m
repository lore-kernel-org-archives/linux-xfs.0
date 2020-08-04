Return-Path: <SRS0=OnOM=BO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A311BC433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Aug 2020 09:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BB2D206DA
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Aug 2020 09:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgHDJwt convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Aug 2020 05:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726844AbgHDJws (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Aug 2020 05:52:48 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208805] New: XFS: iozone possible memory allocation deadlock
Date:   Tue, 04 Aug 2020 09:52:48 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jjzuming@outlook.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-208805-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208805

            Bug ID: 208805
           Summary: XFS: iozone possible memory allocation deadlock
           Product: File System
           Version: 2.5
    Kernel Version: Linux 5.4
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: jjzuming@outlook.com
        Regression: No

When I ran iozone to test XFS in a memory insufficient situation，I found that
iozone was blocked and The log "XFS: iozone possible memory allocation
deadlock" was printed.

Reviewing the XFS code, I found that kmem_alloc(), xfs_buf_allocate_memory(),
kmem_zone_alloc() and kmem_realloc() were implemented with "while" loops. These
functions kept trying to get memory while the memory was insufficient, as a
result of which "memory allocation deadlock" happened.

I think it may be a little unreasonable, although it can guarantee that the
memory allocation succeed. Maybe using error handling code to handle the memory
allocation failures is better.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
