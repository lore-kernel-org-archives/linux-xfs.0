Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7E9C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 23:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B645222581
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 23:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbhAXXDI convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Jan 2021 18:03:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbhAXXDG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 24 Jan 2021 18:03:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 59F8122D03
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jan 2021 23:02:25 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211329] New: XFS related memory leak on ppc64le
Date:   Sun, 24 Jan 2021 23:02:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: cam@neo-zeon.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-211329-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=211329

            Bug ID: 211329
           Summary: XFS related memory leak on ppc64le
           Product: File System
           Version: 2.5
    Kernel Version: =>5.10.10
          Hardware: PPC-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: cam@neo-zeon.de
        Regression: No

Not necessarily ppc64le specific, but so far I'm only seeing this on my Talos
II system with XFS and none of my amd64 systems. 5.10.10 is the only 5.10.x
series kernel tested so far. Issue may have started earlier.

These are the only leaks so far with the box up for several hours. Not sure how
serious this is.

Specs:
2x 18 Core POWER9
512 GB memory

The XFS filesystems on this system:
df -h / /home
Filesystem      Size  Used Avail Use% Mounted on
/dev/md1        1.8T   59G  1.8T   4% /
/dev/bcache0     14T  634G   14T   5% /home

cat /sys/kernel/debug/kmemleak
unreferenced object 0xc0000011c63af400 (size 512):
  comm "worker", pid 7351, jiffies 4295245272 (age 21394.586s)
  hex dump (first 32 bytes):
    c0 e0 58 3c 00 00 00 c0 08 f4 3a c6 11 00 00 c0  ..X<......:.....
    08 f4 3a c6 11 00 00 c0 18 2a 3a c6 11 00 00 c0  ..:......*:.....
  backtrace:
    [<000000005f1fe84c>] blkg_alloc+0x58/0x260
    [<00000000bb469d61>] blkg_create+0x3b0/0x570
    [<000000007d35bf0d>] bio_associate_blkg_from_css+0x318/0x480
    [<00000000a4cfa6ed>] bio_associate_blkg+0x44/0xb0
    [<0000000014c40666>] cached_dev_submit_bio+0x140/0x1090
    [<000000001e375f40>] submit_bio_noacct+0x12c/0x5e0
    [<000000005d621ecf>] submit_bio+0x5c/0x270
    [<000000000d4d6bf5>] iomap_readahead+0xdc/0x230
    [<00000000b0093137>] xfs_vm_readahead+0x28/0x40
    [<00000000c7837a39>] read_pages+0xcc/0x370
    [<00000000ace2d2cc>] page_cache_ra_unbounded+0x1a4/0x280
    [<00000000ea5f8116>] generic_file_buffered_read+0x4cc/0xbd0
    [<00000000ce5a2b3b>] xfs_file_buffered_aio_read+0x70/0x130
    [<0000000019bddea7>] xfs_file_read_iter+0xa0/0x150
    [<0000000082a5c085>] new_sync_read+0x14c/0x1d0
    [<00000000abee86d0>] vfs_read+0x1a0/0x210
unreferenced object 0xc00000001772a840 (size 64):
  comm "worker", pid 7351, jiffies 4295245272 (age 21394.586s)
  hex dump (first 32 bytes):
    dc 5f 00 00 00 00 00 00 50 97 80 00 00 00 00 c0  ._......P.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000006e666d7e>] percpu_ref_init+0x7c/0x150
    [<00000000ac923962>] blkg_alloc+0x84/0x260
    [<00000000bb469d61>] blkg_create+0x3b0/0x570
    [<000000007d35bf0d>] bio_associate_blkg_from_css+0x318/0x480
    [<00000000a4cfa6ed>] bio_associate_blkg+0x44/0xb0
    [<0000000014c40666>] cached_dev_submit_bio+0x140/0x1090
    [<000000001e375f40>] submit_bio_noacct+0x12c/0x5e0
    [<000000005d621ecf>] submit_bio+0x5c/0x270
    [<000000000d4d6bf5>] iomap_readahead+0xdc/0x230
    [<00000000b0093137>] xfs_vm_readahead+0x28/0x40
    [<00000000c7837a39>] read_pages+0xcc/0x370
    [<00000000ace2d2cc>] page_cache_ra_unbounded+0x1a4/0x280
    [<00000000ea5f8116>] generic_file_buffered_read+0x4cc/0xbd0
    [<00000000ce5a2b3b>] xfs_file_buffered_aio_read+0x70/0x130
    [<0000000019bddea7>] xfs_file_read_iter+0xa0/0x150
    [<0000000082a5c085>] new_sync_read+0x14c/0x1d0

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.
