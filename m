Return-Path: <SRS0=V0Y3=4A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D030C2BA83
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 15:57:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08227206D7
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 15:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgBLP5G convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Feb 2020 10:57:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727026AbgBLP5G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Feb 2020 10:57:06 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 206397] [xfstests generic/475] XFS: Assertion failed:
 iclog->ic_state == XLOG_STATE_ACTIVE, file: fs/xfs/xfs_log.c, line: 572
Date:   Wed, 12 Feb 2020 15:57:05 +0000
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
Message-ID: <bug-206397-201763-FUYphFEkBX@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206397-201763@https.bugzilla.kernel.org/>
References: <bug-206397-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206397

--- Comment #3 from bfoster@redhat.com ---
On Tue, Feb 04, 2020 at 05:10:05PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=206397
> 
> --- Comment #2 from Zorro Lang (zlang@redhat.com) ---
> (In reply to Chandan Rajendra from comment #1)
> > I was unable to recreate this issue on a ppc64le kvm guest. I used Linux
> > v5.5 and xfsprogs' for-next branch.
> > 
> > Can you please share the kernel config file? Also, Can you please tell me
> > how easy is it recreate this bug?
> 
> It's really hard to reproduce. The g/475 is a random test, it's helped us to
> find many different issues. For this bug, this's the 1st time I hit it, and
> can't reproduce it simply.
> 

Have you still been unable to reproduce (assuming you've been attempting
to)? How many iterations were required before you reproduced the first
time?

I'm wondering if the XLOG_STATE_IOERROR check in xfs_log_release_iclog()
is racy with respect to filesystem shutdown. There's an ASSERT_ALWAYS()
earlier in this (xlog_cil_push()) codepath that checks for ACTIVE ||
WANT_SYNC and it doesn't appear that has failed from your output
snippet. The aforementioned IOERROR check occurs before we acquire
->l_icloglock, however, which I think means xfs_log_force_umount() could
jump in if called from another task and reset all of the iclogs while
the release path waits on the lock.

Brian

> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.
>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
