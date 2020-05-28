Return-Path: <SRS0=OPd9=7K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90DEFC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 28 May 2020 10:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66F1F207D3
	for <linux-xfs@archiver.kernel.org>; Thu, 28 May 2020 10:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387953AbgE1Kru convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 May 2020 06:47:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387981AbgE1Kru (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 May 2020 06:47:50 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 207053] fsfreeze deadlock on XFS (the FIFREEZE ioctl and
 subsequent FITHAW hang indefinitely)
Date:   Thu, 28 May 2020 10:47:49 +0000
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
Message-ID: <bug-207053-201763-0qbx7OrscJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207053-201763@https.bugzilla.kernel.org/>
References: <bug-207053-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207053

--- Comment #9 from bfoster@redhat.com ---
On Thu, May 28, 2020 at 06:00:38AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=207053
> 
> --- Comment #8 from Paul Furtado (paulfurtado91@gmail.com) ---
> The patches that came from this issue have given us many weeks of stability
> now
> and we were ready to declare this as totally fixed, however, we hit another
> instance of this issue this week which I'm assuming is probably on a slightly
> different and much rarer code path.
> 
> Here's a link to the blocked tasks log (beware that it's 2MB due to endless
> processes getting hung inside the container once the filesystem was frozen):
>
> https://gist.githubusercontent.com/PaulFurtado/48253a6978763671f70dc94d933df851/raw/6bad12023ac56e9b6cb3dde771fcb5b15f0bd679/patched_kernel_fsfreeze_sys_w.log
> 

This shows the eofblocks scan in the following (massaged) trace:

[1259466.349224] Workqueue: xfs-eofblocks/nvme4n1 xfs_eofblocks_worker [xfs]
[1259466.353550] Call Trace:
[1259466.359370]  schedule+0x2f/0xa0
[1259466.362297]  rwsem_down_read_slowpath+0x196/0x530
[1259466.372467]  __percpu_down_read+0x49/0x60
[1259466.375778]  __sb_start_write+0x5b/0x60
[1259466.379139]  xfs_trans_alloc+0x152/0x160 [xfs]
[1259466.382715]  xfs_free_eofblocks+0x12d/0x1f0 [xfs]
[1259466.386407]  xfs_inode_free_eofblocks+0x128/0x1a0 [xfs]
[1259466.394058]  xfs_inode_ag_walk.isra.17+0x1a7/0x410 [xfs]
[1259466.536551]  xfs_inode_ag_iterator_tag+0x73/0xb0 [xfs]
[1259466.540235]  xfs_eofblocks_worker+0x29/0x40 [xfs]
[1259466.543748]  process_one_work+0x195/0x380
[1259466.546996]  worker_thread+0x30/0x390
[1259466.553449]  kthread+0x113/0x130
[1259466.559579]  ret_from_fork+0x1f/0x40

This should be addressed by upstream commit 4b674b9ac8529 ("xfs: acquire
superblock freeze protection on eofblocks scans"), which causes
xfs_eofblocks_worker() to bail unless it acquires freeze write
protection. What exact kernel is this seen on?

Brian

> Thanks,
> Paul
> 
> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.
>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
