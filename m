Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CEFDC2D0F8
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 04:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16C3120675
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 04:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgEMEb7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 00:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbgEMEb7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 May 2020 00:31:59 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 207713] xfs: data races on ip->i_itemp->ili_fields in
 xfs_inode_clean()
Date:   Wed, 13 May 2020 04:31:58 +0000
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
Message-ID: <bug-207713-201763-QVUM9CClsv@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207713-201763@https.bugzilla.kernel.org/>
References: <bug-207713-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207713

--- Comment #1 from Dave Chinner (david@fromorbit.com) ---
On Wed, May 13, 2020 at 03:02:10AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=207713
> 
>             Bug ID: 207713
>            Summary: xfs: data races on ip->i_itemp->ili_fields in
>                     xfs_inode_clean()
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
> The function xfs_inode_clean() is concurrently executed with the functions
> xfs_inode_item_format_data_fork(), xfs_trans_log_inode() and
> xfs_inode_item_format() at runtime in the following call contexts:
> 
> Thread 1:
> xfsaild()
>   xfsaild_push()
>     xfsaild_push_item()
>       xfs_inode_item_push()
>         xfs_iflush()
>           xfs_iflush_cluster()
>             xfs_inode_clean()

The code explains:

                /*
                 * Do an un-protected check to see if the inode is dirty and
                 * is a candidate for flushing.  These checks will be repeated
                 * later after the appropriate locks are acquired.
                 */
                if (xfs_inode_clean(cip) && xfs_ipincount(cip) == 0)
                        continue;

Then it is repeated if the racy check indicates the inode is dirty
whilst holding the correct inode locks.  All three of the "thread 2"
cases are modifying the fields with the correct locks held, so there
isn't actually a data race bug we care about here.

IOWs, this code is simply avoiding taking locks if we don't need
them - it's a pattern we use in numerous places in XFS, so you're
going to get lots of false positives from your tool.

Not a bug, please close.

-Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
