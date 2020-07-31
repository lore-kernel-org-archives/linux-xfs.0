Return-Path: <SRS0=R26v=BK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9791C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 19:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91CE9208E4
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 19:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgGaTUw convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 31 Jul 2020 15:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728713AbgGaTUw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Jul 2020 15:20:52 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208751] KASAN: Use-after-free bug in xlog_alloc_log
Date:   Fri, 31 Jul 2020 19:20:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sandeen@redhat.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: PATCH_ALREADY_AVAILABLE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status cc resolution
Message-ID: <bug-208751-201763-d8YDcQKuP2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208751-201763@https.bugzilla.kernel.org/>
References: <bug-208751-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208751

Eric Sandeen (sandeen@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |sandeen@redhat.com
         Resolution|---                         |PATCH_ALREADY_AVAILABLE

--- Comment #1 from Eric Sandeen (sandeen@redhat.com) ---
You've reported this on a 5.4.0 kernel from November 2019 (please, in future
bug reports include the kernel version more prominently)

This commit:

commit 798a9cada4694ca8d970259f216cec47e675bfd5
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Dec 3 07:53:15 2019 -0800

    xfs: fix mount failure crash on invalid iclog memory access

    syzbot (via KASAN) reports a use-after-free in the error path of
    xlog_alloc_log(). Specifically, the iclog freeing loop doesn't
    handle the case of a fully initialized ->l_iclog linked list.
    Instead, it assumes that the list is partially constructed and NULL
    terminated.

    This bug manifested because there was no possible error scenario
    after iclog list setup when the original code was added.  Subsequent
    code and associated error conditions were added some time later,
    while the original error handling code was never updated. Fix up the
    error loop to terminate either on a NULL iclog or reaching the end
    of the list.

    Reported-by: syzbot+c732f8644185de340492@syzkaller.appspotmail.com
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>


went into v5.5

I believe this is already resolved; if you have a reproducer can you please
test?  If you believe this bug is still not fixed, please re-open this bug.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
