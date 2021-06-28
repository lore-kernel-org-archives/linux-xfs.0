Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2CC5C49361
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Jun 2021 13:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7DDB619AB
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Jun 2021 13:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhF1NQ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Jun 2021 09:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232502AbhF1NQ0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Jun 2021 09:16:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B6D4B61C74
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jun 2021 13:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624886040;
        bh=XuoXCpU1HtyiE8RYFZr0BbOQR6DPHEd8ogpuImfq7Zw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Q6ldPeQAEEADhSFZU5EYUEouC6lX2Gr/xxtwQJGkhsHO56Bp2Tq453BSPd5xotcYu
         sey8jkJ2B2Me4N3LFQGCOU8Zbxf5KdovNtBxzGdpvHEOXLoAO46bp9tNa49QVm0yHK
         IV3wbb0e1J4yo36sv6OWIlV29dOYzGIse41RTBVwJjkxiw2t/hE5IdlsgZmoInpszr
         3ZAWLBeajC5qsVIroNVUavKczsJbdonnb1eUi+JoHXA6jg8wEyUuTa44FSzYDoh0R/
         I8a08fMLZea8lnvyhdPyR32BXhhG4X8xGALOBb1ODCRRJ0fz3HiLC5ntTZDWjdXTv+
         p0tWnBBH9i9OQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 213609] [xfstests xfs/503] testing always hang on 64k directory
 size xfs
Date:   Mon, 28 Jun 2021 13:14:00 +0000
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
Message-ID: <bug-213609-201763-2kjq1YG9OX@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213609-201763@https.bugzilla.kernel.org/>
References: <bug-213609-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213609

--- Comment #3 from Zorro Lang (zlang@redhat.com) ---
Can't reproduce this issue on default directory size xfs:

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/ppc64le ibm-p9z-26-lp2 5.13.0-rc4 #1 SMP Fri Jun 25
07:19:50 EDT 2021
MKFS_OPTIONS  -- -f -m crc=3D1,finobt=3D1,rmapbt=3D0,reflink=3D1,bigtime=3D=
1,inobtcount=3D1
/dev/sda3
MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /dev/sda3
/mnt/xfstests/scratch

xfs/503  95s
Ran: xfs/503
Passed all 1 tests

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
