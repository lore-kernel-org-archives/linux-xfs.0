Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D47C2D0F8
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 04:10:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE8D620708
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 04:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgEMEK5 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 00:10:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgEMEK5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 May 2020 00:10:57 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 207715] xfs: data race on lip->li_lsn in
 xfs_trans_ail_update_bulk()
Date:   Wed, 13 May 2020 04:10:56 +0000
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
Message-ID: <bug-207715-201763-8SlYWYrmkc@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207715-201763@https.bugzilla.kernel.org/>
References: <bug-207715-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207715

--- Comment #1 from Dave Chinner (david@fromorbit.com) ---
On Wed, May 13, 2020 at 03:21:05AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=207715
> 
>             Bug ID: 207715
>            Summary: xfs: data race on lip->li_lsn in
>                     xfs_trans_ail_update_bulk()
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
> The functions xfs_trans_ail_update_bulk() and xfs_inode_item_format_core()
> are
> concurrently executed at runtime in the following call contexts:
> 
> Thread 1:
> xlog_ioend_work()
>   xlog_state_done_syncing()
>     xlog_state_do_callback()
>       xlog_state_do_iclog_callbacks()
>         xlog_cil_process_committed()
>           xlog_cil_committed()
>             xfs_trans_committed_bulk()
>               xfs_log_item_batch_insert()
>                 xfs_trans_ail_update_bulk()
> 
> Thread 2:
> xfs_file_write_iter()
>   xfs_file_buffered_aio_write()
>     xfs_file_aio_write_checks()
>       xfs_vn_update_time()
>         xfs_trans_commit()
>           __xfs_trans_commit()
>             xfs_log_commit_cil()
>               xlog_cil_insert_items()
>                 xlog_cil_insert_format_items()
>                   xfs_inode_item_format()
>                     xfs_inode_item_format_core()
> 
> In xfs_trans_ail_update_bulk():
>   lip->li_lsn = lsn;
> 
> In xfs_inode_item_format_core():
>   xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);

Probably a bug on 32 bit systems where a torn write can be seen.
Likely should use xfs_trans_ail_copy_lsn() to sample the lsn out
of the log item.

Cheers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
