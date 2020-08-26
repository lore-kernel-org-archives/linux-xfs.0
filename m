Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D558C433E3
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 15:20:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7B532075E
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 15:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgHZPUJ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 11:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbgHZPUI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Aug 2020 11:20:08 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208805] XFS: iozone possible memory allocation deadlock
Date:   Wed, 26 Aug 2020 15:20:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bfoster@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-208805-201763-Gba1ispQSA@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208805-201763@https.bugzilla.kernel.org/>
References: <bug-208805-201763@https.bugzilla.kernel.org/>
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

--- Comment #1 from bfoster@redhat.com ---
On Tue, Aug 04, 2020 at 09:52:48AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=208805
> 
>             Bug ID: 208805
>            Summary: XFS: iozone possible memory allocation deadlock
>            Product: File System
>            Version: 2.5
>     Kernel Version: Linux 5.4
>           Hardware: x86-64
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: jjzuming@outlook.com
>         Regression: No
> 
> When I ran iozone to test XFS in a memory insufficient situation，I found that
> iozone was blocked and The log "XFS: iozone possible memory allocation
> deadlock" was printed.
> 
> Reviewing the XFS code, I found that kmem_alloc(), xfs_buf_allocate_memory(),
> kmem_zone_alloc() and kmem_realloc() were implemented with "while" loops.
> These
> functions kept trying to get memory while the memory was insufficient, as a
> result of which "memory allocation deadlock" happened.
> 
> I think it may be a little unreasonable, although it can guarantee that the
> memory allocation succeed. Maybe using error handling code to handle the
> memory
> allocation failures is better.
> 

I think some of this memory allocation code is currently being reworked,
but that aside most of the above cases do break the retry loop if the
caller passes KM_MAYFAIL. So it's a case by case basis as to whether a
particular allocation should be allowed to fail and potentially return
an error to userspace or should continue to retry.

A more useful approach to this bug would be to describe your test, the
specific system/memory conditions, and provide the full log output
(stack trace?) associated with the issue. Then perhaps we can analyze
the cause and determine whether it's something that can be addressed or
improved, or if you just need more memory. ;)

Brian

> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.
>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
