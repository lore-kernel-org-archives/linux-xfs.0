Return-Path: <SRS0=4Qc2=3Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A88C3524A
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 06:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B33C62087E
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 06:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgBDGie convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 01:38:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbgBDGie (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Feb 2020 01:38:34 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 206399] [xfstests xfs/433] BUG: KASAN: use-after-free in
 xfs_attr3_node_inactive+0x6c8/0x7b0 [xfs]
Date:   Tue, 04 Feb 2020 06:38:31 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206399-201763-0UBzpQgK0D@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206399-201763@https.bugzilla.kernel.org/>
References: <bug-206399-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206399

--- Comment #2 from Zorro Lang (zlang@redhat.com) ---
    208                 error = xfs_trans_get_buf(*trans, mp->m_ddev_targp,
    209                                 child_blkno,
    210                                 XFS_FSB_TO_BB(mp,
mp->m_attr_geo->fsbcount), 0,
    211                                 &child_bp);
    212                 if (error)
    213                         return error;
--> 214                 error = bp->b_error;

I think this place is wrong, why not use child_bp->b_error? The 'bp' has been
freed by:

    160         xfs_trans_brelse(*trans, bp);   /* no locks for later trans */

right?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
