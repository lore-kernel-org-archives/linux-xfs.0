Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB74C43461
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 07:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6822D2192A
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 07:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgINHHR convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 03:07:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgINHHK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Sep 2020 03:07:10 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209243] [regression] fsx IO_URING reading get BAD DATA
Date:   Mon, 14 Sep 2020 07:07:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc short_desc
Message-ID: <bug-209243-201763-opaRuXiAHH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209243-201763@https.bugzilla.kernel.org/>
References: <bug-209243-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209243

Zorro Lang (zlang@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |axboe@kernel.dk
            Summary|fsx IO_URING reading get    |[regression] fsx IO_URING
                   |BAD DATA                    |reading get BAD DATA

--- Comment #5 from Zorro Lang (zlang@redhat.com) ---
Finally, I find the first commit which can reproduce this failure:

commit c3cf992c25c7ff04bfc4dec5c916705a5332320e
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri May 22 09:24:42 2020 -0600

    io_uring: support true async buffered reads, if file provides it

    If the file is flagged with FMODE_BUF_RASYNC, then we don't have to punt
    the buffered read to an io-wq worker. Instead we can rely on page
    unlocking callbacks to support retry based async IO. This is a lot more
    efficient than doing async thread offload.

    The retry is done similarly to how we handle poll based retry. From
    the unlock callback, we simply queue the retry to a task_work based
    handler.

    Signed-off-by: Jens Axboe <axboe@kernel.dk>

So CC the author of this patch to get more review.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
