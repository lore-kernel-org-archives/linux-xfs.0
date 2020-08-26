Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D9BC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 11:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4A782087C
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 11:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgHZLEl convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 07:04:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728676AbgHZLEi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Aug 2020 07:04:38 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209039] xfs_fsr skips most of the files as no improvement will
 be made
Date:   Wed, 26 Aug 2020 11:04:37 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: marc@gutt.it
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209039-201763-BNwTvHz8PU@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209039-201763@https.bugzilla.kernel.org/>
References: <bug-209039-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209039

--- Comment #2 from mgutt (marc@gutt.it) ---
Ok. This means as my filesystem has a blocksize (bsize) of 4 KiB (4096 bytes):

     xfs_info /dev/md1
     meta-data=/dev/md1               isize=512    agcount=11, agsize=268435455
blks
              =                       sectsz=512   attr=2, projid32bit=1
              =                       crc=1        finobt=1, sparse=1, rmapbt=0
              =                       reflink=1
     data     =                       bsize=4096   blocks=2929721331, imaxpct=5
              =                       sunit=0      swidth=0 blks
     naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
     log      =internal log           bsize=4096   blocks=521728, version=2
              =                       sectsz=512   sunit=0 blks, lazy-count=1
     realtime =none                   extsz=4096   blocks=0, rtextents=0

each extend can't be bigger than 8GB as mentioned in the docs:
https://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/Data_Extents.html
>If a file is zero bytes long, it will have no extents, di_nblocks and
>di_nexents will be zero. Any file with data will have at least one extent, and
>each extent can use from 1 to over 2 million blocks (221) on the filesystem.
>For a default 4KB block size filesystem, a single extent can be up to 8GB in
>length.

Good to know. Maybe this information should be part of xfs_fsr output? At the
moment it creates the impression with "ideal 674" and "can_save=3" that it
could be more defragmentated.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
