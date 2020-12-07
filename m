Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5213CC4361B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 18:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDBDC238E3
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 18:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgLGSxg convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 13:53:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgLGSxg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Dec 2020 13:53:36 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 210535] [xfstests generic/466] XFS: Assertion failed:
 next_agino == irec->ir_startino + XFS_INODES_PER_CHUNK, file:
 fs/xfs/xfs_iwalk.c, line: 366
Date:   Mon, 07 Dec 2020 18:52:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: darrick.wong@oracle.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-210535-201763-IJeGbtyisU@https.bugzilla.kernel.org/>
In-Reply-To: <bug-210535-201763@https.bugzilla.kernel.org/>
References: <bug-210535-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=210535

--- Comment #3 from darrick.wong@oracle.com ---
On Mon, Dec 07, 2020 at 05:14:26PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=210535
> 
>             Bug ID: 210535
>            Summary: [xfstests generic/466] XFS: Assertion failed:
>                     next_agino == irec->ir_startino +
>                     XFS_INODES_PER_CHUNK, file: fs/xfs/xfs_iwalk.c, line:
>                     366
>            Product: File System
>            Version: 2.5
>     Kernel Version: xfs-linux xfs-5.10-fixes-7
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: zlang@redhat.com
>         Regression: No
> 
> Created attachment 294021
>   --> https://bugzilla.kernel.org/attachment.cgi?id=294021&action=edit
> generic-466.full
> 
> xfstests generic/466 hit below assertion failure on power9 ppc64le:
> 
> [16404.196161] XFS: Assertion failed: next_agino == irec->ir_startino +
> XFS_INODES_PER_CHUNK, file: fs/xfs/xfs_iwalk.c, line: 366

Does this patch fix it?

--D

From: Darrick J. Wong <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix the forward progress assertion in
xfs_iwalk_run_callbacks

In commit 27c14b5daa82 we started tracking the last inode seen during an
inode walk to avoid infinite loops if a corrupt inobt record happens to
have a lower ir_startino than the record preceeding it.  Unfortunately,
the assertion trips over the case where there are completely empty inobt
records (which can happen quite easily on 64k page filesystems) because
we advance the tracking cursor without actually putting the empty record
into the processing buffer.  Fix the assert to allow for this case.

Reported-by: zlang@redhat.com
Fixes: 27c14b5daa82 ("xfs: ensure inobt record walks always make forward
progress")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iwalk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 2a45138831e3..eae3aff9bc97 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -363,7 +363,7 @@ xfs_iwalk_run_callbacks(
        /* Delete cursor but remember the last record we cached... */
        xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
        irec = &iwag->recs[iwag->nr_recs - 1];
-       ASSERT(next_agino == irec->ir_startino + XFS_INODES_PER_CHUNK);
+       ASSERT(next_agino >= irec->ir_startino + XFS_INODES_PER_CHUNK);

        error = xfs_iwalk_ag_recs(iwag);
        if (error)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
