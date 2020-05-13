Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C19F0C2D0F8
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 04:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94BA4206F5
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 04:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgEMEHl convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 00:07:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbgEMEHl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 May 2020 00:07:41 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 207711] xfs: data race on ctx->space_used in
 xlog_cil_insert_items()
Date:   Wed, 13 May 2020 04:07:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-207711-201763-7pzjvcIIk4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207711-201763@https.bugzilla.kernel.org/>
References: <bug-207711-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207711

--- Comment #1 from Dave Chinner (david@fromorbit.com) ---
On Wed, May 13, 2020 at 02:45:54AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=207711
> 
>             Bug ID: 207711
>            Summary: xfs: data race on ctx->space_used in
>                     xlog_cil_insert_items()
>            Product: File System
>            Version: 2.5
>     Kernel Version: 5.4
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: baijiaju1990@gmail.com
>         Regression: No
> 
> The functions xlog_cil_insert_items() and xlog_cil_push_background() are
> concurrently executed at runtime at the following call contexts:
> 
> Thread 1:
> xfs_file_write_iter()
>   xfs_file_buffered_aio_write()
>     xfs_file_aio_write_checks()
>       xfs_vn_update_time()
>         xfs_trans_commit()
>           __xfs_trans_commit()
>             xfs_log_commit_cil()
>               xlog_cil_insert_items()
> 
> Thread 2:
> xfs_file_write_iter()
>   xfs_file_buffered_aio_write()
>     xfs_file_aio_write_checks()
>       xfs_vn_update_time()
>         xfs_trans_commit()
>           __xfs_trans_commit()
>             xfs_log_commit_cil()
>               xlog_cil_push_background()
> 
> In xlog_cil_insert_items():
>   ctx->space_used += len;
> 
> In xlog_cil_push_background():
>   if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))

Intentionally racy accounting check as it's not critical to be
perfectly accurate here.

Not a bug, please close.

-Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
