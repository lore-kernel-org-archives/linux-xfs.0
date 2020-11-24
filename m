Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9256DC2D0E4
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 20:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4276320708
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 20:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731080AbgKXU3O convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 15:29:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgKXU3O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Nov 2020 15:29:14 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 210341] XFS (dm-3): Internal error xfs_trans_cancel at line
 1041 of file fs/xfs/xfs_trans.c.
Date:   Tue, 24 Nov 2020 20:29:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-210341-201763-dqLJ7gmDrD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-210341-201763@https.bugzilla.kernel.org/>
References: <bug-210341-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=210341

--- Comment #1 from Dave Chinner (david@fromorbit.com) ---
On Tue, Nov 24, 2020 at 05:53:09AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=210341
> 
>             Bug ID: 210341
>            Summary: XFS (dm-3): Internal error xfs_trans_cancel at line
>                     1041 of file fs/xfs/xfs_trans.c.
>            Product: File System
>            Version: 2.5
>     Kernel Version: 4.18.0-147
>           Hardware: Intel
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: blocking
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: lokendra.rathour@hsc.com
>         Regression: No
> 
> Created attachment 293797
>   --> https://bugzilla.kernel.org/attachment.cgi?id=293797&action=edit
> Detailed logs as shown above
> 
> Getting errror for xfs file system :
> 
> 2020-11-11T11:55:16.809 controller-1 kernel: alert [419472.614847] XFS
> (dm-3):
> xfs_dabuf_map: bno 8388608 dir: inode 122425344
> 2020-11-11T11:55:16.809 controller-1 kernel: alert [419472.621963] XFS
> (dm-3):
> [00] br_startoff 8388608 br_startblock -2 br_blockcount 1 br_state 0
> 2020-11-11T11:55:16.823 controller-1 kernel: alert [419472.630908] XFS
> (dm-3):
> Internal error xfs_da_do_buf(1) at line 2558 of file
> fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_da_read_buf+0x6c/0x120 [xfs]
> 2020-11-11T11:55:16.824 controller-1 kernel: warning [419472.644671] CPU: 1
> PID: 83210 Comm: heat-manage Kdump: loaded Tainted: G           O    
> ---------
> -t - 4.18.0-147.3.1.el8_1.7.tis.x86_64 #1

So you have a corrupt directory (missing a leaf root pointer). Have
you run `xfs_repair -n` on that filesystem to see if it finds the
same corruption?

Keep in mind that you are running on a CentOS8/RHEL8 kernel. It is
unlikely that upstream developers will be able to reliably diagnose
the root cause of your issue as the kernel codebase is a highly
modified vendor kernel.  You really should report this to your
vendor support contacts, not upstream....

Cheers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
